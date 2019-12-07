/***********************************************
 *                                              *
 * Examples for the book Practical UVM          *
 *                                              *
 * Copyright Srivatsa Vasudevan 2010-2016       *
 * All rights reserved                          *
 *                                              *
 * Permission is granted to use this work       * 
 * provided this notice and attached license.txt*
 * are not removed/altered while redistributing *
 * See license.txt for details                  *
 *                                              *
 ************************************************/

typedef class wb_transaction;
   typedef class ral_reg_ethernet_blk_TxBD_TxBD_CTRL;
class wb_master_seqr_sequence_library extends uvm_sequence_library # (wb_transaction);
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
`include "sequences/write_master_single.sv"
`include "sequences/read_master_single.sv"
`include "sequences/heir_sequence.sv"
`include "sequences/init_tx_seq.sv"
`include "sequences/tx_interrupt_seq.sv"
`include "sequences/setup_txbd_sequence.sv"
`include "sequences/initialize_txbd_rxbd_sequence.sv"
`include "sequences/send_tx_packet.sv"
`include "sequences/send_2_packets.sv"
`include "sequences/send_tx_packet2.sv"
`include "sequences/send_2_packets_barrier.sv"
`include "sequences/tx_interrupt_seq_barrier.sv"
`include "sequences/tx_interrupt_event_seq.sv"
`include "sequences/send_2_packets_event_sync_sequence.sv"
`include "sequences/send_2_packets_heartbeat_sequence.sv"


