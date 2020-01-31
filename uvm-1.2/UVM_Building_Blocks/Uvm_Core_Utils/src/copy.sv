module top;
   import uvm_pkg::*;
   typedef class class_A;

`include "class.sv"

   class_P  class_P_inst1;
   class_P  class_P_inst2;
   initial begin
      // Create and print instances
      class_P_inst1 = new("first_inst");
      class_P_inst1.randomize();
      class_P_inst1.print();
      
      class_P_inst2 = new("second_inst");
      class_P_inst2.randomize();
      class_P_inst2.print();

      class_P_inst2.copy(class_P_inst1);
      class_P_inst2.print();

   end 
endmodule
