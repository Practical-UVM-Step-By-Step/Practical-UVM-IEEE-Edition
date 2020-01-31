class initialize_txbd_rxbd_sequence extends base_sequence;
   `uvm_object_utils(initialize_txbd_rxbd_sequence)
   

   function new(string name = "initialize_rxbd_sequence");
      super.new(name);
   endfunction:new

   virtual task body();
      uvm_reg_data_t reg_data;
      uvm_status_e reg_status;
      `uvm_info(get_full_name(),$sformatf("Began cleaning up descriptors %d",$time),UVM_MEDIUM)
      p_sequencer.regmodel.MODER.write(.status(reg_status), .value(0), .path(UVM_FRONTDOOR), .parent(this));
      for(int i = 0; i < 64; i = i+1) begin
	 p_sequencer.regmodel.TxBD[i].TxBD_CTRL.write(.status(reg_status),.path(UVM_FRONTDOOR), .parent(this), .value(0));
	 p_sequencer.regmodel.TxBD[i].TxPNT_val.write(.status(reg_status),.path(UVM_FRONTDOOR), .parent(this), .value(0));
      end
      `uvm_info(get_full_name(),$sformatf("End cleaning up descriptors %d",$time),UVM_MEDIUM)
   endtask
endclass
