`ifndef WB_ENV_TEST_PHASE_CB__SV
 `define WB_ENV_TEST_PHASE_CB__SVWB_ENV_TEST_PHASE_CB__SV

typedef class wb_env_env;

class my_uvm_phase_cb extends uvm_phase_cb;
   `uvm_object_utils(my_uvm_phase_cb)

   function void phase_state_change( uvm_phase phase, uvm_phase_state_change change);
      uvm_phase_state old_state = change.get_prev_state();
      uvm_phase_state new_state = change.get_state();

      `uvm_info("PHASE STATE_CHANGE ", $sformatf("phase name: %s , OLD STATE %s, NEW STATE : %s\n",phase.get_name(),old_state.name(),new_state.name()),UVM_LOW)

   endfunction

   function new(string name="my_phase_cb");
      super.new(name);
   endfunction

endclass



class wb_env_test_phase_cb extends uvm_test;
   bit test_pass = 1;

   wb_config wb_master_config;
   wb_config wb_slave_config;
   my_uvm_phase_cb my_phase_cb;

   `uvm_component_utils(wb_env_test_phase_cb)

   wb_env_env env;

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      my_phase_cb = new("my simple phase callback");
      uvm_phase_cb_pool::add(null,my_phase_cb);
      env = wb_env_env::type_id::create("env", this);
      wb_master_config = new("wb_master_config");
      wb_slave_config = new("wb_slave_config");

      wb_master_config.max_n_wss = 10;
      wb_master_config.min_addr = 0;
      wb_master_config.max_addr = 10000000;

      wb_slave_config.max_n_wss = 10;
      wb_slave_config.min_addr = 0;
      wb_slave_config.max_addr = 10000000;

      begin: configure
	 uvm_config_db #(uvm_object_wrapper)::set(this, "env.master_agent.mast_sqr.run_phase", "default_sequence", sequence_1::get_type()); 
	 uvm_config_db #(uvm_object_wrapper)::set(this, "env.slave_agent.slv_seqr.run_phase", "default_sequence", ram_sequence::get_type()); 

	 uvm_config_db #(wb_config)::set(this, "env.master_agent", "config", wb_master_config); 
	 uvm_config_db #(wb_config)::set(this, "env.slave_agent", "config", wb_slave_config); 
      end 
   endfunction
   task run_phase(uvm_phase phase);
      uvm_phase phase_ = phase;
      uvm_objection obj_ = phase.get_objection();
      //set a drain-time for the environment if desired
      obj_.set_drain_time(this, 50);
   endtask : run_phase


endclass : wb_env_test_phase_cb

`endif //TEST__SV

