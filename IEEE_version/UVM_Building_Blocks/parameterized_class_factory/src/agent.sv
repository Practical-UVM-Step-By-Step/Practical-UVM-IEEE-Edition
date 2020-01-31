class agent_ex extends uvm_agent_ex;

   `uvm_component_utils(agent_ex)
   
   my_driver1 driver0;
   my_driver1 driver1;

   function new(string name, uvm_component parent=null);
      super.new(name,parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);

      // override the packet type for driver0 and below
      packet::type_id::set_inst_override(packet::get_type(),"driver0.*");

      // create using the factory; actual driver types may be different
      driver0 = my_driver1::type_id::create("driver0",this);
      driver1 = my_driver1::type_id::create("driver1",this);

   endfunction

endclass
