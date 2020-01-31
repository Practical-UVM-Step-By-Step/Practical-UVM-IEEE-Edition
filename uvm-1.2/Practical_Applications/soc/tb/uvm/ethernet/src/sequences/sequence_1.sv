class sequence_1 extends base_sequence;
   byte sa;
   `uvm_object_utils(sequence_1)
   
   function new(string name = "seq_1");
      super.new(name);
   endfunction:new
   virtual task body();

      `uvm_do_with(req, {address == 3; kind == wb_transaction::READ ;} )
      `uvm_do_with(req, {address == 4; kind == wb_transaction::READ;} )
      `uvm_do_with(req, {address == 5; kind == wb_transaction::READ;} ) 
   endtask
endclass

