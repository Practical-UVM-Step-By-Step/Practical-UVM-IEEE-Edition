class heir_sequence_w extends base_sequence;
    `uvm_object_utils(heir_sequence_w)
   
    write_master_single single_seq;
   
    function new(string name = "seq_0");
        super.new(name);
    endfunction:new
    virtual task body();
        single_seq = write_master_single::type_id::create("my_sequence");
        single_seq.write_address  = 10;
        single_seq.write_data = 32'h12345678;
        single_seq.start(p_sequencer);
    endtask
endclass
