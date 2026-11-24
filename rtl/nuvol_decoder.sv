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
//  Revision    : 0.3 | 2026-11-23 | Finished the decoders
//====================================================================================

module nuvol_decoder (
    input   logic [31:0]    instr_data_i,
    output  alu_op_e        alu_op_o,
    output  logic [4:0]     raddr_a_o,
    output  logic [4:0]     raddr_b_o,
    output  logic [4:0]     w_addr_o,
    output  logic           wen_o,
    output  logic [31:0]    imm_o,
    output  logic           mem_wen_o,
    output  logic [1:0]     operand_a_sel_o,
    output  logic           operand_b_sel_o,
    output  logic [1:0]     wb_sel_o,
    output  logic           is_jump_instr_o,
    output  logic           is_branch_instr_o,
    output  logic [1:0]     byte_width_o,
    output  logic           load_unsigned_o,
    output  logic           illegal_instr_o

);

    import nuvol_pkg::*;

   
//------------------------------------------------------------------------------------
// Instruction slices
//------------------------------------------------------------------------------------
    // Signals
    logic [6:0]         opcode;
    logic [2:0]         funct3;
    logic [6:0]         funct7;

    // Fnction slices
    assign opcode       = instr_data_i[6:0];
    assign funct3       = instr_data_i[14:12];
    assign funct7       = instr_data_i[31:25];

    // Addresses
    assign raddr_a_o    = instr_data_i[19:15];
    assign raddr_b_o    = instr_data_i[24:20];
    assign w_addr_o     = instr_data_i[11:7];

//------------------------------------------------------------------------------------
// Immediate generator
//------------------------------------------------------------------------------------

    // Immediate encoding variants
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
        // Defaults
        wen_o               = 1'b0; 
        mem_wen_o            = 1'b0; 
        operand_a_sel_o     = OP_A_ZERO; 
        operand_b_sel_o     = 1'b0; 
        wb_sel_o            = WB_ALU; 
        is_jump_instr_o     = 1'b0; 
        is_branch_instr_o   = 1'b0; 
        byte_width_o        = BW_BYTE; 
        load_unsigned_o     = 1'b0; 
        illegal_instr_o     = 1'b0; 

        unique case(opcode)
            OPCODE_LOAD     : begin
                operand_a_sel_o = OP_A_RS1;
                operand_b_sel_o = OP_B_IMM;
                wen_o           = 1'b1;
                wb_sel_o        = WB_MEM;
                load_unsigned_o = funct3[2];

                case (funct3[1:0])
                    2'b00: begin
                        byte_width_o = BW_BYTE;
                    end

                    2'b01: begin
                        byte_width_o = BW_HALF;
                    end

                    2'b10: begin
                        byte_width_o = BW_WORD;
                    end

                    default: begin
                        byte_width_o = BW_BYTE;
                    end
                endcase

                if (!(funct3 inside{FUNCT3_LB, FUNCT3_LH, FUNCT3_LW, FUNCT3_LBU, FUNCT3_LHU})) begin
                    illegal_instr_o = 1'b1;
                end
            end

            OPCODE_MISC_MEM : begin
                if (funct3 != '0) begin
                    illegal_instr_o = 1'b1;
                end
            end            

            OPCODE_OP_IMM   : begin
                operand_a_sel_o     = OP_A_RS1;
                operand_b_sel_o     = OP_B_IMM;
                wen_o               = 1'b1;
                wb_sel_o            = WB_ALU;

                case (funct3)
                    FUNCT3_SRL_SRA: begin
                        if (!(funct7 inside {FUNCT7_VALID1, FUNCT7_VALID2})) begin
                            illegal_instr_o = 1'b1;
                        end
                    end

                    FUNCT3_SLL: begin
                        if (funct7 != FUNCT7_VALID1) begin
                            illegal_instr_o = 1'b1;
                        end
                    end
                    
                    default: ;

                endcase
            end

            OPCODE_AUIPC    : begin
                operand_a_sel_o = OP_A_PC;
                operand_b_sel_o = OP_B_IMM;
                wen_o           = 1'b1;
                wb_sel_o        = WB_ALU;
            end

            OPCODE_STORE    : begin
                operand_a_sel_o = OP_A_RS1;
                operand_b_sel_o = OP_B_IMM;
                mem_wen_o        = 1'b1;
                wb_sel_o        = WB_MEM;

                case (funct3[1:0])
                    2'b00: begin
                        byte_width_o = BW_BYTE;
                    end

                    2'b01: begin
                        byte_width_o = BW_HALF;
                    end

                    2'b10: begin
                        byte_width_o = BW_WORD;
                    end

                    default: begin
                        byte_width_o = BW_BYTE;
                    end
                endcase

                if (!(funct3 inside {FUNCT3_SB, FUNCT3_SH, FUNCT3_SW})) begin
                    illegal_instr_o = 1'b1;
                end
 
            end

            OPCODE_OP       : begin
                operand_a_sel_o     = OP_A_RS1;
                operand_b_sel_o     = OP_B_RS2;
                wen_o               = 1'b1;
                wb_sel_o            = WB_ALU;

                case(funct3)
                    FUNCT3_ADD_SUB, FUNCT3_SRL_SRA: begin
                        if (!(funct7 inside {FUNCT7_VALID1, FUNCT7_VALID2})) begin
                            illegal_instr_o = 1'b1;
                        end
                    end

                    default: begin
                        if (funct7 != FUNCT7_VALID1) begin
                            illegal_instr_o = 1'b1;
                        end 
                    end
                endcase
            end

            OPCODE_LUI      : begin
                operand_a_sel_o     = OP_A_ZERO;
                operand_b_sel_o     = OP_B_IMM;
                wen_o               = 1'b1;
                wb_sel_o            = WB_ALU;
            end

            OPCODE_BRANCH   : begin
                operand_a_sel_o     = OP_A_RS1;
                operand_b_sel_o     = OP_B_RS2;
                is_branch_instr_o   = 1'b1;

                if (!(funct3 inside {FUNCT3_BEQ, FUNCT3_BNE, FUNCT3_BLT, FUNCT3_BGE, FUNCT3_BLTU, FUNCT3_BGEU})) begin
                    illegal_instr_o = 1'b1;
                end
                
            end

            OPCODE_JALR     : begin
                operand_a_sel_o = OP_A_RS1;
                operand_b_sel_o = OP_B_IMM;
                wen_o           = 1'b1;
                wb_sel_o        = WB_PC4;
                is_jump_instr_o = 1'b1;

                if (funct3 != '0) begin
                    illegal_instr_o = 1'b1;
                end
            end

            OPCODE_JAL      : begin
                operand_a_sel_o = OP_A_PC;
                operand_b_sel_o = OP_B_IMM;
                wen_o           = 1'b1;
                wb_sel_o        = WB_PC4;
                is_jump_instr_o = 1'b1;
            end

            OPCODE_SYSTEM   : begin
                illegal_instr_o = 1'b1;

            end

            default: begin
                illegal_instr_o = 1'b1;
            end
        endcase
    end

//------------------------------------------------------------------------------------
// ALU decoder
//------------------------------------------------------------------------------------
    always_comb begin
        // Default
        alu_op_o            = ALU_ADD;
        
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

endmodule