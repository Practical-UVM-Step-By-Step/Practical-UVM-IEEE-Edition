# Practical-UVM-IEEE-Edition ISBN 978-0-9977896-1-4
This is the repository for the IEEE version of the book

├── IEEE_BOOK_TOC.pdf      This contains  the Table of Contents for the Book!
├── changes.pdf		   This lists the changes from the first version to this version
├── cleanup		   Cleanup Script
├── Listing_Pointers       Links to Actual listings  used in the book
├── README.md		   This file
├── IEEE_version	   This directory contains the IEEE Version examples
│   ├── Advanced_UVM_Topics
│   │   ├── Advanced_Stimulus_Generation
│   │   │   ├── env
│   │   │   ├── hdl
│   │   │   ├── include
│   │   │   ├── run
│   │   │   ├── src
│   │   │   │   └── sequences
│   │   │   └── tests
│   │   ├── config_db_regular_expressions
│   │   │   ├── run
│   │   │   └── src
│   │   ├── phase_callbacks
│   │   │   ├── env
│   │   │   ├── hdl
│   │   │   ├── include
│   │   │   ├── run
│   │   │   ├── src
│   │   │   └── tests
│   │   ├── registers_example
│   │   │   ├── env
│   │   │   ├── hdl
│   │   │   ├── include
│   │   │   ├── run
│   │   │   ├── src
│   │   │   └── tests
│   │   └── uvm_reactive_seq_slave
│   │       ├── env
│   │       ├── hdl
│   │       ├── include
│   │       ├── run
│   │       ├── src
│   │       └── tests
│   ├── Extra_Examples
│   │   ├── Factory
│   │   └── Reporting
│   ├── Practical_Applications
│   │   ├── ethernet -> soc/tb/uvm/ethernet
│   │   ├── soc
│   │   │   ├── docs
│   │   │   │   ├── common
│   │   │   │   ├── ethernet
│   │   │   │   │   └── src
│   │   │   │   ├── fpu
│   │   │   │   ├── gpio
│   │   │   │   │   └── src
│   │   │   │   ├── or1k
│   │   │   │   ├── smii
│   │   │   │   ├── spi_ctrl
│   │   │   │   ├── uart16550
│   │   │   │   ├── usb
│   │   │   │   ├── vga_lcd
│   │   │   │   └── wb_conmax
│   │   │   ├── rtl
│   │   │   │   ├── cfi_ctrl
│   │   │   │   ├── clkgen
│   │   │   │   ├── dbg_if
│   │   │   │   ├── debug_if
│   │   │   │   ├── ethernet
│   │   │   │   ├── ethmac
│   │   │   │   ├── gpio
│   │   │   │   ├── i2c_master_slave
│   │   │   │   ├── include
│   │   │   │   ├── jtag
│   │   │   │   ├── jtag_tap
│   │   │   │   ├── or1200
│   │   │   │   ├── or1k_startup
│   │   │   │   ├── or1k_top
│   │   │   │   ├── ram_wb
│   │   │   │   ├── rom
│   │   │   │   ├── simple_spi
│   │   │   │   ├── smii
│   │   │   │   ├── spi_ctrl
│   │   │   │   ├── tap
│   │   │   │   ├── top
│   │   │   │   ├── uart16550
│   │   │   │   ├── usb
│   │   │   │   ├── usbhostslave
│   │   │   │   ├── vga_lcd
│   │   │   │   ├── wb_conbus
│   │   │   │   ├── wb_conmax
│   │   │   │   └── wb_sdram_ctrl
│   │   │   └── tb
│   │   │       ├── uvm
│   │   │       │   ├── common
│   │   │       │   │   └── unused
│   │   │       │   ├── ethernet
│   │   │       │   │   ├── env
│   │   │       │   │   ├── hdl
│   │   │       │   │   ├── include
│   │   │       │   │   ├── log
│   │   │       │   │   ├── run
│   │   │       │   │   ├── src
│   │   │       │   │   │   ├── layering
│   │   │       │   │   │   └── sequences
│   │   │       │   │   └── tests
│   │   │       │   ├── spi_ctrl
│   │   │       │   │   ├── env
│   │   │       │   │   ├── hdl
│   │   │       │   │   ├── include
│   │   │       │   │   ├── run
│   │   │       │   │   ├── src
│   │   │       │   │   └── tests
│   │   │       │   ├── vga_lcd
│   │   │       │   │   ├── env
│   │   │       │   │   ├── hdl
│   │   │       │   │   ├── include
│   │   │       │   │   ├── run
│   │   │       │   │   ├── src
│   │   │       │   │   │   ├── bad
│   │   │       │   │   │   └── old
│   │   │       │   │   └── tests
│   │   │       │   └── wb_conmax
│   │   │       │       ├── env
│   │   │       │       ├── hdl
│   │   │       │       ├── include
│   │   │       │       ├── run
│   │   │       │       ├── src
│   │   │       │       └── tests
│   │   │       └── verilog_tb
│   │   │           ├── common
│   │   │           ├── ethernet
│   │   │           ├── exampleSOC
│   │   │           │   ├── include
│   │   │           │   ├── usbhostslave
│   │   │           │   └── vpi
│   │   │           │       ├── c
│   │   │           │       └── verilog
│   │   │           ├── gpio
│   │   │           ├── log
│   │   │           ├── spi_ctrl
│   │   │           ├── top
│   │   │           │   ├── include
│   │   │           │   ├── usbhostslave
│   │   │           │   └── vpi
│   │   │           │       ├── c
│   │   │           │       └── verilog
│   │   │           ├── uart16550
│   │   │           │   └── test_cases
│   │   │           ├── usb
│   │   │           ├── vga_lcd
│   │   │           ├── vpi
│   │   │           │   ├── c
│   │   │           │   └── verilog
│   │   │           └── wb_conmax
│   │   ├── vga_lcd -> soc/tb/uvm/vga_lcd
│   │   └── wb_conmax -> soc/tb/uvm/wb_conmax
│   ├── UVM_Building_Blocks
│   │   ├── automatic_config
│   │   │   ├── env
│   │   │   ├── hdl
│   │   │   ├── include
│   │   │   ├── run
│   │   │   ├── src
│   │   │   │   └── sequences
│   │   │   └── tests
│   │   ├── Config_DB_NewFeatures
│   │   │   ├── env
│   │   │   ├── hdl
│   │   │   ├── include
│   │   │   ├── run
│   │   │   │   └── verdiLog
│   │   │   ├── src
│   │   │   │   └── sequences
│   │   │   └── tests
│   │   ├── Factory_NewFeatures
│   │   │   ├── env
│   │   │   ├── hdl
│   │   │   ├── include
│   │   │   ├── run
│   │   │   ├── src
│   │   │   │   └── sequences
│   │   │   └── tests
│   │   ├── generic
│   │   │   ├── env
│   │   │   ├── hdl
│   │   │   ├── include
│   │   │   ├── run
│   │   │   ├── src
│   │   │   │   └── sequences
│   │   │   └── tests
│   │   ├── parameterized_class_factory
│   │   │   └── src
│   │   ├── phase_callbacks
│   │   │   ├── env
│   │   │   ├── hdl
│   │   │   ├── include
│   │   │   ├── run
│   │   │   ├── src
│   │   │   │   └── sequences
│   │   │   └── tests
│   │   ├── push_driver_example
│   │   │   ├── env
│   │   │   ├── hdl
│   │   │   ├── include
│   │   │   ├── run
│   │   │   ├── src
│   │   │   └── tests
│   │   ├── RunTestCallbacks
│   │   │   ├── env
│   │   │   ├── hdl
│   │   │   ├── include
│   │   │   ├── run
│   │   │   ├── src
│   │   │   │   └── sequences
│   │   │   └── tests
│   │   ├── spanning_phases
│   │   │   ├── env
│   │   │   ├── hdl
│   │   │   ├── include
│   │   │   ├── run
│   │   │   ├── src
│   │   │   └── tests
│   │   └── Uvm_Core_Utils
│   │       ├── run
│   │       └── src
│   ├── UVM_Quickstart
│   │   ├── Generating_Stimulus
│   │   │   ├── env
│   │   │   ├── hdl
│   │   │   ├── include
│   │   │   ├── run
│   │   │   ├── src
│   │   │   │   └── sequences
│   │   │   └── tests
│   │   ├── svtb
│   │   │   ├── run
│   │   │   └── src
│   │   └── UVM_TestBench
│   │       ├── env
│   │       ├── hdl
│   │       ├── include
│   │       ├── run
│   │       ├── src
│   │       │   └── sequences
│   │       └── tests
│   └── Web_Chapters
│       └── CoverageClosure_non_UVM
│           ├── bench
│           │   ├── common
│           │   ├── verilog
│           │   └── wb_dma_uvm
│           │       ├── env
│           │       ├── hdl
│           │       ├── include
│           │       ├── src
│           │       └── tests
│           ├── doc
│           ├── rtl
│           │   └── verilog
│           └── sim
│               └── cov
├── Listing_Pointers
├── sve
└── uvm-1.2
    ├── Advanced_UVM_Topics
    │   ├── config_db_regular_expressions
    │   │   ├── run
    │   │   └── src
    │   ├── phase_callbacks
    │   │   ├── env
    │   │   ├── hdl
    │   │   ├── include
    │   │   ├── run
    │   │   ├── src
    │   │   └── tests
    │   ├── registers_example
    │   │   ├── env
    │   │   ├── hdl
    │   │   ├── include
    │   │   ├── run
    │   │   ├── src
    │   │   └── tests
    │   ├── spanning_phases
    │   │   ├── env
    │   │   ├── hdl
    │   │   ├── include
    │   │   ├── run
    │   │   ├── src
    │   │   └── tests
    │   └── uvm_reactive_seq_slave
    │       ├── env
    │       ├── hdl
    │       ├── include
    │       ├── run
    │       ├── src
    │       └── tests
    ├── Extra_Examples
    │   ├── Factory
    │   └── Reporting
    ├── Practical_Applications
    │   └── soc
    │       ├── docs
    │       │   ├── common
    │       │   ├── ethernet
    │       │   │   └── src
    │       │   ├── fpu
    │       │   ├── gpio
    │       │   │   └── src
    │       │   ├── or1k
    │       │   ├── smii
    │       │   ├── spi_ctrl
    │       │   ├── uart16550
    │       │   ├── usb
    │       │   ├── vga_lcd
    │       │   └── wb_conmax
    │       ├── rtl
    │       │   ├── cfi_ctrl
    │       │   ├── clkgen
    │       │   ├── dbg_if
    │       │   ├── debug_if
    │       │   ├── ethernet
    │       │   ├── ethmac
    │       │   ├── gpio
    │       │   ├── i2c_master_slave
    │       │   ├── include
    │       │   ├── jtag
    │       │   ├── jtag_tap
    │       │   ├── or1200
    │       │   ├── or1k_startup
    │       │   ├── or1k_top
    │       │   ├── ram_wb
    │       │   ├── rom
    │       │   ├── simple_spi
    │       │   ├── smii
    │       │   ├── spi_ctrl
    │       │   ├── tap
    │       │   ├── top
    │       │   ├── uart16550
    │       │   ├── usb
    │       │   ├── usbhostslave
    │       │   ├── vga_lcd
    │       │   ├── wb_conbus
    │       │   ├── wb_conmax
    │       │   └── wb_sdram_ctrl
    │       └── tb
    │           ├── uvm
    │           │   ├── common
    │           │   │   └── unused
    │           │   ├── ethernet
    │           │   │   ├── env
    │           │   │   ├── hdl
    │           │   │   ├── include
    │           │   │   ├── log
    │           │   │   ├── run
    │           │   │   ├── src
    │           │   │   │   ├── layering
    │           │   │   │   └── sequences
    │           │   │   └── tests
    │           │   ├── spi_ctrl
    │           │   │   ├── env
    │           │   │   ├── hdl
    │           │   │   ├── include
    │           │   │   ├── run
    │           │   │   ├── src
    │           │   │   └── tests
    │           │   ├── vga_lcd
    │           │   │   ├── env
    │           │   │   ├── hdl
    │           │   │   ├── include
    │           │   │   ├── run
    │           │   │   │   └── tests
    │           │   │   ├── src
    │           │   │   └── tests
    │           │   └── wb_conmax
    │           │       ├── env
    │           │       ├── hdl
    │           │       ├── include
    │           │       ├── run
    │           │       ├── src
    │           │       └── tests
    │           └── verilog_tb
    │               ├── common
    │               ├── ethernet
    │               ├── exampleSOC
    │               │   ├── include
    │               │   ├── usbhostslave
    │               │   └── vpi
    │               │       ├── c
    │               │       └── verilog
    │               ├── gpio
    │               ├── log
    │               ├── spi_ctrl
    │               ├── top
    │               │   ├── include
    │               │   ├── usbhostslave
    │               │   └── vpi
    │               │       ├── c
    │               │       └── verilog
    │               ├── uart16550
    │               │   └── test_cases
    │               ├── usb
    │               ├── vga_lcd
    │               ├── vpi
    │               │   ├── c
    │               │   └── verilog
    │               └── wb_conmax
    ├── Quickstart
    │   ├── proj
    │   │   └── simple_dut_env
    │   │       ├── env
    │   │       ├── hdl
    │   │       ├── include
    │   │       ├── run
    │   │       ├── src
    │   │       └── tests
    │   ├── rtl
    │   ├── svtb
    │   │   └── new
    │   └── verilog
    ├── UVM_Building_Blocks
    │   ├── generic
    │   │   ├── env
    │   │   ├── hdl
    │   │   ├── include
    │   │   ├── run
    │   │   ├── src
    │   │   └── tests
    │   ├── parameterized_class_factory
    │   ├── phase_callbacks
    │   │   ├── env
    │   │   ├── hdl
    │   │   ├── include
    │   │   ├── run
    │   │   ├── src
    │   │   └── tests
    │   ├── spanning_phases
    │   │   ├── env
    │   │   ├── hdl
    │   │   ├── include
    │   │   ├── run
    │   │   ├── src
    │   │   └── tests
    │   ├── uvm_core_utilities
    │   │   ├── run
    │   │   └── src
    │   └── Uvm_Core_Utils
    │       ├── run
    │       └── src
    ├── UVM_Quickstart
    │   ├── Generating_Stimulus
    │   │   ├── env
    │   │   ├── hdl
    │   │   ├── include
    │   │   ├── run
    │   │   ├── src
    │   │   └── tests
    │   ├── svtb
    │   └── UVM_TestBench
    │       ├── env
    │       ├── hdl
    │       ├── include
    │       ├── run
    │       ├── src
    │       └── tests
    └── Web_Chapters
        └── CoverageClosure_non_UVM
            ├── bench
            │   ├── common
            │   ├── verilog
            │   └── wb_dma_uvm
            │       ├── env
            │       ├── hdl
            │       ├── include
            │       ├── src
            │       └── tests
            ├── rtl
            │   └── verilog
            └── sim
