/***********************************************
 *                                              *
 * Examples for the book Practical UVM          *
 *                                              *
 * Copyright Srivatsa Vasudevan 2010-2016       *
 * All rights reserved                          *
 *                                              *
 * Permission is granted to use this work       * 
 * provided this notice and attached license.txt*
 * are not removed/altered while redistributing *
 * See license.txt for details                  *
 *                                              *
 ************************************************/

class wb_svtb_config ;

   bit enable_coverage;  // Enable coverage from monitor
   int num_trans = 10;

   typedef enum {BYTE, WORD, DWORD, QWORD} sizes_e;
   rand sizes_e port_size;
   rand sizes_e granularity;

   typedef enum {CLASSIC, REGISTERED} cycle_types_e;
   rand cycle_types_e cycles;

   rand integer max_n_wss;
   integer 	master_id;
   integer 	slave_id;

   rand bit [31:0] min_addr;
   rand bit [31:0] max_addr;

   constraint wb_slave_cfg_valid {
      max_addr >= min_addr;

   }

   constraint wb_cfg_valid {
      granularity <= port_size;
      max_n_wss >= 0;
   }

   constraint reasonable_max_n_wss {
      max_n_wss  < 16;
   }

   constraint supported {
      port_size   == DWORD;
      granularity == BYTE; 
      cycles      == CLASSIC;
   }
   function new(string name = "");
   endfunction

endclass

