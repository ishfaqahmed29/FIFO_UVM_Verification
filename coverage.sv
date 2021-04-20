import uvm_pkg::*;
`include "uvm_macros.svh"

// ----COVERAGE----

class fifo_coverage extends uvm_subscriber #(data_item);
    `uvm_component_utils(fifo_coverage)
    data_item pkt;
    int i;

    covergroup cg;
        covg_write_en   : coverpoint pkt.write_en;  
        covg_read_en    : coverpoint pkt.read_en;
        covg_data_in    : coverpoint pkt.data_in;
        covg_data_out   : coverpoint pkt.data_out;
    endgroup: cg
        
    function new(string name, uvm_component parent);
        super.new(name, parent);
        cg = new();
    endfunction: new

    function void write(data_item t);
        pkt = t;
        i++;
        cg.sample();
    endfunction: write

    virtual function void extract_phase(uvm_phase phase);
        `uvm_info(get_type_name(), $sformatf("Coverage : %f", cg.get_coverage()), UVM_LOW)
    endtask: extract_phase

endclass: fifo_coverage