//====================================================================================
//  NUVOL CORE  |  32-bit RISC-V 
//------------------------------------------------------------------------------------
//  Module      : Nuvol Core Register File
//  File        : nuvol_regfile.sv
//  Author      : Jordi Bou Garcia
//  Created     : 2026-11-10
//------------------------------------------------------------------------------------
//  Description : This module takes reads from two 32-bit registers (combinational) 
//                and writes into another (sequential). It has no reset as RISCV does 
//                not require it, so the registers will hold undefined values until 
//                they are written. The x0 register is hardwired to zero
//                and cannot be written.
//    
//------------------------------------------------------------------------------------
//  Revision    : 0.1 | 2026-11-11 | Initial version
//====================================================================================

module nuvol_regfile (
    input   logic           clk_i,
    input   logic [4:0]     raddr_a_i,
    input   logic [4:0]     raddr_b_i,
    input   logic [4:0]     waddr_i,
    input   logic [31:0]    wdata_i,
    input   logic           wen_i,
    output  logic [31:0]    rdata_a_o,
    output  logic [31:0]    rdata_b_o

);

// -----------------------------------------------------------------------------------
// Signals and registers
// -----------------------------------------------------------------------------------

    logic [31:0]    regs_q [1:31];

// -----------------------------------------------------------------------------------
// Read Logic                                                     
// -----------------------------------------------------------------------------------
    always_comb begin
        if (raddr_a_i == '0) begin
            rdata_a_o = '0;
        end else begin
            rdata_a_o = regs_q [raddr_a_i];
        end

        if (raddr_b_i == '0) begin
            rdata_b_o = '0;
        end else begin
            rdata_b_o = regs_q [raddr_b_i];
        end

    end
        

// -----------------------------------------------------------------------------------
// Write Logic                                                     
// -----------------------------------------------------------------------------------
    always_ff @(posedge clk_i) begin
        if (wen_i && (waddr_i != '0)) begin
            regs_q[waddr_i] <= wdata_i;
        end
    end


endmodule
