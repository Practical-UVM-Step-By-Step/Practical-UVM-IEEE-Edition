`ifndef WB_ENV_RUN_TEST_CALLBACK_TEST__SV
 `define WB_ENV_RUN_TEST_CALLBACK_TEST__SV



class my_run_test_callback extends uvm_run_test_callback;
   `uvm_object_utils(my_run_test_callback)

   function new(string name="my_run_test_callback");
      super.new(name);
   endfunction
   virtual function void pre_run_test();
      super.pre_run_test();
      `uvm_info("RUN_TEST_CALLBACK","\n\n\n\n\n\n\n This pre_run_test Callback was called before run_test is called \n\n\n\n\n", UVM_NONE);
   endfunction
   virtual function void post_run_test();
      super.pre_run_test();
      `uvm_info("RUN_TEST_CALLBACK"," \n\n\n\n\n\n This post_run_test Callback was called is AFTER run_test was done before collecting statistics \n\n\n\n\n\n", UVM_NONE);
   endfunction
   virtual	function void pre_abort();
      // You can call any function in here
   endfunction
endclass

class wb_env_run_test_callback_test extends  wb_env_slave_test;
   `uvm_component_utils(wb_env_run_test_callback_test)

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);


   endfunction
   task run_phase(uvm_phase phase);
      super.run_phase(phase);	
   endtask : run_phase


endclass : wb_env_run_test_callback_test

`endif //WB_ENV_RUN_TEST_CALLBACK_TEST__SV

