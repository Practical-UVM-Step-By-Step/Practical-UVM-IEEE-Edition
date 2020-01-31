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
	 `uvm_info("SEQUENCE0",
                   $sformatf("%s pre_body() raising %s objection",
                             get_sequence_path(),
                             phase_.get_name()), UVM_MEDIUM);
	 phase_.raise_objection(this);
      end
   endtask

   // Drop the objection in the post_body so the objection is removed when
   // the root sequence is complete. 
   virtual task post_body();
      uvm_phase phase_ = get_starting_phase();
      if (phase_!=null) begin
	 `uvm_info("SEQUENCE0",
                   $sformatf("%s post_body() dropping %s objection",
                             get_sequence_path(),
                             phase_.get_name()), UVM_MEDIUM);
	 phase_.drop_objection(this);
      end
   endtask

endclass
