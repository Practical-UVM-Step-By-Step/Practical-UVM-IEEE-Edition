`ifndef WB_MASTER__SV
 `define WB_MASTER__SV

typedef class wb_transaction;
   typedef class wb_config;
   typedef class wb_master;
   typedef class wb_config;
 `include "wb_master_if.sv"

class wb_master_callbacks extends uvm_callback;

   // Called before a transaction is executed
   virtual task pre_tx( wb_master xactor, wb_transaction tr);
      
      `uvm_info("WB_MASTER_CALLBACKS"," This is in the pre-callback phase",UVM_LOW)

   endtask: pre_tx


   // Called after a transaction has been executed
   virtual task post_tx( wb_master xactor, wb_transaction tr);

   endtask: post_tx

endclass: wb_master_callbacks

class wb_master extends uvm_driver # (wb_transaction);

   wb_config mstr_drv_cfg;
   
   typedef virtual wb_master_if v_if; 
   v_if drv_if;
   `uvm_register_cb(wb_master,wb_master_callbacks); 
   
   extern function new(string name = "wb_master",
                       uvm_component parent = null); 
   
   `uvm_component_utils_begin(wb_master)
   `uvm_component_utils_end

   extern virtual function void build_phase(uvm_phase phase);
   extern virtual function void end_of_elaboration_phase(uvm_phase phase);
   extern virtual function void connect_phase(uvm_phase phase);
   extern virtual task main_phase(uvm_phase phase);
   extern protected virtual task main_driver();

   extern protected virtual task read(wb_transaction trans);
   extern protected virtual task write(wb_transaction trans);
   extern protected virtual task blockRead(wb_transaction trans);
   extern protected virtual task blockWrite( wb_transaction trans);  
   extern protected virtual task ReadModifyWrite(wb_transaction trans);

endclass: wb_master


   function wb_master::new(string name = "wb_master",
			   uvm_component parent = null);
      super.new(name, parent);
      
   endfunction: new

   function void wb_master::build_phase(uvm_phase phase);
      super.build_phase(phase);
   endfunction: build_phase

   function void wb_master::connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      uvm_config_db#(v_if)::get(this, "", "mst_if", drv_if);

   endfunction: connect_phase

   function void wb_master::end_of_elaboration_phase(uvm_phase phase);
      super.end_of_elaboration_phase(phase);
      if (drv_if == null)
	`uvm_fatal("NO_CONN", "Virtual port not connected to the actual interface instance");   
   endfunction: end_of_elaboration_phase
   
   task wb_master::main_phase(uvm_phase phase);
      super.main_phase(phase);
      fork 
	 main_driver();
      join_none
   endtask: main_phase

   task wb_master::main_driver();
      int count;
      uvm_event_pool my_event_pool;  // This will become global pool
      uvm_event      local_reset_event;  // Event to be used with global pool   

      count = 0;
      my_event_pool = uvm_event_pool::get_global_pool();
      local_reset_event = my_event_pool.get("reset_event"); 
      local_reset_event.wait_off(); 

      forever begin
	 wb_transaction tr;
	 // Set output signals to their idle state

	 drv_if.master_cb.DAT_O <= 'bz; 
         drv_if.master_cb.TGD_O <= 'bz;
         drv_if.master_cb.ADR_O <= 'bz;
         drv_if.master_cb.CYC_O <= 'bz;
         drv_if.master_cb.LOCK_O <= 'bz;
         drv_if.master_cb.SEL_O <= 'bz;
         drv_if.master_cb.STB_O <= 'b0;
         drv_if.master_cb.TGA_O <= 'bz;
         drv_if.master_cb.TGC_O <= 'bz;

	 seq_item_port.get_next_item(tr);
	 `uvm_info("WB_MASTER_DRV", "Starting transaction...",UVM_LOW)
	 `uvm_do_callbacks(wb_master,wb_master_callbacks, pre_tx(this, tr))
	 // Since we are just beginning the transaction, we dont know what kind it's yet. 

         tr.status = wb_transaction::UNKNOWN;

	 case (tr.kind)  
           wb_transaction::READ: begin
	      read(tr);
           end
           wb_transaction::WRITE: begin
	      write(tr);
           end
           wb_transaction::BLK_RD: begin
	      blockRead(tr);
           end
           wb_transaction::BLK_WR: begin
	      blockWrite(tr);
           end
           wb_transaction::RMW: begin
	      ReadModifyWrite(tr);
           end
	 endcase
	 
	 seq_item_port.item_done();
	 `uvm_info("WB_MASTER_DRV", tr.sprint(),UVM_HIGH)

	 `uvm_do_callbacks(wb_master,wb_master_callbacks, post_tx(this, tr))
	 count = count + 1;
	 `uvm_info("WB_MASTER_DRV", $sformatf("Completed %d transactions...",count),UVM_LOW)
      end
   endtask : main_driver


   task wb_master::read(wb_transaction trans);
      @(drv_if.master_cb);

      `uvm_info("Wb master","Got a read transaction",UVM_LOW)

      // Edge 0
      drv_if.master_cb.ADR_O <= trans.address;
      drv_if.master_cb.TGA_O <= trans.tga;
      drv_if.master_cb.WE_O  <= 1'b0;
      drv_if.master_cb.SEL_O <= trans.sel;
      drv_if.master_cb.CYC_O <= 1'b1;
      drv_if.master_cb.TGC_O <= trans.tgc;
      drv_if.master_cb.STB_O <= 1'b1;

      // Edge 1
      trans.status = wb_transaction::TIMEOUT ;
      repeat (this.mstr_drv_cfg.max_n_wss + 1) begin
	 // Wait states
	 @(drv_if.master_cb);

	 case (1'b1)
	   drv_if.master_cb.ERR_I: trans.status = wb_transaction::ERR ;
	   drv_if.master_cb.RTY_I: trans.status = wb_transaction::RTY ;
	   drv_if.master_cb.ACK_I: trans.status = wb_transaction::ACK ;
	   default: continue;
	 endcase

	 break;
      end
      trans.data = drv_if.master_cb.DAT_I;
      trans.tgd  = drv_if.master_cb.TGD_I;

      drv_if.master_cb.LOCK_O <= trans.lock;
      drv_if.master_cb.CYC_O  <= 1'bz;

   endtask	
   
   task wb_master::write( wb_transaction trans);


      // Section 3.2.2 of Wishbone B3 Specification
      @(drv_if.master_cb);
      `uvm_info("Wb master","Got a write transaction",UVM_LOW)

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
      trans.status = wb_transaction::TIMEOUT ;
      repeat (this.mstr_drv_cfg.max_n_wss + 1) begin
	 // Wait states
	 @(drv_if.master_cb);
	 case (1'b1)
      	   drv_if.master_cb.ERR_I: trans.status = wb_transaction::ERR ;
     	   drv_if.master_cb.RTY_I: trans.status = wb_transaction::RTY ;
      	   drv_if.master_cb.ACK_I: trans.status = wb_transaction::ACK ;
      	   default: continue;
	 endcase

	 break;
      end

      if (trans.status == wb_transaction::TIMEOUT ) begin
	 `uvm_info("wb_master_driver: ", "Timeout waiting for ACK_I, RTY_I or ERR_I",UVM_HIGH);
      end 

      drv_if.master_cb.LOCK_O <= trans.lock;
      drv_if.master_cb.CYC_O  <= 1'bz;

   endtask	

   task wb_master::blockRead(wb_transaction trans);
      `uvm_error("WB_MASTER","blockRead not implemented yet")
   endtask

   task wb_master::blockWrite(wb_transaction trans);
      `uvm_error("WB_MASTER","blockWrite not implemented yet")
   endtask

   task wb_master::ReadModifyWrite(wb_transaction trans);

      `uvm_error("WB_MASTER","ReadModifyWrite not implemented yet")
   endtask

`endif // WB_MASTER__SV


