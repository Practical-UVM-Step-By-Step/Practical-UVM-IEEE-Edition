class grabsequence extends base_sequence;
   `uvm_object_utils(grabsequence)
   `uvm_add_to_seq_lib(grabsequence,wb_master_seqr_sequence_library)

   function new(string name="my_grabsequence");
      super.new(name);
   endfunction

   virtual task body();
      grab();
      `uvm_do(req, get_sequencer(), -1, {address == 0; kind == wb_transaction::READ; })
      `uvm_do(req, get_sequencer(), -1, {address == 1; kind == wb_transaction::READ; })
      `uvm_do(req, get_sequencer(), -1, {address == 2; kind == wb_transaction::READ; })
      `uvm_do(req, get_sequencer(), -1, {address == 3; kind == wb_transaction::READ; })
      ungrab();
   endtask

endclass
