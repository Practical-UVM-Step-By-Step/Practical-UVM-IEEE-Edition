module top;
  import uvm_pkg::*;
  import my_env_pkg::*;

  my_env topenv;


  logic unsigned [4095:0] my_int;
  string my_string;

  initial begin
    //set configuration prior to creating the environment
     uvm_config_db #(int)::set(null,"topenv.inst1.u1", "v", 30);
     uvm_config_db #(int)::set(null,"topenv.instB.u1", "v", 10);

     uvm_config_db #(int)::set(null,"/^(a){2}/", "s", 11); 

	// Set the value of V to 30 for tom05 to tom07
       uvm_config_db #(int)::set(null,"/topenv\.tom0[5-7*]\.u1/", "v", 30);
    topenv = new("topenv", null);

    run_test();

  end
endmodule
