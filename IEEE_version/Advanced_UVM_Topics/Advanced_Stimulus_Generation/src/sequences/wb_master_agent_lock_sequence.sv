class lock_sequence extends base_sequence;
	`uvm_object_utils(lock_sequence)
	`uvm_add_to_seq_lib(lock_sequence,wb_master_seqr_sequence_library)

	function new(string name="my_lock_sequence");
		super.new(name);
	endfunction

	virtual task body();
		lock();
		`uvm_do(req, get_sequencer(), -1, {address == 0; kind == wb_transaction::READ; })
		`uvm_do(req, get_sequencer(), -1, {address == 1; kind == wb_transaction::READ; })
		`uvm_do(req, get_sequencer(), -1, {address == 2; kind == wb_transaction::READ; })
		`uvm_do(req, get_sequencer(), -1, {address == 3; kind == wb_transaction::READ; })
		unlock();
	endtask

endclass
