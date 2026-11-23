//==============================================================================
//  NUVOL CORE  |  32-bit RISC-V
//------------------------------------------------------------------------------
//  Module      : Nuvol Core Package
//  File        : nuvol_pkg.sv
//  Author      : Jordi Bou Garcia
//  Created     : 2026-10-30
//------------------------------------------------------------------------------
//  Description :
//    
//------------------------------------------------------------------------------
//  Revision    : 0.1 | 2026-10-30 | Initial version
//==============================================================================    

package nuvol_pkg;

    // ALU operations
    typedef enum logic [3:0] {
        // Arithmetic
        ALU_ADD,    // Addition
        ALU_SUB,    // Substraction

        // Logic 
        ALU_OR,     // OR
        ALU_AND,    // AND
        ALU_XOR,    // XOR

        // Shift 
        ALU_SLL,    // Shift left logical
        ALU_SRL,    // Shift right logical
        ALU_SRA,    // Shift right arithmetic

        // Comparison
        ALU_SLT,    // Set less than signed
        ALU_SLTU,   // Set less than unsigned

        // Branch
        ALU_BEQ,
        ALU_BNE,
        ALU_BLT,
        ALU_BGE,
        ALU_BLTU,
        ALU_BGEU
    } alu_op_e;


    // OPCODES list
    typedef enum logic [6:0] {
        OPCODE_LOAD     = 7'b000_0011,
        OPCODE_MISC_MEM = 7'b000_1111,
        OPCODE_OP_IMM   = 7'b001_0011,
        OPCODE_AUIPC    = 7'b001_0111,
        OPCODE_STORE    = 7'b010_0011,
        OPCODE_OP       = 7'b011_0011,
        OPCODE_LUI      = 7'b011_0111,
        OPCODE_BRANCH   = 7'b110_0011,
        OPCODE_JALR     = 7'b110_0111,
        OPCODE_JAL      = 7'b110_1111,
        OPCODE_SYSTEM   = 7'b111_0011
    } opcodes_e;

    // Funct3 list
    typedef enum logic [2:0] {
        // Funct3 for OP and OP-IMM
        FUNCT3_ADD_SUB  = 3'b000,
        FUNCT3_SLL      = 3'b001,
        FUNCT3_SLT      = 3'b010,
        FUNCT3_SLTU     = 3'b011,
        FUNCT3_XOR      = 3'b100,
        FUNCT3_SRL_SRA  = 3'b101,
        FUNCT3_OR       = 3'b110,
        FUNCT3_AND      = 3'b111,

        // Funct3 for LOAD
        FUNCT3_LB       = 3'b000,
        FUNCT3_LH       = 3'b001,
        FUNCT3_LW       = 3'b010,
        FUNCT3_LBU      = 3'b100,
        FUNCT3_LHU      = 3'b101,

        // Funct3 for STORE
        FUNCT3_SB       = 3'b000,
        FUNCT3_SH       = 3'b001,
        FUNCT3_SW       = 3'b010,

        // Funct3 for BRANCH
        FUNCT3_BEQ      = 3'b000;
        FUNCT3_BNE      = 3'b001;
        FUNCT3_BLT      = 3'b100;
        FUNCT3_BGE      = 3'b101;
        FUNCT3_BLTU     = 3'b110;
        FUNCT3_BGEU     = 3'b111;
    } funct3_e;

    typedef enum logic [1:0] {
        OP_A_RS1,
        OP_A_PC,
        OP_A_ZERO
    } operand_a_e;

    typedef enum logic {
        OP_B_RS2,
        OP_B_IMM
    } operand_a_e;

    typedef enum logic [1:0] {
        WB_ALU,
        WB_MEM,
        WB_PC4
    } wb_sel_e;

    typedef enum logic [1:0] {
        BW_BYTE,
        BW_HALF,
        BW_WORD
    } byte_width_e;
endpackage