`ifndef WB_ENV_ENV__SV
    `define WB_ENV_ENV__SV
    `include "wb_env.sv"
   
    class wb_env_env extends uvm_env;
        wb_master_agent master_agent;
        wb_slave_agent slave_agent;
     
        `uvm_component_utils(wb_env_env)

        extern function new(string name="wb_env_env", uvm_component parent=null);
        extern virtual function void build_phase(uvm_phase phase);
        extern virtual function void connect_phase(uvm_phase phase);
        

    endclass: wb_env_env

    function wb_env_env::new(string name= "wb_env_env",uvm_component parent=null);
        super.new(name,parent);
    endfunction:new

    function void wb_env_env::build_phase(uvm_phase phase);
        super.build_phase(phase);
        master_agent = wb_master_agent::type_id::create("master_agent",this); 
        slave_agent = wb_slave_agent::type_id::create("slave_agent",this);
   
    endfunction: build_phase

    function void wb_env_env::connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction: connect_phase
`endif // WB_ENV_ENV__SV

