//  Class: regfile_scoreboard
//
class regfile_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(regfile_scoreboard);

    uvm_analysis_imp #(regfile_seq_item, regfile_scoreboard) imp;

    logic [31:0]    model [32];
    bit             written [32];
    int unsigned    n_checks, n_errors;

    function new(string name = "regfile_scoreboard", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        imp = new("imp", this);
        // x0 is always 0
        model[0]    = '0;
        written[0]  = 1;
    endfunction


    function void write(regfile_seq_item t);
        // Check agains the model
        check_port("A", t.raddr_a, t.rdata_a);
        check_port("B", t.raddr_a, t.rdata_a);

        // Update the model with this cycle's write
        if (t.wen && t.waddr != 0) begin
            model[t.waddr]      = t.wdata;
            written[t.waddr]    = 1;
        end
    endfunction

    function void check_port(string port, logic [4:0] addr, logic [31:0] got);
        if (!written[addr]) return;
        n_checks++;
        if (got !== model[addr]) begin
            n_errors++;
            `uvm_error("SCB", $sformatf("port %s x%0d: expected 0x%08h, got 0x%08h",
                                        port, addr, model[addr], got))
        end
    endfunction

    function void report_phase(uvm_phase phase);
        `uvm_info("SCB", $sformatf("%0d checks, %0d errors", n_checks, n_errors), UVM_NONE)
    endfunction
    
endclass
