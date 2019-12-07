//
// Template for VMM-compliant verification environment
//

`ifndef SIMPLE_DUT_ENV__SV
`define SIMPLE_DUT_ENV__SV

`include "vmm.sv"
`include "vmm_sb.sv"
`include "simple_dut_env_cfg.sv"
`include "wb_simple_trans.sv"    
`include "wb_simple_trans.sv"    
`include "simple_dut_env_scbd.sv"

`include "simple_dut_env_wb_simple_trans_bfm_1.sv"  
`include "simple_dut_env_wb_simple_trans_bfm_2.sv"  
//ToDo: If you have multiple drivers in the environment, Include other drivers here. 
`include "simple_dut_env_wb_simple_trans_bfm_1_sb_cb.sv"
`include "simple_dut_env_mon.sv"
`include "simple_dut_env_mon_sb_cb.sv"
`include "simple_dut_env_slave.sv"
`include "simple_dut_env_cov.sv"
`include "simple_dut_env_mon_2cov_connect.sv"

// ToDo: Add additional required `include directives

`endif // SIMPLE_DUT_ENV__SV
