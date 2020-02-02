class repeated_read_sequence extends base_sequence;
    `uvm_object_utils(repeated_read_sequence)
    `uvm_add_to_seq_lib(repeated_read_sequence,wb_master_seqr_sequence_library)

    function new(string name="my_repeated_read_sequence");
        super.new(name);
    endfunction

    virtual task body();
        `uvm_do(req, get_sequencer(), -1, {address == 0; kind == wb_transaction::READ; })
        `uvm_do(req, get_sequencer(), -1, {address == 1; kind == wb_transaction::READ; })
        `uvm_do(req, get_sequencer(), -1, {address == 2; kind == wb_transaction::READ; })
        `uvm_do(req, get_sequencer(), -1, {address == 3; kind == wb_transaction::READ; })
    endtask

endclass
