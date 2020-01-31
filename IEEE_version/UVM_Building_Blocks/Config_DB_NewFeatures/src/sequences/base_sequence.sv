class base_sequence extends uvm_sequence #(wb_transaction);
   `uvm_object_utils(base_sequence)

   function new(string name = "base_seq");
      super.new(name);
      set_automatic_phase_objection(1);
   endfunction:new

   virtual task pre_start();
      uvm_phase phase_ = get_starting_phase();
      if (phase_ != null)
	phase_.raise_objection(this);
   endtask:pre_start
   virtual task post_start();
      uvm_phase phase_ = get_starting_phase();
      if (phase_ != null)
	phase_.drop_objection(this);
   endtask:post_start

endclass
