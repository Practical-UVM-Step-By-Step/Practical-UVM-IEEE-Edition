import uvm_pkg::*;
class packet extends uvm_object;
   `uvm_object_utils(packet)
endclass

class packetD extends packet;
   `uvm_object_utils(packetD)
endclass

class my_driver1 #(type T=packetD) extends uvm_driver #(T);

   // parameterized classes must use the _param_utils version
   `uvm_component_param_utils(my_driver1 #(T))

   // our packet type; this can be overridden via the factory
   T pkt;

   // standard component constructor
   function new(string name, uvm_component parent=null);
      super.new(name,parent);
   endfunction

   // get_type_name not implemented by macro for parameterized classes
   const static string type_name = {"my_driver1 #(",T::type_name,")"};
   virtual function string get_type_name();
      return type_name;
   endfunction

   // using the factory allows pkt overrides from outside the class
   virtual function void build_phase(uvm_phase phase);
      pkt = packet::type_id::create("pkt",this);
   endfunction

   // print the packet so we can confirm its type when printing
   virtual function void do_print(uvm_printer printer);
      printer.print_object("pkt",pkt);
   endfunction

endclass


class my_driver21 #(type T=uvm_object) extends my_driver1 #(T);

   `uvm_component_param_utils(my_driver21 #(T))

   function new(string name, uvm_component parent=null);
      super.new(name,parent);
   endfunction

   const static string type_name = {"my_driver21 #(",T::type_name,")"};
   virtual function string get_type_name();
      return type_name;
   endfunction

endclass

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

// typedef some specializations for convenience
typedef my_driver1  #(packet) B_driver;   // the base driver
typedef my_driver21 #(packet) D1_driver;  // a derived driver
typedef my_driver22 #(packet) D2_driver;  // another derived driver
typedef my_driver22 #(packet) C_driver;  // another derived driver

class agent extends uvm_agent;

   `uvm_component_utils(agent)
   
   B_driver driver0;
   B_driver driver1;
   C_driver driver2;

   function new(string name, uvm_component parent=null);
      super.new(name,parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);

      // override the packet type for driver0 and below
      packet::type_id::set_inst_override(packetD::get_type(),"driver0.*");

      // create using the factory; actual driver types may be different
      driver0 = B_driver::type_id::create("driver0",this);
      driver1 = B_driver::type_id::create("driver1",this);

   endfunction

endclass
class env extends uvm_env;

   `uvm_component_utils(env)

   agent agent0;
   agent agent1;
   agent agent2;

   function new(string name, uvm_component parent=null);
      super.new(name,parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      // set a override for one specific instance
      // - via the component's proxy (same approach as create)...
      B_driver::type_id::set_inst_override(D2_driver::get_type(),
                                           "agent1.driver0",this);

      // direct factory call
      set_inst_override_by_type({"top.env0.agent1.driver1"},
				B_driver::get_type(),
				D1_driver::get_type());

      // Replace all base drivers with derived drivers...

      // create agents using the factory; actual agent types may be different
      agent0 = agent::type_id::create("agent0",this);
      agent1 = agent::type_id::create("agent1",this);
      agent2 = agent::type_id::create("agent2",this);

   endfunction

   // at end_of_elaboration, print topology and factory state to verify
   virtual function void end_of_elaboration_phase(uvm_phase phase);
      uvm_top.print_topology();
   endfunction

   virtual task run_phase(uvm_phase phase);
      #100 global_stop_request();
   endtask

endclass

module top;

   env env0;

   initial begin

      // Being registered first, the following overrides take precedence
      // over any overrides made within env0's construction & build.




      // - via a direct call to a factory method...
      factory.set_inst_override_by_type(B_driver::get_type(),
					D2_driver::get_type(),
					"env0.agent2.driver1");


      // - via a direct call to a factory method
      factory.set_inst_override_by_type(B_driver::get_type(),
					D1_driver::get_type(),
					"env0.agent2.driver0"); 

      // now, create the environment; our factory configuration will
      // govern what topology gets created
      env0 = new("env0");
      factory.print();

      // run the test (will execute build phase)
      run_test();

   end

endmodule


