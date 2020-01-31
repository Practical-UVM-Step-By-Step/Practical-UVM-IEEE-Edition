class init_tx_seq extends base_sequence;
   `uvm_object_utils(init_tx_seq)
   

   function new(string name = "init_tx_seq");
      super.new(name);
   endfunction:new

   virtual task body();
      uvm_reg_data_t reg_data;
      uvm_status_e reg_status;

      // Set the Mac's address. 

      p_sequencer.regmodel.MODER.PAD.set(1);
      p_sequencer.regmodel.MODER.RXEN.set(1);
      p_sequencer.regmodel.MODER.TXEN.set(1);
      p_sequencer.regmodel.MODER.FULLD.set(1);
      p_sequencer.regmodel.MODER.CRCEN.set(1);
      p_sequencer.regmodel.MODER.update(.status(reg_status),  .path(UVM_FRONTDOOR), .parent(this));
   endtask

endclass
