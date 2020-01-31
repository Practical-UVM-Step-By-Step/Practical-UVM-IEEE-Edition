class my_driver22 #(type T=uvm_object) extends my_driver1 #(T);

   `uvm_component_param_utils(my_driver22 #(T))

   function new(string name, uvm_component parent=null);
      super.new(name,parent);
   endfunction

   const static string type_name = {"my_driver22 #(",T::type_name,")"};
   virtual function string get_type_name();
      return type_name;
   endfunction

endclass

