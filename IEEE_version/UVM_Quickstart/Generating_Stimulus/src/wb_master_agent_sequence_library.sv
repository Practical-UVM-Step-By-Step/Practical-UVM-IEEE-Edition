`ifndef WB_MASTER_SEQR_SEQUENCE_LIBRARY
 `define WB_MASTER_SEQR_SEQUENCE_LIBRARY

typedef class wb_transaction;

class wb_master_seqr_sequence_library extends uvm_sequence_library # (wb_transaction);
   `uvm_sequence_library_utils(wb_master_seqr_sequence_library)

   function new(string name = "simple_seq_lib");
      super.new(name);
      init_sequence_library();
   endfunction

endclass  

class base_sequence extends uvm_sequence #(wb_transaction);
   `uvm_object_utils(base_sequence)

   function new(string name = "base_seq");
      super.new(name);
   endfunction:new
   virtual task pre_body();
      uvm_phase phase_ = get_starting_phase();
      if (phase_ != null)
	phase_.raise_objection(this);
   endtask:pre_body
   virtual task post_body();
      uvm_phase phase_ = get_starting_phase();
      if (phase_ != null)
	phase_.drop_objection(this);
   endtask:post_body

endclass

 `include "sequences/wb_master_agent_sequence_0.sv"
 `include "sequences/wb_master_agent_sequence_1.sv"
 `include "sequences/wb_master_agent_repeated_read_sequence.sv"
 `include "sequences/wb_master_agent_objection_in_sequence.sv"

`endif
