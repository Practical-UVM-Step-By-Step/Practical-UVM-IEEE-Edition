`ifndef WB_SCOREBOARD__SV
 `define WB_SCOREBOARD__SV

class wb_svtb_scoreboard;

   function new(mailbox mast_mailbox, mailbox slave_mailbox, wb_svtb_config cfg);

   endfunction


   task run;

   endtask
endclass: wb_svtb_scoreboard

`endif // WB_SCOREBOARD__SV
