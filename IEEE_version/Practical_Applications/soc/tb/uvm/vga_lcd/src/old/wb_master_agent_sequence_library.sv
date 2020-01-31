

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

`ifdef WB_MASTER_AGENT_SEQUENCE_LIBRARY
 `define WB_MASTER_AGENT_SEQUENCE_LIBRARY

typedef class wb_transaction;

class wb_master_seqr_sequence_library extends uvm_sequence_library # (wb_transaction);
   `uvm_sequence_library_utils(wb_master_seqr_sequence_library)

   function new(string name = "simple_seq_lib");
      super.new(name);
      init_sequence_library();
   endfunction

endclass  

class base_sequence extends uvm_sequence #(wb_transaction);
   `uvm_object_utils(base_sequence)

   function new(string name = "base_seq");
      super.new(name);
      set_automatic_phase_objection(1);
   endfunction:new
   virtual task pre_start();
      if (starting_phase != null)
	starting_phase.raise_objection(this);
   endtask:pre_start
   virtual task post_start();
      if (starting_phase != null)
	starting_phase.drop_objection(this);
   endtask:post_start
endclass

class sequence_0 extends base_sequence;
   `uvm_object_utils(sequence_0)
   `uvm_add_to_seq_lib(sequence_0,wb_master_seqr_sequence_library)
   function new(string name = "seq_0");
      super.new(name);
   endfunction:new
   virtual task body();
      
      repeat(2) begin
	 `uvm_do(req);
      end
      start_item(req);
      finish_item(req);
      // Vid    global_stop_request();
      //  $display("done a count of 10");
   endtask
   virtual task pre_body();
      if (starting_phase!=null) begin
	 `uvm_info(get_type_name(),
                   $sformatf("%s pre_body() raising %s objection",
                             get_sequence_path(),
                             starting_phase.get_name()), UVM_MEDIUM);
	 starting_phase.raise_objection(this);
      end
   endtask

   // Drop the objection in the post_body so the objection is removed when
   // the root sequence is complete. 
   virtual task post_body();
      if (starting_phase!=null) begin
	 `uvm_info(get_type_name(),
                   $sformatf("%s post_body() dropping %s objection",
                             get_sequence_path(),
                             starting_phase.get_name()), UVM_MEDIUM);
	 starting_phase.drop_objection(this);
      end
   endtask

endclass

class sequence_1 extends base_sequence;
   byte sa;
   `uvm_object_utils(sequence_1)
   `uvm_add_to_seq_lib(sequence_1, wb_master_seqr_sequence_library)
   function new(string name = "seq_1");
      super.new(name);
   endfunction:new
   virtual task body();
      
      // `uvm_do_with(req, { sa == 3; } );
      
      `uvm_do(req, get_sequencer(), -1, {address == 3; kind == wb_transaction::WRITE; data == 63'hdeadbeef;})
      
      `uvm_do(req, get_sequencer(), -1, {address == 4; kind == wb_transaction::WRITE; data == 63'hbeefdead;})
      
      `uvm_do(req, get_sequencer(), -1, {address == 5; kind == wb_transaction::WRITE; data == 63'h0123456678;})

      
      `uvm_do(req, get_sequencer(), -1, {address == 6; kind == wb_transaction::READ ;})
      
      `uvm_do(req, get_sequencer(), -1, {address == 6; kind == wb_transaction::READ;})
      
      `uvm_do(req, get_sequencer(), -1, {address == 7; kind == wb_transaction::READ;}) 
      // ToDo: User can add implementation here
   endtask
endclass

`endif
