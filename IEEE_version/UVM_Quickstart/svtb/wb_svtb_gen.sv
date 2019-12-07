`ifndef SVTB_GEN 
 `define SVTB_GEN

typedef class wb_svtb_config;
   typedef class wb_svtb_transaction;

class generator;

   mailbox gen2drv;

   rand wb_svtb_transaction trans;
   event   ended;
   wb_svtb_config config;

   function new(mailbox gen2driv, wb_svtb_config cfg);
      this.gen2driv = gen2driv;
      config = cfg;
endfunction

   task run();
      repeat(config.num_trans) begin
	 trans = new();
	 if( !trans.randomize() ) $fatal("Gen:: trans randomization failed");
	 gen2driv.put(trans);
      end
   -> ended;
endtask

endclass


endclass

`endif
   `
