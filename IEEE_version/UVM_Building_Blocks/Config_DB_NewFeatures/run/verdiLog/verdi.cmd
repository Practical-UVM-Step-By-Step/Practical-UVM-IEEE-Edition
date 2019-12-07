simSetSimulator "-vcssv" -exec "./simv" -args "+UVM_TESTNAME=wb_env_slave_test" \
           -uvmDebug on -simDelim
debImport "-i" "-simflow" "-dbdir" "./simv.daidir"
srcTBInvokeSim
uvmCreateRsrcWin
uvmRsrcWinAccessHistoryOn
uvmRsrcWinQuickFilterOn
srcTBRunSim
uvmRsrcWinClick -row 0
uvmRsrcWinExportSetGetCalls -file \
           /SCRATCH/srivats/vs/IEEE_Book/Practical-UVM-IEEE-Edition/UVM_Building_Blocks/Config_DB_NewFeatures/run/s
uvmCloseRsrcWin
debExit
