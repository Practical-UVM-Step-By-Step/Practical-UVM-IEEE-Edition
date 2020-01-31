`ifndef WB_SVTB_SLAVE
 `define WB_SVTB_SLAVE

class wb_svtb_slave;

   virtual wb_slave_if slvif;

   function new(virtual wb_slave_if slv_if);
      slvif = slv_if;
   endfunction

   task run();
   endtask

endclass



`endif

