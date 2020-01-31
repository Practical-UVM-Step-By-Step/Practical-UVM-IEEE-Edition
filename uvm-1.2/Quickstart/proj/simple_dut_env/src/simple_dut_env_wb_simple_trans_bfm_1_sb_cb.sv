//
// Template for VMM-compliant Data Stream Scoreboard Callbacks
//

`ifndef SIMPLE_DUT_ENV_SCBD_CB__SV
 `define SIMPLE_DUT_ENV_SCBD_CB__SV

typedef class simple_dut_env_wb_simple_trans_bfm_1;
   typedef class simple_dut_env_scbd;

   //ToDo: Callback methods of this class are made only with respect to physical level components(driver/monitor)
class simple_dut_env_wb_simple_trans_bfm_1_sb_callbacks extends simple_dut_env_wb_simple_trans_bfm_1_callbacks;

   simple_dut_env_scbd sb;

   function new(simple_dut_env_scbd sb);
      this.sb = sb;
      // ToDo: Add relevant code  
   endfunction: new

   // ToDo: Add additional relevant callbacks
   // ToDo: Use a task if callbacks can be blocking

   // Called after a transaction has been executed
   virtual task post_ex_trans(simple_dut_env_wb_simple_trans_bfm_1 xactor,
                              wb_simple_trans tr);
      sb.insert(tr);  
      // ToDo: Add relevant code  
   endtask: post_ex_trans

endclass: simple_dut_env_wb_simple_trans_bfm_1_sb_callbacks

`endif // SIMPLE_DUT_ENV_SCBD_CB__SV
