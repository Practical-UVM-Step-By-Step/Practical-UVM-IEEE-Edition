`ifndef WB_ENV_PHASE_CB_TEST
 `define WB_ENV_PHASE_CB_TEST


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

class wb_env_phase_cb_test extends wb_env_base_test;
   my_uvm_phase_cb my_phase_cb;
   `uvm_component_utils(wb_env_phase_cb_test)


   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      my_phase_cb = new("my simple phase callback");
      uvm_phase_cb_pool::add(null,my_phase_cb);
   endfunction


endclass : wb_env_phase_cb_test

`endif //TEST__SV

