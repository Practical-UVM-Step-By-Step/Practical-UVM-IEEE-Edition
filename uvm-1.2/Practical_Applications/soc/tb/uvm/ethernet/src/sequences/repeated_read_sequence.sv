class repeated_read_sequence extends base_sequence;
   `uvm_object_utils(repeated_read_sequence)


   function new(string name="my_repeated_read_sequence");
      super.new(name);
   endfunction

   virtual task body();
      `uvm_do_with(req, {address == 0; kind == wb_transaction::READ; } )
      `uvm_do_with(req, {address == 1; kind == wb_transaction::READ; } )
      `uvm_do_with(req, {address == 2; kind == wb_transaction::READ; } )
      `uvm_do_with(req, {address == 3; kind == wb_transaction::READ; } )
   endtask

endclass
