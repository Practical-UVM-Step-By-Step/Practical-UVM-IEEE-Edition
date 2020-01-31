class send_tx_packet extends base_sequence;

   init_tx_seq tx_seq;
   setup_txbd_sequence  txbd_sequence;
   tx_interrupt_seq  tx_int_sequence;
   initialize_txbd_rxbd_sequence  initialize_desc_seq;
   write_master_single single_seq;
   read_master_single single_seq_read;

   `uvm_object_utils(send_tx_packet)
   

   function new(string name = "send_tx_packet");
      super.new(name);
   endfunction:new

   virtual task body();
      uvm_reg_data_t reg_data;
      uvm_status_e reg_status;
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
      p_sequencer.regmodel.TX_BD_NUM.write(.status(reg_status),.path(UVM_FRONTDOOR), .parent(this),.value(1));
      single_seq.write_address = 32'h00000400;
      single_seq.write_data = 32'h007c5800;
      single_seq.start(p_sequencer);
      single_seq.write_address = 32'h00000404;
      single_seq.write_data = 32'h00002000;
      single_seq.start(p_sequencer);
      p_sequencer.regmodel.INT_MASK.write(.status(reg_status),.path(UVM_FRONTDOOR), .parent(this),.value(32'h0000007f));
      p_sequencer.regmodel.MODER.write(.status(reg_status),.path(UVM_FRONTDOOR), .parent(this),.value(32'h00002403));
      p_sequencer.regmodel.TX_BD_NUM.write(.status(reg_status),.path(UVM_FRONTDOOR), .parent(this),.value(1));
      single_seq.write_address = 32'h00000404;
      single_seq.write_data = 32'h00002000;
      single_seq.start(p_sequencer);
      p_sequencer.regmodel.TX_BD_NUM.write(.status(reg_status),.path(UVM_FRONTDOOR), .parent(this),.value(1));
      single_seq.write_address = 32'h00000404;
      single_seq.write_data = 32'h00002000;
      single_seq.start(p_sequencer);
      single_seq.write_address = 32'h00000400;
      single_seq.write_data = 32'h007c5800;
      single_seq.start(p_sequencer);
      single_seq.write_address = 32'h00000400;
      single_seq.write_data = 32'h003cd800;
      single_seq.start(p_sequencer);

      single_seq_read.read_address = 32'h00000400;
      single_seq_read.read_data = 32'h007c5800;
      single_seq_read.start(p_sequencer);

      single_seq_read.read_address = 32'h00000400;
      single_seq_read.read_data = 32'h007c5800;
      single_seq_read.start(p_sequencer);
      single_seq_read.start(p_sequencer);

      tx_int_sequence.start(p_sequencer);
   endtask
endclass
