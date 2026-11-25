class decoder_seq_item extends uvm_sequence_item;
    // Stimulus randomized
    rand logic [31:0]   instr_data;


    // Responses (outputs)
    alu_op_e            alu_op;
    logic [4:0]         raddr_a;
    logic [4:0]         raddr_b;
    logic [4:0]         w_addr;
    logic               wen;
    logic [31:0]        imm;          
    logic               mem_wen;      
    logic [1:0]         operand_a_sel;
    logic               operand_b_sel;
    logic [1:0]         wb_sel;
    logic               is_jump_instr;
    logic               is_branch_instr;
    logic [1:0]         byte_width;
    logic               load_unsigned;
    logic               illegal_instr;

    // 
    constraint c_opcode {
        instr_data[6:0] inside {OPCODE_LOAD, OPCODE_MISC_MEM, 
                                OPCODE_OP_IMM, OPCODE_AUIPC,
                                OPCODE_STORE, OPCODE_OP,
                                OPCODE_LUI, OPCODE_BRANCH,
                                OPCODE_JALR, OPCODE_JAL,
                                OPCODE_SYSTEM
                            };
    }


    `uvm_object_utils(decoder_seq_item)
    

    function new(string name = "decoder_seq_item");
        super.new(name);
    endfunction: new

    function string convert2string();
        return $sformatf("instr_data=%08h", 
                        instr_data);
    endfunction
    
endclass
