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

//
// Template for Top module
//

`ifndef VGA_LCD_ENV_TOP__SV
 `define VGA_LCD_ENV_TOP__SV
 `include "vga_enh_top_wrap.sv"
module vga_lcd_env_top();

   logic clk;
   logic rst;
   logic interrupt;

   // Clock Generation
   parameter sim_cycle = 10;
   
   // Reset Delay Parameter
   parameter rst_delay = 50;

   initial begin
      clk  = 0;
      forever clk = #(sim_cycle/2) ~clk;
   end

   wb_vga_disp_if disp_if();
   wb_slave_if slv_if(clk,rst);
   wb_master_if mast_if(clk,rst);
   reset_if rst_if(clk,rst);
   vga_lcd_env_tb_mod test(); 
   
   // Dut Instance 

   vga_enh_top_wrap_if vga_enh_top(.wb_clk(clk), .wb_rst(rst), .wb_inta_o(interrupt), .mast_if(mast_if),.slv_if(slv_if),.disp_if(disp_if));
   
endmodule: vga_lcd_env_top

`endif // VGA_LCD_ENV_TOP__SV
