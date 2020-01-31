`ifndef SVTB_GEN 
 `define SVTB_GEN

typedef class wb_svtb_config;
   typedef class wb_svtb_transaction;

class wb_svtb_generator;

   mailbox gen2drv;

   rand wb_svtb_transaction trans;
   event   gen_ended;
   wb_svtb_config cfg;

   function new(mailbox gen2driv, wb_svtb_config cfg);
      this.gen2drv = gen2driv;
      cfg = cfg;
   endfunction

   task run();
      repeat(cfg.num_trans) begin
	 trans = new();
	 if( !trans.randomize() ) $fatal("Gen:: trans randomization failed");
	 gen2drv.put(trans);
      end
      -> gen_ended;
   endtask


endclass

`endif
