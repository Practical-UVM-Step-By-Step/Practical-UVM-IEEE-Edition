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

`ifndef WB_CONMAX_ENV_CFG__SV
    `define WB_CONMAX_ENV_CFG__SV

    class wb_conmax_env_cfg extends uvm_object; 

        // Define test configuration parameters (e.g. how long to run)
        rand int num_trans;
        rand int num_scen;
        // ToDo: Add other environment configuration varaibles

        constraint cst_num_trans_default {
            num_trans inside {[1:7]};
        }
        constraint cst_num_scen_default {
            num_scen inside {[1:2]};
        }
        // ToDo: Add constraint blocks to prevent error injection
        function new(string name = "wb_env_config");
            super.new(name);
        endfunction

        `uvm_object_utils_begin(wb_conmax_env_cfg)
        `uvm_field_int(num_trans,UVM_DEFAULT) 
        `uvm_field_int(num_scen,UVM_DEFAULT)
        `uvm_object_utils_end

   
    endclass: wb_conmax_env_cfg

`endif // WB_CONMAX_ENV_CFG__SV


class wb_master_seqr_sequence_library extends uvm_sequence_library # (wb_transaction);  
    `uvm_sequence_library_utils(wb_master_seqr_sequence_library)


    function new(string name = "simple_seq_lib");
        super.new(name); 
        init_sequence_library();
    endfunction

endclass  

class sequence_1 extends base_sequence;
    byte sa;
  
    `uvm_object_utils(sequence_1)
  
    `uvm_add_to_seq_lib(sequence_1, wb_master_seqr_sequence_library)
    function new(string name = "seq_1");
        super.new(name);
    endfunction:new
    virtual task body();

        `uvm_do(req, get_sequencer(), -1, {address == 3; kind == wb_transaction::WRITE; data == 63'hdeadbeef;})
        `uvm_do(req, get_sequencer(), -1, {address == 4; kind == wb_transaction::WRITE; data == 63'hbeefdead;})
        `uvm_do(req, get_sequencer(), -1, {address == 5; kind == wb_transaction::WRITE; data == 63'h23456678;})


        `uvm_do(req, get_sequencer(), -1, {address == 3; kind == wb_transaction::READ ;})
        `uvm_do(req, get_sequencer(), -1, {address == 4; kind == wb_transaction::READ;})
        `uvm_do(req, get_sequencer(), -1, {address == 5; kind == wb_transaction::READ;})
   
    endtask
endclass
