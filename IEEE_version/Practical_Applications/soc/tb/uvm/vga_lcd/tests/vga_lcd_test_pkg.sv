`ifndef VGA_LCD_TEST_PKG
 `define VGA_LCD_TEST_PKG

package vga_lcd_test_pkg; 
   import uvm_pkg::*;
 `include "vga_lcd_env.sv"
 `include "vga_lcd_env_base_test.sv"
 `include "vga_lcd_reg_access.sv"
 `include "vga_lcd_reg_single_access.sv"
 `include "vga_lcd_reg_hw_reset.sv"
 `include "vga_lcd_reg_single_access_front.sv"
 `include "vga_lcd_reg_single_access_bkdoor.sv"
 `include "vga_lcd_unlock_test.sv"
endpackage

`endif
