//
// Template for VMM-compliant Monitor to Coverage Connector Callbacks
//


`ifndef SIMPLE_DUT_ENV_MON_2COV_CONNECT
 `define SIMPLE_DUT_ENV_MON_2COV_CONNECT


class simple_dut_env_mon_2cov_connect extends simple_dut_env_mon_callbacks;

   simple_dut_env_cov cov;

   function new(simple_dut_env_cov cov);
      this.cov = cov;
   endfunction: new

   // ToDo: Use "function" if callbacks cant be blocking
   
   // Callback method post_cb_trans can be used for coverage
   virtual task post_cb_trans(simple_dut_env_mon xactor,
                              wb_simple_trans tr);
      cov.tr = tr; 
      -> cov.cov_event;
      
   endtask: post_cb_trans

endclass: simple_dut_env_mon_2cov_connect

`endif // SIMPLE_DUT_ENV_MON_2COV_CONNECT
