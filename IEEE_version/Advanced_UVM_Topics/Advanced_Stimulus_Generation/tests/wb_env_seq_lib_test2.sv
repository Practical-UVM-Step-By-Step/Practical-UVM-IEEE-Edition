`ifndef TEST_SEQ_LIB2__SV
	`define TEST_SEQ_LIB2__SV

	typedef class wb_env;

	class wb_env_seq_lib_test_2 extends wb_env_base_test;
		`uvm_component_utils(wb_env_seq_lib_test_2)
		wb_env env;
		wb_master_seqr_sequence_library seq_lib;

		function new(string name="wb_env_seq_lib_test_2", uvm_component parent);
			super.new(name, parent);
		endfunction

		virtual function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			uvm_config_db #(uvm_sequence_lib_mode)::set(null, "env.master_agent.mast_sqr.main_phase", "default_sequence.selection_mode", UVM_SEQ_LIB_RANDC);
			uvm_config_db #(uvm_object_wrapper)::set(this, "env.master_agent.mast_sqr.main_phase", "default_sequence", wb_master_seqr_sequence_library::type_id::get()); 
		endfunction

	endclass : wb_env_seq_lib_test_2

`endif //TEST_SEQ_LIB2__SV

