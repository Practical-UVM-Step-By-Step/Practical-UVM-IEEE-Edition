
These files are changed in this example compared to the example in the UVM_Quickstart

All other files have IDENTICAL Content.

tests/wb_env_apply_config_test
src/wb_master_no_config.sv



*************************************************************
STEPS TO COMPILE AND RUN EXAMPLE
*************************************************************

Note: 
  2) To use the UVM source other than VCS installation directory:
     Set environment variable VCS_UVM_HOME to the uvm-ieee installation directory

-EXAMPLE
  	|
       -README.md ( This file)
       |
       -hdl/        ---> includes top module and inclusion of all environment files.
       |
       | - wb_env_top.sv  -- Top level file that instantiates everything
       | - dut.v     -- Dummy DUT
       |
       -env/        ---> includes environment related files (environment, ralenv)
       |  
       | - wb_slave_agent.sv  -- top level slave agent file
       | - wb_master_agent.sv -- top level master agent file
       | - wb_env_env.sv      -- the complete environment
       |
       -include/
       |
       -src/        ---> includes Transaction, configurations, driver, monitor, master/slave subenv, scoreboard, coverage related files.
       |  
       | - wb_slave.sv     --- Slave drive 
       | - wb_slave_mon.sv  -- Slave monitor
       | - wb_slave_if.sv   -- slave interface. 
       | - wb_transaction.sv  -- transaction class
       | - wb_slave_seqr.sv   -- Slave Sequencer. This is not used in this example
       | - wb_master.sv     -- master driver
       | - wb_master_seqr.sv  -- master sequencer
       | - wb_master_agent_sequence_library.sv -- All the sequences for the master are HERE
       | - wb_slave_agent_sequence_library.sv -- All the sequences for the slave are HERE
       | - wb_master_if.sv  -- master interface
       | - wb_master_mon.sv  -- master monitor
       | - wb_env_cov.sv   -- coverage
       | - wb_env_cfg.sv   -- env config class as an example. Not used much in the example
       |
       -tests/      ---> includes testbench module and testcases 
       |
       | - wb_env_tb_mod.sv 
       | - wb_env_slave_test.sv -- the actual test for the slave reactive agent
       |
       -run/        ---> Makefile
	| - Makefile   
	| - simv.log -- run log file
	| - vcs.log  -- compile log file





