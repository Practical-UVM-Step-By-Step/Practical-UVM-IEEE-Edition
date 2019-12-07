`ifndef WB_SVTB_TOP_PROG

 `define WB_SVTB_TOP_PROG
 `include "environment.sv"
program test(wb_master_if m_intf wb_slave_if s_intf);
   environment env;
   initial begin
      env = new(m_intf, s_intf);
      env.gen.repeat_count = 10;
      env.run();
   end
endprogram

`endif
