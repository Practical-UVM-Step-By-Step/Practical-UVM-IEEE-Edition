`ifndef TEST_SEQ_LIB__SV
 `define TEST_SEQ_LIB__SV

typedef class wb_env;
   typedef class wb_master_seqr_sequence_library;

class wb_env_seq_lib_test extends wb_env_base_test;
   `uvm_component_utils(wb_env_seq_lib_test)
   wb_env env;

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      begin: configure
	 
	 uvm_config_db #(uvm_object_wrapper)::set(this, "env.master_agent.mast_sqr.main_phase", "default_sequence", wb_master_seqr_sequence_library::type_id::get()); 
	 
      end:configure 
   endfunction

endclass : wb_env_seq_lib_test

`endif //TEST_SEQ_LIB__SV

