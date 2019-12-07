module top;
   import uvm_pkg::*;
`include "uvm_macros.svh"

class param_packet_base extends uvm_object;
   function new(string name="TypeT");
      super.new(name);
   endfunction
endclass
	
class packet #(type T=int) extends param_packet_base;
	const static string type_name = $sformatf("packet#(%s)",$typename(T));

   T my_var;
   `uvm_object_param_utils(packet#(T))

   function new(string name="TypeT");
      super.new(name);
   endfunction

   virtual function string get_type_name();
      return type_name;
   endfunction

endclass

   packet #(string)my_s_packet;
   packet #(int)my_int_packet;

   initial begin 
      my_int_packet = new("hello");
      my_s_packet = new("hello");
      $display("string %s",my_s_packet.get_type_name());
      $display("int %s",my_int_packet.get_type_name());
   end
endmodule
