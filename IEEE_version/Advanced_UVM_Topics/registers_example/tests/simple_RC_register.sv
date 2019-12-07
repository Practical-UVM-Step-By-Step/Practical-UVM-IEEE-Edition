`ifndef TEST__SV1_simple_RC_register
 `define TEST__SV1_simple_RC_register


class simple_RC_register_test extends simple_ral_env_test;

   `uvm_component_utils(simple_RC_register_test)
   uvm_reg_data_t value_w;
   uvm_reg_data_t value_r;
   uvm_reg rg;
   uvm_status_e status;



   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
   endfunction

   task run_phase(uvm_phase phase) ;
      uvm_objection phase_done;
      value_w = 32'h12345678;

      phase.raise_objection(this);

      rg = env.regmodel.r_RC_register;
      rg.read(status, value_r);
      `uvm_info("RC_REG_TEST",$sformatf("1:%x\n",value_r),UVM_LOW)
      value_r = 32'hffffffff;
      rg.read(status, value_r);
      `uvm_info("RC_REG_TEST",$sformatf("2:%x\n",value_r),UVM_LOW)
      rg.write(status, value_w);
      value_r = 32'hffffffff;
      rg.read(status, value_r);
      `uvm_info("RC_REG_TEST",$sformatf("3:%x\n",value_r),UVM_LOW)
      value_r = 32'hffffffff;
      rg.read(status, value_r);
      `uvm_info("RC_REG_TEST",$sformatf("4:%x\n",value_r),UVM_LOW)
      
      phase_done = phase.get_objection();
      phase_done.set_drain_time(this,2000);
   
      phase.drop_objection(this);
      
   endtask

endclass : simple_RC_register_test

`endif //TEST__SV1

