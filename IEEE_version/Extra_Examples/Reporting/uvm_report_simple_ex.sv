module top;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class test extends uvm_test;

        `uvm_component_utils(test)

        function new(string name, uvm_component parent = null);
            super.new(name, parent);
        endfunction

        virtual task run_phase(uvm_phase phase);
            phase.raise_objection(this);

            `uvm_info("INFO1", "first info message", UVM_LOW)
            uvm_report_info("INFO2", "second info message", UVM_LOW);

            `uvm_error("ERROR1", "first error message")
            // Note that verbosity below ignored
            uvm_report_error("ERROR2", "second error message",UVM_LOW);

            `uvm_warning("WARNING1", "first warning message")
            uvm_report_warning("WARNING2", "second warning message",UVM_LOW);

            // Only one of these two.  verbosity ignored + sim dies
            `uvm_fatal("FATAL1", "first fatal message")
            // uvm_report_fatal("FATAL2", "second warning message");

            phase.drop_objection(this);
        endtask
    endclass

    initial
        run_test();

endmodule
