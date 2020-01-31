`ifndef GRAB_TEST__SV
 `define GRAB_TEST__SV

typedef class wb_env;

class wb_env_grab_test extends wb_env_base_test;
   bit test_pass = 1;

   `uvm_component_utils(wb_env_grab_test)

   wb_env env;

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      begin: configure
	 uvm_config_db #(uvm_object_wrapper)::set(this, "env.master_agent.mast_sqr.run_phase", "default_sequence", grabsequence::get_type()); 
      end 
   endfunction


endclass : wb_env_grab_test

`endif //GRAB_TEST__SV

