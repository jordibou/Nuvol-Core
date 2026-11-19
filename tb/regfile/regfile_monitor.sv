    class regfile_monitor extends uvm_monitor;
        `uvm_component_utils(regfile_monitor);
    
        virtual regfile_if vif;
        uvm_analysis_port #(regfile_seq_item) ap;

        function new(string name = "regfile_monitor", uvm_component parent);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            ap = new("ap", this);
            if (!uvm_config_db#(virtual regfile_if)::get(this, "", "vif", vif))
                `uvm_fatal("MON", "no virtual interface found in config_db")
        endfunction

        task run_phase(uvm_phase phase);
            regfile_seq_item item;
            forever begin
                @(vif.mon_cb);
                item            = regfile_seq_item::type_id::create("item");
                item.wen        = vif.mon_cb.wen;
                item.waddr      = vif.mon_cb.waddr;
                item.wdata      = vif.mon_cb.wdata;
                item.raddr_a    = vif.mon_cb.raddr_a;
                item.raddr_b    = vif.mon_cb.raddr_b;
                item.rdata_a    = vif.mon_cb.rdata_a;
                item.rdata_b    = vif.mon_cb.rdata_b;
                `uvm_info("MON", item.convert2string, UVM_HIGH)
                ap.write(item);
            end
        endtask
    endclass
    