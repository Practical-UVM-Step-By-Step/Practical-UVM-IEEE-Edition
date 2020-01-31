// This class is the actual interrupt sequence.
class tx_interrupt_seq extends base_sequence;
   `uvm_object_utils(tx_interrupt_seq)
   

   function new(string name = "tx_interrupt_seq");
      super.new(name);
   endfunction:new

   virtual task body();
      uvm_reg_data_t reg_data;
      uvm_status_e reg_status;
      
      `uvm_info(get_full_name(),$sformatf("waiting for Interrupt %d",$time),UVM_MEDIUM)
      p_sequencer.int_if.wait_for_intr_pos();
      `uvm_info(get_full_name(),$sformatf("Got Interrupt %d",$time),UVM_MEDIUM)
      grab();
      p_sequencer.regmodel.INT_MASK.read(.status(reg_status),.path(UVM_FRONTDOOR), .parent(this),.value(reg_data));
      p_sequencer.regmodel.INT_MASK.write(.status(reg_status),.path(UVM_FRONTDOOR), .parent(this),.value(32'h0000007f));
      p_sequencer.regmodel.INT_SOURCE.read(.status(reg_status),.path(UVM_FRONTDOOR), .parent(this),.value(reg_data));
      p_sequencer.regmodel.INT_SOURCE.write(.status(reg_status),.path(UVM_FRONTDOOR), .parent(this),.value(reg_data));
      `uvm_info(get_full_name(),$sformatf("Completed interrupt sequence %d",$time),UVM_MEDIUM)
      ungrab();
   endtask
endclass

