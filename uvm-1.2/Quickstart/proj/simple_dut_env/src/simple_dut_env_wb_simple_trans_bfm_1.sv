//
// Template for VMM-compliant full-duplex physical-level transactor
//

`ifndef SIMPLE_DUT_ENV_WB_SIMPLE_TRANS_BFM_1__SV
 `define SIMPLE_DUT_ENV_WB_SIMPLE_TRANS_BFM_1__SV

 `include "simple_dut_env_if.sv"
 `include "wb_simple_trans.sv"

typedef class simple_dut_env_wb_simple_trans_bfm_1;

class simple_dut_env_wb_simple_trans_bfm_1_callbacks extends vmm_xactor_callbacks;

   // ToDo: Add additional relevant callbacks
   // ToDo: Use task if callbacks can be blocking

   // Called before a transaction is executed
   virtual task pre_ex_trans(simple_dut_env_wb_simple_trans_bfm_1 xactor,
                             wb_simple_trans tr,
                             ref bit drop);
      
   endtask: pre_ex_trans


   // Called after a transaction has been executed
   virtual task post_ex_trans(simple_dut_env_wb_simple_trans_bfm_1 xactor,
                              wb_simple_trans tr);
      
   endtask: post_ex_trans


   // Called at start of observed transaction
   virtual function void pre_obs_trans(simple_dut_env_wb_simple_trans_bfm_1 xactor,
                                       wb_simple_trans tr);
      
   endfunction: pre_obs_trans


   // Called before acknowledging a transaction
   virtual function void pre_ack(simple_dut_env_wb_simple_trans_bfm_1 xactor,
                                 wb_simple_trans tr);
      
   endfunction: pre_ack


   // Called at end of observed transaction
   virtual function void post_obs_trans(simple_dut_env_wb_simple_trans_bfm_1 xactor,
                                        wb_simple_trans tr);
      
   endfunction: post_obs_trans

endclass: simple_dut_env_wb_simple_trans_bfm_1_callbacks


class simple_dut_env_wb_simple_trans_bfm_1_cfg;
   // ToDo: Add transactor configuration class properties
   rand int mode;

endclass: simple_dut_env_wb_simple_trans_bfm_1_cfg


class simple_dut_env_wb_simple_trans_bfm_1 extends vmm_xactor;

   int 	   EXECUTING;
   int 	   OBSERVING;
   
   protected simple_dut_env_wb_simple_trans_bfm_1_cfg cfg;
   local simple_dut_env_wb_simple_trans_bfm_1_cfg reset_cfg;
   protected wb_simple_trans rx_factory;
   local wb_simple_trans reset_rx_factory;

   wb_simple_trans_channel in_chan;
   wb_simple_trans_channel out_chan;
   virtual simple_dut_env_if.master sigs;

   extern function new(string inst = "",
                       int     stream_id = -1,
                       virtual simple_dut_env_if.master sigs,
		       simple_dut_env_wb_simple_trans_bfm_1_cfg cfg = null,
		       wb_simple_trans_channel in_chan = null,
		       wb_simple_trans_channel out_chan = null,
		       wb_simple_trans rx_factory = null);
   
   `vmm_xactor_member_begin(simple_dut_env_wb_simple_trans_bfm_1)
     `vmm_xactor_member_scalar(EXECUTING, DO_ALL)
      `vmm_xactor_member_scalar(OBSERVING, DO_ALL)
      `vmm_xactor_member_channel(in_chan, DO_ALL)
      `vmm_xactor_member_channel(out_chan, DO_ALL)
      // ToDo: Add vmm xactor member

   `vmm_xactor_member_end(simple_dut_env_wb_simple_trans_bfm_1)
   // ToDo: Add required short hand override method

   extern virtual function void reconfigure(simple_dut_env_wb_simple_trans_bfm_1_cfg cfg);
   extern protected virtual task main();
   extern protected virtual task tx_driver();
   extern protected virtual task rx_monitor();

endclass: simple_dut_env_wb_simple_trans_bfm_1


   function simple_dut_env_wb_simple_trans_bfm_1::new(string inst = "",
						      int     stream_id = -1,
						      virtual simple_dut_env_if.master sigs,
						      simple_dut_env_wb_simple_trans_bfm_1_cfg cfg = null,
						      wb_simple_trans_channel in_chan = null,
						      wb_simple_trans_channel out_chan = null,
						      wb_simple_trans rx_factory = null);

      super.new("simple_dut_env_wb_simple_trans_bfm_1 Transactor", inst, stream_id);

      this.EXECUTING = this.notify.configure(-1, vmm_notify::ON_OFF);
      this.OBSERVING = this.notify.configure(-1, vmm_notify::ON_OFF);

      this.sigs = sigs;

      if (cfg == null) cfg = new;
      this.cfg = cfg;
      this.reset_cfg = cfg;

      if (in_chan == null) in_chan = new("simple_dut_env_wb_simple_trans_bfm_1 Input Channel", inst);
      this.in_chan = in_chan;
      this.in_chan.set_consumer(this);

      if (out_chan == null) out_chan = new("simple_dut_env_wb_simple_trans_bfm_1 Output Channel", inst);
      this.out_chan = out_chan;

      if (rx_factory == null) rx_factory = new;
      this.rx_factory = rx_factory;
      this.reset_rx_factory = rx_factory;

   endfunction: new


   function void simple_dut_env_wb_simple_trans_bfm_1::reconfigure(simple_dut_env_wb_simple_trans_bfm_1_cfg cfg);

      if (!this.notify.is_on(XACTOR_IDLE)) begin
	 `vmm_warning(this.log, "Transactor should be reconfigured only when IDLE");
      end

      this.cfg = cfg;   
      // ToDo: Notify any running threads of the new configuration

   endfunction: reconfigure


   task simple_dut_env_wb_simple_trans_bfm_1::main();
      super.main();

      fork
	 tx_driver();
	 rx_monitor();
      join
   endtask: main


   task simple_dut_env_wb_simple_trans_bfm_1::tx_driver();

      forever begin
	 wb_simple_trans tr;
	 bit drop;

	 // ToDo: Set output/inout signals to their idle state
	 this.sigs.mck1.sync_txd <= 0;
	 this.sigs.async_en      <= 0;
	 
	 this.wait_if_stopped_or_empty(this.in_chan);
	 this.in_chan.activate(tr);

	 drop = 0;
	 `vmm_callback(simple_dut_env_wb_simple_trans_bfm_1_callbacks,
                       pre_ex_trans(this, tr, drop));
	 if (drop) begin
            void'(this.in_chan.remove());
            continue;
	 end
	 
	 void'(this.in_chan.start());
	 this.notify.indicate(this.EXECUTING, tr);

	 tr.notify.indicate(vmm_data::STARTED);
	 `vmm_trace(this.log, "Starting Tx transaction...");
	 `vmm_debug(this.log, tr.psdisplay("   "));

	 case (tr.kind) 
           wb_simple_trans::READ: begin
              // ToDo: Implement READ transaction
           end

           wb_simple_trans::WRITE: begin
              // ToDo: Implement WRITE transaction
           end
	 endcase
         // ToDo: User need to add driving logic and remove $finish;"
	 `vmm_note(log, "User need to add driving logic and remove $finish");
	 $finish;
	 `vmm_note(this.log," User need to add driving logic ");
	 this.notify.reset(this.EXECUTING);
	 void'(this.in_chan.complete());

	 `vmm_trace(this.log, "Completed Tx transaction...");
	 `vmm_debug(this.log, tr.psdisplay("   "));
	 tr.notify.indicate(vmm_data::ENDED);

	 `vmm_callback(simple_dut_env_wb_simple_trans_bfm_1_callbacks,
                       post_ex_trans(this, tr));
	 
	 void'(this.in_chan.remove());
      end

   endtask: tx_driver

   task simple_dut_env_wb_simple_trans_bfm_1::rx_monitor();

      forever begin
	 wb_simple_trans tr;

	 // ToDo: Set output signals to their idle state
	 this.sigs.mck1.sync_dat <= 'z;
	 
	 // ToDo: Wait for start of transaction

	 $cast(tr, this.rx_factory.copy());
	 `vmm_callback(simple_dut_env_wb_simple_trans_bfm_1_callbacks,
                       pre_obs_trans(this, tr));

	 tr.notify.indicate(vmm_data::STARTED);
	 this.notify.indicate(this.OBSERVING, tr);

	 `vmm_trace(this.log, "Starting Rx transaction...");

	 // ToDo: Observe first half of transaction
	 // ToDo: User need to add monitoring logic and remove $finish;"
	 `vmm_note(log, "User need to add monitoring logic and remove $finish");
	 $finish;
	 tr.status = wb_simple_trans::IS_OK;
	 `vmm_callback(simple_dut_env_wb_simple_trans_bfm_1_callbacks,
                       pre_ack(this, tr));

	 // ToDo: React to observed transaction with ACK/NAK

	 `vmm_trace(this.log, "Completed Rx transaction...");
	 `vmm_debug(this.log, tr.psdisplay("   "));

	 this.notify.reset(this.OBSERVING);
	 tr.notify.indicate(vmm_data::ENDED);

	 `vmm_callback(simple_dut_env_wb_simple_trans_bfm_1_callbacks,
                       post_obs_trans(this, tr));
	 this.out_chan.sneak(tr);
      end

   endtask: rx_monitor

`endif // SIMPLE_DUT_ENV_WB_SIMPLE_TRANS_BFM_1__SV
