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

`ifndef VGA_LCD_VGA_LCD_REG_SINGLE_ACCESS_FRONT
 `define VGA_LCD_VGA_LCD_REG_SINGLE_ACCESS_FRONT

class vga_lcd_reg_single_access_test_frontdoor extends vga_lcd_env_base_test;

   `uvm_component_utils(vga_lcd_reg_single_access_test_frontdoor)

   ral_block_vga_lcd ral_regmodel;
   uvm_status_e status;

   uvm_reg_data_t value_w;
   uvm_reg_data_t value_r;
   uvm_reg rg;

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction

   task main_phase(uvm_phase phase);
      uvm_objection phase_done = phase.get_objection();
      value_w = 32'h00001111;
      env.ral_regmodel.set_coverage(UVM_CVR_ALL);
      phase_done.raise_objection(this);
      rg = env.ral_regmodel.HTIM;
      `uvm_info(get_full_name(),"Starting Back door",UVM_LOW)
      rg.write(status, value_w,.path(UVM_FRONTDOOR));
      `uvm_info(get_full_name()," Done Back door",UVM_LOW)
      `uvm_info(get_full_name(),"Starting Back door",UVM_LOW)
      rg.read(status, value_r,.path(UVM_FRONTDOOR));
      `uvm_info(get_full_name()," Done Back door",UVM_LOW)

      phase_done.set_drain_time(this,200);
      phase.drop_objection(this);
   endtask : main_phase

endclass : vga_lcd_reg_single_access_test_frontdoor

`endif
