`ifndef WB_MASTER__SV
 `define WB_MASTER__SV

typedef class wb_transaction;
   typedef class wb_config;
   typedef class wb_master;
   typedef class wb_config;
 `include "wb_master_if.sv"


class wb_master extends uvm_driver # (wb_transaction,wb_transaction);

   wb_config mstr_drv_cfg;

   bit ok_to_start_next_transaction;

   
   typedef virtual wb_master_if v_if; 
   v_if drv_if;
   
   extern function new(string name = "wb_master",
                       uvm_component parent = null); 
   
   `uvm_component_utils_begin(wb_master)
   `uvm_component_utils_end

   extern virtual function void build_phase(uvm_phase phase);
   extern virtual function void end_of_elaboration_phase(uvm_phase phase);
   extern virtual function void start_of_simulation_phase(uvm_phase phase);
   extern virtual function void connect_phase(uvm_phase phase);
   extern virtual task reset_phase(uvm_phase phase);
   extern virtual task configure_phase(uvm_phase phase);
   extern virtual task run_phase(uvm_phase phase);
   //extern protected virtual task get_item();
   //extern protected virtual task execute_item();
   //extern protected virtual task process_responses();
   extern task automatic process_transaction(int id);


   //extern protected virtual task read(wb_transaction trans);
   //extern protected virtual task write(wb_transaction trans);

   // Internal variables
   semaphore bus_lock;
   bit [4:0] active_transaction_id;
   

endclass: wb_master


   function wb_master::new(string name = "wb_master",
			   uvm_component parent = null);
      super.new(name, parent);
      bus_lock = new(1);
      active_transaction_id = 0;
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

   function void wb_master::start_of_simulation_phase(uvm_phase phase);
      super.start_of_simulation_phase(phase);
   endfunction: start_of_simulation_phase

   
   task wb_master::reset_phase(uvm_phase phase);
      super.reset_phase(phase);
      phase.raise_objection(this,"");
      // Driving the signals as per the spec.
      drv_if.master_cb.DAT_O <= 'bz;
      drv_if.master_cb.TGD_O <= 'bz;
      drv_if.master_cb.ADR_O  <= 'bz;
      drv_if.master_cb.WE_O   <= 'bz;
      drv_if.master_cb.CYC_O <= 'b0;
      drv_if.master_cb.STB_O <= 'b0;
      drv_if.master_cb.LOCK_O <= 'bz;
      drv_if.master_cb.SEL_O <= 'bz;
      drv_if.master_cb.TGA_O <= 'bz;
      drv_if.master_cb.TGC_O <= 'bz;

      repeat (4) @(drv_if.master_cb);
      phase.drop_objection(this);

   endtask: reset_phase

   task wb_master::configure_phase(uvm_phase phase);
      super.configure_phase(phase);
   endtask:configure_phase


   task wb_master::run_phase(uvm_phase phase);
      super.configure_phase(phase);
      fork 
	 process_transaction(1);
	 process_transaction(2);
      join_none
   endtask: run_phase

   task automatic wb_master::process_transaction( int id);
      wb_transaction trans;
      forever begin
	 /*
	  drv_if.master_cb.DAT_O <= 'bz;
	  drv_if.master_cb.TGD_O <= 'bz;
	  drv_if.master_cb.ADR_O  <= 'bz;
	  drv_if.master_cb.WE_O   <= 'bz;
	  drv_if.master_cb.CYC_O <= 'b0;
	  drv_if.master_cb.LOCK_O <= 'bz;
	  drv_if.master_cb.SEL_O <= 'bz;
	  drv_if.master_cb.STB_O <= 'b0;
	  drv_if.master_cb.TGA_O <= 'bz;
	  drv_if.master_cb.TGC_O <= 'bz;
	  */
	 // Edge 0
	 @(drv_if.master_cb);
	 seq_item_port.get(trans);
	 bus_lock.get(1); // We get access to the bus.
	 `uvm_info("WB_MASTER",$sformatf("%d STARTED %s TRANSACTION %s",id,trans.kind.name(),trans.sprint()),UVM_LOW)
	 trans.tga = active_transaction_id;
	 
	 drv_if.master_cb.ADR_O <= trans.address;
	 drv_if.master_cb.TGA_O <= trans.tga;
	 active_transaction_id = active_transaction_id + 1;
	 drv_if.master_cb.CYC_O  <= 1'b1;
	 drv_if.master_cb.STB_O  <= 1'b1;
         drv_if.master_cb.WE_O    <= 1'b0;
	 if(trans.kind == wb_transaction::WRITE) begin
     	    drv_if.master_cb.DAT_O <= trans.data;
            drv_if.master_cb.WE_O    <= 1'b1;
	    drv_if.master_cb.TGD_O <= trans.tgd;
	    drv_if.master_cb.SEL_O  <= trans.sel;
	 end
	 @(drv_if.master_cb);
	 drv_if.master_cb.CYC_O  <= 'b0;
	 drv_if.master_cb.STB_O  <= 'b0;
	 drv_if.master_cb.ADR_O <= 'bz;
	 drv_if.master_cb.TGA_O <= 'bz;
         drv_if.master_cb.WE_O    <= 1'b0;
	 drv_if.master_cb.DAT_O <= 'bz;

	 if(trans.kind == wb_transaction::WRITE) begin
	    trans.status = wb_transaction::OK;
	 end
	 //	 while(!drv_if.ACK_I) 
	 //	   @(drv_if.master_cb);

	 @(drv_if.master_cb);

	 if(trans.kind == wb_transaction::WRITE) begin
	    do begin
	       @(drv_if.master_cb);
	    end while (drv_if.TGD_I != trans.tga &&  drv_if.ACK_I!==1  );
	    seq_item_port.put( trans);
	    `uvm_info("WB_MASTER",$sformatf("%d Completed WRITE TRANSACTION %s",id,trans.sprint()),UVM_LOW)
	 end

	 
	 if(trans.kind == wb_transaction::READ) begin
	    do begin
	       @(drv_if.master_cb);
	    end while (drv_if.TGD_I != trans.tga &&  drv_if.RESP_I!==1  );
	    trans.data = drv_if.DAT_I;
	    trans.status = wb_transaction::OK;
	    `uvm_info("WB_MASTER",$sformatf("%d COMPLETED READ TRANSACTION %s",id,trans.sprint()),UVM_LOW)
	    seq_item_port.put( trans);
	    @(drv_if.master_cb);
	 end
	 bus_lock.put(1);
      end
   endtask	

`endif // WB_MASTER__SV


