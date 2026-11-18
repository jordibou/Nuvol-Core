class regfile_env extends uvm_env;
    `uvm_component_utils(regfile_env);

    regfile_agent       agt;
    regfile_scoreboard  scb;
    regfile_coverage    cov;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agt = regfile_agent     ::type_id::create("agt", this);
        scb = regfile_scoreboard::type_id::create("scb", this);
        cov = regfile_coverage  ::type_id::create("cov", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agt.mon.ap.connect(scb.imp);
        agt.mon.ap.connect(cov.analysis_export);
    endfunction

endclass
