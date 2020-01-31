module top;
   import uvm_pkg::*;
   typedef class class_A;

   // Class definition
class class_A extends uvm_object;

   int cl_int;
   string cl_string;
   rand   int 	  cl_int_arr[];
   `uvm_object_utils_begin(class_A)
      `uvm_field_int(cl_int,UVM_DEFAULT);
      `uvm_field_string(cl_string,UVM_DEFAULT);
      `uvm_field_array_int(cl_int_arr,UVM_DEFAULT);
   `uvm_object_utils_end
   
   function new(string name="");
      super.new(name);	
      cl_string = name;
      cl_int = 10;
      cl_int_arr = new[cl_int];
      for(int i = 0; i < cl_int; i++) begin
	 cl_int_arr[i] = i + 1;
      end
   endfunction

endclass
class uvm_copy_filter_ext extends uvm_object;
   `uvm_object_utils(uvm_copy_filter_ext)
   function new(string name="uvm_copy_filter_ext");
      super.new(name);
   endfunction

endclass


   
class  class_P extends uvm_object;

   // basic datatypes
   rand int par_int; 
   rand byte par_address;
   string par_string;

   // Some objects to demonstrate the copy recursion policy

   class_A cl1; // UVM_SHALLOW
   class_A cl3; // UVM_DEEP
   /*
    `uvm_object_utils_begin(class_P)
    `uvm_field_int(par_int,UVM_DEFAULT)
    `uvm_field_int(par_address,UVM_DEFAULT | UVM_NOCOPY)
    `uvm_field_string(par_string,UVM_NOCOPY)
    `uvm_field_object(cl1,UVM_DEFAULT|UVM_NOCOPY)
    `uvm_field_object(cl3,UVM_DEFAULT | UVM_NOCOPY)
   `uvm_object_utils_end
    */
   `uvm_object_utils(class_P)

   function new(string name="");
      super.new(name);
      cl1 = new(name);
      cl3 = new(name )	;
      par_string  = name;
   endfunction
   
   function void do_copy(uvm_object rhs);
      class_P rhs_;
      super.do_copy(rhs);
      $cast(rhs_,rhs);
      par_int = rhs_.par_int;
      par_address = rhs_.par_address;
      par_string = rhs_.par_string;
      cl1 = new rhs_.cl1;
      cl3 = new rhs_.cl3;
      cl1.copy(rhs_.cl1);
      cl3.copy(rhs_.cl3);
   endfunction

   
   function void do_execute_op(uvm_field_op op); 
      class_P rhs_;
      uvm_copier copier;
      uvm_printer m_printer;
      uvm_copy_filter_ext copy_filter_ext;
      
      `uvm_info("POLICY",$sformatf("Operation Name %s",op.get_op_name()),UVM_LOW)
      
      if(op.get_op_name() == "copy") begin
	 $cast(copier,  op.get_policy());
	 if(copier.extension_exists(uvm_copy_filter_ext::get_type())) begin
	    op.disable_user_hook(); // do_copy disabled
	    // Our own implementation
	    if ($cast(rhs_,op.get_rhs())) begin
	       par_int = rhs_.par_int;
	       par_address = rhs_.par_address;
	       cl1 = new rhs_.cl1;
	       cl3 = new rhs_.cl3;
	       cl1.copy(rhs_.cl1);
	       // dont copy cl3.
	    end
	 end
      end
      if(op.get_op_name() == "print") begin
	 $cast(m_printer,  op.get_policy());
         op.disable_user_hook(); // do_copy disabled
	 m_printer.print_field("par_int",par_int,32,UVM_NORADIX);
	 m_printer.print_field("par_address",par_address,32,UVM_NORADIX);
	 //m_printer.print_object("cl1",cl1);
	 //m_printer.print_object("cl3",cl3);
      end

   endfunction

endclass

   class_P  class_P_inst1;
   class_P  class_P_inst2;
   class_A    class_A_inst1;
   class_A    class_A_inst2;
   uvm_copier def_copier;
   uvm_coreservice_t cs;
   uvm_copy_filter_ext  copier_ext;

   
   initial begin
      cs = uvm_coreservice_t::get();
      def_copier = cs.get_default_copier();
      copier_ext=uvm_copy_filter_ext::type_id::create("copier_ext");
      def_copier.set_extension(copier_ext);
      // free children
      class_A_inst1 = new("child_inst1");
      class_A_inst2 = new("child_inst3");

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
