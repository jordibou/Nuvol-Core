class regfile_seq_item extends uvm_sequence_item;
    // Stimulus randomized
    rand logic [4:0]    raddr_a;
    rand logic [4:0]    raddr_b;
    rand logic [4:0]    waddr;
    rand logic [31:0]   wdata;
    rand logic          wen;

    // Responses (outputs)
    logic [31:0]    rdata_a;
    logic [31:0]    rdata_b;

    // Assigning more weight to address 0
    constraint c_addr_dist {
        waddr   dist { 0 := 2, [1:31] :/8 };
        raddr_a dist { 0 := 2, [1:31] :/8 };
        raddr_b dist { 0 := 2, [1:31] :/8 };
    }


    `uvm_object_utils(regfile_seq_item)

    function new(string name = "regfile_seq_item");
       super.new(name);
    endfunction

    function string convert2string();
        return $sformatf("wen=%0b waddr=x%0d wdata=0x%08h | ra=x%0d rb=x%0d | rdata_a=0x%08h rdata_b=0x%08h",
                     wen, waddr, wdata, raddr_a, raddr_b, rdata_a, rdata_b);
    endfunction

endclass