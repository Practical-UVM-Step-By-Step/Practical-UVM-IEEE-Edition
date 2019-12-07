/* This example illustrates a custom comparer
 * and the copy operation 
 */

module top;
`include "uvm_macros.svh"
   import uvm_pkg::*;
    `include "class.sv" 
   // Class definition
   class_P    class_P_inst1;
   class_P    class_P_inst2;



   initial begin
      uvm_comparer c_comp = new();
      c_comp.show_max = 1;
      c_comp.sev = uvm_pkg::UVM_WARNING;

      class_P_inst1 = new("class_P_inst1");
      class_P_inst1.cl1.set_value(32);
      class_P_inst2 = new("class_P_inst2");
      class_P_inst2.cl1.set_value(16);
      
      class_P_inst1.randomize();
      class_P_inst2.randomize();
      // Make a copy into class_P_inst2.
      class_P_inst2.copy(class_P_inst1);
      // Change the values in class_P_inst1. 
      class_P_inst1.cl1.logic_data[16 ] = 2;
      class_P_inst1.cl1.logic_data[32 ] = 2;
      class_P_inst1.cl1.logic_data[64] = 2;
      class_P_inst1.cl1.logic_data[128] = 1;
      // We should see miscompares.
      class_P_inst1.compare(class_P_inst2, c_comp);
      // We can get all the miscompares into a string and print them
      `uvm_info("COMPARES",c_comp.miscompares,UVM_LOW)

   end 
endmodule
