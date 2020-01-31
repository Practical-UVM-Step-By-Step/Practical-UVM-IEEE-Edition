## 
## -------------------------------------------------------------
##    Copyright 2004-2009 Synopsys, Inc.
##    All Rights Reserved Worldwide
## 
##    Licensed under the Apache License, Version 2.0 (the
##    "License"); you may not use this file except in
##    compliance with the License.  You may obtain a copy of
##    the License at
## 
##        http://www.apache.org/licenses/LICENSE-2.0
## 
##    Unless required by applicable law or agreed to in
##    writing, software distributed under the License is
##    distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
##    CONDITIONS OF ANY KIND, either express or implied.  See
##    the License for the specific language governing
##    permissions and limitations under the License.
## -------------------------------------------------------------
##



all: clean comp run1 run2 run3 run4 run5 

clean:
	rm -rf simv* csrc *.log vc_hdrs.h ucli.key

run_examples:
		vcs -sverilog -ntb_opts uvm-ieee my_env_pkg.sv abc_alternate_def.sv -q -l abc_alternate_def.log -R
		vcs -sverilog -ntb_opts uvm-ieee my_env_pkg.sv a_beginning.sv -q -l a_beginning.log -R
		vcs -sverilog -ntb_opts uvm-ieee my_env_pkg.sv anchor.sv -q -l anchor.log -R
		vcs -sverilog -ntb_opts uvm-ieee my_env_pkg.sv a_plus_b.sv -q -l a_plus_b.log -R
		vcs -sverilog -ntb_opts uvm-ieee my_env_pkg.sv a_question_b_1.sv -q -l a_question_b_1.log -R
		vcs -sverilog -ntb_opts uvm-ieee my_env_pkg.sv a_repeat_b_2_unbound.sv -q -l a_repeat_b_2_unbound.log -R
		vcs -sverilog -ntb_opts uvm-ieee my_env_pkg.sv a_repeat_b.sv -q -l a_repeat_b.log -R
		vcs -sverilog -ntb_opts uvm-ieee my_env_pkg.sv repeat.sv -q -l repeat.log -R
		vcs -sverilog -ntb_opts uvm-ieee my_env_pkg.sv star.sv -q -l star.log -R
