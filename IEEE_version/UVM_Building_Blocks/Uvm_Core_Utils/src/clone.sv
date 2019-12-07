module top;
   import uvm_pkg::*;
   `include "class.sv"

   // Class definition

   class_A    class_A_inst1;
   class_A    class_A_inst2;
   initial begin
      // free children
      class_A_inst1 = new("child_inst1");

      class_A_inst1.randomize();
      class_A_inst1.print();
      $cast(class_A_inst2,class_A_inst1.clone());
      class_A_inst1.print();

   end 
endmodule
