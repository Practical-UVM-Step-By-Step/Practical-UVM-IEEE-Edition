`ifndef RESET_MONITOR__SV
 `define RESET_MONITOR__SV


typedef class reset_trans;
   typedef class reset_monitor;

class reset_monitor extends uvm_monitor;

   uvm_analysis_port #(reset_trans) mon_analysis_port;  //TLM analysis port
   typedef virtual reset_if v_if;
   v_if mon_if;
   extern function new(string name = "reset_monitor",uvm_component parent);
   `uvm_component_utils(reset_monitor)

   extern virtual function void end_of_elaboration_phase(uvm_phase phase);
   extern virtual function void connect_phase(uvm_phase phase);
   extern virtual task run_phase(uvm_phase phase);
   extern protected virtual task monitor();

   // Reset Event
   uvm_event_pool my_event_pool;  // This will become global pool
   uvm_event      reset_event ;  // Reset Event to be used with global pool   

endclass: reset_monitor


   function reset_monitor::new(string name = "reset_monitor",uvm_component parent);
      super.new(name, parent);
      mon_analysis_port = new ("mon_analysis_port",this);
      my_event_pool = uvm_event_pool::get_global_pool();
      reset_event = my_event_pool.get("reset_event");
   endfunction: new

   function void reset_monitor::connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      uvm_config_db#(v_if)::get(this, "", "mon_if", mon_if);
   endfunction: connect_phase

   function void reset_monitor::end_of_elaboration_phase(uvm_phase phase);
      super.end_of_elaboration_phase(phase); 
      if (mon_if == null)
	`uvm_fatal("NO_CONN", "Virtual port not connected to the actual interface instance");
   endfunction: end_of_elaboration_phase

   task reset_monitor::run_phase(uvm_phase phase);
      super.run_phase(phase);
      fork
	 monitor();
      join_none

   endtask: run_phase


   task reset_monitor::monitor();
      /* This is left as an exercise for the reader to improve upon.
       *  Only a rudimentary implementation is provided 
       * See the assignments for what to fill in here
       */
      forever begin
	 @(mon_if.rst);
	 assert(!$isunknown(mon_if.rst));
	 if (mon_if.rst == 1'b1) begin
	    reset_event.trigger();
	    `uvm_info("RESET_MON","Reset triggered",UVM_LOW)
	 end else begin
	    reset_event.reset();
	    `uvm_info("RESET_MON","Reset cleared",UVM_LOW)
	 end
      end

      
   endtask: monitor

`endif // RESET_MONITOR__SV
