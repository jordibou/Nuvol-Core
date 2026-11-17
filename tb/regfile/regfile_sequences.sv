// -----------------------------------------------------------------------------------
// Random class: sends random N_ITEMS 
// -----------------------------------------------------------------------------------
class regfile_rand_seq extends uvm_sequence #(regfile_seq_item);

    `uvm_object_utils(regfile_rand_seq)

    int unsigned n_items = 200;

    function new(string name = "regfile_rand_seq");
        super.new(name);
    endfunction 

    task body();
        regfile_seq_item item;
        repeat (n_items) begin
            item = regfile_seq_item::type_id::create("item");
            start_item(item);
            if (!item.randomize())
                `uvm_error("SEQ", "randomize failed")
            finish_item(item);
        end
    endtask

endclass 

// -----------------------------------------------------------------------------------
// Fill sequence: writes every register x1 to x31
// -----------------------------------------------------------------------------------
class regfile_fill_seq extends uvm_sequence #(regfile_seq_item);
    `uvm_object_utils(regfile_fill_seq)

    function new(string name = "regfile_fill_seq");
        super.new(name);
    endfunction 

    task body();
        regfile_seq_item item;
        for (int r = 1; r < 32; r++) begin
            item = regfile_seq_item::type_id::create("item");
            start_item(item);
            if (!item.randomize() with { wen == 1 && waddr == r; })
                `uvm_error("SEQ", "fill randomized failed")
            finish_item(item);
        end
    endtask
endclass

// -----------------------------------------------------------------------------------
// Pattern sequence: writes every register with patterns and writes them back
// -----------------------------------------------------------------------------------
class regfile_pattern_seq extends uvm_sequence #(regfile_seq_item);
    `uvm_object_utils(regfile_pattern_seq)

    int unsigned n_items = 128;

    function new(string name = "regfile_pattern_seq");
        super.new(name);
    endfunction 

    task body();
        regfile_seq_item item;
        logic [31:0] patterns[4] = '{32'h0000_0000, 32'hFFFF_FFFF,
                                     32'hAAAA_AAAA, 32'h5555_5555};
        foreach (patterns[p] begin) begin
            // Write phase
            for (int r = 1; r < 32; r++) begin
                item = regfile_seq_item::type_id::create("item");
                start_item(item);
                if (!item.randomize() with {wen == 1; waddr == r; wdata == patterns[p]; })
                    `uvm_error("SEQ", "pattern write failed")
                finish_item(item);
            end

            // Read phase
            for (int r = 1; r < 32; r+=2) begin
                item = regfile_seq_item::type_id::create("item");
                start_item(item);
                if (!item.randomize() with {wen == 0; raddr_a == r; raddr_b == r + 1; })
                    `uvm_error("SEQ", "pattern write failed")
                finish_item(item);
            end
        end
    endtask
endclass