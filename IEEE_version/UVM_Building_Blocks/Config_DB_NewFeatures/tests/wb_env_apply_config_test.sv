`ifndef APPLY_CONFIG_TEST__SV
 `define APPLY_CONFIG_TEST__SV

typedef class wb_env;

class apply_config_test extends wb_env_base_test;

   `uvm_component_utils(apply_config_test)

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      uvm_factory f = uvm_coreservice_t::get().get_factory();
      f.set_type_override_by_type(wb_master::get_type(),wb_master_no_config::get_type());

      super.build_phase(phase);
   endfunction

   virtual function void connect_phase(uvm_phase phase);
      uvm_root uvm_top = uvm_root::get();
      uvm_top.print_topology();
   endfunction
   

endclass : apply_config_test

`endif //APPLY_CONFIG_TEST__SV

