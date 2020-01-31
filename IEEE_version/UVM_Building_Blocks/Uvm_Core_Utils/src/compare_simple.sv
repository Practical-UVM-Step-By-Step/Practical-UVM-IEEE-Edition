module top;
`include "uvm_macros.svh"
   import uvm_pkg::*;
   typedef class class_A;

`include "class.sv"

   class_A    class_A_inst1;
   class_A    class_A_inst2;
   initial begin
      // free children
      class_A_inst1 = new("child_inst1");
      class_A_inst2 = new("child_inst3");

      class_A_inst1.randomize();
      class_A_inst1.print();
      class_A_inst2.randomize();
      class_A_inst2.print();
      class_A_inst2.copy(class_A_inst1);
      class_A_inst1.print();
      
      class_A_inst2.compare(class_A_inst1);
      class_A_inst2.cl_int = 2;
      class_A_inst2.compare(class_A_inst1);

   end 
endmodule
