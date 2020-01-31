class mixed_env extends uvm_env;

   `uvm_component_utils(mixed_env)

   simple_agent agent0;
   simple_agent agent1;
   simple_agent agent2;
   simple_agent agent3;

   function new(string name, uvm_component parent=null);
      super.new(name,parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);

      // three methods to set an instance override for agent1.driver1
      // - via component convenience method...
      set_inst_override_by_type("agent1.driver0",
				simple_drv::get_type(),
				param_driver::get_type());


      /*
       // - via the component's proxy (same approach as create)...
       simple_drv ::type_id::set_inst_override(param_drv::get_type(),
       "agent1.driver0",this);


       // - via a direct call to a factory method...
       factory.set_inst_override_by_type(simple_mon::get_type(),
       param_mon::get_type(),
       {get_full_name(),".agent1.monitor1"});
       */
      // create agents using the factory; actual agent types may be different
      agent0 = simple_agent::type_id::create("agent0",this);
      agent1 = simple_agent::type_id::create("agent1",this);
      agent2 = simple_agent::type_id::create("agent2",this);
      agent3 = simple_agent::type_id::create("agent3",this);

   endfunction

   // at end_of_elaboration, print topology and factory state to verify
   virtual function void end_of_elaboration_phase(uvm_phase phase);
      uvm_top.print_topology();
   endfunction

   virtual task run_phase(uvm_phase phase);
      #100 global_stop_request();
   endtask

endclass
