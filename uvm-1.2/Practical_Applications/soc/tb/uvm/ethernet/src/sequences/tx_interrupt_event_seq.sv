class tx_interrupt_event_seq extends base_sequence;
   `uvm_object_utils(tx_interrupt_event_seq)
   
   uvm_event int_event;

   function new(string name = "tx_interrupt_event_seq");
      super.new(name);
   endfunction:new

   virtual task body();
      uvm_reg_data_t reg_data;
      uvm_status_e reg_status;
      uvm_config_db #(uvm_event)::get(null,"","transmit_b",int_event);
      `uvm_info(get_full_name(),$sformatf("waiting for Interrupt at start of Sequence %d",$time),UVM_MEDIUM)
      int_event.wait_ptrigger();
      `uvm_info(get_full_name(),$sformatf("waiting for Interrupt trigger %d",$time),UVM_MEDIUM)
      p_sequencer.int_if.wait_for_intr_pos();
      `uvm_info(get_full_name(),$sformatf("Got Interrupt finally %d",$time),UVM_MEDIUM)
      grab();
      p_sequencer.regmodel.INT_MASK.read(.status(reg_status),.path(UVM_FRONTDOOR), .parent(this),.value(reg_data));
      p_sequencer.regmodel.INT_MASK.write(.status(reg_status),.path(UVM_FRONTDOOR), .parent(this),.value(32'h0000007f));
      p_sequencer.regmodel.INT_SOURCE.read(.status(reg_status),.path(UVM_FRONTDOOR), .parent(this),.value(reg_data));
      p_sequencer.regmodel.INT_SOURCE.write(.status(reg_status),.path(UVM_FRONTDOOR), .parent(this),.value(reg_data));
      ungrab();
      `uvm_info(get_full_name(),$sformatf("Completed interrupt sequence %d",$time),UVM_MEDIUM)
   endtask
endclass


