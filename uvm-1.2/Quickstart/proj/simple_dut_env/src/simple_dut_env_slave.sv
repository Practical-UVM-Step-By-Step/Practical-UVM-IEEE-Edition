//
// Template for VMM-compliant generic slave receiver component
//

`ifndef SIMPLE_DUT_ENV_SLAVE__SV
 `define SIMPLE_DUT_ENV_SLAVE__SV

 `include "simple_dut_env_slave_base.sv"

typedef class simple_dut_env_slave;

class simple_dut_env_slave_cov_cb extends simple_dut_env_slave_base_cb #(wb_simple_trans);

   // ToDo: define covergroups 

   function new();
      // ToDo: instantiate covergroups  

   endfunction: new


   virtual task pre_recv(wb_simple_trans tr); 

      // ToDo: Coverage tasks to be done before receiving transactions.

   endtask: pre_recv


   virtual task post_recv(wb_simple_trans tr);
      
      // ToDo: Coverage tasks to be done after receiving transactions.
      
   endtask: post_recv

endclass: simple_dut_env_slave_cov_cb


class simple_dut_env_slave extends simple_dut_env_slave_base #(wb_simple_trans) ;

   virtual simple_dut_env_if intf_i;   
   
   `vmm_xactor_member_begin(simple_dut_env_slave)
     // ToDo: Add vmm xactor member 

     `vmm_xactor_member_end(simple_dut_env_slave)
   // ToDo: Add required short hand override method

   extern function new(string inst = "", 
                       int     stream_id = -1, 
			       wb_simple_trans_channel out_chan = null, 
                       virtual simple_dut_env_if intf_i); 

   extern task receive (ref wb_simple_trans pkt);
   
endclass: simple_dut_env_slave


   function simple_dut_env_slave::new(string inst = "", 
				      int     stream_id = -1, 
					      wb_simple_trans_channel out_chan = null, 
				      virtual simple_dut_env_if intf_i); 

      super.new("Receiver", inst, stream_id, out_chan); 
      this.intf_i = intf_i; 

   endfunction: new


   task simple_dut_env_slave::receive(ref wb_simple_trans pkt);
      // ToDo: Add receiver specific logic
      `vmm_note(log, "Add receiver specific logic which can NEW the transaction pkt of type wb_simple_trans");
      `vmm_note(log, "User need to remove $finish once receiver specific logic is added");
      $finish;
   endtask: receive

`endif // SIMPLE_DUT_ENV_SLAVE__SV
