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

   task get(output wb_transaction transaction);
      wait(m_tr != null )
  	transaction = m_tr;
      m_tr = null;
   endtask: get

   semaphore bus_lock;

endclass: wb_slave

   function wb_slave::new(string name = "wb_slave",
			  uvm_component parent = null);
      super.new(name, parent);
      getp= new("slv_get_export",this);
      bus_lock = new(1);
      
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
      drv_if.RESP_O <=  1'b0;
      phase.drop_objection(this);
   endtask: reset_phase

   task wb_slave::configure_phase(uvm_phase phase);
      super.configure_phase(phase);
      phase.raise_objection(this,"");

      phase.drop_objection(this);
   endtask:configure_phase


   task wb_slave::run_phase(uvm_phase phase);
      super.configure_phase(phase);
      //phase.raise_objection(this,"");
      fork 
	 slave_driver();
	 send_response();
      join_none
      //phase.drop_objection(this);
   endtask: run_phase


   task wb_slave::slave_driver();
      bit [63:0] read_data;
      wb_slave_cfg.print();
      forever begin
	 wb_transaction tr;


	 /*
	  do begin
          if (drv_if.CYC_I !== 1'b1 ) begin
          drv_if.DAT_O    <= 64'bz;
          drv_if.TGD_O    <= 16'bz;
          drv_if.ACK_O    <=  1'bz;
          drv_if.RTY_O    <=  1'bz;
          drv_if.ERR_O     <=  1'bz;
            end
 	  `uvm_info("WB_SLAVE",$sformatf("Bef CYC_I: %b",drv_if.CYC_I),UVM_LOW)
          @(drv_if.CYC_I or
          drv_if.ADR_I or
          drv_if.SEL_I or
          drv_if.WE_I  or
          drv_if.TGA_I or
          drv_if.TGC_I);
 	  `uvm_info("WB_SLAVE",$sformatf("@ CYC_I: %b",drv_if.CYC_I),UVM_LOW)
	 end while (drv_if.CYC_I !== 1'b1);
	  */
	 bus_lock.get(1);
	 wait(drv_if.CYC_I == 1'b1);
         tr= wb_transaction::type_id::create("tr", this);
	 tr.address = drv_if.ADR_I;
	 // Are we supposed to respond to this cycle?
	 if(this.wb_slave_cfg.min_addr <= tr.address  && tr.address <=this.wb_slave_cfg.max_addr )
	   begin
	      tr.sel = drv_if.SEL_I;
	      tr.tga = drv_if.TGA_I;
	      if(drv_if.WE_I) begin
		 tr.kind = wb_transaction::WRITE;
		 tr.data  = drv_if.DAT_I;
	         tr.tgd  = drv_if.TGD_I;
   		 `uvm_info("Wb_slave",$sformatf("got a Write transaction %s  ",tr.sprint()),UVM_LOW)
	      end
	      else begin
		 tr.kind = wb_transaction::READ ;
   		 `uvm_info("Wb_slave",$sformatf("got a read transaction %s  ",tr.sprint()),UVM_LOW)
	      end
	      m_tr = tr;
	      `uvm_info("WB_SLAVE","WAITFORLOCK 1",UVM_LOW)
	      `uvm_info("WB_SLAVE","GOT LOCK 1",UVM_LOW)
	      @(drv_if.slave_cb);
	      drv_if.ACK_O = 1;
	      drv_if.TGD_O = tr.tga;
	      @(drv_if.slave_cb);
	      drv_if.ACK_O = 0;
	      drv_if.TGD_O = 'bz;
	      @(drv_if.slave_cb);
	      bus_lock.put(1);
	      `uvm_info("WB_SLAVE","PUT LOCK 1",UVM_LOW)
	   end
      end //forever
      
   endtask : slave_driver

   task wb_slave::send_response();
      forever begin
         wb_transaction trans;
         drv_if.TGD_O = 'bz;
         drv_if.DAT_O = 'bz;
         drv_if.RESP_O = 'b0;
         seq_item_port.get_next_item(trans);
         repeat (this.wb_slave_cfg.max_n_wss) begin
            @ (drv_if.slave_cb);
         end
	 `uvm_info("WB_SLAVE","WAITFORLOCK 2",UVM_LOW)
	 bus_lock.get(1);
	 `uvm_info("WB_SLAVE","GOT LOCK 2",UVM_LOW)
         `uvm_info("SLAVE_DRIVER",$sformatf("sending a response to transaction %s",trans.sprint()),UVM_HIGH)
         if(trans.kind == wb_transaction::WRITE) begin
            //drv_if.DAT_O    <= 'bz;
            //drv_if.RESP_O = 1'b0;
            //drv_if.RTY_O <= 1'b0;
            //drv_if.ERR_O <= 1'b0;
            @ (drv_if.slave_cb);
            seq_item_port.item_done(trans);
         end

         if(trans.kind == wb_transaction::READ) begin
            drv_if.DAT_O = trans.data;
            drv_if.TGD_O = trans.tga;
            drv_if.RESP_O = 1'b1;
            @ (drv_if.slave_cb);
            drv_if.DAT_O = 'bz;
            drv_if.RESP_O = 'b0;
            drv_if.TGD_O = 'bz;
            @ (drv_if.slave_cb);
            seq_item_port.item_done(trans);
         end
	 bus_lock.put(1);
	 `uvm_info("WB_SLAVE","PUT LOCK 2",UVM_LOW)
      end //forever
   endtask


`endif // WB_SLAVE__SV


