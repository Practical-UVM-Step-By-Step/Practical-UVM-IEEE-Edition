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

`ifndef WB_SVTB_MASTER_MON__SV
 `define WB_SVTB_MASTER_MON__SV

typedef class wb_svtb_transaction;
   typedef class wb_svtb_master_mon;
   typedef class wb_svtb_config;
   

class wb_svtb_master_mon ;


   mailbox monitor_port;
   typedef virtual wb_master_if v_if;
   v_if mon_if;

   wb_svtb_config mstr_mon_cfg;

   extern function new(mailbox sbport, virtual  wb_master_if m_if,  wb_svtb_config cfg);
   extern virtual task run();
   extern protected virtual task master_monitor_task();

endclass: wb_svtb_master_mon

   function wb_svtb_master_mon::new(mailbox sbport, virtual  wb_master_if m_if,  wb_svtb_config cfg);
      mstr_mon_cfg = cfg;
      mon_if = m_if;
      monitor_port = sbport;
   endfunction

   task wb_svtb_master_mon::run();
      fork
	 master_monitor_task();
      join_none

   endtask: run

   task wb_svtb_master_mon::master_monitor_task();
      int repeat_count = this.mstr_mon_cfg.max_n_wss + 1;
      int timeout_count = 0;

      integer master_transaction_timeout;

      forever begin
	 wb_svtb_transaction tr;

	 do begin

            @(this.mon_if.CYC_O or
              this.mon_if.STB_O or
              this.mon_if.ADR_O or
              this.mon_if.SEL_O or
              this.mon_if.WE_O  or
              this.mon_if.TGA_O or
              this.mon_if.TGC_O);
	 end while (this.mon_if.CYC_O !== 1'b1 ||
                    this.mon_if.STB_O !== 1'b1);
	 tr= wb_svtb_transaction::type_id::create("tr", this);
	 tr.address = this.mon_if.ADR_O;
	 // Are we supposed to respond to this cycle?
	 if(this.mstr_mon_cfg.min_addr <= tr.address  && tr.address <=this.mstr_mon_cfg.max_addr )

	   begin
	      timeout_count = 0;

	      tr.tga = this.mon_if.TGA_O;
	      if(this.mon_if.WE_O) begin
		 tr.kind = wb_svtb_transaction::WRITE;
		 tr.data  = this.mon_if.DAT_I;
	         tr.tgd  = this.mon_if.TGD_O;
		 tr.status = wb_svtb_transaction::ACK;
              end
	      else begin
		 tr.kind = wb_svtb_transaction::READ ;
		 tr.data  = this.mon_if.DAT_O;
	         tr.tgd  = this.mon_if.TGD_O;

		 tr.status = wb_svtb_transaction::ACK;
      	      end
      	      tr.sel = this.mon_if.SEL_O;
      	      tr.tgc  =this.mon_if.TGC_O;

	      // Edge 1
	      tr.status = wb_svtb_transaction::TIMEOUT ;
	      while(!this.mon_if.ACK_I) begin
		 @(this.mon_if.monitor_cb);
		 timeout_count = timeout_count + 1;
		 // Wait states
		 case (1'b1)
		   this.mon_if.ERR_I: tr.status = wb_svtb_transaction::ERR ;
		   this.mon_if.RTY_I: tr.status = wb_svtb_transaction::RTY ;
		   this.mon_if.ACK_I: tr.status = wb_svtb_transaction::ACK ;
		   default: continue;
		 endcase
	      end
	      tr.data  = this.mon_if.DAT_O;
	      if ((timeout_count >  repeat_count )|| tr.status == wb_svtb_transaction::TIMEOUT ) begin
		 $display("Timeout waiting for ACK_I, RTY_I or ERR_I");
	      end
	      monitor_port.put(tr);
	   end
      end // forever
   endtask: master_monitor_task

`endif // WB_SVTB_MASTER_MON__SV

