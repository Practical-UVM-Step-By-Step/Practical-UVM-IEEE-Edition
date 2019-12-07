class read_master_single extends base_sequence;
   bit [31:0] read_data;
   bit [31:0] read_address;
   `uvm_object_utils(read_master_single)
   
   function new(string name = "seq_1");
      super.new(name);
   endfunction:new
   virtual    task body();
      `uvm_do_with(req, {address == read_address; kind == wb_transaction::READ; } )
   endtask
endclass
