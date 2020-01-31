
typedef class my_env;

class test2 extends uvm_component;


   `uvm_component_utils(test2)

   // The ENV base class
   my_env topenv;

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);


      uvm_config_db #(int)::set(null,"/topenv\.tom+[0-1.][^0-2.]\.u1/", "v", 8); 


      topenv = my_env::type_id::create("topenv",this);
   endfunction

endclass


