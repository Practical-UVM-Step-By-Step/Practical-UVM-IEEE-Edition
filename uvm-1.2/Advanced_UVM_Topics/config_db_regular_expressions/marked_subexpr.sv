`include "my_env_pkg.sv"
module top;
   import uvm_pkg::*;
   import my_env_pkg::*;

   my_env topenv;


   logic unsigned [4095:0] my_int;
   string 		   my_string;

   initial begin
      uvm_config_db #(int)::set(null,"/topenv\.t(omm){3}[1*].\.u1/", "s", 42);
      topenv = new("topenv", null);

      run_test();


   end

endmodule
