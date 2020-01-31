
`ifndef WB_ENV_TB_MOD__SV
 `define WB_ENV_TB_MOD__SV

 `include "mstr_slv_intfs.incl"
 `include "wb_test.pkg"
module wb_env_tb_mod;
   import uvm_pkg::*;
   import wb_tests::*;


   typedef wb_transaction_ext actual_transaction_packet;
   typedef wb_transaction base_transaction_packet;

   string new_type;

   // Declare interfaces
   typedef virtual wb_master_if v_if1;
   typedef virtual wb_slave_if v_if2;
   initial begin
      uvm_factory f = uvm_coreservice_t::get().get_factory() ;
      uvm_cmdline_processor p = uvm_cmdline_processor::get_inst();
      f.set_type_alias("BasePacket",wb_transaction::get_type());
      f.set_type_override_by_type(wb_cov_base::get_type(),wb_env_cov::get_type());
      void'(p.get_arg_value("+NEW_PACKET=",new_type));
      if(new_type == "")
        $fatal("no override. test will fail");
      else
        f.set_type_override_by_name("BasePacket",new_type);
      //Note that this is equivalent to wb_transaction::type_id::set_type_override(wb_transaction_ext::get_type);

      uvm_config_db #(v_if1)::set(null,"uvm_test_top.env.master_agent","mst_if",wb_env_top_mod.mast_if);
      uvm_config_db #(v_if2)::set(null,"uvm_test_top.env.slave_agent","slv_if",wb_env_top_mod.slave_if);
      uvm_config_db #(bit) :: set(null,"env.slave_agent","is_active",1);
      uvm_config_db #(bit) :: set(null,"env.master_agent","is_active",1);
      run_test();
   end

endmodule: wb_env_tb_mod


`endif // WB_ENV_TB_MOD__SV

