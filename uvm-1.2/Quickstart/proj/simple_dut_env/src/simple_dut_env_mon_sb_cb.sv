//
// Template for VMM-compliant Monitor scoreboard callbacks

`ifndef SIMPLE_DUT_ENV_MON_SB_CB__SV
 `define SIMPLE_DUT_ENV_MON_SB_CB__SV


typedef class simple_dut_env_mon;

class simple_dut_env_mon_sb_cb extends simple_dut_env_mon_callbacks;

   simple_dut_env_scbd sb;

   function new(simple_dut_env_scbd sb);
      this.sb = sb;
   endfunction: new

   // ToDo: Add additional relevant callbacks
   // ToDo: Use "task" if callbacks can be blocking

   virtual function void pre_trans (simple_dut_env_mon xactor,
                                    wb_simple_trans tr);
      // ToDo: Add relevant code  

   endfunction: pre_trans


   virtual function void post_trans (simple_dut_env_mon xactor,
                                     wb_simple_trans tr);
      sb.expect_in_order(tr);   
      // ToDo: Add relevant code if required 

   endfunction: post_trans

endclass: simple_dut_env_mon_sb_cb

`endif // SIMPLE_DUT_ENV_MON_SB_CB__SV
