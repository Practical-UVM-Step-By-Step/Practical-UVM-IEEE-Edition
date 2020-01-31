//
// Template for VMM-compliant testcase
//

//Error Injection Callbacks
class simple_dut_env_wb_simple_trans_bfm_1_err_callbacks extends simple_dut_env_wb_simple_trans_bfm_1_callbacks;

   // Called before a transaction has been executed by physical driver
   virtual task pre_trans(simple_dut_env_wb_simple_trans_bfm_1 xactor,
                          wb_simple_trans tr,
                          ref bit drop);
      if(!drop) begin
         //ToDo: Add the Error Injection logic to modify the transaction tr, if needed
      end   
   endtask: pre_trans

endclass : simple_dut_env_wb_simple_trans_bfm_1_err_callbacks

`vmm_test_begin(simple_dut_env_test, simple_dut_env_env, "simple_dut_env_test")
//Instantiating Error Injection callback, ToDo: Instantiates other callbacks if any
simple_dut_env_wb_simple_trans_bfm_1_err_callbacks xct_err_inj_cb=new(); 
// ToDo: Set configuration parameters and turn rand mode OFF, if needed
env_inst.build();

//registering the error injection callback before scoreboard callbacks to keep the scoreboard 'aware' of Errors. 
//ToDo: Append/Prepend other callbacks if required
env_inst.driver_0.prepend_callback(xct_err_inj_cb);        


// ToDo: Set message service interface verbosity, if needed

// ToDo: Replace factory instances, if needed

env_inst.start();

begin
   // For multiple driver, set total number of transaction for all driver
   // `foreach_vmm_xactor(simple_dut_env_wb_simple_trans_bfm_1, "/./", "/./") begin
   // xact.stop_after_n_insts = 3;
   // end
   // ToDo: Directed stimulus, if needed
end

env_inst.run();
`vmm_test_end(simple_dut_env_test)
