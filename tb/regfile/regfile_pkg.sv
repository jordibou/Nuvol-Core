package regfile_pkg;
    import uvm_package;
    `include "uvm_macros.svh"
    `include "regfile_seq_item.sv"
    `include "regfile_sequences.sv"
    typedef uvm_sequencer #(regfile_seq_item) regfile_sequencer;
    `include "regfile_driver.sv"
    `include "regfile_monitor.sv"
    `include "regfile_agent.sv"
    `include "regfile_scoreboard.sv"
    `include "regfile_coverage.sv"
    `include "regfile_env.sv"
    `include "regfile_tests.sv"

endpackage