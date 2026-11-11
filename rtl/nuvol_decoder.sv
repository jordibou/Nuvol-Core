//====================================================================================
//  NUVOL CORE  |  32-bit RISC-V 
//------------------------------------------------------------------------------------
//  Module      : Nuvol Core Decoder
//  File        : nuvol_decoder.sv
//  Author      : Jordi Bou Garcia
//  Created     : 2026-11-11
//------------------------------------------------------------------------------------
//  Description : This module takes a 32-bit input from the instruction register (IR),
//                decodes its contents and outputs them.
//    
//------------------------------------------------------------------------------------
//  Revision    : 0.1 | 2026-11-11 | Initial version
//====================================================================================

module nuvol_decoder (
    input   logic [31:0]    instr_data_i,
    output  alu_op_e        alu_op_o,
    output  logic [4:0]     raddr_a_o,
    output  logic [4:0]     raddr_b_o,
    output  logic [31:0]    w_addr_o,
    output  logic           wen_o,
    output  logic [31:0]    imm_o,
    output  logic           mem_we_o,
    output  logic [1:0]     operand_a_sel_o,
    output  logic [1:0]     operand_b_sel_o,
    output  logic [1:0]     wb_sel_o,
    output  logic           is_jump_instr_o,
    output  logic           is_branch_instr_o,
    output logic            illegal_instr_o

);

endmodule