class parallel_sequence extends base_sequence;
   byte sa;
   `uvm_object_utils(parallel_sequence)
   `uvm_add_to_seq_lib(parallel_sequence, wb_master_seqr_sequence_library)
   `uvm_declare_p_sequencer(wb_master_seqr)
   function new(string name = "seq_1");
      super.new(name);
   endfunction:new
   virtual task body(); uvm_phase phase_=get_starting_phase();

      integer i;
      sequence_0 seq0;
      sequence_1 seq1;

      fork
        `uvm_do(seq0,p_sequencer,-1,{})
        `uvm_do(seq1,p_sequencer,-1,{})
      join
      
   endtask
endclass

