`timescale 1ns / 1ps

// -----TOP MODULE (TESTBENCH)-----

module top_tb;
  import uvm_pkg::*;
  import fifo_pkg::*;
  
  bit clk;
  bit rst_n;
  
  fifo_if fifo_vif_input(.clk(clk), .rst_n(rst_n));
  fifo_if fifo_vif_output(.clk(clk), .rst_n(rst_n));
  
  fifo fifo_dut( 
    .clk(clk),
    .rst_n(rst_n),
    .read_en(fifo_vif_input.read_en),
    .write_en(fifo_vif_input.write_en),
    .data_in(fifo_vif_input.data_in),
    .empty_fifo(fifo_vif_output.empty_fifo),
    .full_fifo(fifo_vif_output.full_fifo),
    .data_out(fifo_vif_output.data_out)
);
  
  initial begin
    rst_n = 1'b0;
    clk = 1'b1;
    #35 rst_n = 1'b1;
  end

  always #5 clk = ~clk;
  
  initial begin
    uvm_config_db#(virtual fifo_if)::set(null, "uvm_test_top.agent.input_intf", "fifo_if", fifo_vif_input);
    uvm_config_db#(virtual fifo_if)::set(null, "uvm_test_top.monitor.output_intf", "fifo_if", fifo_vif_output);

    run_test();
  end
  
endmodule: top_tb