class base_sequence extends uvm_sequence #(wb_transaction);
   `uvm_object_utils(base_sequence)
   `uvm_declare_p_sequencer(wb_master_seqr)

   function new(string name = "base_seq");
      super.new(name);
   endfunction:new
   virtual task pre_body(); 
      uvm_phase phase_=get_starting_phase();

      if (get_starting_phase()!= null)
	phase_.raise_objection(this);

   endtask:pre_body
   virtual task post_body(); uvm_phase phase_=get_starting_phase();

      if (get_starting_phase()!= null)
	phase_.drop_objection(this);
   endtask:post_body
endclass
