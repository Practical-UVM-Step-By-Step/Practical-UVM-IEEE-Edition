`define UVM_ENABLE_DEPRECATED_API
module top;
   import uvm_pkg::*;
`include "class_P_do_methods.sv"

   uvm_printer uvm_default_table_printer = uvm_table_printer::get_default() ;
   uvm_printer uvm_default_tree_printer = uvm_tree_printer::get_default() ;
   uvm_printer uvm_default_line_printer = uvm_line_printer::get_default() ;

   UVM_FILE myfile;

   class_A cl1 = new("Child Class");
   initial begin
      
      cl1.print(uvm_default_table_printer);
      cl1.print(uvm_default_line_printer);
      
   end
endmodule


