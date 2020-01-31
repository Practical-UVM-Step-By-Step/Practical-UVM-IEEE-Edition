class sequence_2 extends base_sequence;
   byte sa;
   `uvm_object_utils(sequence_2)
   `uvm_add_to_seq_lib(sequence_2, wb_master_seqr_sequence_library)
   function new(string name = "seq_1");
      super.new(name);
   endfunction:new
   virtual task body();
      
      `uvm_do(req, get_sequencer(), -1, {address == 6; kind == wb_transaction::WRITE; data == 63'hdeadbeef;})
      `uvm_do(req, get_sequencer(), -1, {address == 7; kind == wb_transaction::WRITE; data == 63'hbeefdead;})
      `uvm_do(req, get_sequencer(), -1, {address == 8; kind == wb_transaction::WRITE; data == 63'h0123456678;})

      
      `uvm_do(req, get_sequencer(), -1, {address == 6; kind == wb_transaction::READ ;})
      `uvm_do(req, get_sequencer(), -1, {address == 7; kind == wb_transaction::READ;})
      `uvm_do(req, get_sequencer(), -1, {address == 8; kind == wb_transaction::READ;}) 
   endtask
endclass
