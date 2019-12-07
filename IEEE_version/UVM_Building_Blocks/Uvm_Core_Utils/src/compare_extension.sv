/* This example illustrates a custom comparer
 * and the copy operation 
 */


module test;
`include "uvm_macros.svh"
   import uvm_pkg::*;
   typedef class class_A;

   // Class definition
class class_A extends uvm_object;

   int cl_int;
   string cl_string;
   int 	  cl_int_arr[];
   `uvm_object_utils_begin(class_A)
      `uvm_field_int(cl_int,UVM_DEFAULT|UVM_NOCOMPARE);
      `uvm_field_string(cl_string,UVM_DEFAULT|UVM_NOCOMPARE);
      `uvm_field_array_int(cl_int_arr,UVM_DEFAULT|UVM_NOCOMPARE);
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

   virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
      uvm_comparer my_comparer;
      class_A rhs_;
      $cast(rhs_,rhs);
      //$cast(my_comparer,get_active_policy());
      $cast(my_comparer,comparer);
      if(my_comparer.get_active_object_depth() != 2 )
        `uvm_fatal("Compare policy depth","Expected value of 1")
      do_compare = super.do_compare(rhs,comparer);
      $cast(rhs_,rhs);
      do_compare &= comparer.compare_field_int("cl_int",cl_int,rhs_.cl_int,32,UVM_NORADIX);
      do_compare &= comparer.compare_string("cl_string",cl_string,rhs_.cl_string);
      for(int i = 0; i < cl_int; i++) begin
         do_compare &= comparer.compare_field_int("cl_int_arr[i]",cl_int_arr[i],rhs_.cl_int_arr[i],32,UVM_NORADIX);
      end
   endfunction

endclass


class comparer_B_extension extends uvm_comparer ;

   function new(string name = "comparer_B_extension");
      super.new(name);
   endfunction

endclass

class compare_extension_1 extends uvm_object;
   `uvm_object_utils(compare_extension_1)
   function new(string name = "compare_extension_1");
      super.new(name);
   endfunction

   bit compare_integers;
   bit compare_strings;
endclass


class compare_extension_2 extends uvm_object;
   `uvm_object_utils(compare_extension_2)
   function new(string name = "compare_extension_2");
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

   `uvm_object_utils_begin(class_P)
      `uvm_field_int(par_int,UVM_DEFAULT|UVM_NOCOMPARE)
      `uvm_field_int(par_address,UVM_DEFAULT | UVM_NOCOPY|UVM_NOCOMPARE)
      `uvm_field_string(par_string,UVM_DEFAULT|UVM_NOCOMPARE)
      `uvm_field_object(cl1,UVM_DEFAULT|UVM_NOCOMPARE)
      `uvm_field_object(cl3,UVM_DEFAULT | UVM_NOCOMPARE)
   `uvm_object_utils_end

   function new(string name="");
      super.new(name);
      cl1 = new(name);
      cl3 = new(name);
      par_string  = name;
   endfunction


   virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
      class_P rhs_;
      uvm_comparer my_comparer;
      uvm_recursion_policy_enum  my_recur_policy;
      compare_extension_1  compare_extension;
      do_compare = super.do_compare(rhs,comparer);
      $cast(my_comparer,comparer);
      $cast(my_recur_policy,my_comparer.get_recursion_policy());
      $cast(rhs_,rhs);
      if(my_comparer != null) begin
         if(my_comparer.get_active_object_depth() != 1 )
           `uvm_fatal("compare policy depth","Expected value of 1")
         if(my_comparer.extension_exists(compare_extension_1::get_type()))    begin
            $cast(compare_extension, my_comparer.get_extension(compare_extension_1::get_type()));
            if(compare_extension.compare_integers == 1) begin
               do_compare &= comparer.compare_field_int("par_int",par_int,rhs_.par_int,32,UVM_NORADIX);
               do_compare &= comparer.compare_field_int("par_address",par_int,rhs_.par_int,32,UVM_NORADIX);
            end
            if(compare_extension.compare_strings == 1) begin
               do_compare &= comparer.compare_string("par_string",par_string,rhs_.par_string);
            end
         end
	 else begin
            do_compare &= comparer.compare_field_int("par_int",par_int,rhs_.par_int,32,UVM_NORADIX);
            do_compare &= comparer.compare_field_int("par_address",par_int,rhs_.par_int,32,UVM_NORADIX);
            do_compare &= comparer.compare_string("par_string",par_string,rhs_.par_string);
	 end
         do_compare &= comparer.compare_object("cl1",cl1,rhs_.cl1);
         do_compare &= comparer.compare_object("cl3",cl3,rhs_.cl3);
      end
   endfunction
endclass


class test extends uvm_test;
   `uvm_component_utils(test)

   class_P  class_P_inst1;
   class_P  class_P_inst2;
   class_A    class_A_inst1;
   class_A    class_A_inst2;


   compare_extension_1 compare_ext1;
   compare_extension_2 compare_ext2;
   comparer_B_extension  comparer_B_policy_with_extensions;

   function new(string name="test", uvm_component parent=null);
      super.new(name,parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      class_A_inst1 = new("child_inst1");
      class_A_inst2 = new("child_inst3");
      class_P_inst1 = new("first_inst");
      class_P_inst2 = new("second_inst");
   endfunction


   task run_phase(uvm_phase phase);
      super.run_phase(phase);
      phase.raise_objection(this);
      #5;
      class_P_inst1.randomize();
      class_P_inst2.randomize();


      class_P_inst2.copy(class_P_inst1);
      if(class_P_inst2.compare(class_P_inst1) )
        `uvm_info("COMPARE","values ok",UVM_LOW)
      else
        `uvm_fatal("COMPARE","values MISMATCH")

      class_P_inst2.par_int =  class_P_inst2.par_int ^  class_P_inst2.par_int;

      compare_ext1 = new("compare_ext1");
      compare_ext2 = new("compare_ext2");
      comparer_B_policy_with_extensions = new("comparer_B_policy_with_extensions");
      compare_ext1.compare_integers = 0;
      compare_ext1.compare_strings = 1;
      comparer_B_policy_with_extensions.set_extension(compare_ext1);

      if(class_P_inst2.compare(class_P_inst1, comparer_B_policy_with_extensions) )
        `uvm_info("COMPARE","values ok",UVM_LOW)
      else
        `uvm_fatal("COMPARE","values MISMATCH")

      phase.drop_objection(this);
   endtask

   
endclass
   initial begin
      run_test();
   end
endmodule
