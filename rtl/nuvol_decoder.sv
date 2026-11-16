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
    output  logic           byte_width_o,
    output  logic           load_unsigned_o,
    output  logic            illegal_instr_o

);

    opcodes_e       opcode;
    logic [31:0]    sign_extended_imm;

    logic [31:0]    imm_i_type;
    logic [31:0]    imm_s_type;
    logic [31:0]    imm_b_type;
    logic [31:0]    imm_u_type;
    logic [31:0]    imm_j_type;


    assign opcode = instr_data_i[6:0];
    


    assign imm_i_type = { {20{instr_data_i[31]}} , instr_data_i[31:20] };                       
    assign imm_s_type = { {20{instr_data_i[31]}} , instr_data_i[31:25] , instr_data_i[11:7]};
    assign imm_b_type = { {20{instr_data_i[31]}} , instr_data_i[7] , instr_data_i[30:25] , instr_data_i[11:8] , 1'b0};
    assign imm_u_type = { instr_data_i[31:12] , 12'b0 };
    assign imm_j_type = { {12{instr_data_i[31]}} , instr_data_i[19:12] , instr_data_i[20] , instr_data_i[30:21] , 1'b0 };

    // Immediate generator
    always_comb begin
        unique case (opcode)
            OPCODE_OP_IMM, OPCODE_LOAD, OPCODE_JALR, OPCODE_SYSTEM, OPCODE_MISC_MEM: begin
                imm_o = imm_i_type;
            end 

            OPCODE_STORE: begin
                imm_o = imm_s_type;
            end 

            OPCODE_BRANCH: begin
                imm_o = imm_b_type;
            end 
           
            OPCODE_LUI, OPCODE_AUIPC: begin
                imm_o = imm_u_type;
            end

            OPCODE_JAL: begin
                imm_o = imm_j_type;
            end 

            default: begin
                imm_o = '0;
            end
        endcase
    end 

    // Instructions decoder
    always_comb begin

    end

    // ALU decoder
    always_comb begin

    end

endmodule