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

`ifndef WB_CONMAX_FLAT_SEQ_SV
	`define WB_CONMAX_FLAT_SEQ_SV

	typedef class wb_conmax_base_test;

	class wb_conmax_flat_seq_test extends wb_conmax_base_test;

		`uvm_component_utils(wb_conmax_flat_seq_test)

		function new(string name, uvm_component parent);
			super.new(name, parent);
		endfunction

		sequence_0 seq0;


		virtual task main_phase(uvm_phase phase);
			super.main_phase(phase);
			phase.raise_objection(this,"Test Main Objection");
			seq0 = sequence_0::type_id::create("sequence_1",this);
			seq0.start(env.master_agent[00].mast_sqr,null);
			seq0.wait_for_sequence_state(UVM_FINISHED);
			phase.drop_objection(this,"Dropping Test Main Objection");
		endtask

	endclass :  wb_conmax_flat_seq_test

`endif //WB_CONMAX_FLAT_SEQ_SV

