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

class base_sequence extends uvm_sequence #(wb_transaction);
   `uvm_object_utils(base_sequence)
   `uvm_declare_p_sequencer(wb_master_seqr)

   function new(string name = "base_seq");
      super.new(name);
   endfunction:new
   virtual task pre_body(); 
      uvm_phase phase_=get_starting_phase();

      if (get_starting_phase()!= null)
	phase_.raise_objection(this);

   endtask:pre_body
   virtual task post_body(); uvm_phase phase_=get_starting_phase();

      if (get_starting_phase()!= null)
	phase_.drop_objection(this);
   endtask:post_body
endclass

class sequence_0 extends base_sequence;
   `uvm_object_utils(sequence_0)
   
   function new(string name = "seq_0");
      super.new(name);
   endfunction:new
   virtual task body();
      
      repeat(2) begin
	 `uvm_do(req);
      end
      start_item(req);
      finish_item(req);
   endtask
   virtual task pre_body();
      if (get_starting_phase()!=null) begin
	 uvm_phase phase_=get_starting_phase();
	 `uvm_info(get_type_name(),
                   $sformatf("%s pre_body() raising %s objection", get_sequence_path(),
                             phase_.get_name()), UVM_MEDIUM);
	 phase_.raise_objection(this);
      end
   endtask

   // Drop the objection in the post_body so the objection is removed when
   // the root sequence is complete. 
   virtual task post_body();
      if (get_starting_phase()!=null) begin
	 uvm_phase phase_=get_starting_phase();
	 `uvm_info(get_type_name(),
                   $sformatf("%s post_body() dropping %s objection", get_sequence_path(),
                             phase_.get_name()), UVM_MEDIUM);
	 phase_.drop_objection(this);
      end
   endtask

endclass

class sequence_1 extends base_sequence;
   byte sa;
   `uvm_object_utils(sequence_1)
   
   function new(string name = "seq_1");
      super.new(name);
   endfunction:new
   virtual task body();

      
      `uvm_do(req, get_sequencer(), -1, {address == 3; kind == wb_transaction::READ ;})
      
      `uvm_do(req, get_sequencer(), -1, {address == 4; kind == wb_transaction::READ;})
      
      `uvm_do(req, get_sequencer(), -1, {address == 5; kind == wb_transaction::READ;}) 
   endtask
endclass

class repeated_read_sequence extends base_sequence;
   `uvm_object_utils(repeated_read_sequence)


   function new(string name="my_repeated_read_sequence");
      super.new(name);
   endfunction

   virtual task body();
      
      `uvm_do(req, get_sequencer(), -1, {address == 0; kind == wb_transaction::READ; })
      
      `uvm_do(req, get_sequencer(), -1, {address == 1; kind == wb_transaction::READ; })
      
      `uvm_do(req, get_sequencer(), -1, {address == 2; kind == wb_transaction::READ; })
      
      `uvm_do(req, get_sequencer(), -1, {address == 3; kind == wb_transaction::READ; })
   endtask

endclass
   
class write_master_single extends base_sequence;
   bit [31:0] write_data;
   bit [31:0] write_address;
   `uvm_object_utils(write_master_single)

   function new(string name = "seq_1");
      super.new(name);
   endfunction:new
   virtual    task body();
      
      `uvm_do(req, get_sequencer(), -1, {address == write_address; kind == wb_transaction::WRITE; data == write_data;})
   endtask
endclass

class read_master_single extends base_sequence;
   bit [31:0] read_data;
   bit [31:0] read_address;
   `uvm_object_utils(read_master_single)
   
   function new(string name = "seq_1");
      super.new(name);
   endfunction:new
   virtual    task body();
      
      `uvm_do(req, get_sequencer(), -1, {address == read_address; kind == wb_transaction::READ; })
   endtask
endclass

class heir_sequence_w extends base_sequence;
   `uvm_object_utils(heir_sequence_w)
   
   write_master_single single_seq;

   
   function new(string name = "seq_0");
      super.new(name);
   endfunction:new
   virtual task body();
      single_seq = write_master_single::type_id::create("my_sequence");
      single_seq.write_address  = 10;
      single_seq.write_data = 32'h12345678;
      repeat(2) begin
	 single_seq.start(p_sequencer);
      end
   endtask
endclass
`include "sequences/wb_master_agent_tx_init_sequence.sv"

`include "sequences/wb_master_agent_tx_interrupt_sequence.sv"
`include "sequences/wb_master_agent_setup_txbd_sequence.sv"
`include "sequences/wb_master_agent_setup_initialize_txbd_rxbd_sequence.sv"
`include "sequences/wb_master_agent_send_tx_packet.sv"
`include "sequences/wb_master_agent_send_2_packets.sv"
`include "sequences/wb_master_agent_send_tx_packet2.sv"
`include "sequences/wb_master_agent_send_2_packets_barrier.sv"
`include "sequences/wb_master_agent_tx_interrupt_seq_barrier.sv"
`include "sequences/wb_master_agent_tx_interrupt_event_seq.sv"
`include "sequences/wb_master_agent_send_2_packets_event_sync_sequence.sv"
