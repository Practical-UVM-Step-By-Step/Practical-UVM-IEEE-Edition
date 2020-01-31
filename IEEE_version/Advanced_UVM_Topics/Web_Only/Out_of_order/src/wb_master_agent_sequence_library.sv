`ifndef WB_MASTER_SEQR_SEQUENCE_LIBRARY
 `define WB_MASTER_SEQR_SEQUENCE_LIBRARY

typedef class wb_transaction;

class wb_master_seqr_sequence_library extends uvm_sequence_library # (wb_transaction);
   `uvm_sequence_library_utils(wb_master_seqr_sequence_library)

   function new(string name = "simple_seq_lib");
      super.new(name);
      init_sequence_library();
   endfunction

endclass  

class base_sequence extends uvm_sequence #(wb_transaction,wb_transaction);
   `uvm_object_utils(base_sequence)

   function new(string name = "base_seq");
      super.new(name);
   endfunction:new
   virtual task pre_body();
      uvm_phase phase_ = get_starting_phase();
      if (phase_ != null)
	phase_.raise_objection(this);
   endtask:pre_body
   virtual task post_body();
      uvm_phase phase_ = get_starting_phase();
      if (phase_ != null)
	phase_.drop_objection(this);
   endtask:post_body

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
   endtask
   virtual task pre_body();
      uvm_phase phase_ = get_starting_phase();
      if (phase_!=null) begin
	 `uvm_info(get_type_name(),
                   $sformatf("%s pre_body() raising %s objection",
                             get_sequence_path(),
                             phase_.get_name()), UVM_LOW);
	 phase_.raise_objection(this);
      end
   endtask

   // Drop the objection in the post_body so the objection is removed when
   // the root sequence is complete. 
   virtual task post_body();
      uvm_phase phase_ = get_starting_phase();
      if (phase_!=null) begin
	 `uvm_info(get_type_name(),
                   $sformatf("%s post_body() dropping %s objection",
                             get_sequence_path(),
                             phase_.get_name()), UVM_LOW);
	 phase_.drop_objection(this);
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
      
      `uvm_do(req, get_sequencer(), -1, {address == 3; kind == wb_transaction::WRITE; data == 63'hdeadbeef;})
      `uvm_do(req, get_sequencer(), -1, {address == 4; kind == wb_transaction::WRITE; data == 63'hbeefdead;})
      `uvm_do(req, get_sequencer(), -1, {address == 5; kind == wb_transaction::WRITE; data == 63'h0123456678;})

      
      `uvm_do(req, get_sequencer(), -1, {address == 3; kind == wb_transaction::READ ;})
      `uvm_do(req, get_sequencer(), -1, {address == 4; kind == wb_transaction::READ;})
      `uvm_do(req, get_sequencer(), -1, {address == 5; kind == wb_transaction::READ;}) 
      // ToDo: User can add implementation here
   endtask
endclass

class repeated_read_sequence extends base_sequence;
   `uvm_object_utils(repeated_read_sequence)
   `uvm_add_to_seq_lib(repeated_read_sequence,wb_master_seqr_sequence_library)

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
   
class out_of_order_sequence extends base_sequence;
   byte sa;
   int 	i;
   wb_transaction packet_q[int];
   wb_transaction my_packet = wb_transaction::type_id::create("my_packet");
   wb_config wb_master_config;
   `uvm_object_utils(out_of_order_sequence)
   `uvm_add_to_seq_lib(out_of_order_sequence, wb_master_seqr_sequence_library)

   function new(string name = "seq_1");
      super.new(name);
   endfunction:new
   virtual task body();
      wb_transaction pkt_q[$];
      
      use_response_handler(1);
      uvm_config_db #(wb_config)::get(null, "env.master_agent", "config", wb_master_config);
      if (wb_master_config == null)
	`uvm_fatal("OUT_OF_ORDER_SEQ","Got a bad config") 
      `uvm_do(req, get_sequencer(), -1, {address == 16; kind == wb_transaction::READ; })
      `uvm_do(req, get_sequencer(), -1, {address == 32; kind == wb_transaction::READ; })
      
      begin
     	 `uvm_do(req, get_sequencer(), -1, {address == 8; kind == wb_transaction::WRITE; data == 63'hdeadbeef; })
      	 //`uvm_do(req, get_sequencer(), -1, {address == 8; kind == wb_transaction::READ; })
    	 `uvm_do(req, get_sequencer(), -1, {address == 4; kind == wb_transaction::WRITE; data == 63'hbeefdead; })
      	 `uvm_do(req, get_sequencer(), -1, {address == 8; kind == wb_transaction::READ; })
      	 `uvm_do(req, get_sequencer(), -1, {address == 4; kind == wb_transaction::READ; })
      end
      
   endtask
   
   function void response_handler(uvm_sequence_item response);
      wb_transaction rsp;
      if(!$cast(rsp, response)) begin
	 `uvm_error("response_handler", "Failed to cast response to wb_transaction")
	 return;
      end
      `uvm_info("SEQUENCE",$sformatf("RESPONSE Transaction Received %s",rsp.sprint()),UVM_LOW)
   endfunction: response_handler

endclass

`endif
