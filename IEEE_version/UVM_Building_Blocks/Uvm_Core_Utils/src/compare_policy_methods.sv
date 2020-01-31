/* This example illustrates a custom comparer
 * and the copy operation 
 */

module top;
`include "uvm_macros.svh"
   import uvm_pkg::*;
   
   // Class definition
class class_A extends uvm_object;

   int cl_int;
   string cl_string;
   int 	  cl_int_arr[];
   int 	  logic_data[int];

   `uvm_object_utils_begin(class_A)
      `uvm_field_int(cl_int,UVM_DEFAULT)
      `uvm_field_array_int(cl_int_arr,UVM_DEFAULT)
      `uvm_field_aa_int_int(logic_data,UVM_DEFAULT)
      `uvm_field_string(cl_string,UVM_DEFAULT)
   `uvm_object_utils_end
   
   function new(string name="");
      int idx = 1;
      super.new(name);	
      cl_string = name;
   endfunction

endclass

   class_A    class_A_inst1;
   class_A    class_A_inst2;

class custom_comparer extends uvm_comparer;

   int unsigned show_max = 10;
   string 	miscompares  = "srivatsa %m";
   
endclass

   initial begin
      custom_comparer c_comp = new();
      c_comp.set_show_max(2);

      class_A_inst1 = class_A::type_id::create("child_inst1");
      class_A_inst2 = class_A::type_id::create("child_inst2");
      // Custom Comparison:

      class_A_inst1.randomize();
      
      class_A_inst2.randomize();
      class_A_inst2.copy(class_A_inst1);
      
      class_A_inst1.logic_data[16 ] = 2;
      class_A_inst1.logic_data[32 ] = 2;
      class_A_inst1.logic_data[64] = 2;
      class_A_inst1.logic_data[128] = 1;
      class_A_inst1.print();
      class_A_inst2.print();
      class_A_inst1.compare(class_A_inst2, c_comp);
      `uvm_info("HELLO THERE",c_comp.get_miscompares(),UVM_LOW)

   end 
endmodule
