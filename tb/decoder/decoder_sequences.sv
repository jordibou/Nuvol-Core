// -----------------------------------------------------------------------------------
// Random class: sends random N_ITEMS for instr_data with valid OPCODES 
// -----------------------------------------------------------------------------------
class decoder_rand_seq extends uvm_sequence #(decoder_seq_item);

    `uvm_object_utils(decoder_rand_seq)

    int unsigned    n_items = 200;
    bit             allow_illegal = 0;

    function new(string name = "decoder_rand_seq");
        super.new(name);
    endfunction 

    task body();
        decoder_seq_item item;
        repeat (n_items) begin
            item = decoder_seq_item::type_id::create("item");
            start_item(item);
            item.allow_illegal = allow_illegal;     // Ensure that random valid opcodes are selected
            if (!item.randomize())
                `uvm_error("SEQ", "randomize failed")
            finish_item(item);
        end
    endtask

endclass 

// -----------------------------------------------------------------------------------
// Illegal class: sends invalid opcodes, funct3 and funct7
// -----------------------------------------------------------------------------------
class decoder_illegal_seq extends decoder_rand_seq;

    `uvm_object_utils(decoder_illegal_seq)
    
    function new(string name = "decoder_illegal_seq");
        super.new(name);
        n_items = 200;
        allow_illegal = 1;
    endfunction 


endclass 

// -----------------------------------------------------------------------------------
// Pattern class: sends patterns
// -----------------------------------------------------------------------------------
class decoder_patt_seq extends uvm_sequence #(decoder_seq_item);
    `uvm_object_utils(decoder_patt_seq)

    int unsigned n_patterns = 10;

    function new(string name = "decoder_patt_seq");
        super.new(name):
    endfunction 

    task body();
        decoder_seq_item item;
        logic [11:0] imm_patterns_12[4] = '{12'h000, 12'hFFF,
                                            12'h800, 12'h7FF};

        logic [19:0] imm_patterns_20[4] = '{20'h0_0000, 20'hF_FFFF,
                                            20'h8_0000, 20'h7_FFFF};

        // I-immediate
        foreach (imm_patterns_12[p]) begin
            item = decoder_seq_item::type_id::create("item");
            start_item(item);
            if (!item.randomize() with {instr_data[6:0]     == OPCODE_OP_IMM; 
                                        instr_data[31:20]   == imm_patterns_12[p];})
                `uvm_error("SEQ", "immediate pattern for I-imm")            
            finish_item(item);
        end

        // S-immediate
        foreach (imm_patterns_12[p]) begin
            item = decoder_seq_item::type_id::create("item");
            start_item(item);
            if (!item.randomize() with {instr_data[6:0]     == OPCODE_STORE; 
                                        instr_data[11:7]    == imm_patterns_12[p][4:0];
                                        instr_data[31:25]   == imm_patterns_12[p][11:5];})
                `uvm_error("SEQ", "immediate pattern for S-imm")            
            finish_item(item);
        end
 
        // B-immediate
        foreach (imm_patterns_12[p]) begin
            item = decoder_seq_item::type_id::create("item");
            start_item(item);
            if (!item.randomize() with {instr_data[6:0]     == OPCODE_BRANCH; 
                                        instr_data[7]       == imm_patterns_12[p][10];
                                        instr_data[11:8]    == imm_patterns_12[p][3:0];
                                        instr_data[30:25]   == imm_patterns_12[p][9:4];
                                        instr_data[31]      == imm_patterns_12[p][11];})
                `uvm_error("SEQ", "immediate pattern for B-imm")            
            finish_item(item);
        end       

        // U-immediate
        foreach (imm_patterns_20[p]) begin
            item = decoder_seq_item::type_id::create("item");
            start_item(item);
            if (!item.randomize() with {instr_data[6:0]     inside { OPCODE_LUI, OPCODE_AUIPC }; 
                                        instr_data[31:12]   == imm_patterns_20[p][19:0];})
                `uvm_error("SEQ", "immediate pattern for U-imm")            
            finish_item(item);
        end

        // J-immediate
        foreach (imm_patterns_20[p]) begin
            item = decoder_seq_item::type_id::create("item");
            start_item(item);
            if (!item.randomize() with {instr_data[6:0]     == OPCODE_JAL; 
                                        instr_data[19:12]   == imm_patterns_20[p][18:11];
                                        instr_data[20]      == imm_patterns_20[p][10];
                                        instr_data[30:21]   == imm_patterns_20[p][9:0];
                                        instr_data[31]      == imm_patterns_20[p][19];})
                `uvm_error("SEQ", "immediate pattern for J-imm")            
            finish_item(item);
        end



            item = decoder_seq_item::type_id::create("item");
            start_item(item);
            if (!item.randomize() with {instr_data[6:0]     == OPCODE_OP_IMM; 
                                        instr_data[14:12]   == FUNCT3_ADD_SUB;
                                        instr_data[30]      == 1;})
                `uvm_error("SEQ", "pattern")            
            finish_item(item);

    endtask

endclass 

