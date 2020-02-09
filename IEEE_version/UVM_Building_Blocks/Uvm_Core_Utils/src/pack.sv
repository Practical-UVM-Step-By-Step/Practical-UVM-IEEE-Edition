module top;
    import uvm_pkg::*;
    `include "class.sv"

    bit 	   pack_bytes[];
    class_P  class_P_inst1;
    class_P  class_P_inst2;
    initial begin
        // Create and print children 

        class_P_inst1 = new("first_inst");
        class_P_inst1.randomize();
        class_P_inst1.print();
        // Pack object
        class_P_inst1.pack(pack_bytes);

        class_P_inst2 = new("second_inst");
        //      class_P_inst2.randomize();
        class_P_inst2.print();

        // Unpack object
        class_P_inst2.unpack(pack_bytes);
        class_P_inst2.print();

    end
endmodule


