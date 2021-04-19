`timescale 1ns / 1ps

// -----TOP MODULE (TESTBENCH)-----

module top_tb;
  import uvm_pkg::*;
  import fifo_pkg::*;
  
  bit clk;
  bit rst;
  
  fifo_if fifo_vif_input();
  fifo_if fifo_vif_output();
  
  fifo fifo_dut( 
    .clk(clk),
    .rst(rst),
    .read_en(fifo_vif_input.read_en),
    .write_en(fifo_vif_input.write_en),
    .data_in(fifo_vif_input.data_in),
    .empty_fifo(fifo_vif_output.empty_fifo),
    .full_fifo(fifo_vif_output.full_fifo),
    .data_out(fifo_vif_output.data_out)
);
  
  initial begin
    fifo_vif_input.rst = 1'b1;
    fifo_vif_input.clk = 1'b1;
    #35 rst = 1'b0;
  end

  always #5 clk = ~clk;
  
  initial begin
    uvm_config_db#(virtual fifo_if)::set(uvm_root::get(), "*.agent.*", "input_intf", fifo_vif_input);
    uvm_config_db#(virtual fifo_if)::set(uvm_root::get(), "*.monitor.*", "output_intf", fifo_vif_output);

    run_test();
  end
  
endmodule: top_tb