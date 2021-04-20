`timescale 1ns / 1ps

// ------DUT-------

module fifo(
  input                   clk,
  input                   rst,
  input                   read_en,
  input                   write_en,
  input   [WIDTH-1:0]     data_in,
  output                  empty_fifo,                             // Active low signal
  output                  full_fifo,                              // Active low signal
  output  [WIDTH-1:0]     data_out
);
  
  parameter WIDTH = 32;
  parameter DEPTH = 16;
  parameter PTR_SIZE = 5;

  reg [PTR_SIZE:0]       write_ptr;
  reg [PTR_SIZE:0]       read_ptr;
  reg                    empty_fifo;
  reg                    full_fifo;
  reg [WIDTH-1:0]        data_out;
  
  reg [WIDTH-1:0]        fifo_buffer [DEPTH-1:0];          
  
  
  wire [PTR_SIZE-1:0]    write_pointer;                           // Pointer to write data to FIFO
  wire [PTR_SIZE-1:0]    read_pointer;                            // Pointer to read data from FIFO
  wire                   empty;
  wire                   full;
  wire                   do_read;
  wire                   do_write;
  wire [DEPTH:0]         counter; 				                        // Prevents read from empty FIFO, stops write to full FIFO
  
  
  assign counter = write_ptr - read_ptr;
  assign empty = (counter == 5'b00000);                           // Condition for empty FIFO
  assign full = (counter == 5'b10000);                            // Condition for full FIFO
  assign write_pointer = write_ptr[PTR_SIZE-1:0];		              
  assign read_pointer = read_ptr[PTR_SIZE-1:0];			              
  assign do_read = (read_en && empty == 1'b0);
  assign do_write = (write_en && full == 1'b0);
  
  // FIFO read/write logic, increment pointer to update location
  
  always @ (posedge clk) begin
    if (rst)begin
        write_ptr <= 0;
        read_ptr <= 0;
        counter <= 0;
    end
    else begin
      if (do_read)begin
        read_ptr++; 
      end
    	if (do_write)begin
      	fifo_buffer[write_pointer] <= data_in;
      	write_ptr++;
    end
    end
  end
  
  // Assign Latches to read data and set empty/full flags

  always @ (read_pointer)begin
    data_out <= fifo_buffer[read_pointer-1];
  end
  
  always @ (empty or full)begin
    empty_fifo <= ~empty;
    full_fifo <= ~full;
  end
  
endmodule: fifo

// -----INTERFACE------

interface fifo_if;
  bit                 clk, 
  bit                 rst, 
  logic               read_en, 
  logic               write_en, 
  logic [WIDTH-1:0]   data_in,
  logic               empty_fifo,
  logic               full_fifo,
  logic [WIDTH-1:0]   data_out
endinterface: fifo_if