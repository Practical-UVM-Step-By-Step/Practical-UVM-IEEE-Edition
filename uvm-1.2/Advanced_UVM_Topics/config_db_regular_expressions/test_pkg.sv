
`include "my_env_pkg.svh"
class test1 extends uvm_component;


   // the component registration macros
   `uvm_component_utils(test1)

   // The ENV base class
   my_env topenv;

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      uvm_config_db #(int)::set(null,"/topenv\.TOM\{2\}.2[3-5.]\.u1/", "v", 10); 
      // uvm_config_db #(int)::set(null,"/topenv\.TOM{2}.2[3-5]\.u1/", "v", 20); 
      uvm_config_db #(int)::set(null,"/topenv\.TOM{3}.2*\.u1/", "v", 40); 
      uvm_config_db #(int)::set(null,"/topenv\.tom+[0-1.][^0-2.]\.u1/", "v", 8); 

      // need to try alternation

      topenv = my_env::type_id::create("topenv",this);
   endfunction

endclass


