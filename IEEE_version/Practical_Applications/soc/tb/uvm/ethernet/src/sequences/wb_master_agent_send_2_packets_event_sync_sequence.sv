class send_2_packets_event_sync_sequence extends base_sequence;

    init_tx_seq tx_seq;
    setup_txbd_sequence  txbd_sequence;
    tx_interrupt_seq  tx_int_sequence;
    initialize_txbd_rxbd_sequence  initialize_desc_seq;
    write_master_single single_seq;
    read_master_single single_seq_read;
    uvm_event send_2_pkt_event;

    `uvm_object_utils(send_2_packets_event_sync_sequence)
    `uvm_declare_p_sequencer(wb_master_seqr)

    function new(string name = "send_2_packets_event_sync_sequence");
        super.new(name);
    endfunction:new

    virtual task body();
        uvm_reg_data_t reg_data;
        uvm_status_e reg_status;

        uvm_config_db #(uvm_event)::get(null,"","transmit_b",send_2_pkt_event);

        p_sequencer.regmodel.MODER.write(.status(reg_status), .value(0), .path(UVM_FRONTDOOR), .parent(this));
        p_sequencer.regmodel.MAC_ADDR0.write(.status(reg_status), .value(32'h03040506), .path(UVM_FRONTDOOR), .parent(this));
        p_sequencer.regmodel.MAC_ADDR1.write(.status(reg_status), .value(32'h00001020), .path(UVM_FRONTDOOR), .parent(this));
        tx_seq = init_tx_seq::type_id::create("tx seq");
        txbd_sequence = setup_txbd_sequence::type_id::create("TXBD data Sequence");
        initialize_desc_seq = initialize_txbd_rxbd_sequence::type_id::create("initialize_desc_sequence");
        tx_int_sequence = tx_interrupt_seq::type_id::create("tx_init_sequence");
        single_seq_read = read_master_single::type_id::create("single_seq");
        single_seq = write_master_single::type_id::create("simple seq read");
        // Clean up descriptors
        initialize_desc_seq.start(p_sequencer);
        p_sequencer.regmodel.INT_MASK.write(.status(reg_status),.path(UVM_FRONTDOOR), .parent(this),.value(32'h0000007f));
        p_sequencer.regmodel.MODER.write(.status(reg_status),.path(UVM_FRONTDOOR), .parent(this),.value(32'h00002403));

        txbd_sequence.packet_lenght = 80;
        txbd_sequence.buffer_num = 0;
        txbd_sequence.mem_addr = 1000;
        txbd_sequence.start(p_sequencer);
        txbd_sequence.packet_lenght = 80;
        txbd_sequence.buffer_num = 1;
        txbd_sequence.mem_addr = 1000;
        txbd_sequence.packet_lenght = 80;
        txbd_sequence.buffer_num = 2;
        txbd_sequence.mem_addr = 1000;
        txbd_sequence.start(p_sequencer);

        single_seq_read.read_address = 32'h00000400;
        single_seq_read.read_data = 32'h007c5800;

        repeat (5)  // Apparently this is a magic number that kicks off the machine
            single_seq_read.start(p_sequencer);
        send_2_pkt_event.trigger();
    endtask
endclass
