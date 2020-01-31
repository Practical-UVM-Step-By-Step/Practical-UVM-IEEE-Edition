`ifndef WB_SVTB_ENV__SV
 `define WB_SVTB_ENV__SV


class wb_svtb_env;

   // Generator and Driver and monitors
   wb_svtb_generator gen;
   wb_svtb_master m_driv;
   wb_svtb_slave s_driv;
   wb_svtb_master_mon m_mon;
   wb_svtb_slave_mon s_mon;

   // Scoreboard
   wb_svtb_scoreboard scoreboard;
   
   // Environment Configuration
   wb_svtb_config  m_env_cfg;

   // mailboxes for communication
   mailbox mast_mon_mbox;
   mailbox slave_mon_mbox;
   mailbox gen2driv;

   // Interfaces
   virtual wb_master_if master_vif;
   virtual wb_slave_if slave_vif;


   extern function new(virtual wb_master_if mvif,virtual wb_slave_if slvif);
   extern virtual function void build();
   extern virtual task reset();
   extern virtual function configure();
   extern virtual task run();
   

endclass

// Constructor
function wb_svtb_env::new(virtual wb_master_if mvif,virtual wb_slave_if slvif);
   master_vif = mvif;
   slave_vif = slvif;
endfunction

function void wb_svtb_env::build();
   // Create mailboxes 
   m_env_cfg = new();
   gen2driv = new();
   mast_mon_mbox = new();
   slave_mon_mbox = new();

   // Create components
   gen = new(gen2driv,m_env_cfg);
   m_driv = new(master_vif,gen2driv);
   s_driv = new(slave_vif);
   
   scoreboard = new(mast_mon_mbox,slave_mon_mbox,m_env_cfg);

endfunction

task wb_svtb_env::reset();
   m_driv.reset_task();
endtask

task wb_svtb_env::run();
   build();
   reset();
   
   fork
      gen.run();
      m_driv.run();
      s_driv.run();
      m_mon.run();
      s_mon.run();
      scoreboard.run();
   join;
endtask

function wb_svtb_env::configure();
   m_env_cfg.randomize();
endfunction



`endif
