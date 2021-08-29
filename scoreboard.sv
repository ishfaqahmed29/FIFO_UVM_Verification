import uvm_pkg::*;
`include "uvm_macros.svh"

// ----SCOREBOARD----

class fifo_scoreboard extends uvm_scoreboard;
    
    uvm_tlm_analysis_fifo #(data_item) input_pkts_collected;
    uvm_tlm_analysis_fifo #(data_item) output_pkts_collected;

    data_item input_data;
    data_item output_data;
    bit result;

    `uvm_component_utils(fifo_scoreboard)

    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        input_pkts_collected = new("Input data port ", this);
        output_pkts_collected = new("Output data port ", this);

        input_data = data_item::type_id::create("input_data");
        output_data = data_item::type_id::create("output_data");
    endfunction: build_phase

    virtual task run_phase(uvm_phase phase);
        forever begin
            input_pkts_collected.get(input_data);
            output_pkts_collected.get(output_data);
            result = input_data.compare(output_data);
            if(result)
                $display("RESULTS COMPARED SUCCESSFULLY! ");
            else begin
                `uvm_error("COMPARE", "RESULTS DID NOT MATCH! ")
                $display("Expected data: ");
                input_data.print();
                $display("Actual data: ");
                output_data.print();
            end
        end
    endtask: run_phase

endclass: fifo_scoreboard