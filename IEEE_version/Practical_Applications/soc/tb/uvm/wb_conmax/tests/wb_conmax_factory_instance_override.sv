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

`ifndef WB_CONMAX_FACTORY_INSTANCE_OVERRIDE_SV
 `define WB_CONMAX_FACTORY_INSTANCE_OVERRIDE_SV

typedef class wb_conmax_base_test;

class wb_conmax_factory_instance_override_test extends wb_conmax_base_test;

   `uvm_component_utils(wb_conmax_factory_instance_override_test)

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      string my_full_path;
      string orig_type_name, override_type_name;
      uvm_coreservice_t cs;
      uvm_root r;
      uvm_factory fact;

      cs = uvm_coreservice_t::get();
      r = cs.get_root();
      fact = cs.get_factory();
      my_full_path = "env.master_agent[00]";
      orig_type_name = "wb_master_agent";
      override_type_name = "wb_master_agent_n";
   
      set_inst_override(my_full_path,orig_type_name,override_type_name);

      fact.print();
      super.build_phase(phase);
      // Set the default sequencer in one of the master agents
      uvm_config_db #(uvm_object_wrapper)::set(this, "env.master_agent[00].mast_sqr.main_phase", "default_sequence", sequence_1::get_type()); 
      r.enable_print_topology=1;
      r.print_topology();

   endfunction

endclass :  wb_conmax_factory_instance_override_test

`endif //WB_CONMAX_FACTORY_INSTANCE_OVERRIDE_SV

