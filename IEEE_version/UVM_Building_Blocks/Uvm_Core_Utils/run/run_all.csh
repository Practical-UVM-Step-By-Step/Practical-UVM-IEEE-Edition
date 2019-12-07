vcs -sverilog -ntb_opts uvm-ieee ../src/compare_extension.sv +incdir+../src  -R -l compare_extension.log +UVM_TESTNAME=test
vcs -sverilog -ntb_opts uvm-ieee ../src/compare_new.sv +incdir+../src  -R -l compare_new.log
vcs -sverilog -ntb_opts uvm-ieee ../src/compare_policy_methods.sv +incdir+../src  -R -l compare_policy_methods.log
vcs -sverilog -ntb_opts uvm-ieee ../src/compare_simple.sv +incdir+../src  -R -l compare_simple.log
vcs -sverilog -ntb_opts uvm-ieee ../src/compare.sv +incdir+../src  -R -l compare.log
vcs -sverilog -ntb_opts uvm-ieee ../src/complete_class.sv +incdir+../src  -R -l complete_class.log
vcs -sverilog -ntb_opts uvm-ieee ../src/copy_ex.sv +incdir+../src  -R -l copy_ex.log
vcs -sverilog -ntb_opts uvm-ieee ../src/copy.sv +incdir+../src  -R -l copy.log
vcs -sverilog -ntb_opts uvm-ieee ../src/do_execute_op.sv +incdir+../src  -R -l do_execute_op.log
vcs -sverilog -ntb_opts uvm-ieee ../src/do_print_example2.sv +incdir+../src  -R -l do_print_example2.log -q
vcs -sverilog -ntb_opts uvm-ieee ../src/do_print_example.sv +incdir+../src  -R -l do_print_example.log
vcs -sverilog -ntb_opts uvm-ieee ../src/pack_example.sv +incdir+../src  -R -l pack_example.log
vcs -sverilog -ntb_opts uvm-ieee ../src/pack.sv +incdir+../src  -R -l pack.log
vcs -sverilog -ntb_opts uvm-ieee ../src/print_do_methods.sv +incdir+../src  -R -l print_do_methods.log
vcs -sverilog -ntb_opts uvm-ieee ../src/print.sv +incdir+../src  -R -l print.log
rm -rf csrc simv simv.daidir
