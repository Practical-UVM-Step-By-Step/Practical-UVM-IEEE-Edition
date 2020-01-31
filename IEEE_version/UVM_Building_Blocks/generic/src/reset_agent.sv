`ifndef RESET_AGENT__SV
 `define RESET_AGENT__SV

class reset_agent extends uvm_agent;
   reset_sequencer mast_sqr;
   reset_driver mast_drv;
   reset_monitor mast_mon;
   typedef virtual wb_master_if vif;
   vif mast_agt_if; 

   `uvm_component_utils(reset_agent)

   function new(string name = "mast_agt", uvm_component parent = null);
      super.new(name, parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      mast_mon = reset_monitor::type_id::create("mast_mon", this);
      if (is_active == UVM_ACTIVE) begin
         mast_sqr = reset_sequencer::type_id::create("mast_sqr", this);
         mast_drv = reset_driver::type_id::create("mast_drv", this);
      end
      if (!uvm_config_db#(vif)::get(this, "", "mst_if", mast_agt_if)) begin
         `uvm_fatal("AGT/NOVIF", "No virtual interface specified for this agent instance Master Agent")
      end
      uvm_config_db# (vif)::set(this,"mast_drv","mst_if",mast_agt_if);
      uvm_config_db# (vif)::set(this,"mast_mon","mon_if",mast_agt_if);

   endfunction: build_phase

   virtual function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      if (is_active == UVM_ACTIVE) begin
   	 mast_drv.seq_item_port.connect(mast_sqr.seq_item_export);
      end
   endfunction
endclass: reset_agent
`endif // RESET_AGENT__SV

