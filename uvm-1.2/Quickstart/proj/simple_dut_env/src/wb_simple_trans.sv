//
// Template for VMM-compliant transaction descriptor
//

`ifndef WB_SIMPLE_TRANS__SV
`define WB_SIMPLE_TRANS__SV

class wb_simple_trans extends vmm_data;

   // ToDo: Modify/add symbolic transaction identifiers to match
   typedef enum {READ, WRITE } kinds_e;
   rand kinds_e kind;

   // ToDo: Add relevant class properties to define all transactions

   // ToDo: Modify/add symbolic transaction identifiers to match
   typedef enum {IS_OK, ERROR} status_e;
   rand status_e status;

   constraint wb_simple_trans_valid {
      // ToDo: Define constraint to make descriptor valid
      status == IS_OK;
   }

   `vmm_data_member_begin(wb_simple_trans)
      `vmm_data_member_enum(kind, DO_ALL)
      `vmm_data_member_enum(status, DO_ALL)
      // ToDo: add properties using macros here

   `vmm_data_member_end(wb_simple_trans)


endclass: wb_simple_trans


`vmm_channel(wb_simple_trans)
`vmm_atomic_gen(wb_simple_trans, "wb_simple_trans")
`vmm_scenario_gen(wb_simple_trans, "wb_simple_trans")

`endif // WB_SIMPLE_TRANS__SV
