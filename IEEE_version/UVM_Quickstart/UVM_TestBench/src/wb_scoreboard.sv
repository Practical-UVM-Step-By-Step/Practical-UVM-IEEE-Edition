`ifndef WB_SCOREBOARD__SV
	`define WB_SCOREBOARD__SV

	class wb_scoreboard extends uvm_scoreboard;
		`uvm_component_utils( wb_scoreboard)
   
		uvm_tlm_analysis_fifo #( wb_transaction ) expected_wb_transaction_fifo;
		uvm_tlm_analysis_fifo #( wb_transaction ) actual_wb_transaction_fifo;
   
		// Constructor

		function new( string name, uvm_component parent );
			super.new( name, parent );
		endfunction: new

		extern virtual function void build_phase( uvm_phase phase );
		extern virtual function void connect_phase( uvm_phase phase );
		extern virtual task run_phase( uvm_phase phase );

	endclass: wb_scoreboard

	// Build all the components ..

	function void wb_scoreboard::build_phase( uvm_phase phase );
		super.build_phase( phase );
		expected_wb_transaction_fifo = new( "expected_wb_transaction_fifo", this );
		actual_wb_transaction_fifo  = new(   "actual_wb_transaction_fifo", this );
	endfunction: build_phase

	// Function: connect_phase
	// Connect the components

	function void wb_scoreboard::connect_phase( uvm_phase phase );
		super.connect_phase( phase );
	endfunction: connect_phase

	// Task: run_phase. All the heavy lifting takes place here.

	task wb_scoreboard::run_phase( uvm_phase phase );
		wb_transaction expected_transaction;
		wb_transaction   actual_transaction;
		uvm_event_pool my_event_pool;  // This becomes the global pool
		uvm_event      local_reset_event;  // Event to be used with global pool   

		super.run_phase( phase ); 
		my_event_pool = uvm_event_pool::get_global_pool();
		local_reset_event = my_event_pool.get("reset_event"); 
		local_reset_event.wait_off(); 
		`uvm_info("SCOREBOARD","Scoreboard received reset",UVM_LOW)
   
		forever begin
			expected_wb_transaction_fifo.get_peek_export.get( expected_transaction);
			actual_wb_transaction_fifo.get_peek_export.get(actual_transaction);
			`uvm_info("SCOREBOARD","EXPECTED TRANSACTION",UVM_LOW)
			expected_transaction.print();
			`uvm_info("SCOREBOARD","ACTUAL TRANSACTION",UVM_LOW)
			actual_transaction.print();
      
			if ( !expected_transaction.compare( actual_transaction)  ) begin
				`uvm_error( "WB Scoreboard", "wb_transaction mismatch") 
			end
			else begin
				`uvm_info("WB SCOREBOARD", "TRANSACTIONS MATCH", UVM_LOW)
			end
		end
	endtask: run_phase


`endif // WB_SCOREBOARD__SV
