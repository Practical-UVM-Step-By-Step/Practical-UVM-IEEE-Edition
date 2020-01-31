`ifndef RESET_IF__SV
 `define RESET_IF__SV

interface reset_if (input wire clk, output logic rst);

   parameter setup_time = 5/*ns*/;
   parameter hold_time  = 3/*ns*/;



   clocking master_cb @(posedge clk);
      output rst;
   endclocking




   clocking monitor_cb @(posedge clk);
      // Common Signals
      input  rst;
   endclocking


   modport master (clocking master_cb);


   modport monitor (clocking monitor_cb);


endinterface: reset_if

`endif // RESET_IF__SV
