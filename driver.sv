import uvm_pkg::*;
`include "uvm_macros.svh"

// ----DRIVER----

class fifo_driver extends uvm_driver #(data_item)
  `uvm_component_utils(fifo_driver)
  
    virtual fifo_if fifo_driver_vif;

    function new(string name, uvm_component parent);
    super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
    super.build(phase);
    if (!uvm_config_db#(virtual fifo_if)::get(this, "", "fifo_if", fifo_driver_vif))
      `uvm_fatal("NO_VIF", {"Must set virtual interface for: ", get_full_name(), ".fifo_driver_vif"})
      `uvm_info(get_full_name(), "Build stage done ", UVM_LOW)
    endfunction
      
    virtual task run_phase(uvm_phase phase);
    	fork
        check_reset();
        driver_to_dut();
      join
    endtask: run_phase
    
    virtual task check_reset();
      forever begin
        @(negedge fifo_driver_vif.rst_n);
          `uvm_info(get_type_name(), "Resetting signals ", UVM_LOW)
          fifo_driver_vif.read_en = 1'b0;
          fifo_driver_vif.write_en = 1'b0;
          fifo_driver_vif.data_in = 32'b0;
        end
    endtask: check_reset
    
    virtual task driver_to_dut(data_item pkt);
      forever begin
        while (!fifo_driver_vif.rst) begin
          seq_item_port.get_next_item(req);
          fifo_driver_vif.write_en = 1'b0;
          fifo_driver_vif.read_en = 1'b0;
          repeat(pkt.delay) @(posedge fifo_driver_vif.clk)
          fifo_driver_vif.read_en = pkt.read_en;
          fifo_driver_vif.write_en = pkt.write_en;
          fifo_driver_vif.data_in = pkt.data_in;
          @(posedge fifo_driver_vif.clk)
          fifo_driver_vif.write_en = 1'b0;
          fifo_driver_vif.read_en = 1'b0;      
          seq_item_port.item_done();
        end
      end
    endtask: driver_to_dut

endclass: fifo_driver
