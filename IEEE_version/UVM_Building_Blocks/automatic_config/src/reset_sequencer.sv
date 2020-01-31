`ifndef RESET_SEQUENCER__SV
 `define RESET_SEQUENCER__SV


typedef class reset_trans;
class reset_sequencer extends uvm_sequencer # (reset_trans);

   `uvm_component_utils(reset_sequencer)
   function new (string name,
                 uvm_component parent);
      super.new(name,parent);
   endfunction:new 
endclass:reset_sequencer

`endif // RESET_SEQUENCER__SV
