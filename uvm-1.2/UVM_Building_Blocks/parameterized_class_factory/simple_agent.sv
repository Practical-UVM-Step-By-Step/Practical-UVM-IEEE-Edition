class simple_agent extends uvm_agent;

   `uvm_component_utils(simple_agent)
   
   simple_drv driver0;
   simple_mon monitor1;

   function new(string name, uvm_component parent=null);
      super.new(name,parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);

      // override the packet type for driver0 and below
      packet::type_id::set_inst_override(packet::get_type(),"driver0.*");

      // create using the factory; actual driver types may be different
      driver0 = simple_drv::type_id::create("driver0",this);
      monitor1 = simple_mon::type_id::create("monitor0",this);

   endfunction

endclass
