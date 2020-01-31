`ifndef WB_MASTER_SEQR_SEQUENCE_LIBRARY
 `define WB_MASTER_SEQR_SEQUENCE_LIBRARY

typedef class wb_transaction;

class wb_master_seqr_sequence_library extends uvm_sequence_library # (wb_transaction);
   `uvm_object_utils(wb_master_seqr_sequence_library)
   `uvm_sequence_library_utils(wb_master_seqr_sequence_library)

   function new(string name = "simple_seq_lib");
      super.new(name);
      init_sequence_library();
   endfunction

endclass  
 `include "sequences/base_sequence.sv"
 `include "sequences/sequence_0.sv"
 `include "sequences/sequence_1.sv"
 `include "sequences/repeated_read_sequence.sv"
 `include "sequences/objection_in_sequence.sv"
   
`endif
