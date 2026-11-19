class regfile_driver extends uvm_driver #(regfile_seq_item);
    `uvm_component_utils(regfile_driver)

    virtual regfile_if vif;

    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual regfile_if)::get(this,"", "vif", vif))
            `uvm_fatal("DRV", "no virtual interface found in config_db")
    endfunction

    task run_phase(uvm_phase phase);
        regfile_seq_item item;
        
        vif.drv_cb.wen      <= 1'b0;
        vif.drv_cb.waddr    <= '0;
        vif.drv_cb.wdata    <= '0;
        vif.drv_cb.raddr_a  <= '0;
        vif.drv_cb.raddr_b  <= '0;
            
        forever begin
            seq_item_port.get_next_item(item);
            @(vif.drv_cb);
            vif.drv_cb.wen      <= item.wen;
            vif.drv_cb.waddr    <= item.waddr;
            vif.drv_cb.wdata    <= item.wdata;
            vif.drv_cb.raddr_a  <= item.raddr_a;
            vif.drv_cb.raddr_b  <= item.raddr_b;
            `uvm_info("DRV", item.convert2string, UVM_HIGH)
            seq_item_port.item_done();
        end
    endtask

endclass