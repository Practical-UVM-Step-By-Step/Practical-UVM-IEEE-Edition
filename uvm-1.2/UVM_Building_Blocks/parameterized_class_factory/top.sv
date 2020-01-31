
import uvm_pkg::*;
`include "pkt.sv"
`include "simple_drv.sv"
`include "simple_mon.sv"
`include "simple_agent.sv"
`include "param_drv.sv"
`include "param_mon.sv"
`include "param_agent.sv"
`include "env.sv"

module top;

   env env0;

   initial begin
      /*
       // Being registered first, the following overrides take precedence
       // over any overrides made within env0's construction & build.

       // Replace all base drivers with derived drivers...
       my_driver1::type_id::set_type_override(my_driver2::get_type());

       // ...except for agent0.driver0, whose type remains a base driver.
       //     (Both methods below have the equivalent result.)

       // - via the component's proxy (preferred)
       my_driver1::type_id::set_inst_override(my_driver1::get_type(),
       "env0.agent0.driver0");

       // - via a direct call to a factory method
       factory.set_inst_override_by_type(my_driver1::get_type(),
       my_driver1::get_type(),
       {get_full_name(),"env0.agent0.driver0"});
       */
      // now, create the environment; our factory configuration will
      // govern what topology gets created
      env0 = new("env0");

      // run the test (will execute build phase)
      run_test();

   end

endmodule
