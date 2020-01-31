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
   typedef class wb_svtb_master;
   typedef class wb_svtb_config;

class wb_svtb_master ;

   wb_svtb_config mstr_drv_cfg;
   
   typedef virtual wb_master_if v_if; 
   v_if drv_if;
   
   mailbox 	   gen2drv;

   function new(virtual wb_master_if vif,mailbox generator2driv);
      drv_if  = vif;
      gen2drv = generator2driv;
   endfunction

   extern virtual task reset_task();
   extern virtual task run();
   extern protected virtual task main_driver();

   extern protected virtual task read(wb_svtb_transaction trans);
   extern protected virtual task write(wb_svtb_transaction trans);

endclass: wb_svtb_master

   task wb_svtb_master::reset_task();
      // Driving the signals as per the spec.
      drv_if.master_cb.DAT_O <= 'b0;
      drv_if.master_cb.TGD_O <= 'b0;
      drv_if.master_cb.ADR_O  <= 'b0;
      drv_if.master_cb.WE_O   <= 'b0;
      drv_if.master_cb.CYC_O <= 'b0;
      drv_if.master_cb.LOCK_O <= 'b0;
      drv_if.master_cb.SEL_O <= 'b0;
      drv_if.master_cb.STB_O <= 'b0;
      drv_if.master_cb.TGA_O <= 'b0;
      drv_if.master_cb.TGC_O <= 'b0;
      repeat (4) @(drv_if.master_cb);

   endtask: reset_task

   task wb_svtb_master::run();
      fork 
	 reset_task();
	 main_driver();
      join_none
   endtask: run

   task wb_svtb_master::main_driver();
      forever begin
	 wb_svtb_transaction tr;
	 bit drop = 0;
	 // Set output signals to their idle state

	 drv_if.master_cb.DAT_O <= 'b0; 
         drv_if.master_cb.TGD_O <= 'b0;
         drv_if.master_cb.ADR_O <= 'b0;
         drv_if.master_cb.CYC_O <= 'b0;
         drv_if.master_cb.LOCK_O <= 'b0;
         drv_if.master_cb.SEL_O <= 'b0;
         drv_if.master_cb.STB_O <= 'b0;
         drv_if.master_cb.TGA_O <= 'b0;
         drv_if.master_cb.TGC_O <= 'b0;

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
	 
      end
   endtask : main_driver

   task wb_svtb_master::read(wb_svtb_transaction trans);

      @(drv_if.master_cb);

      $display("Got a read transaction");

      // Edge 0
      drv_if.master_cb.ADR_O <= trans.address;
      drv_if.master_cb.TGA_O <= trans.tga;
      drv_if.master_cb.WE_O  <= 1'b0;
      drv_if.master_cb.SEL_O <= trans.sel;
      drv_if.master_cb.CYC_O <= 1'b1;
      drv_if.master_cb.TGC_O <= trans.tgc;
      drv_if.master_cb.STB_O <= 1'b1;
      drv_if.master_cb.LOCK_O <= trans.lock;

      // Edge 1
      trans.status = wb_svtb_transaction::TIMEOUT ;
      while(!drv_if.master_cb.ACK_I) begin 
	 @(drv_if.master_cb);
      end
      trans.data = drv_if.master_cb.DAT_I;
      trans.tgd  = drv_if.master_cb.TGD_I;

      drv_if.master_cb.CYC_O  <= 1'b0;
      @(drv_if.master_cb);

   endtask	
   
   task wb_svtb_master::write( wb_svtb_transaction trans);

      // Section 3.2.2 of Wishbone B3 Specification
      @(drv_if.master_cb);
      $display("Got a write transaction");

      // Edge 0
      drv_if.master_cb.ADR_O <= trans.address;
      drv_if.master_cb.TGA_O  <= trans.tga;
      drv_if.master_cb.DAT_O <= trans.data;
      drv_if.master_cb.TGD_O <= trans.tgd;
      drv_if.master_cb.WE_O    <= 1'b1;
      drv_if.master_cb.SEL_O  <= trans.sel;
      drv_if.master_cb.CYC_O  <= 1'b1;
      drv_if.master_cb.TGC_O  <= trans.tgc;
      drv_if.master_cb.STB_O  <= 1'b1;

      // Edge 1
      trans.status = wb_svtb_transaction::TIMEOUT ;
      while(!drv_if.master_cb.ACK_I) begin 
	 @(drv_if.master_cb);
	 drv_if.master_cb.LOCK_O <= trans.lock;
	 drv_if.master_cb.CYC_O  <= 1'b0;
	 @(drv_if.master_cb);
      end
   endtask	
`endif // WB_MASTER__SV

