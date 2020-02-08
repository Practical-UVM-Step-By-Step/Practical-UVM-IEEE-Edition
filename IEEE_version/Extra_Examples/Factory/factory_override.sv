module top;
	import uvm_pkg::*;


	class Class_A_acs extends uvm_component;
		int my_component_int_prop ;
		`uvm_component_utils_begin(Class_A_acs)
		`uvm_field_int(my_component_int_prop,UVM_ALL_ON)
		`uvm_component_utils_end
    
		function new(string name="Class_A_acs",uvm_component parent = null);
			super.new(name,parent);
		endfunction
		virtual function bit use_automatic_config();
			return 1;
		endfunction
	endclass

	class Class_A_no_acs extends uvm_component;
		int my_component_int_prop ;
		`uvm_component_utils_begin(Class_A_no_acs)
		`uvm_field_int(my_component_int_prop,UVM_ALL_ON)
		`uvm_component_utils_end
    
		function new(string name="Class_A_no_acs",uvm_component parent = null);
			super.new(name,parent);
		endfunction
		virtual function bit use_automatic_config();
			return 0;
		endfunction
	endclass

	class Class_A_no_acs_ext extends Class_A_acs;
			`uvm_component_utils(Class_A_no_acs_ext)
		function new(string name="Class_A_no_acs_ext",uvm_component parent = null);
			super.new(name,parent);
		endfunction
		virtual function bit use_automatic_config();
			return 1;
		endfunction
	endclass
	class Class_A_no_acs_ext_2 extends Class_A_acs;
		`uvm_component_utils(Class_A_no_acs_ext_2)
		function new(string name="Class_A_no_acs_ext_2",uvm_component parent = null);
			super.new(name,parent);
		endfunction
		virtual function bit use_automatic_config();
			return 0;
		endfunction
	endclass

	class mytest extends uvm_test;
		`uvm_component_utils(mytest)
		function new(string name="mytest",uvm_component parent = null);
			super.new(name,parent);
		endfunction
		Class_A_no_acs no_acs1;
		Class_A_no_acs no_acs2;
		Class_A_acs  acs1;
		Class_A_acs  acs2;
		Class_A_acs  acs_array[16];

		function void build_phase(uvm_phase phase);
			uvm_coreservice_t cs;
			int my_comp_int = 10;
			uvm_root r;
			uvm_factory my_factory = uvm_factory::get();
			cs = uvm_coreservice_t::get();
			r = cs.get_root();
			r.enable_print_topology = 1;
			my_factory.set_inst_override_by_name("Class_A_acs","Class_A_no_acs_ext_2",{get_full_name(),".","acs_array[10]"});
			// Type override
			my_factory.set_type_override_by_type( Class_A_acs::get_type(),Class_A_no_acs_ext::get_type());

			uvm_config_db #(int)::set(this,"no_acs1","my_component_int_prop",10);
			uvm_config_db #(int)::set(this,"no_acs1","my_component_int_prop",20);
			uvm_config_db #(int)::set(this,"acs1","my_component_int_prop",14);
			uvm_config_db #(int)::set(this,"acs2","my_component_int_prop",15);
			for(int i = 0; i < 16; i++) begin
				uvm_config_db #(int)::set(this,$sformatf("acs_array[%02d]",i),"my_component_int_prop",i);
				acs_array[i]  = Class_A_acs::type_id::create($sformatf("acs_array[%02d]",i),this);
			end
			no_acs1 = Class_A_no_acs::type_id::create("no_acs1",this);
			no_acs2 = Class_A_no_acs::type_id::create("no_acs2",this);
			acs1 = Class_A_acs::type_id::create("acs1",this);
			acs2 = Class_A_acs::type_id::create("acs2",this);
			my_factory.print();
        
		endfunction
	endclass



	initial begin
		run_test();
	end


endmodule
