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
