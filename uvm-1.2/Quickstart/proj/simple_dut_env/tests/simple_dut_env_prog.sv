//
// Template for VMM-compliant Program block
//

`ifndef SIMPLE_DUT_ENV_PROG__SV
`define SIMPLE_DUT_ENV_PROG__SV

`include "simple_dut_env_if.sv"

program simple_dut_env_prog(simple_dut_env_if intf [2]);

`include "simple_dut_env_env.sv"
`include "simple_dut_env_test.sv"
 // ToDo: Include test list here

   simple_dut_env_env env_inst;
   vmm_test_registry registry;
   initial begin
      env_inst = new(intf);
      registry = new;
      registry.run(env_inst);
   end

endprogram: simple_dut_env_prog

`endif // SIMPLE_DUT_ENV_PROG__SV

