`timescale 1ns / 1ps

// ------DUT-------

module fifo(
  input                   clk,
  input                   rst_n,
  input                   read_en,
  input                   write_en,
  input   [WIDTH-1:0]     data_in,
  output                  empty_fifo,     // Active LOW signal
  output                  full_fifo,      // Active LOW signal
  output  [WIDTH-1:0]     data_out
);
  
  parameter WIDTH = 32;
  parameter DEPTH = 16;
  parameter CTR_SIZE = 5;

  reg [CTR_SIZE:0]      write_addr_reg;
  reg [CTR_SIZE:0]      read_addr_reg;
  reg                   empty_fifo;
  reg                   full_fifo;
  reg [WIDTH-1:0]       data_out;
  
  reg [WIDTH-1:0]       fifo_buffer [DEPTH-1:0];          
  
  
  wire  [CTR_SIZE-1:0]  write_pointer;      // Pointer to write data to FIFO
  wire  [CTR_SIZE-1:0]  read_pointer;       // Pointer to read data from FIFO
  wire                  empty;
  wire                  full;
  wire  [DEPTH:0]       counter;                               
  wire                  read_ready;         // Prevents read from empty FIFO
  wire                  write_ready;        // Prevents write to full FIFO
  

  
  assign counter = write_addr_reg - read_addr_reg;
  assign empty = (counter == 5'b00000 || read_addr_reg + 1 == write_addr_reg);      // Condition for EMPTY_FIFO
  assign full = (counter == 5'b10000 || write_addr_reg + 1 == read_addr_reg);       // Condition for FULL_FIFO
  assign write_pointer = write_addr_reg[CTR_SIZE-1:0];		              
  assign read_pointer = read_addr_reg[CTR_SIZE-1:0];
  assign read_ready = (read_en && empty == 1'b0);
  assign write_ready = (write_en && full == 1'b0);
  			              
  
// FIFO read/write logic, increment pointer to update location
  
  always @ (posedge clk) begin
    if (!rst_n)begin
      write_addr_reg <= 0;
      read_addr_reg <= 0;
      counter <= 0;
    end
    else begin
      if (read_ready) begin
        data_out <= fifo_buffer[read_pointer];
        if (read_addr_reg == DEPTH - 1) begin
          read_addr_reg <= 0;
        end
        else begin
          read_addr_reg++;  
        end
      end
      else if (write_ready) begin
      	fifo_buffer[write_pointer] <= data_in;
        if (write_addr_reg == DEPTH - 1) begin
          write_addr_reg <= 0;
        end
      	else begin
          write_addr_reg++;
        end
      end
    end
  end
  
// Assign Latch to set synchronous EMPTY/FULL flags

  always @ (empty or full) begin
    empty_fifo <= ~empty;
    full_fifo <= ~full;
  end
  
endmodule: fifo

// -----INTERFACE------

interface fifo_if;
  bit                 clk, 
  bit                 rst_n, 
  logic               read_en, 
  logic               write_en, 
  logic [WIDTH-1:0]   data_in,
  logic               empty_fifo,
  logic               full_fifo,
  logic [WIDTH-1:0]   data_out
endinterface: fifo_if
