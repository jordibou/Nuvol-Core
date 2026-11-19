module regfile_sva (
    input   logic           clk_i,
    input   logic [4:0]     raddr_a_i,
    input   logic [4:0]     raddr_b_i,
    input   logic [4:0]     waddr_i,
    input   logic [31:0]    wdata_i,
    input   logic           wen_i,
    input   logic [31:0]    rdata_a_o,
    input   logic [31:0]    rdata_b_o,

    input   logic [31:0]    regs_q [1:31] 

);

    import uvm_pkg::*;
    `include "uvm_macros.svh"


    default clocking 
        cb @(posedge clk_i);
    endclocking


// -----------------------------------------------------------------------------------
// Assertions
// -----------------------------------------------------------------------------------
    // TP-RF-02: 
    a_x0_a: assert property (raddr_a_i == 0 |-> rdata_a_o ==0) 
        else `uvm_error("SVA", "Port A read x0 !=0");
    a_x0_b: assert property (raddr_b_i == 0 |-> rdata_b_o ==0) 
        else `uvm_error("SVA", "Port B read x0 !=0");
    
    // TP-RF-05: 
    a_rd_a: assert property (raddr_a_i !=0 |-> rdata_a_o === regs_q[raddr_a_i])  
        else `uvm_error("SVA", "Port A mismatch");
    a_rd_b: assert property (raddr_b_i !=0 |-> rdata_b_o === regs_q[raddr_b_i])  
        else `uvm_error("SVA", "Port B mismatch");
    
    // TP-RF-01/04: 
    a_wr: assert property (wen_i && waddr_i != 0 |=> regs_q[$past(waddr_i)] == $past(wdata_i))
        else `uvm_error("SVA", "Write did not land");

    
    // TP-RF-03/07: 
    genvar i;
    for (i = 1; i < 32 ; i++) begin : g_stable
        a_stable: assert property (!(wen_i && waddr_i == i) |=> $stable(regs_q[i]))
            else `uvm_error("SVA", "xn changed without a write");
    end

endmodule