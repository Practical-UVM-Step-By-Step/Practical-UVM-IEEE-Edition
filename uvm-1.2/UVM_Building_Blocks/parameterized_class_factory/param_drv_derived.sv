class param_drv_d #(type T=uvm_object) extends param_drv #(T);

   `uvm_component_param_utils(param_drv_d #(T))

   function new(string name, uvm_component parent=null);
      super.new(name,parent);
   endfunction

   const static string type_name = {"param_drv_d #(",T::type_name,")"};
   virtual function string get_type_name();
      return type_name;
   endfunction

endclass
typedef param_drv_d #(packet) param_drv_der;


class param_drv_d2 #(type T=uvm_object) extends param_drv #(T);

   `uvm_component_param_utils(param_drv_d2 #(T))

   function new(string name, uvm_component parent=null);
      super.new(name,parent);
   endfunction

   const static string type_name = {"param_drv_d2 #(",T::type_name,")"};
   virtual function string get_type_name();
      return type_name;
   endfunction

endclass

// typedef some specializations for convenience
typedef param_drv_d2 #(packet) param_drv_der2;  //  a second derived driver
