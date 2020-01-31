class reset_base_sequence extends uvm_sequence #(reset_trans);
   `uvm_object_utils(reset_base_sequence)

   function new(string name = "reset_base_seq");
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
class reset_sequence extends reset_base_sequence;

   `uvm_object_utils(reset_sequence)

   function new(string name = "seq_0");
      super.new(name);
   endfunction:new

   virtual task body();
      `uvm_info("RESET_SEQUENCE","Starting Reset Sequence",UVM_LOW)

      `uvm_info("RESET_SEQUENCE","Deasserting Reset ",UVM_LOW)
      `uvm_do(req, get_sequencer(), -1, {reset_kind == reset_trans::DEASSERT; cycles == 3;})
      `uvm_info("RESET_SEQUENCE","Asserting Reset ",UVM_LOW)
      `uvm_do(req, get_sequencer(), -1, {reset_kind == reset_trans::ASSERT; cycles == 5;})
      `uvm_info("RESET_SEQUENCE","Deasserting Reset ",UVM_LOW)
      `uvm_do(req, get_sequencer(), -1, {reset_kind == reset_trans::DEASSERT; cycles == 2;})

      `uvm_info("RESET_SEQUENCE","Ended Reset Sequence",UVM_LOW)

   endtask

endclass
