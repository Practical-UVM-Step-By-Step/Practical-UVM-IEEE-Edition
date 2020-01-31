`ifndef RESET_TRANS__SV
	`define RESET_TRANS__SV


	class reset_trans extends uvm_sequence_item;

		typedef enum {ASSERT, DEASSERT} reset_kind_e;
		rand reset_kind_e reset_kind;
		rand int  unsigned cycles;

		constraint reset_trans_valid {
			cycles > 0;
			cycles < 100;
		}
		`uvm_object_utils_begin(reset_trans) 
		`uvm_field_int(cycles,UVM_ALL_ON)
		`uvm_field_enum(reset_kind_e,reset_kind,UVM_ALL_ON)
		`uvm_object_utils_end
   
		function new(string name = "Trans");
			super.new(name);
		endfunction: new

	endclass: reset_trans

`endif // RESET_TRANS__SV
