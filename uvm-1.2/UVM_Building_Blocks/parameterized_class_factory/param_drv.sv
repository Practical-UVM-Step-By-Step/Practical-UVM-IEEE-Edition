typedef class uvm_object;
class param_drv #(type T=uvm_object) extends uvm_driver;

   // parameterized classes must use the _param_utils macro
   `uvm_component_param_utils(param_drv #(T))

   // our packet type; this can be overridden via the factory
   T pkt;

   // standard component constructor
   function new(string name, uvm_component parent=null);
      super.new(name,parent);
   endfunction

   // get_type_name not implemented by macro for parameterized classes
   const static string type_name = {"param_drv #(",T::type_name,")"};
   virtual function string get_type_name();
      return type_name;
   endfunction

   // using the factory allows pkt overrides from outside the class
   virtual function void build_phase(uvm_phase phase);
      pkt= packet::type_id::create("pkt",this);
   endfunction

   // print the packet so we can confirm its type when printing
   virtual function void do_print(uvm_printer printer);
      printer.print_object("pkt",pkt);
   endfunction

endclass

   typedef param_drv #(packet) param_driver;   

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
