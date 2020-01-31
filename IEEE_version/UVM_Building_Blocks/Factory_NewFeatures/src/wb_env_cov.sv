`ifndef WB_ENV_COV__SV
 `define WB_ENV_COV__SV
virtual class wb_cov_base extends uvm_component;
   `uvm_component_abstract_utils(wb_cov_base) 

   uvm_analysis_imp #(wb_transaction, wb_cov_base) analysis_export;
   wb_transaction tr;
   event cov_event;
   function new(string name="wb_cov_base",uvm_component parent);
      super.new(name,parent);
   endfunction

   virtual function write(wb_transaction tr);
      this.tr = tr;
      -> cov_event;
   endfunction: write

endclass

class wb_env_cov extends wb_cov_base;
   `uvm_component_utils(wb_env_cov)
   
   covergroup cg_trans @(cov_event);
      coverpoint tr.kind;
      coverpoint tr.address {
	 bins low = {[0:10]};
	 bins mid = {[10:100]};
	 bins high = {[100:$]};
      }
      coverpoint tr.lock ;
      coverpoint tr.status;
      coverpoint tr.num_wait_states {
	 bins legal[] = {[0:15]};
	 illegal_bins ib = {[16:$]};
      }
      
   endgroup: cg_trans


   function new(string name, uvm_component parent);
      super.new(name,parent);
      cg_trans = new;
      analysis_export = new("Coverage Analysis",this);
   endfunction: new

endclass: wb_env_cov

`endif // WB_ENV_COV__SV

