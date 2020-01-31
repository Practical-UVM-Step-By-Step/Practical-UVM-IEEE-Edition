class param_agent extends uvm_agent;

   `uvm_component_utils(param_agent)
   
   param_driver driver0;
   param_monitor monitor1;

   function new(string name, uvm_component parent=null);
      super.new(name,parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);

      // override the packet type for driver0 and below
      packet::type_id::set_inst_override(packet::get_type(),"driver0.*");

      // create using the factory; actual driver types may be different
      driver0 = param_driver::type_id::create("param_drv0",this);
      monitor1 = param_monitor::type_id::create("param_mon1",this);

   endfunction

endclass
