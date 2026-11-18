class regfile_agent extends uvm_agent;
    `uvm_component_utils(regfile_agent);

    regfile_sequencer   sqr;
    regfile_driver      drv;
    regfile_monitor     mon;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sqr = regfile_sequencer ::type_id::create("sqr", this);
        drv = regfile_driver    ::type_id::create("sqr", this);
        mon = regfile_monitor   ::type_id::create("sqr", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        drv.seq_item_port.connect(sqr.seq_item_port);
    endfunction
    
endclass
