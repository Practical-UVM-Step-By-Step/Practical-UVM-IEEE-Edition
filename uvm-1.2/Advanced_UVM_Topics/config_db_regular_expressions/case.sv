module top;
   import uvm_pkg::*;
   import my_env_pkg::*;

   my_env topenv;


   logic unsigned [4095:0] my_int;
   string 		   my_string;

   initial begin
      //set configuration prior to creating the environment
      uvm_config_db #(int)::set(null,"topenv.inst1.u1", "v", 30);
      uvm_config_db #(int)::set(null,"topenv.instB.u1", "v", 10);

      uvm_config_db #(int)::set(null,"/a{2,3}b.u1/", "s", 11); 
      uvm_config_db #(int)::set(null,"/a{2,}b.u1/", "v", 15); 

      uvm_config_db #(int)::set(null,"/topenv\.t(omm){3}[1*].\.u1/", "s", 42);
      uvm_config_db #(int)::set(null,"/topenv\.to(m){3,}\.u1/", "v", 22);
      uvm_config_db #(int)::set(null,"/topenv\.to(m){2,}\.u1/", "v", 32);
      uvm_config_db #(int)::set(null,"/topenv\.TOMMmm.*\.u1/", "v", 80); 
      topenv = new("topenv", null);

      run_test();

   end

endmodule
