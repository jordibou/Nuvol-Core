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
    funct3_e        funct3;
    
//------------------------------------------------------------------------------------
// Helpers
//------------------------------------------------------------------------------------
    assign opcode = instr_data_i[6:0];
    assign funct3 = instr_data_i[14:12];

//------------------------------------------------------------------------------------
// Immediate generator
//------------------------------------------------------------------------------------

    logic [31:0]    imm_i_type;
    logic [31:0]    imm_s_type;
    logic [31:0]    imm_b_type;
    logic [31:0]    imm_u_type;
    logic [31:0]    imm_j_type;


    
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

//------------------------------------------------------------------------------------
// Instruction decoder
//------------------------------------------------------------------------------------
    always_comb begin


    end

//------------------------------------------------------------------------------------
// ALU decoder
//------------------------------------------------------------------------------------
    always_comb begin
        // Default
        alu_op_o            = ALU_ADD;
        illegal_instr_o     = 1'b0;
        
        unique case (opcode)
            // Operations with R and I types
            OPCODE_OP, OPCODE_OP_IMM: begin
                case (funct3)
                    FUNCT3_ADD_SUB: begin
                        if (opcode == OPCODE_OP) begin
                            alu_op_o = instr_data_i[30] ? ALU_SUB : ALU_ADD;
                        end else alu_op_o = ALU_ADD;
                    end

                    FUNCT3_SLL: begin
                        alu_op_o = ALU_SLL;
                    end

                    FUNCT3_SLT: begin
                        alu_op_o = ALU_SLT;
                    end

                    FUNCT3_SLTU: begin
                        alu_op_o = ALU_SLTU;
                    end

                    FUNCT3_XOR: begin
                        alu_op_o = ALU_XOR;
                    end

                    FUNCT3_SRL_SRA: begin
                        alu_op_o = instr_data_i[30] ? ALU_SRA : ALU_SRL;
                    end

                    FUNCT3_OR: begin
                        alu_op_o = ALU_OR;
                    end

                    FUNCT3_AND: begin
                        alu_op_o = ALU_AND;
                    end
                    
                endcase

            end

            // Branch
            OPCODE_BRANCH: begin
                case (funct3)
                    FUNCT3_BEQ: begin
                        alu_op_o = ALU_BEQ;
                    end

                    FUNCT3_BNE: begin
                        alu_op_o = ALU_BNE;
                    end

                    FUNCT3_BLT: begin
                        alu_op_o = ALU_BLT;
                    end

                    FUNCT3_BGE: begin
                        alu_op_o = ALU_BGE;
                    end

                    FUNCT3_BLTU: begin
                        alu_op_o = ALU_BLTU;
                    end

                    FUNCT3_BGEU: begin
                        alu_op_o = ALU_BGEU;
                    end

                endcase
            end

            // Rest of instructions
            default: begin
                alu_op_o = ALU_ADD;
            end

        endcase

    end

//------------------------------------------------------------------------------------
// Illegal instruction detector
//------------------------------------------------------------------------------------

endmodule