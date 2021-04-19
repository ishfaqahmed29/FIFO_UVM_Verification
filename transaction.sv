import uvm_pkg::*;
`include "uvm_macros.svh"

// ----DATA TRANSACTION----

class data_item extends uvm_sequence_item;
  rand bit              rst;
  rand logic 		        read_en;
  rand logic 		        write_en;
  rand logic [31:0]     data_in;
  rand logic		        empty_fifo;
  rand logic		        full_fifo;
  rand logic [31:0]     data_out;
  
  function new(string name = "data_item");
    super.new(name);
  endfunction: new
  
  `uvm_object_utils_begin(data_item)
    `uvm_field_int(rst, UVM_DEFAULT)
  	`uvm_field_int(read_en, UVM_DEFAULT)
  	`uvm_field_int(write_en, UVM_DEFAULT)
    `uvm_field_int(data_in, UVM_DEFAULT)
  	`uvm_field_int(empty_fifo, UVM_DEFAULT)
  	`uvm_field_int(full_fifo, UVM_DEFAULT)
  	`uvm_field_int(data_out, UVM_DEFAULT)
  `uvm_object_utils_end
  
endclass: data_item
