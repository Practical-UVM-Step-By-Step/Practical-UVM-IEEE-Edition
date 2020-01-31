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

`ifndef WB_SLAVE__SV
 `define WB_SLAVE__SV

typedef class wb_transaction;
   typedef class wb_slave;


class wb_slave ;

   protected wb_transaction m_tr; // This is what is captured
   event send_to_get;
   local bit [63:0] ram [*];


   wb_config wb_slave_cfg;
   
   typedef virtual  wb_slave_if v_if; 
   v_if drv_if;
   
   extern function new(string name = "wb_slave");
   

   extern protected virtual task slave_driver();
   extern protected virtual task reset_task();
   extern virtual task run();

   task get(output wb_transaction transaction);
      wait(send_to_get.triggered)
  	transaction = m_tr;
      m_tr = null;
      send_to_get = null;
   endtask: get

   function bit [63:0] read(bit [63:0] addr);
      read = (ram.exists(addr)) ? ram[addr] : 64'bx;
   endfunction: read
   function void write(bit [63:0] addr, bit [63:0] data);
      ram[addr] = data;
   endfunction: write

endclass: wb_slave

   function wb_slave::new(string name = "wb_slave");
      
   endfunction: new


   
   task wb_slave::reset_task();
      this.drv_if.DAT_O <= 64'bz;
      this.drv_if.TGD_O <= 16'bz;
      this.drv_if.ACK_O <=  1'b0;
      this.drv_if.RTY_O  <=  1'b0;
      this.drv_if.ERR_O <=  1'b0;
   endtask: reset_task

   task wb_slave::run();
      fork 
	 reset_task();
	 slave_driver();
      join_none
   endtask: run

   task wb_slave::slave_driver();
      bit [63:0] read_data;
      int 	 repeat_count = this.wb_slave_cfg.max_n_wss;
      forever begin
	 wb_transaction tr;
         process proc;

	 do begin
            if (this.drv_if.CYC_I !== 1'b1 || this.drv_if.STB_I !== 1'b1) begin
               this.drv_if.DAT_O    <= 64'bz;
               this.drv_if.TGD_O    <= 16'bz;
               this.drv_if.ACK_O    <=  1'b0;
               this.drv_if.RTY_O    <=  1'b0;
               this.drv_if.ERR_O     <=  1'b0;
            end

            @(this.drv_if.CYC_I or
              this.drv_if.STB_I or
              this.drv_if.ADR_I or
              this.drv_if.SEL_I or
              this.drv_if.WE_I  or
              this.drv_if.TGA_I or
              this.drv_if.TGC_I);
	 end while (this.drv_if.CYC_I !== 1'b1 ||
                    this.drv_if.STB_I !== 1'b1);
	 tr= new;
	 tr.address = this.drv_if.ADR_I;
	 // Are we supposed to respond to this cycle?
	 if(this.wb_slave_cfg.min_addr <= tr.address  && tr.address <=this.wb_slave_cfg.max_addr )
	   begin
	      $display("responding in this cycle");
	      
	      tr.tga = this.drv_if.TGA_I;
	      if(this.drv_if.WE_I) begin
		 tr.kind = wb_transaction::WRITE;
	   	 $display("Wb_slave","got a write transaction  from Master ");
		 tr.data  = this.drv_if.DAT_I;
	         tr.tgd  = this.drv_if.TGD_I;
		 write(tr.address,tr.data);
		 tr.status = wb_transaction::ACK;
		 $display($sformatf(" Received write transaction to address %h with data %h",tr.address,tr.data));
              end
	      else begin
		 tr.kind = wb_transaction::READ ;
   		 $display("Wb_slave","got a read transaction  ");
		 read_data = read(tr.address);

		 this.drv_if.DAT_O = read_data;
		 this.drv_if.TGD_O = tr.tgd;
		 tr.status = wb_transaction::ACK;
		 $display($sformatf(" Received READ transaction to address %h. Responding with data %h",tr.address,tr.data));
      	      end

	      // repeat (this.wb_slave_cfg.max_n_wss) begin
	      repeat (repeat_count) begin
		 @ (this.drv_if.slave_cb);
              end

	      case (tr.status)
		wb_transaction::ACK : this.drv_if.ACK_O <= 1'b1;
		wb_transaction::RTY : this.drv_if.RTY_O <= 1'b1;
		wb_transaction::ERR : this.drv_if.ERR_O <= 1'b1;
              endcase

	      tr.sel = this.drv_if.SEL_I;
	      tr.tgc  = this.drv_if.TGC_I;
	      @(this.drv_if.slave_cb);
	   end
      	 $display("SLAVE_DRIVER", "Completed transaction...");
      end
   endtask : slave_driver

`endif // WB_SLAVE__SV

