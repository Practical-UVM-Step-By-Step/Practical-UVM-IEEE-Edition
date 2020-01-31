`ifndef WB_TRANSACTION_GENERIC_COMPARER
 `define WB_TRANSACTION_GENERIC_COMPARER

class compare_generic_payload extends uvm_object;

   function bit compare_against_bus_item(wb_transaction wb_tran, uvm_tlm_generic_payload gp);
      byte unsigned data[];
      if(gp == null) begin
	 return 0;
      end
      compare_against_bus_item = (wb_tran.address == gp.m_address[31:0]);
      if(gp.is_read()) begin
	 compare_against_bus_item = compare_against_bus_item & (wb_tran.kind == wb_transaction::READ);
	 compare_against_bus_item = compare_against_bus_item & ((wb_tran.read_data.size())*4 == gp.get_data_length());
	 // Change this      data = convert_bus_item_data(wb_tran.read_data);
	 compare_against_bus_item = compare_against_bus_item & (data == gp.get_data());
      end
      else if(gp.is_write()) begin
	 compare_against_bus_item = compare_against_bus_item & (wb_tran.kind == wb_transaction::write);
	 compare_against_bus_item = compare_against_bus_item & ((wb_tran.write_data.size())*4 == gp.get_data_length());
	 // Change this      data = convert_bus_item_data(wb_tran.write_data);
	 compare_against_bus_item = compare_against_bus_item & (data == gp.get_data());
      end
      else begin
	 return 0;
      end
   endfunction



endclass


`endif
