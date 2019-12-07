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

`ifndef VGA_LCD_VGA_LCD_REG_UNLOCK
 `define VGA_LCD_VGA_LCD_REG_UNLOCK


class vga_lcd_reg_unlock_test extends vga_lcd_env_base_test;

   `uvm_component_utils(vga_lcd_reg_unlock_test)

   ral_block_vga_lcd ral_regmodel;
   uvm_status_e status;

   uvm_reg_data_t value_w;
   uvm_reg_data_t value_r;
   uvm_reg rg;

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction

   task run_phase(uvm_phase phase);
      uvm_objection phase_done = phase.get_objection();
      value_w = 32'h00001111;
      env.ral_regmodel.CTRL.get_offset();
      `uvm_info("RAL_REGMODEL_OFFSET",$sformatf("Offset of CTRL register is %x", env.ral_regmodel.CTRL.get_offset()),UVM_LOW)
      env.ral_regmodel.unlock_model();
      env.ral_regmodel.CTRL.set_offset(env.ral_regmodel.default_map,0,0);
      env.ral_regmodel.lock_model();
      `uvm_info("RAL_REGMODEL_OFFSET",$sformatf("Offset of CTRL register is %x", env.ral_regmodel.CTRL.get_offset()),UVM_LOW)

      env.ral_regmodel.set_coverage(UVM_CVR_ALL);
      phase_done.raise_objection(this);
      rg = env.ral_regmodel.CTRL;
      rg.read(status, value_r,.path(UVM_FRONTDOOR));
      `uvm_info(get_full_name()," Done front  door",UVM_LOW)
      `uvm_info("REGISTER READ",$sformatf("register value is %x",value_r),UVM_LOW)
//      phase_done.set_drain_time(this,200);
      phase_done.drop_objection(this);
   endtask : run_phase

endclass : vga_lcd_reg_unlock_test

`endif
