

interface regfile_if ( 
    input logic clk
);

// -----------------------------------------------------------------------------------
// Signals and registers
// -----------------------------------------------------------------------------------
    logic [4:0]     raddr_a;
    logic [4:0]     raddr_b;
    logic [4:0]     waddr;
    logic [31:0]    wdata;
    logic           wen;
    logic [31:0]    rdata_a;
    logic [31:0]    rdata_b;


// -----------------------------------------------------------------------------------
// Driver: drives inputs 1ns after the edge
// -----------------------------------------------------------------------------------
    clocking drv_cb @(posedge clk);
        default output #1;
        output raddr_a;
        output raddr_b;
        output waddr;
        output wdata;
        output wen;
    endclocking

// -----------------------------------------------------------------------------------
// Monitor: samples everything just before the edge
// -----------------------------------------------------------------------------------
    clocking mon_cb @(posedge clk);
        default input #1step;
        input raddr_a;
        input raddr_b;
        input waddr;
        input wdata;
        input wen;
        input rdata_a;
        input rdata_b;
    endclocking
    
endinterface