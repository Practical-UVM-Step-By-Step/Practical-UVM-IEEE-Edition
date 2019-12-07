`ifndef WB_ENV_TB_MOD__SV
 `define WB_ENV_TB_MOD__SV

 `include "mstr_slv_intfs.incl"
module wb_env_tb_mod;

   import uvm_pkg::*;
   typedef class my_run_test_callback;

 `include "wb_env_env.sv"
 `include "wb_env_slave_test.sv"  //ToDo: Change this name to the testcase file-name
 `include "wb_env_phase_callback_test.sv"

   my_run_test_callback run_test_cb;
   typedef virtual wb_master_if v_if1;
   typedef virtual wb_slave_if v_if2;
   initial begin
      uvm_config_db #(v_if1)::set(null,"uvm_test_top.env.master_agent","mst_if",wb_env_top_mod.mast_if); 
      uvm_config_db #(v_if2)::set(null,"uvm_test_top.env.slave_agent","slv_if",wb_env_top_mod.slave_if);
      uvm_config_db #(int)::set(null, "", "max_n_wss", 10);
      uvm_config_db #(int)::set(null, "", "min_addr", 0); 
      uvm_config_db #(int)::set(null, "", "max_addr", 10000000); 
      uvm_config_db #(bit) :: set(null,"env.slave_agent","is_active",1);
      uvm_config_db #(bit) :: set(null,"env.master_agent","is_active",1);

      run_test_cb = new("run_test_cb");
      uvm_run_test_callback::add(run_test_cb);

      run_test();
   end

endmodule: wb_env_tb_mod

`endif // WB_ENV_TB_MOD__SV

