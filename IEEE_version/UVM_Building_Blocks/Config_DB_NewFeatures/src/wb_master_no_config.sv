`ifndef WB_MASTER_NO_CONFIG
 `define WB_MASTER_NO_CONFIG
class wb_master_no_config extends wb_master; 
   `uvm_component_utils(wb_master_no_config)

   function new(string name = "wb_master_no_config",uvm_component parent);
      super.new(name,parent);
   endfunction

   virtual function bit use_automatic_config();
      return 0;
   endfunction
   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
   endfunction

   virtual function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
   endfunction

endclass
`endif
