
`ifndef WB_ENV_TB_MOD__SV
 `define WB_ENV_TB_MOD__SV

 `include "mstr_slv_intfs.incl"
 `include "wb_test.pkg"
module wb_env_tb_mod;

   import uvm_pkg::*;
   import wb_tests::*;

   typedef virtual wb_master_if v_if1;
   typedef virtual wb_slave_if v_if2;
   initial begin
      uvm_config_db #(v_if1)::set(null,"uvm_test_top.env.rst_agent","mst_if",wb_env_top_mod.mast_if); 
      uvm_config_db #(v_if1)::set(null,"uvm_test_top.env.master_agent","mst_if",wb_env_top_mod.mast_if); 
      uvm_config_db #(v_if2)::set(null,"uvm_test_top.env.slave_agent","slv_if",wb_env_top_mod.slave_if);
      run_test();
   end

endmodule: wb_env_tb_mod

`endif // WB_ENV_TB_MOD__SV

