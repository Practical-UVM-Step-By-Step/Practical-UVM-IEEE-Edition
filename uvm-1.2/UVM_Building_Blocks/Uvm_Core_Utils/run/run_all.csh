vcs -sverilog -ntb_opts uvm-1.2 ../src/compare_new.sv +incdir+../src  -R -l compare_new.log
vcs -sverilog -ntb_opts uvm-1.2 ../src/compare_policy_methods.sv +incdir+../src  -R -l compare_policy_methods.log
vcs -sverilog -ntb_opts uvm-1.2 ../src/compare_simple.sv +incdir+../src  -R -l compare_simple.log
vcs -sverilog -ntb_opts uvm-1.2 ../src/compare.sv +incdir+../src  -R -l compare.log
vcs -sverilog -ntb_opts uvm-1.2 ../src/copy_ex.sv +incdir+../src  -R -l copy_ex.log
vcs -sverilog -ntb_opts uvm-1.2 ../src/copy.sv +incdir+../src  -R -l copy.log
vcs -sverilog -ntb_opts uvm-1.2 ../src/do_print_example2.sv +incdir+../src  -R -l do_print_example2.log -q
vcs -sverilog -ntb_opts uvm-1.2 ../src/do_print_example.sv +incdir+../src  -R -l do_print_example.log
vcs -sverilog -ntb_opts uvm-1.2 ../src/pack_example.sv +incdir+../src  -R -l pack_example.log
vcs -sverilog -ntb_opts uvm-1.2 ../src/pack.sv +incdir+../src  -R -l pack.log
vcs -sverilog -ntb_opts uvm-1.2 ../src/print_do_methods.sv +incdir+../src  -R -l print_do_methods.log
vcs -sverilog -ntb_opts uvm-1.2 ../src/print.sv +incdir+../src  -R -l print.log
rm -rf csrc simv simv.daidir vc_hdrs.h ucli.key
