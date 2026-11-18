class regfile_base_test extends uvm_test;
    `uvm_component_utils(regfile_base_test)

    regfile_env env;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = regfile_env::type_id::create("env", this);
    endfunction

    function void end_of_elaboration_phase(uvm_phase phase);
        uvm_top.print_topology();
    endfunction

    function void report_phase(uvm_phase phase);
        uvm_report_server rs = uvm_report_server::get_server();
        if (rs.get_severity_count(UVM_ERROR) + rs.get_severity_count(UVM_FATAL) == 0)
            `uvm_info("TEST", "*** TEST PASSED ***", UVM_NONE)
        else 
            `uvm_info("TEST", "*** TEST FAILED ***", UVM_NONE)
    endfunction
            
endclass

class regfile_rand_test extends regfile_base_test;
    `uvm_component_utils(regfile_rand_test);

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        regfile_fill_seq fill   = regfile_fill_seq::type_id::create("fill");
        regfile_rand_seq rnd    = regfile_rand_seq::type_id::create("rnd");
        phase.raise_objection(this);
        fill.start(env.agt.sqr);
        rnd.n_items = 2000;
        rnd.start(env.agt.sqr);
        phase.drop_objection(this);
    endtask
    
endclass


class regfile_pattern_test extends regfile_base_test;
    `uvm_component_utils(regfile_pattern_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        regfile_fill_seq fill   = regfile_fill_seq::type_id::create("fill");
        regfile_pattern_seq pat = regfile_pattern_seq::type_id::create("pat");
        phase.raise_objection(this);
        fill.start(env.agt.sqr);
        pat.start(env.agt.sqr);
        phase.drop_objection(this);
    endtask
endclass

