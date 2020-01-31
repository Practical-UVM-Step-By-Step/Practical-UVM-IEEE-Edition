//
// Template for Top module
//

`ifndef SIMPLE_DUT_ENV_TOP__SV
 `define SIMPLE_DUT_ENV_TOP__SV

module simple_dut_env_top();

   logic ck1;
   logic ck2;
   logic rst_n;

   // Clock Generation
   parameter sim_cycle = 10;
   
   // Reset Delay Parameter
   parameter rst_delay = 50;

   always 
     begin
        ck1 = #(sim_cycle/2) ~ck1;
        ck2 = #(sim_cycle/2) ~ck2;
     end

   simple_dut_env_if intf[ 2] (ck1,ck2);
   simple_dut_env_prog test(intf); 
   
   // ToDo: Include Dut instance here
   
   //Driver reset depending on rst_delay
   initial
     begin
        ck1   = 0;
        ck2   = 0;
        rst_n = 1;
	#1 rst_n = 0;
        repeat (rst_delay) @(ck1);
        rst_n = 1'b1;
        @(ck1);
     end

endmodule: simple_dut_env_top

`endif // SIMPLE_DUT_ENV_TOP__SV
