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
        ALU_AND,     // AND
        ALU_XOR,    // XOR

        // Shift 
        ALU_SLL,    // Shift left logical
        ALU_SRL,    // Shift right logical
        ALU_SRA,    // Shift right arithmetic

        // Comparison
        ALU_SLT,    // Set less than signed
        ALU_SLTU    // Set less than unsigned
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

endpackage