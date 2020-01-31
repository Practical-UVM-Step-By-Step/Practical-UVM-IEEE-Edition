`ifndef RESET_DRIVER__SV
 `define RESET_DRIVER__SV

typedef class reset_trans;
   typedef class reset_driver;

class reset_driver_callbacks extends uvm_callback;

   virtual task pre_reset_cbk( reset_driver xactor, reset_trans tr);

      `uvm_info("RESET_CBK","Calling Pre-reset callback",UVM_HIGH)
      

   endtask: pre_reset_cbk


   // Called after a Reset has been executed
   virtual task post_reset_cbk( reset_driver xactor,
				reset_trans tr);
      `uvm_info("POST_RESET_CBK","Calling Pre-reset callback",UVM_HIGH)

   endtask: post_reset_cbk

endclass: reset_driver_callbacks


class reset_driver extends uvm_driver # (reset_trans);
   
   typedef virtual reset_if v_if; 
   v_if drv_if;
   `uvm_register_cb(reset_driver,reset_driver_callbacks); 
   
   extern function new(string name = "reset_driver",
                       uvm_component parent = null); 
   
   `uvm_component_utils(reset_driver)

   extern virtual function void connect_phase(uvm_phase phase);
   extern virtual function void end_of_elaboration_phase(uvm_phase phase);
   extern virtual task run_phase(uvm_phase phase);
   extern protected virtual task tx_driver();

endclass: reset_driver


   function reset_driver::new(string name = "reset_driver",
			      uvm_component parent = null);
      super.new(name, parent);

      
   endfunction: new



   function void reset_driver::connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      uvm_config_db#(v_if)::get(this, "", "mst_if", drv_if); 
   endfunction: connect_phase

   function void reset_driver::end_of_elaboration_phase(uvm_phase phase);
      super.end_of_elaboration_phase(phase);
      if (drv_if == null)
	`uvm_fatal("NO_CONN", "Virtual port not connected to the actual interface instance");   
   endfunction: end_of_elaboration_phase

   

   task reset_driver::run_phase(uvm_phase phase);
      super.run_phase(phase);
      fork 
	 tx_driver();
      join_none
   endtask: run_phase


   task reset_driver::tx_driver();
      forever begin
	 reset_trans tr;
	 `uvm_info("RESET_DRIVER", "Starting transaction...",UVM_LOW)
	 seq_item_port.get_next_item(tr);
	 `uvm_info("RESET_DRIVER", tr.sprint(),UVM_LOW)

	 `uvm_do_callbacks(reset_driver,reset_driver_callbacks, pre_reset_cbk(this, tr))
	 case (tr.reset_kind) 
           reset_trans::ASSERT: begin
	      drv_if.master_cb.rst <= 'b1;
	      repeat(tr.cycles) @(drv_if.master_cb);

           end
           reset_trans::DEASSERT: begin
	      drv_if.master_cb.rst <= 'b0;
	      repeat(tr.cycles) @(drv_if.master_cb);

           end
	 endcase
	 `uvm_do_callbacks(reset_driver,reset_driver_callbacks, post_reset_cbk(this, tr))
	 `uvm_info("RESET_DRIVER", "Completed transaction...",UVM_LOW)
	 seq_item_port.item_done();

      end // Forever
   endtask : tx_driver

`endif // RESET_DRIVER__SV


