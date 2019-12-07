`include "class_A.sv"
class class_P extends uvm_object;


   // basic datatypes
   rand int par_int; 
   rand byte par_address;
   string par_string;

   // Some objects to demonstrate the copy recursion policy

   class_A cl1; // UVM_SHALLOW
   class_A cl3; // UVM_DEEP

   `uvm_object_utils_begin(class_P)
      `uvm_field_int(par_int,UVM_DEFAULT)
      `uvm_field_int(par_address,UVM_DEFAULT | UVM_NOCOPY|UVM_NOPRINT|UVM_NOPACK)
      `uvm_field_string(par_string,UVM_NOCOPY|UVM_NOPRINT|UVM_NOPACK)
      `uvm_field_object(cl1,UVM_DEFAULT|UVM_NOCOPY|UVM_NOPRINT|UVM_NOPACK)
      `uvm_field_object(cl3,UVM_DEFAULT| UVM_NOCOPY|UVM_NOPRINT|UVM_NOPACK)
   `uvm_object_utils_end

   function new(string name="");
      super.new(name);
      cl1 = new(name);
      cl3 = new(name )	;
      par_string  = name;
   endfunction

   virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
      class_P rhs_;    
      do_compare = super.do_compare(rhs,comparer);
      $cast(rhs_,rhs);
      do_compare &= comparer.compare_field_int("par_int",par_int,rhs_.par_int,32,UVM_NORADIX);
      do_compare &= comparer.compare_field_int("par_address",par_int,rhs_.par_int,32,UVM_NORADIX);
      do_compare &= comparer.compare_string("par_string",par_string,rhs_.par_string);
      do_compare &= comparer.compare_object("cl1",cl1,rhs_.cl1);
      do_compare &= comparer.compare_object("cl3",cl3,rhs_.cl3);
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

  function void do_pack (uvm_packer packer);
      super.do_pack(packer);
      packer.pack_field_int(par_int,32);
      packer.pack_field_int(par_address,8);
      packer.pack_string(par_string);
      packer.pack_object(cl1);
      packer.pack_object(cl3);
   endfunction


   function void do_unpack (uvm_packer packer);
      super.do_unpack(packer);
      par_int = packer.unpack_field_int(32);
      par_address = packer.unpack_field_int(8);
      par_string = packer.unpack_string();
      packer.unpack_object(cl1);
      packer.unpack_object(cl3);
   endfunction


   function void do_print(uvm_printer printer);
      printer.knobs.type_name = 1;
      printer.print_field_int("Integer",par_int,32,UVM_NORADIX,".","");
      printer.print_field_int("Address",par_int,32,UVM_NORADIX,".","");
      printer.print_string("String",par_string,"");
      printer.print_object("cl1 Inst",cl1);
      printer.print_object("cl3 Inst",cl3);
   endfunction

endclass
