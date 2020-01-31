`ifndef VGA_LCD_VGA_LCD_REG_SINGLE_ACCESS_BKDOOR
 `define VGA_LCD_VGA_LCD_REG_SINGLE_ACCESS_BKDOOR

class vga_lcd_reg_single_access_test_bkdoor extends vga_lcd_env_base_test;

   `uvm_component_utils(vga_lcd_reg_single_access_test_bkdoor)

   uvm_status_e status;

   uvm_reg_data_t value_w;
   uvm_reg_data_t value_r;
   uvm_reg rg;

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction

   task main_phase(uvm_phase phase);
      uvm_objection phase_done = phase.get_objection();
      phase_done.raise_objection(this);
      value_w = 32'h00001111;

      rg = env.ral_regmodel.HTIM;
      `uvm_info(get_full_name(),"Starting Backdoor write access to VTIM",UVM_LOW)
      rg.write(status, value_w, .path(UVM_BACKDOOR));
      `uvm_info(get_full_name(),"Ending Backdoor write access to VTIM",UVM_LOW)
      `uvm_info(get_full_name(),"Starting Backdoor read access to VTIM",UVM_LOW)
      rg.read(status, value_r, .path(UVM_BACKDOOR));
      `uvm_info(get_full_name(),"Ending Backdoor read access to VTIM",UVM_LOW)
      // Another way of doing this
      env.ral_regmodel.HTIM.write(status, value_w, .path(UVM_BACKDOOR));
      env.ral_regmodel.HTIM.read(status, value_r, .path(UVM_BACKDOOR));

      phase_done.set_drain_time(this,200);
      phase_done.drop_objection(this);
   endtask : main_phase

endclass : vga_lcd_reg_single_access_test_bkdoor

`endif
