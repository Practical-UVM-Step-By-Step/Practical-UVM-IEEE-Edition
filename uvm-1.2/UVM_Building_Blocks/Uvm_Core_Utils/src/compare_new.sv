/* This example illustrates a custom comparer
 * and the copy operation 
 */

module top;
`include "uvm_macros.svh"
   import uvm_pkg::*;
`include "class.sv" 
   // Class definition
   class_A    class_A_inst1;
   class_A    class_A_inst2;

   initial begin
      uvm_comparer c_comp = new();
      c_comp.show_max = 1;
      c_comp.sev = uvm_pkg::UVM_WARNING;

      class_A_inst1 = class_A::type_id::create("child_inst1");
      class_A_inst1.set_value(32);
      class_A_inst2 = class_A::type_id::create("child_inst2");
      class_A_inst2.set_value(16);
      
      class_A_inst1.randomize();
      class_A_inst2.randomize();
      // Make a copy into class_A_inst2.
      class_A_inst2.copy(class_A_inst1);
      // Change the values in class_A_inst1. 
      class_A_inst1.logic_data[16 ] = 2;
      class_A_inst1.logic_data[32 ] = 2;
      class_A_inst1.logic_data[64] = 2;
      class_A_inst1.logic_data[128] = 1;
      // We should see miscompares.
      class_A_inst1.compare(class_A_inst2, c_comp);
      // We can get all the miscompares into a string and print them
      `uvm_info("COMPARES",c_comp.miscompares,UVM_LOW)

   end 
endmodule
