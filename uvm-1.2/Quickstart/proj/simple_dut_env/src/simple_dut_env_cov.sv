//
// Template for VMM-compliant Coverage Class
//

`ifndef SIMPLE_DUT_ENV_COV__SV
 `define SIMPLE_DUT_ENV_COV__SV

class simple_dut_env_cov;
   event cov_event;
   wb_simple_trans tr;

   covergroup cg_trans @(cov_event);
      coverpoint tr.kind;
      // ToDo: Add required coverpoints, coverbins
   endgroup: cg_trans

   function new();
      cg_trans = new;
   endfunction: new

endclass: simple_dut_env_cov

`endif // SIMPLE_DUT_ENV_COV__SV
