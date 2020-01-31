class sequence_1 extends base_sequence;
   byte sa;
   `uvm_object_utils(sequence_1)
   `uvm_add_to_seq_lib(sequence_1, wb_master_seqr_sequence_library)
   function new(string name = "seq_1");
      super.new(name);
   endfunction:new
   virtual task body();
      
      `uvm_do(req, get_sequencer(), -1, {address == 3; kind == wb_transaction::WRITE; data[0] == 63'hdeadbeef;})
      `uvm_do(req, get_sequencer(), -1, {address == 4; kind == wb_transaction::WRITE; data[0] == 63'hbeefdead;})
      `uvm_do(req, get_sequencer(), -1, {address == 5; kind == wb_transaction::WRITE; data[0] == 63'h01234578;})

      
      `uvm_do(req, get_sequencer(), -1, {address == 3; kind == wb_transaction::READ ;})
      `uvm_do(req, get_sequencer(), -1, {address == 4; kind == wb_transaction::READ;})
      `uvm_do(req, get_sequencer(), -1, {address == 5; kind == wb_transaction::READ;}) 
   endtask
endclass

