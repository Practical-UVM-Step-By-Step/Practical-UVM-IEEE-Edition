`ifndef TEST__SV1_simple_uvm_reg_bit_bash_seq
 `define TEST__SV1_simple_uvm_reg_bit_bash_seq


class simple_uvm_reg_bit_bash_seq_test extends simple_ral_env_test;

   `uvm_component_utils(simple_uvm_reg_bit_bash_seq_test)
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
      uvm_reg_single_bit_bash_seq  seq = uvm_reg_single_bit_bash_seq::type_id::create("uvm_reg_single_bit_bash_seq",this);
      phase_done = phase.get_objection();
      value_w = 32'h12345678;
      phase.raise_objection(this);

      seq.model = env.regmodel;
      seq.rg = env.regmodel.r_RC_register;
      seq.start(null);
      seq.wait_for_sequence_state(UVM_FINISHED);

      phase_done.set_drain_time(this,2000);
      phase.drop_objection(this);
      
   endtask

endclass : simple_uvm_reg_bit_bash_seq_test

`endif //TEST__SV1_simple_uvm_reg_bit_bash_seq

