//
// Template for UVM-compliant generic slave agent component
//

`ifndef WB_SLAVE_AGENT__SV
 `define WB_SLAVE_AGENT__SV


class wb_slave_agent extends uvm_agent;

   protected uvm_active_passive_enum is_active = get_is_active();
   wb_slave slv_drv;
   wb_slave_mon slv_mon;
   typedef virtual wb_slave_if vif;
   vif slv_agt_if;

   wb_config slv_agent_cfg;

   `uvm_component_utils_begin(wb_slave_agent)
      `uvm_field_object(slv_drv, UVM_DEFAULT)
      `uvm_field_object(slv_mon, UVM_DEFAULT)
   `uvm_component_utils_end


   function new(string name = "slv_agt", uvm_component parent = null);
      super.new(name, parent);
      slv_agent_cfg = new;
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      slv_mon = wb_slave_mon::type_id::create("slv_mon", this);
      if (is_active == get_is_active()) begin
         slv_drv = wb_slave::type_id::create("slv_drv", this);
      end
      //  if (!uvm_config_db#(vif)::get(null,this.get_full_name() , "slv_if", slv_agt_if)) begin
      if (!uvm_config_db#(vif)::get(this, "", "slv_if", slv_agt_if)) begin
         `uvm_fatal("AGT/NOVIF", $sformatf("No virtual interface specified for this agent instance %s",get_full_name()))
      end
      uvm_config_db# (vif)::set(this,"slv_drv","slv_if",slv_agt_if);
      uvm_config_db# (vif)::set(this,"slv_mon","mon_if",slv_agt_if);

      uvm_config_db #(wb_config)::get(null, this.get_full_name(), "slv_agent_cfg",slv_agent_cfg);
      if (is_active == get_is_active()) begin
 	 slv_drv.wb_slave_cfg  = slv_agent_cfg;
      end
      slv_mon.slv_mon_cfg = slv_agent_cfg;


   endfunction: build_phase

   virtual function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      if (is_active == get_is_active()) begin
	 

      end
   endfunction


   virtual task run_phase(uvm_phase phase);
      super.run_phase(phase);
      phase.raise_objection(this,"slv_agt_main");

      //ToDo :: Implement here

      phase.drop_objection(this);
   endtask

   virtual function void report_phase(uvm_phase phase);
      super.report_phase(phase);

   endfunction

endclass: wb_slave_agent

`endif // WB_SLAVE_AGENT__SV
