class class_A extends uvm_object;

   int cl_int;
   string cl_string;
   int 	  cl_int_arr[];
   int unsigned logic_data[int];

   `uvm_object_utils_begin(class_A)
      `uvm_field_int(cl_int,UVM_DEFAULT)
      `uvm_field_string(cl_string,UVM_DEFAULT)
      `uvm_field_array_int(cl_int_arr,UVM_DEFAULT)
      `uvm_field_aa_int_int(logic_data,UVM_DEFAULT)
   `uvm_object_utils_end

   function void set_value(int value); 
      cl_int  = value;
   endfunction
   
   function new(string name="");
      super.new(name);	
      cl_string = name;
      set_value(10);
      cl_int_arr = new[cl_int];
      for(int i = 0; i < cl_int; i++) begin
	 cl_int_arr[i] = i + 1;
      end
   endfunction

endclass
