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
      `uvm_field_int(par_address,UVM_DEFAULT)
      `uvm_field_string(par_string,UVM_DEFAULT)
      `uvm_field_object(cl1,UVM_DEFAULT)
      `uvm_field_object(cl3,UVM_DEFAULT)
   `uvm_object_utils_end

   function new(string name="");
      super.new(name);
      cl1 = new(name);
      cl3 = new(name )	;
      par_string  = name;
   endfunction

endclass
