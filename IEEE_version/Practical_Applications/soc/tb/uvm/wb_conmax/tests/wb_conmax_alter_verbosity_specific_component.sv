
`ifndef WB_CONMAX_ALTER_VERBOSITY_TEST_SPECIFIC_COMPONENT_SV
 `define WB_CONMAX_ALTER_VERBOSITY_TEST_SPECIFIC_COMPONENT_SV

typedef class wb_conmax_base_test;


   // This class promotes the UVM_INFO 
class message_promoter  extends uvm_report_catcher;
   function new(string name="message_promoter");
      super.new(name);
   endfunction

   //This example demotes "MY_ID" errors to an info message
   function action_e catch();
      if(get_severity() == UVM_INFO && get_id() == "SLAVE_DRIVER")
	set_severity(UVM_ERROR);
      return THROW;
   endfunction
endclass

class wb_conmax_alter_verbosity_specific_component_test extends wb_conmax_base_test;

   `uvm_component_utils(wb_conmax_alter_verbosity_specific_component_test)

   message_promoter promoter = new;

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      // Set the default sequencer in all the master agents
      uvm_config_db #(uvm_object_wrapper)::set(this, "env.wb_conmax_virt_seqr.main_phase", "default_sequence",wb_conmax_virtual_sequence::get_type());
      
      uvm_report_cb::add(null,promoter);

   endfunction

   function void end_of_elaboration_phase(uvm_phase phase);
      uvm_report_cb::add(this.env.slave_agent[0].slv_drv, promoter);
   endfunction 

endclass :  wb_conmax_alter_verbosity_specific_component_test

`endif //WB_CONMAX_ALTER_VERBOSITY_TEST
