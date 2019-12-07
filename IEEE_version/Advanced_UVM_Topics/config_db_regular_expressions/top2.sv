import uvm_pkg::*;

`include "my_env_pkg.sv"
module top2;

   import my_env_pkg::*;

`include "uvm_macros.svh"
`include "classA.svh"
`include "classB.svh"
`include "classD.svh"
`include "my_env.svh"
`include "test1.sv"
`include "test2.sv"
`include "test3.sv"
`include "test4.sv"
`include "test5.sv"
`include "test6.sv"
   

   initial begin
      run_test();

   end

endmodule
