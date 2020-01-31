//
// Template for VMM-compliant configuration class
//

`ifndef SIMPLE_DUT_ENV_CFG__SV
 `define SIMPLE_DUT_ENV_CFG__SV


class simple_dut_env_cfg extends vmm_data; 

   // Define test configuration parameters (e.g. how long to run)
   int num_trans = 1;
   int num_scen = 1;
   
   typedef enum bit [1:0] {NORMAL, RECORD, PLAYBACK} mode_e;
   mode_e mode = NORMAL;
   
   `vmm_data_member_begin(simple_dut_env_cfg)
     `vmm_data_member_enum(mode, DO_ALL)
      `vmm_data_member_scalar(num_trans, DO_ALL)
      `vmm_data_member_scalar(num_scen, DO_ALL)
      // ToDo: add properties using macros here

   `vmm_data_member_end(simple_dut_env_cfg)

endclass: simple_dut_env_cfg


`vmm_channel(simple_dut_env_cfg)
`vmm_atomic_gen(simple_dut_env_cfg, "simple_dut_env_cfg Gen")
`vmm_scenario_gen(simple_dut_env_cfg, "simple_dut_env_cfg")

`endif // SIMPLE_DUT_ENV_CFG__SV
