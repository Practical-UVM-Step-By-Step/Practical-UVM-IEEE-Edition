typedef class wb_master_seqr;
class wb_virt_sequencer extends uvm_sequencer;

   `uvm_component_utils(wb_virt_sequencer);
   wb_master_seqr seqr1;


   function new(string name = "wb_virtual_sequencer", input uvm_component parent=null);
      super.new(name,parent);
      // set_arbitration(UVM_SEQ_ARB_FIFO);

   endfunction


endclass
