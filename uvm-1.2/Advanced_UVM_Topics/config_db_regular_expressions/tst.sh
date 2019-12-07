#!/bin/sh
for file in `cat list`
do
	echo "		vcs -sverilog -ntb_opts uvm-ieee my_env_pkg.sv ${file}.sv -q -l ${file}.log -R"
done
