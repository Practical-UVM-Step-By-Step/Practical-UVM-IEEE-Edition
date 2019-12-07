class write_master_single extends base_sequence;
   bit [31:0] write_data;
   bit [31:0] write_address;
   `uvm_object_utils(write_master_single)

   function new(string name = "seq_1");
      super.new(name);
   endfunction:new
   virtual    task body();
      `uvm_do_with(req, {address == write_address; kind == wb_transaction::WRITE; data == write_data;} )
   endtask
endclass
