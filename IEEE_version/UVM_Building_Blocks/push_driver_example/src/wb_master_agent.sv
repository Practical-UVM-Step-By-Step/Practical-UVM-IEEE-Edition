`ifndef WB_MASTER_AGENT__SV
    `define WB_MASTER_AGENT__SV


    class wb_master_agent extends uvm_agent;
        wb_master_seqr mast_sqr;
        wb_master mast_drv;
        wb_master_mon mast_mon;
        typedef virtual wb_master_if vif;
        vif mast_agt_if; 
        wb_config mstr_agent_cfg;

        `uvm_component_utils(wb_master_agent)


        function new(string name = "mast_agt", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            uvm_config_db #(wb_config)::get(this, "", "config", mstr_agent_cfg);

            mast_mon = wb_master_mon::type_id::create("mast_mon", this);
            if (is_active == UVM_ACTIVE) begin
                mast_sqr = wb_master_seqr::type_id::create("mast_sqr", this);
                mast_drv = wb_master::type_id::create("mast_drv", this);
                mast_drv.mstr_drv_cfg = mstr_agent_cfg;
                mast_sqr.cfg = mstr_agent_cfg;
                mast_mon.mstr_mon_cfg = mstr_agent_cfg;

            end
            if (!uvm_config_db#(vif)::get(this, "", "mst_if", mast_agt_if)) begin
                `uvm_fatal("AGT/NOVIF", "No virtual interface specified for this agent instance Master Agent")
            end
            uvm_config_db# (vif)::set(this,"mast_drv","mst_if",mast_agt_if);
            uvm_config_db# (vif)::set(this,"mast_mon","mon_if",mast_agt_if);

            // Now getting the configuration
        endfunction: build_phase

        virtual function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            if (is_active == UVM_ACTIVE) begin
                mast_sqr.req_port.connect(mast_drv.req_export);
            end
        endfunction

    endclass: wb_master_agent

`endif // WB_MASTER_AGENT__SV

