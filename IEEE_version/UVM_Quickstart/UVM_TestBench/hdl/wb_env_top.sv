`ifndef WB_ENV_TOP__SV
	`define WB_ENV_TOP__SV

	module wb_env_top_mod();

		logic clk;

		// Clock Generation
		parameter sim_cycle = 10;
   
		// Reset Delay Parameter
		parameter rst_delay = 5;
		initial begin 
			clk  = 0;
			forever clk = #(sim_cycle/2) ~clk;
		end 

		wb_master_if mast_if(clk);
		wb_slave_if slave_if(clk);

		wb_env_tb_mod test(); 

		dut dut(mast_if,slave_if);

	endmodule: wb_env_top_mod

`endif // WB_ENV_TOP__SV
