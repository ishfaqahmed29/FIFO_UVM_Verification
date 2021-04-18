`ifndef FIFO_PKG__SV
`define FIFO_PKG__SV

package fifo_pkg;

	import uvm_pkg::*;
	`include "uvm_macros.svh"
	`include "transaction.sv"
	`include "driver.sv"
	`include "monitor.sv"
	`include "sequencer.sv"
	`include "agent.sv"
	`include "environments.sv"
	`include "scoreboard.sv"
	`include "coverage.sv"
	`include "tests_top.sv"

endpackage: fifo_pkg