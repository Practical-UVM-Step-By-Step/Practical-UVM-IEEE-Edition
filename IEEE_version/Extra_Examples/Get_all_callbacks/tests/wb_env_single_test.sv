`ifndef TEST__SV
 `define TEST__SV

typedef class wb_env_env;

class wb_env_test extends uvm_test;
   bit test_pass = 1;

   `uvm_component_utils(wb_env_test)

   wb_env_env env;

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      env = wb_env_env::type_id::create("env", this);
      uvm_config_db #(uvm_object_wrapper)::set(this, "env.master_agent.mast_sqr.run_phase", "default_sequence", sequence_1::get_type()); 
      uvm_config_db #(uvm_object_wrapper)::set(this, "env.slave_agent.slv_seqr.run_phase", "default_sequence", ram_sequence::get_type()); 
   endfunction
   task run_phase(uvm_phase phase);
      //set a drain-time for the environment if desired
      phase.phase_done.set_drain_time(this, 50);
   endtask : run_phase

   function void extract_phase(uvm_phase phase);

   endfunction 

   function void report_phase(uvm_phase phase);
      if(test_pass) begin
	 `uvm_info(get_type_name(), "** UVM TEST PASSED **", UVM_NONE)
      end
      else begin
	 `uvm_error(get_type_name(), "** UVM TEST FAIL **")
      end
   endfunction


endclass : wb_env_test

`endif //TEST__SV

