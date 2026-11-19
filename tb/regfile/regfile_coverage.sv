class regfile_coverage extends uvm_subscriber #(regfile_seq_item);
    `uvm_component_utils(regfile_coverage)

    regfile_seq_item t;

    covergroup cg_regfile;
        // TP-RF-01/06
        cp_waddr:   coverpoint t.waddr iff (t.wen) { bins regs [] = {[1:31]}; bins x0 = {0};}

        // TP-RF-05
        cp_raddr_a: coverpoint t.raddr_a { bins regs[] = {[0:31]};}
        cp_raddr_b: coverpoint t.raddr_b { bins regs[] = {[0:31]};}

        // TP-RF-03
        cp_wen:     coverpoint t.wen;

        // TP-RF-06
        cp_wdata:   coverpoint t.wdata iff (t.wen) {
            bins zeros  = {32'h0000_0000};
            bins ones   = {32'hFFFF_FFFF};
            bins aa     = {32'hAAAA_AAAA};
            bins x55    = {32'h5555_5555};
            bins other  = default;
        }

        // TP-RF-04
        cp_rw_same: coverpoint (t.wen && t.waddr !=0 && t.waddr == t.raddr_a) {
            bins hit = {1};
        }

        // TP-RF-05
        cp_ports_same:  coverpoint (t.raddr_a == t.raddr_b) {
            bins same   = {1}; 
            bins diff   = {0};
        }

    endgroup

    function new(string name = "regfile_coverage", uvm_component parent);
        super.new(name, parent);
        cg_regfile = new();
    endfunction

    function void write(regfile_seq_item t);
        this.t = t;
        cg_regfile.sample();
    endfunction

    function void report_phase(uvm_phase phase);
        `uvm_info("COV", $sformatf("regfile coverage = %0.2f%%", cg_regfile.get_coverage()), UVM_NONE)
    endfunction 
    
endclass