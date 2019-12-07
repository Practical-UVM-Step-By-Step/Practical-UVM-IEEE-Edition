/***********************************************
 *                                              *
 * Examples for the book Practical UVM          *
 *                                              *
 * Copyright Srivatsa Vasudevan 2010-2016       *
 * All rights reserved                          *
 *                                              *
 * Permission is granted to use this work       * 
 * provided this notice and attached license.txt*
 * are not removed/altered while redistributing *
 * See license.txt for details                  *
 *                                              *
 ************************************************/

`ifndef WB_MASTER__SV
 `define WB_MASTER__SV

typedef class wb_svtb_transaction;
   typedef class wb_svtb_config;
   typedef class wb_master;
   typedef class wb_svtb_config;


class wb_master ;

   wb_svtb_config mstr_drv_cfg;

   
   typedef virtual wb_master_if v_if; 
   v_if drv_if;
   
   mailbox gen2drv;

   function new(virtual intf vif,mailbox generator2driv);
	this.drv_if  = vif;
	gen2drv = generator2driv;
   endfunction
 

   extern virtual task reset_task();
   extern virtual task run();
   extern protected virtual task main_driver();

   extern protected virtual task read(wb_svtb_transaction trans);
   extern protected virtual task write(wb_svtb_transaction trans);

   

endclass: wb_master

task wb_master::reset_task();
      // Driving the signals as per the spec.
      this.drv_if.master_cb.DAT_O <= 'b0;
      this.drv_if.master_cb.TGD_O <= 'b0;
      this.drv_if.master_cb.ADR_O  <= 'b0;
      this.drv_if.master_cb.WE_O   <= 'b0;
      this.drv_if.master_cb.CYC_O <= 'b0;
      this.drv_if.master_cb.LOCK_O <= 'b0;
      this.drv_if.master_cb.SEL_O <= 'b0;
      this.drv_if.master_cb.STB_O <= 'b0;
      this.drv_if.master_cb.TGA_O <= 'b0;
      this.drv_if.master_cb.TGC_O <= 'b0;
      repeat (4) @(this.drv_if.master_cb);
      wait(this.drv_if.rst);
      
      wait(!this.drv_if.rst);
      // Done setting signals. Now we can drop objections and move on.

endtask: reset_task

task wb_master::run();
      fork 
	reset_task();
	 main_driver();
      join_none
endtask: run_phase

task wb_master::main_driver();
      int count;
      count = 0;
      forever begin
	 wb_svtb_transaction tr;
	 bit drop = 0;
	 // Set output signals to their idle state

	 this.drv_if.master_cb.DAT_O <= 'b0; 
         this.drv_if.master_cb.TGD_O <= 'b0;
         this.drv_if.master_cb.ADR_O <= 'b0;
         this.drv_if.master_cb.CYC_O <= 'b0;
         this.drv_if.master_cb.LOCK_O <= 'b0;
         this.drv_if.master_cb.SEL_O <= 'b0;
         this.drv_if.master_cb.STB_O <= 'b0;
         this.drv_if.master_cb.TGA_O <= 'b0;
         this.drv_if.master_cb.TGC_O <= 'b0;

	 gen2drv.get(tr);
	 // Since we are just beginning the transaction, we dont know what state it's in yet. 

         tr.status = wb_svtb_transaction::UNKNOWN;

	 case (tr.kind)  
           wb_svtb_transaction::READ: begin
	      read(tr);
           end
           wb_svtb_transaction::WRITE: begin
	      write(tr);
           end
	 endcase
	 
	 count = count + 1;
      end
endtask : main_driver

task wb_master::read(wb_svtb_transaction trans);
      int repeat_count = this.mstr_drv_cfg.max_n_wss + 1;
      int timeout_count = 0;
      @(this.drv_if.master_cb);

      $display("Got a read transaction");

      // Edge 0
      this.drv_if.master_cb.ADR_O <= trans.address;
      this.drv_if.master_cb.TGA_O <= trans.tga;
      this.drv_if.master_cb.WE_O  <= 1'b0;
      this.drv_if.master_cb.SEL_O <= trans.sel;
      this.drv_if.master_cb.CYC_O <= 1'b1;
      this.drv_if.master_cb.TGC_O <= trans.tgc;
      this.drv_if.master_cb.STB_O <= 1'b1;
      this.drv_if.master_cb.LOCK_O <= trans.lock;

      // Edge 1
      trans.status = wb_svtb_transaction::TIMEOUT ;
      while(!this.drv_if.master_cb.ACK_I) begin 
	 @(this.drv_if.master_cb);
	 timeout_count = timeout_count + 1;
	 case (1'b1)
	   this.drv_if.master_cb.ERR_I: trans.status = wb_svtb_transaction::ERR ;
	   this.drv_if.master_cb.RTY_I: trans.status = wb_svtb_transaction::RTY ;
	   this.drv_if.master_cb.ACK_I: trans.status = wb_svtb_transaction::ACK ;
	   default: continue;
	 endcase

	 break;
      end
      trans.data = this.drv_if.master_cb.DAT_I;
      trans.tgd  = this.drv_if.master_cb.TGD_I;

      this.drv_if.master_cb.CYC_O  <= 1'b0;
      @(this.drv_if.master_cb);

endtask	
   
task wb_master::write( wb_svtb_transaction trans);
      int repeat_count = this.mstr_drv_cfg.max_n_wss + 2;
      int timeout_count = 0;

      // Section 3.2.2 of Wishbone B3 Specification
      @(this.drv_if.master_cb);
      $display("Got a write transaction");

      // Edge 0
      this.drv_if.master_cb.ADR_O <= trans.address;
      this.drv_if.master_cb.TGA_O  <= trans.tga;
      this.drv_if.master_cb.DAT_O <= trans.data;
      this.drv_if.master_cb.TGD_O <= trans.tgd;
      this.drv_if.master_cb.WE_O    <= 1'b1;
      this.drv_if.master_cb.SEL_O  <= trans.sel;
      this.drv_if.master_cb.CYC_O  <= 1'b1;
      this.drv_if.master_cb.TGC_O  <= trans.tgc;
      this.drv_if.master_cb.STB_O  <= 1'b1;

      // Edge 1
      trans.status = wb_svtb_transaction::TIMEOUT ;
      while(!this.drv_if.master_cb.ACK_I) begin 
	 @(this.drv_if.master_cb);
	 timeout_count = timeout_count + 1;
	 // Wait states
	 case (1'b1)
      	   this.drv_if.master_cb.ERR_I: trans.status = wb_svtb_transaction::ERR ;
     	   this.drv_if.master_cb.RTY_I: trans.status = wb_svtb_transaction::RTY ;
      	   this.drv_if.master_cb.ACK_I: trans.status = wb_svtb_transaction::ACK ;
      	   default: continue;
	 endcase
      end

      this.drv_if.master_cb.LOCK_O <= trans.lock;
      this.drv_if.master_cb.CYC_O  <= 1'b0;
      @(this.drv_if.master_cb);
endtask	
`endif // WB_MASTER__SV

