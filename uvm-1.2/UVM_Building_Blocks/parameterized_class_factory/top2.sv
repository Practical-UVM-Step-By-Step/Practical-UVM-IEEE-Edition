class agent extends uvm_agent;

   `uvm_component_utils(agent)
   
   B_driver driver0;
   B_driver driver1;

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
   agent agent3;

   function new(string name, uvm_component parent=null);
      super.new(name,parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);

      // three methods to set an instance override for agent1.driver1
      // - via component convenience method...
      set_inst_override_by_type("agent1.driver1",
				B_driver::get_type(),
				D2_driver::get_type());

      // - via the component's proxy (same approach as create)...
      B_driver::type_id::set_inst_override(D2_driver::get_type(),
                                           "agent1.driver1",this);

      // - via a direct call to a factory method...
      factory.set_inst_override_by_type(B_driver::get_type(),
					D2_driver::get_type(),
					{get_full_name(),".agent1.driver1"});

      // create agents using the factory; actual agent types may be different
      agent0 = agent::type_id::create("agent0",this);
      agent1 = agent::type_id::create("agent1",this);
      agent2 = agent::type_id::create("agent2",this);
      agent3 = agent::type_id::create("agent3",this);

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

      // Replace all base drivers with derived drivers...
      B_driver::type_id::set_type_override(D1_driver::get_type());

      // now, create the environment; our factory configuration will
      // govern what topology gets created
      env0 = new("env0");
      factory.print();

      // run the test (will execute build phase)
      run_test();

   end

endmodule


