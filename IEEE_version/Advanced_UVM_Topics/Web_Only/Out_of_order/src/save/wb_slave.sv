`ifndef WB_SLAVE__SV
 `define WB_SLAVE__SV

typedef class wb_transaction;
   typedef class wb_slave;

class wb_slave_callbacks extends uvm_callback;

   // Called before a transaction is executed
   virtual task pre_tx( wb_slave xactor, wb_transaction tr);
      `uvm_info(get_full_name(),$sformatf("pre tx slave Not implemented yet"),UVM_LOW)
   endtask: pre_tx

   // Called after a transaction has been executed
   virtual task post_tx( wb_slave xactor,
                         wb_transaction tr);
      `uvm_info(get_full_name(),$sformatf("post tx slave Not implemented yet"),UVM_LOW)

   endtask: post_tx

endclass: wb_slave_callbacks


class wb_slave extends uvm_driver # (wb_transaction);

   wb_transaction m_tr; // This is what is captured
   local bit [63:0] ram [*];

   uvm_blocking_get_imp #(wb_transaction,wb_slave) getp;

   wb_config wb_slave_cfg;
   
   typedef virtual  wb_slave_if v_if; 
   v_if drv_if;
   `uvm_register_cb(wb_slave,wb_slave_callbacks); 
   
   extern function new(string name = "wb_slave",
                       uvm_component parent = null); 
   
   `uvm_component_utils(wb_slave)

   extern virtual function void build_phase(uvm_phase phase);
   extern virtual function void end_of_elaboration_phase(uvm_phase phase);
   extern virtual function void connect_phase(uvm_phase phase);
   extern virtual task reset_phase(uvm_phase phase);
   extern virtual task configure_phase(uvm_phase phase);
   extern virtual task run_phase(uvm_phase phase);
   extern protected virtual task slave_driver();
   extern protected virtual task send_response();

   wb_transaction packet_q[$];

   task get(output wb_transaction transaction);
      wait(packet_q.size() > 0);
      $cast(transaction,packet_q.pop_front().clone());
   endtask: get

endclass: wb_slave





   function wb_slave::new(string name = "wb_slave",
			  uvm_component parent = null);
      super.new(name, parent);
      getp= new("slv_get_export",this);
      
   endfunction: new


   function void wb_slave::build_phase(uvm_phase phase);
      super.build_phase(phase);
   endfunction: build_phase

   function void wb_slave::connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      if(!uvm_config_db#(v_if)::get(this, "", "slv_if", drv_if))
	`uvm_fatal("NOVIF SLV DRIVER",{"virtual interface must be set for: ",get_full_name(),".v_if"}); 
   endfunction: connect_phase

   function void wb_slave::end_of_elaboration_phase(uvm_phase phase);
      super.end_of_elaboration_phase(phase);
      if (drv_if == null)
	`uvm_fatal("NO_CONN", "Virtual port not connected to the actual interface instance");   
   endfunction: end_of_elaboration_phase


   
   task wb_slave::reset_phase(uvm_phase phase);
      super.reset_phase(phase);
      phase.raise_objection(this,"");
      drv_if.DAT_O <= 64'bz;
      drv_if.TGD_O <= 16'bz;
      drv_if.ACK_O <=  1'bz;
      drv_if.RTY_O  <=  1'bz;
      drv_if.ERR_O <=  1'bz;
      drv_if.RESP_O <=  1'bz;
      phase.drop_objection(this);
   endtask: reset_phase

   task wb_slave::configure_phase(uvm_phase phase);
      super.configure_phase(phase);
   endtask:configure_phase


   task wb_slave::run_phase(uvm_phase phase);
      super.run_phase(phase);
      fork 
	 slave_driver();
	 send_response();
      join_none
   endtask: run_phase

   task wb_slave::slave_driver();
      bit [63:0] read_data;
      forever begin
	 wb_transaction tr;


	 do begin

            @(drv_if.CYC_I or
              drv_if.STB_I or
              drv_if.ADR_I or
              drv_if.SEL_I or
              drv_if.WE_I  or
              drv_if.TGA_I or
              drv_if.TGC_I);
         end while (drv_if.CYC_I !== 1'b1 ||
                    drv_if.STB_I !== 1'b1);

	 /*
	  do begin
          @(drv_if.CYC_I or
          drv_if.STB_I or
          drv_if.ADR_I or
          drv_if.SEL_I or
          drv_if.WE_I  or
          drv_if.TGA_I or
          drv_if.TGC_I);
	  
	  `uvm_info("SLAVE","waiting",UVM_LOW)
	 end while (drv_if.CYC_I != 1'b1 || drv_if.STB_I != 1'b1) ;
	  */


	 tr= wb_transaction::type_id::create("tr", this);
	 tr.address = drv_if.ADR_I;
	 // Are we supposed to respond to this cycle?
	 if(this.wb_slave_cfg.min_addr <= tr.address  && tr.address <=this.wb_slave_cfg.max_addr )
	   begin
	      tr.sel = drv_if.SEL_I;
	      `uvm_do_callbacks(wb_slave,wb_slave_callbacks, pre_tx(this, tr))
	      tr.tga = drv_if.TGA_I;
	      tr.tgd = drv_if.TGA_I;
	      if(drv_if.WE_I) begin
		 tr.kind = wb_transaction::WRITE;
	   	 `uvm_info("Wb_slave",$sformatf("got a write transaction  from Master Addr:%h data: %h tag :%d",tr.address,tr.data,tr.tga),UVM_LOW)
		 tr.data  = drv_if.DAT_I;
	         tr.tgd  = drv_if.TGA_I;
		 packet_q.push_back(tr);
	      end
	      else  begin
		 tr.kind = wb_transaction::READ ;
	   	 `uvm_info("Wb_slave",$sformatf("got a read transaction  from Master Addr:%h data: %h tag :%d",tr.address,tr.data,tr.tga),UVM_LOW)
		 packet_q.push_back(tr);
	      end
	      // Send back an ACK
	      @ (drv_if.slave_cb);
	      drv_if.ACK_O <= 1'b1;
	      drv_if.TGD_O = tr.tga;
	      @ (drv_if.slave_cb);
	      drv_if.ACK_O <= 1'b0;
	      drv_if.TGD_O = 'b0;
	      @ (drv_if.slave_cb);
	   end // if 
      end //forever
   endtask : slave_driver

   task wb_slave::send_response();
      forever begin
	 wb_transaction trans;
	 seq_item_port.get_next_item(trans);
	 repeat (this.wb_slave_cfg.max_n_wss) begin
	    @ (drv_if.slave_cb);
         end
  	 drv_if.RTY_O = 1'b0;
	 drv_if.ERR_O = 1'b0;
	 `uvm_info("SLAVE_DRIVER",$sformatf("sending a response to transaction %s",trans.sprint()),UVM_HIGH)
         drv_if.DAT_O    = 64'b0;
	 //drv_if.RESP_O = 1'b1;
	 
	 if(trans.kind == wb_transaction::WRITE) begin
            drv_if.DAT_O    <= 'b0;
	    drv_if.RESP_O = 1'b0;
  	    drv_if.RTY_O <= 1'b0;
	    drv_if.ERR_O <= 1'b0;
	    seq_item_port.item_done(trans);
	    @ (drv_if.slave_cb);
	 end
	 
	 if(trans.kind == wb_transaction::READ) begin
	    drv_if.DAT_O = trans.data;
	    drv_if.TGD_O = trans.tgd;
	    drv_if.RESP_O = 1'b1;
	    seq_item_port.item_done(trans);
	    @ (drv_if.slave_cb);
	    drv_if.DAT_O = 'b0;
	    drv_if.RESP_O = 'b0;
	    drv_if.TGD_O = 'b0;
	 end
	 @ (drv_if.slave_cb);
      end //forever
   endtask

`endif // WB_SLAVE__SV


