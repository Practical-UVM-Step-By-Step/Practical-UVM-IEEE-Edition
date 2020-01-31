class setup_txbd_sequence extends base_sequence;
   `uvm_object_utils(setup_txbd_sequence)
   

   int packet_lenght;
   int buffer_num;
   int mem_addr ;
   function new(string name = "setup_txbd_sequence");
      super.new(name);
   endfunction:new

   virtual task body();
      uvm_reg_data_t reg_data;
      uvm_status_e reg_status;

      p_sequencer.regmodel.TX_BD_NUM.write(.status(reg_status),.path(UVM_FRONTDOOR), .parent(this),.value(buffer_num));

      p_sequencer.regmodel.TxBD[buffer_num].TxBD_CTRL.CS.set(0);
      p_sequencer.regmodel.TxBD[buffer_num].TxBD_CTRL.DF.set(0);
      p_sequencer.regmodel.TxBD[buffer_num].TxBD_CTRL.LC.set(0);
      p_sequencer.regmodel.TxBD[buffer_num].TxBD_CTRL.RL.set(0);
      p_sequencer.regmodel.TxBD[buffer_num].TxBD_CTRL.RTRY.set(0);
      p_sequencer.regmodel.TxBD[buffer_num].TxBD_CTRL.UR.set(0);
      p_sequencer.regmodel.TxBD[buffer_num].TxBD_CTRL.CRC.set(1);
      p_sequencer.regmodel.TxBD[buffer_num].TxBD_CTRL.PAD.set(1);
      p_sequencer.regmodel.TxBD[buffer_num].TxBD_CTRL.WR.set(1);
      p_sequencer.regmodel.TxBD[buffer_num].TxBD_CTRL.IRQ.set(1);
      p_sequencer.regmodel.TxBD[buffer_num].TxBD_CTRL.RD.set(1);
      p_sequencer.regmodel.TxBD[buffer_num].TxBD_CTRL.LEN.set(packet_lenght);

      p_sequencer.regmodel.TxBD[buffer_num].TxBD_CTRL.update(.status(reg_status),.path(UVM_FRONTDOOR), .parent(this));
      p_sequencer.regmodel.TxBD[buffer_num].TxPNT_val.write(.status(reg_status),.path(UVM_FRONTDOOR), .parent(this), .value(mem_addr));

      $display("CTRL Time is %d %d %h\n",$time,packet_lenght,p_sequencer.regmodel.TxBD[buffer_num].TxBD_CTRL.get());
      $display("VALUE Time is %d %d %h\n",$time,packet_lenght,p_sequencer.regmodel.TxBD[buffer_num].TxPNT_val.get());

   endtask
endclass

