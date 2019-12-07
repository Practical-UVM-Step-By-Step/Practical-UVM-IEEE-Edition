//
// Template for VMM-compliant half-duplex physical-level monitor
//

`ifndef SIMPLE_DUT_ENV_MON__SV
`define SIMPLE_DUT_ENV_MON__SV

`include "simple_dut_env_if.sv"
`include "wb_simple_trans.sv"

typedef class simple_dut_env_mon;

class simple_dut_env_mon_callbacks extends vmm_xactor_callbacks;

  // ToDo: Add additional relevant callbacks
  // ToDo: Use a task if callbacks can be blocking

   // Called at start of observed transaction
   virtual function void pre_trans(simple_dut_env_mon xactor,
                                   wb_simple_trans tr);
   
   endfunction: pre_trans


   // Called before acknowledging a transaction
   virtual function pre_ack(simple_dut_env_mon xactor,
                            wb_simple_trans tr);
   
   endfunction: pre_ack
   

   // Called at end of observed transaction
   virtual function void post_trans(simple_dut_env_mon xactor,
                                    wb_simple_trans tr);
   
   endfunction: post_trans
   
   // Callback method post_cb_trans can be used for coverage
   virtual task post_cb_trans(simple_dut_env_mon xactor,
                              wb_simple_trans tr);
   
   endtask: post_cb_trans

endclass: simple_dut_env_mon_callbacks


class simple_dut_env_mon_cfg;
   // ToDo: Add transactor configuration class properties
   rand int mode;

endclass: simple_dut_env_mon_cfg


class simple_dut_env_mon extends vmm_xactor;

   int OBSERVING;
   
   protected simple_dut_env_mon_cfg cfg;
   local simple_dut_env_mon_cfg reset_cfg;
   protected wb_simple_trans rx_factory;
   local wb_simple_trans reset_rx_factory;

   wb_simple_trans_channel out_chan;
   virtual simple_dut_env_if.slave sigs;

   extern function new(string inst = "",
                       int stream_id = -1,
                       virtual simple_dut_env_if.slave sigs,
                       simple_dut_env_mon_cfg cfg = null,
                       wb_simple_trans_channel out_chan = null,
                       wb_simple_trans rx_factory = null);

   `vmm_xactor_member_begin(simple_dut_env_mon)
     `vmm_xactor_member_scalar(OBSERVING, DO_ALL)
     `vmm_xactor_member_channel(out_chan, DO_ALL)
     // ToDo: Add vmm xactor member

   `vmm_xactor_member_end(simple_dut_env_mon)
   // ToDo: Add required short hand override method

   extern virtual function void reconfigure(simple_dut_env_mon_cfg cfg);
   extern protected virtual task main();

endclass: simple_dut_env_mon


function simple_dut_env_mon::new(string inst = "",
                  int stream_id = -1,
                  virtual simple_dut_env_if.slave  sigs,
                  simple_dut_env_mon_cfg cfg = null,
                  wb_simple_trans_channel out_chan = null,
                  wb_simple_trans rx_factory = null);

   super.new("simple_dut_env_mon Transactor", inst, stream_id);

   this.OBSERVING = this.notify.configure(-1, vmm_notify::ON_OFF);

   this.sigs = sigs;

   if (cfg == null) cfg = new;
   this.cfg = cfg;
   this.reset_cfg = cfg;

   if (out_chan == null) out_chan = new("simple_dut_env_mon Output Channel", inst);
   this.out_chan = out_chan;

   if (rx_factory == null) rx_factory = new;
   this.rx_factory = rx_factory;
   this.reset_rx_factory = rx_factory;

endfunction: new


function void simple_dut_env_mon::reconfigure(simple_dut_env_mon_cfg cfg);

   if (!this.notify.is_on(XACTOR_IDLE)) begin
      `vmm_warning(this.log, "Transactor should be reconfigured only when IDLE");
   end

   this.cfg = cfg;
   
   // ToDo: Notify any running threads of the new configuration
endfunction: reconfigure


task simple_dut_env_mon::main();
   super.main();

   forever begin
      wb_simple_trans tr;

      // ToDo: Wait for start of transaction

      $cast(tr, this.rx_factory.copy());
      `vmm_callback(simple_dut_env_mon_callbacks,
                    pre_trans(this, tr));

      tr.notify.indicate(vmm_data::STARTED);
      this.notify.indicate(this.OBSERVING, tr);

      `vmm_trace(this.log, "Starting transaction...");

      // ToDo: Observe first half of transaction
      // ToDo: User need to add monitoring logic and remove "#0;"

      #0;
      `vmm_note(this.log," User need to add monitoring logic "); 
      tr.status = wb_simple_trans::IS_OK;
      `vmm_callback(simple_dut_env_mon_callbacks,
                    pre_ack(this, tr));

      // ToDo: React to observed transaction with ACK/NAK

      `vmm_trace(this.log, "Completed transaction...");
      `vmm_debug(this.log, tr.psdisplay("   "));

      this.notify.reset(this.OBSERVING);
      tr.notify.indicate(vmm_data::ENDED);

      `vmm_callback(simple_dut_env_mon_callbacks,
                    post_trans(this, tr));

      this.out_chan.sneak(tr);
   end

endtask: main

`endif // SIMPLE_DUT_ENV_MON__SV
