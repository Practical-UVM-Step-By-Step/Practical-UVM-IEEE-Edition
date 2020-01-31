class env extends uvm_env;

   `uvm_component_utils(env)

   simple_agent agent0;
   simple_agent agent1;

   function new(string name, uvm_component parent=null);
      super.new(name,parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      /*
       // three methods to set an instance override for agent1.driver1
       // - via component convenience method...
       set_inst_override_by_type("agent1.driver1",
       driverB::get_type(),
       my_driver2::get_type());

       // - via the component's proxy (same approach as create)...
       driverB::type_id::set_inst_override(my_driver2::get_type(),
       "agent1.driver1",this);

       // - via a direct call to a factory method...
       factory.set_inst_override_by_type(driverB::get_type(),
       my_driver2::get_type(),
       {get_full_name(),".agent1.driver1"});
       */
      // create agents using the factory; actual agent types may be different
      agent0 = simple_agent::type_id::create("agent0",this);
      agent1 = simple_agent::type_id::create("agent1",this);

   endfunction

   // at end_of_elaboration, print topology and factory state to verify
   virtual function void end_of_elaboration_phase(uvm_phase phase);
      uvm_top.print_topology();
   endfunction

   virtual task run_phase(uvm_phase phase);
      #100 global_stop_request();
   endtask

endclass
