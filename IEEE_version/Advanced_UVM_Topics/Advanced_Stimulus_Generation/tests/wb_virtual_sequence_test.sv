`ifndef WB_ENV_VIRTUAL_SEQUENCE_TEST__SV
 `define WB_ENV_VIRTUAL_SEQUENCE_TEST__SV

typedef class wb_env;

class wb_virtual_sequence_test extends wb_env_base_test;
   bit test_pass = 1;

   `uvm_component_utils(wb_virtual_sequence_test)

   wb_env env;

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
         uvm_config_db #(uvm_object_wrapper)::set(this, "env.virt_sequencer.main_phase", "default_sequence", wb_virtual_seq::get_type());
   endfunction

endclass : wb_virtual_sequence_test

`endif //WB_ENV_VIRTUAL_SEQUENCE_TEST__SV

