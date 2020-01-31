typedef class uvm_object;
class simple_drv extends uvm_monitor;


   `uvm_component_utils(simple_drv)

   // standard component constructor
   function new(string name, uvm_component parent=null);
      super.new(name,parent);
   endfunction


endclass
