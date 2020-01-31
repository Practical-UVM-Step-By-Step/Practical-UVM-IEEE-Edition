`define UVM_ENABLE_DEPRECATED_API
module top;
   import uvm_pkg::*;
`include "complete_class.sv"


   uvm_line_printer local_line_printer = new;
   uvm_tree_printer local_tree_printer = new;
   uvm_table_printer local_table_printer = new;
   UVM_FILE myfile;

   class_A cl1 = new("Child Class");
   initial begin
      
      cl1.print(local_table_printer);
      cl1.print(local_line_printer);
      
   end
endmodule

