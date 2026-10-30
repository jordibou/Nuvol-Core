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

    typedef enum logic [3:0] {
        // Arithmetic
        ALU_ADD,    // Addition
        ALU_SUB,    // Substraction

        // Logic 
        ALU_OR,     // OR
        ALU_AND     // AND
        ALU_XOR,    // XOR

        // Shift 
        ALU_SLL,    // Shift left logical
        ALU_SRL,    // Shift right logical
        ALU_SRA,    // Shift right arithmetic

        // Comparison
        ALU_SLT,    // Set less than signed
        ALU_SLTU    // Set less than unsigned
    } alu_op_e;

endpackage