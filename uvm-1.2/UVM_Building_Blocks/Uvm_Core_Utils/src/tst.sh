#!/bin/sh
for file in `cat a`
do
	echo "vcs -sverilog -ntb_opts uvm-ieee ../src/${file} +incdir+../src -q -R -l ${file}.log"
done
