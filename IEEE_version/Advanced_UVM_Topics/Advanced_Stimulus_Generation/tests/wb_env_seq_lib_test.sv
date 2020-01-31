`ifndef TEST_SEQ_LIB__SV
 `define TEST_SEQ_LIB__SV


class wb_env_seq_lib_test extends wb_env_base_test;
   `uvm_component_utils(wb_env_seq_lib_test)
   wb_master_seqr_sequence_library seq_lib;

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction

   task run_phase(uvm_phase phase);
      seq_lib = wb_master_seqr_sequence_library::type_id::create("seq_lib");
      seq_lib.set_automatic_phase_objection(1);
      seq_lib.selection_mode = UVM_SEQ_LIB_RANDC;
      seq_lib.randomize();
      seq_lib.start(env.master_agent.mast_sqr);
      seq_lib.wait_for_sequence_state(UVM_FINISHED);
   endtask : run_phase


endclass : wb_env_seq_lib_test

`endif //TEST_SEQ_LIB__SV

