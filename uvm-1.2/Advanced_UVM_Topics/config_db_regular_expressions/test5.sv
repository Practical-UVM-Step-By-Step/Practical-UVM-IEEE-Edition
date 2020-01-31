
typedef class my_env;

class test5 extends uvm_component;


   // the component registration macros
   `uvm_component_utils(test5)

   // The ENV base class
   my_env topenv;

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      //	`uvm_info(get_full_name(),"/uvm_test_top\.topenv\.tom{1,2}\.*\.u1/\.v",UVM_LOW)
      //	  uvm_config_db #(int)::set(null,"/uvm_test_top\.topenv\.to\(m\){3,}\.*\.u1/", "v", 55);
      //	  uvm_config_db #(int)::set(null,"/uvm_test_top\.topenv\.to(m){3}\.*\.u1/", "v", 55);
      // set_config_int("/uvm_test_top\.topenv\.TOMMMM.*\.u1/", "v", 87);
      // set_config_int("/topenv\.tom+[0-1.][^0-2.]\.u1/", "v", 8);


      // uvm_config_db #(int)::set(null,"/topenv\.TOMMmm[15-19]*\.u1/", "v", 30); 

      //  uvm_config_db #(int)::set(null,"/topenv\.TOMMMM.*\.u1/", "v", 10); 
      //  uvm_config_db #(int)::set(null,"/topenv\.tom{4}*\.u1/", "v", 22);
      //     uvm_config_db #(int)::set(null,"/topenv\.TO\\(M\\)\\3[15-18*]\.u1/", "v", 10); 
      //  uvm_config_db #(int)::set(null,"/topenv\.tom{4}*\.u1/", "v", 22);
      //  uvm_config_db #(int)::set(null,"/topenv\.TOM\{4\}.1[1-5.]\.u1/", "v", 10); 
      //  uvm_config_db #(int)::set(null,"/topenv\.tom{4}*\.u1/", "v", 22);

      uvm_config_db #(int)::set(null,"/topenv\.TOM\{1,4\}.0[^0-2.]\.u1/", "v", 90); 
      //  uvm_config_db #(int)::set(null,"/topenv\.tom{4}*\.u1/", "v", 22);
      // uvm_config_db #(int)::set(null,"/topenv\.tom0[^0-2.]\.u1/", "v", 8); 
      //  uvm_config_db #(int)::set(null,"/topenv\.tom{4}*\.u1/", "v", 22);
      uvm_config_db #(int)::set(null,"/topenv\.tom+[0-1.][^0-2.]\.u1/", "v", 8); 

      // need to try alternation

      topenv = my_env::type_id::create("topenv",this);
   endfunction

endclass


