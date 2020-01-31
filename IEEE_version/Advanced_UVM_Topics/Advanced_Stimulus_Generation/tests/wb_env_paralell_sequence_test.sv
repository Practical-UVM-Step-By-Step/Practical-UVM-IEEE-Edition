`ifndef WB_ENV_PARALLEL_TEST__SV
 `define WB_ENV_PARALLEL_TEST__SV

typedef class wb_env;

class wb_parallel_sequence_test extends wb_env_base_test;
   bit test_pass = 1;

   `uvm_component_utils(wb_parallel_sequence_test)

   wb_env env;

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      begin: configure
	 uvm_config_db #(uvm_object_wrapper)::set(this, "env.master_agent.mast_sqr.run_phase", "default_sequence", parallel_sequence::get_type()); 

      end 
   endfunction
   task run_phase(uvm_phase phase);
      //set a drain-time for the environment if desired - See the base test for a note
      //       phase.phase_done.set_drain_time(this, 50); 
   endtask : run_phase


endclass : wb_parallel_sequence_test

`endif //WB_ENV_PARALLEL_TEST__SV

