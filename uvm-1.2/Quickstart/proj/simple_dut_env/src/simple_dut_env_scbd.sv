//
// Template for VMM-compliant Data Stream Scoreboard

`ifndef SIMPLE_DUT_ENV_SCBD__SV
`define SIMPLE_DUT_ENV_SCBD__SV

// ToDo: Add additional required `include directives
`include "vmm_sb.sv"
class simple_dut_env_scbd extends vmm_sb_ds;

   // Iterator class instance of type vmm_sb_ds_iter
   vmm_sb_ds_iter sb_iter;

   // DONE notification
   integer DONE;

   // Number of transaction count received by scoreboard
   int count = 0;

   // Constructor
   extern function new(string inst = "");
	extern virtual function bit compare(vmm_data actual,
                                       vmm_data expected);
   extern virtual function bit transform(input  vmm_data in_pkt,
                                         output vmm_data out_pkts[]);

endclass: simple_dut_env_scbd


function simple_dut_env_scbd::new(string inst = "");

   // Call the vmm_sb_ds base class
   super.new(inst);

   sb_iter  = this.new_sb_iter(0,0);

   // Configure DONE notification to be ON/OFF
   DONE = notify.configure(-1, vmm_notify::ON_OFF);

endfunction: new

function bit simple_dut_env_scbd::compare(vmm_data actual,vmm_data expected);
   bit status;
   status = super.compare(actual,expected);
   //This scoreboard performs the basic comparison using the wb_simple_trans.compare, however user can add
   //further logic here if required and update the status flag accordingly.   
   return(status);
endfunction: compare 

function bit simple_dut_env_scbd::transform(input  vmm_data in_pkt,
                           output vmm_data out_pkts[]);
   // ToDo: Declare transaction instance and form out_pkts
   
   // Code for reference(assuming pkt_t as transaction descriptor)
   // pkt_t p, q;
   // $cast(p, in_pkt);
   out_pkts = new [1];
   out_pkts[0] = in_pkt;

endfunction: transform

`endif // SIMPLE_DUT_ENV_SCBD__SV
