typedef class uvm_object;
class simple_mon extends uvm_monitor;


   `uvm_component_utils(simple_mon)
   // leave  a simple packet in here to be overriden if needed.
   packet pkt;

   // standard component constructor
   function new(string name, uvm_component parent=null);
      super.new(name,parent);
   endfunction


   // using the factory allows pkt overrides from outside the class
   virtual function void build_phase(uvm_phase phase);
      pkt= packet::type_id::create("pkt",this);
   endfunction

   // print the packet so we can confirm its type when printing
   virtual function void do_print(uvm_printer printer);
      printer.print_object("pkt",pkt);
   endfunction

endclass
