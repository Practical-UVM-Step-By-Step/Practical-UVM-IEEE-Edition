module top;
   import uvm_pkg::*;
   import my_env_pkg::*;

   my_env topenv;



   initial begin
      // UVM_CONFIG_DB_EXPRESSION
      
      topenv = new("topenv", null);
      run_test();
   end

endmodule
