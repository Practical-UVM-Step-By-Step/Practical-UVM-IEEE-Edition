`ifndef SIMPLE_DUT_ENV_ENV__SV
 `define SIMPLE_DUT_ENV_ENV__SV

 `include "simple_dut_env.sv"


class simple_dut_env_env ;
   simple_dut_env_cfg cfg;
   simple_dut_env_scbd sb;

   virtual simple_dut_env_if intf_inst[2];
   wb_simple_trans_channel mon_chan;
   wb_simple_trans_channel atmc_gen2src_chan;
   wb_simple_trans_atomic_gen atmc_gen;
   //Multiple driver instantiation
   simple_dut_env_wb_simple_trans_bfm_1 driver_0;     
   simple_dut_env_wb_simple_trans_bfm_2 driver_1;     
   //ToDo: Instantiate other drivers here. 

   simple_dut_env_mon monitor;   
   simple_dut_env_cov cov;
   simple_dut_env_mon_2cov_connect mon2cov;
   simple_dut_env_wb_simple_trans_bfm_1_sb_callbacks bfm_sb_cb;

   simple_dut_env_mon_sb_cb mon_sb_cb;

   // ToDo: Add required short hand override method
   extern function new(
                       virtual simple_dut_env_if intf_inst[2]
                       );
   extern virtual function void gen_cfg();
   extern virtual function void build();
   extern virtual task reset_dut();
   extern virtual task cfg_dut();
   extern virtual task wait_for_end();
   extern virtual task cleanup();
   extern virtual task report();
   
endclass: simple_dut_env_env


function simple_dut_env_env::new(
				 virtual simple_dut_env_if intf_inst[2]
				 );
   super.new();
   // Save a copy of the virtual interfaces
   this.intf_inst = intf_inst;
   this.cfg = new;
   $timeformat(-9, 0, "ns", 1);
endfunction: new


function void simple_dut_env_env::gen_cfg();
   super.gen_cfg();

   if (!this.cfg.randomize()) begin
      `fatal(log, "Failed to randomize test configuration");
   end
   cfg.num_trans = 10;
endfunction: gen_cfg


function void simple_dut_env_env::build();
   super.build();

   mon_chan = new("Mon_wb_simple_trans_channel_c", "mon_chan");
   // ToDo : Add appropriate argument in new() where allocating memory to component.
   atmc_gen2src_chan = new("wb_simple_trans_atomic_channel_c", "atmc_gen2src_chan");
   atmc_gen          = new("atomic_gen", 1, atmc_gen2src_chan);
   // ToDo : Add/Remove appropriate argument in new() when multiple drivers are used. instances are created with
   //respect to first driver selected 
   driver_0     = new("driver_0", 0, intf_inst[0]);   
   driver_1     = new("driver_1", 1, intf_inst[1]);   
   monitor      = new("monitor", 1, intf_inst[0], ,mon_chan); 
   // ToDo : Add required instance of driver/monitor 
   cov      = new;
   mon2cov  = new(cov);
   monitor.append_callback(mon2cov);
   atmc_gen.stop_after_n_insts = cfg.num_trans;
   sb = new("SCBD");
   bfm_sb_cb = new(sb);  //Instantiating the driver callback
   driver_0.append_callback(bfm_sb_cb);  
   // ToDo: Register any required callbacks

   begin
      mon_sb_cb = new(sb);
      monitor.append_callback(mon_sb_cb);
   end
   //ToDo: Connect the required driver's channel with generator's channel 
   `vmm_note(this.log, this.cfg.psdisplay());
   // ToDo: Instantiate transactors, using XMRs to access interface instances

   // ToDo: Start transactors needed to configure the DUT

endfunction: build


task simple_dut_env_env::reset_dut();
   super.reset_dut();

   // ToDo: Apply hardware reset to DUT
endtask: reset_dut


task simple_dut_env_env::cfg_dut();
   super.cfg_dut();

   // ToDo: Configure DUT
endtask: cfg_dut



task simple_dut_env_env::wait_for_end();
   super.wait_for_end();
   this.end_vote.wait_for_consensus();
endtask: wait_for_end


task simple_dut_env_env::cleanup();
   super.cleanup();
   // ToDo: check that nothing was lost

endtask: cleanup


task simple_dut_env_env::report() ;
   super.report();
   sb.report();
   // ToDo: Generate the Final Report

endtask: report

`endif // SIMPLE_DUT_ENV_ENV__SV
