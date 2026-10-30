//==============================================================================
//  NUVOL CORE  |  32-bit RISC-V 
//------------------------------------------------------------------------------
//  Module      : Nuvol Core Arithmetic Logic Unit
//  File        : nuvol_alu.sv
//  Author      : Jordi Bou Garcia
//  Created     : 2026-10-30
//------------------------------------------------------------------------------
//  Description :
//    
//------------------------------------------------------------------------------
//  Revision    : 0.1 | 2026-10-30 | Initial version
//==============================================================================    

import nuvol_pkg::*;

module nuvol_alu (
    input   logic [31:0]    operand_a_i,
    input   logic [31:0]    operand_b_i,
    input   alu_op_e        alu_op_i,
    output  logic [31:0]    result_o,
    output  logic           cmp_result_o
);


    always_comb begin

        result_o        = 32'd0;
        cmp_result_o    = 1'b0;

        case (alu_op_i) 
            // Arithmetic
            ALU_ADD: begin
                result_o = operand_a_i + operand_b_i;
            end

            ALU_SUB: begin
                result_o = operand_a_i - operand_b_i;
            end

            // Logic
            ALU_OR: begin
                result_o = operand_a_i | operand_b_i;
            end

            ALU_AND: begin
                result_o = operand_a_i & operand_b_i;
            end

            ALU_XOR: begin
                result_o = operand_a_i ^ operand_b_i;
            end

            // Shift
            ALU_SLL: begin
                result_o = operand_a_i << operand_b_i;
            end

            ALU_SRL: begin
                result_o = operand_a_i >> operand_b_i;
            end

            ALU_SRA: begin
                result_o = operand_a_i >>> operand_b_i;
            end

            // Comparison
            ALU_SLT: begin
                cmp_result_o = (operand_a_i < operand_b_i);
            end

            ALU_SLTU: begin
                cmp_result_o = (operand_a_i < operand_b_i);
            end

            default: begin
                result_o        = 32'd0;
                cmp_result_o    = 1'b0;
            end
        endcase
        
    end


endmodule

