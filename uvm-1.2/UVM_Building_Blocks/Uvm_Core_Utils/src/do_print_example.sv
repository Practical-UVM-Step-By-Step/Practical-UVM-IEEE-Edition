module top;
   import uvm_pkg::*;
   typedef class class_A;

   // Class definition
class class_A extends uvm_object;

   int cl_int;
   string cl_string;
   int 	  cl_int_arr[];
   int 	  cl_int_sarr[40];
   
   `uvm_object_utils_begin(class_A)
      `uvm_field_int(cl_int,UVM_DEFAULT|UVM_NOPRINT);
      `uvm_field_string(cl_string,UVM_DEFAULT|UVM_NOPRINT);
      `uvm_field_array_int(cl_int_arr,UVM_DEFAULT|UVM_NOPRINT);
      `uvm_field_sarray_int(cl_int_sarr,UVM_DEFAULT);
   `uvm_object_utils_end
   
   function new(string name="");
      super.new(name);	
      cl_string = name;
      cl_int = 8;
      //cl_int_arr = new[cl_int];
      for(int i = 0; i < cl_int; i++) begin
	 cl_int_arr[i] = i + 1;
      end
      for(int i = 0; i < 40; i++) begin
	 cl_int_sarr[i] = i * 2;
      end
      
   endfunction

   function void do_print(uvm_printer printer);
      printer.knobs.type_name = 1;
      printer.print_field_int("Class Integer",cl_int,32,UVM_NORADIX,".","");
      printer.print_string("Class String",cl_string,"");
      printer.print_array_header("cl_int_arr",3,"cl_int_sarr(int)");
      foreach(cl_int_sarr[i])
	printer.print_field($sformatf("[%0d]", i), cl_int_sarr[i], 32);
      printer.print_array_footer();
   endfunction

endclass

   
   class_A class_A_inst;
   uvm_printer my_printer;
   initial begin
      // free children
      my_printer = uvm_default_table_printer;
      my_printer.knobs.begin_elements = 7;
      my_printer.knobs.end_elements=2;
      class_A_inst = new("class_A_inst");
      class_A_inst.randomize();
      class_A_inst.print(my_printer);
   end 
endmodule
