`ifndef WB_SVTB_TOP_PROG

 `define WB_SVTB_TOP_PROG
program wb_svtb_test(wb_master_if m_intf, wb_slave_if s_intf);
   wb_svtb_env env;
   initial begin
      env = new(m_intf, s_intf);
      //      env.gen.repeat_count = 10;
   end
endprogram

`endif
