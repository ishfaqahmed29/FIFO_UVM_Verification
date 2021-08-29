import uvm_pkg::*;
`include "uvm_macros.svh"

// ----MONITOR----

class fifo_monitor extends uvm_monitor;
    `uvm_component_utils (fifo_monitor)

    virtual fifo_if vif;
    string monitor_intf;
    int num_pkts;

    uvm_analysis_port #(data_item) item_collected_port;
    data_item data_collected;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual fifo_if)::get(this, "", monitor_intf, vif))
        `uvm_fatal("NO_VIF", {"Set virtual interface for: ", get_full_name(), ".vif"})

        `uvm_info(get_type_name(), $sformatf("MONITOR INTERFACE USED = %0s", monitor_intf), UVM_LOW)

        item_collected_port = new("item_collected_port", this);

        data_collected = data_item::type_id::create("data_collected");

        `uvm_info(get_full_name(), "Build stage complete ", UVM_LOW)
    endfunction: build_phase

    virtual task run_phase(uvm_phase phase);
        collect_data();
    endtask: run_phase

    virtual task collect_data();
        forever begin
            @ (posedge vif.clk)
            if(vif.write_en & vif.full_fifo & !vif.rst_n)begin
            data_collected.data_in = vif.data_in;
            end
            if(vif.read_en & vif.empty_fifo & !vif.rst_n)begin
            data_collected.data_out = vif.data_out;    
            end
            item_collected_port.write(data_collected);
            num_pkts++;
        end
    endtask: collect_data

    virtual function void report_phase(uvm_phase phase);
        `uvm_info(get_type_name(), $sformatf("TOTAL PACKETS = %0d", num_pkts), UVM_LOW)
    endfunction: report_phase

endclass: fifo_monitor
