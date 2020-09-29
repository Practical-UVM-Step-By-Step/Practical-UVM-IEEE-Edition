/***********************************************
 *                                              *
 * Examples for the book Practical UVM          *
 *                                              *
 * Copyright Srivatsa Vasudevan 2010-2016       *
 * All rights reserved                          *
 *                                              *
 * Permission is granted to use this work       * 
 * provided this notice and attached license.txt*
 * are not removed/altered while redistributing *
 * See license.txt for details                  *
 *                                              *
 ************************************************/

`timescale 1ns/1ps
`ifndef ETH_BLK_ENV_TB_MOD__SV
 `define ETH_BLK_ENV_TB_MOD__SV

 `include "mstr_slv_intfs.incl"
 `include "uvm_macros.svh"
 `include "wb_test_pkg.sv"
module eth_blk_env_tb_mod;
   import uvm_pkg::*;
   import wb_eth_test::*;
   typedef virtual mii_if mii_intf;
   typedef virtual wb_master_if mast_if;
   typedef virtual wb_slave_if slv_if;
   typedef virtual interrupt_eth_if eth_rst_intr_if;
   typedef virtual reset_if v_rst_if;
   initial begin
      uvm_config_db #(v_rst_if)::set(null,"uvm_test_top.env.rst_agent","rst_if",eth_env_top.rst_if);
      uvm_config_db #(mast_if)::set(null,"uvm_test_top.env.wb_master_agt","mst_if",eth_env_top.mast_if); 
      uvm_config_db #(slv_if)::set(null,"uvm_test_top.env.wb_slave_agt","slv_if",eth_env_top.slv_if);
      uvm_config_db #(mii_intf)::set(null,"uvm_test_top.env.mii_rx_agt","mii_if",eth_env_top.mii_if_b);
      uvm_config_db #(mii_intf)::set(null,"uvm_test_top.env.mii_tx_agt","mii_if",eth_env_top.mii_if_b);
      uvm_config_db #(eth_rst_intr_if)::set(null,"uvm_test_top.env.wb_master_agt.mast_sqr","ethernet_int_if",eth_env_top.intr_if);

      run_test();
   end

endmodule

`endif // ETH_BLK_ENV_TB_MOD__SV

