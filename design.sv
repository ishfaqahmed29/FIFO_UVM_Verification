`timescale 1ns / 1ps

// ------DUT-------

module fifo(
  input             clk,
  input             rst,
  input             read_en,
  input             write_en,
  input [31:0]      data_in,
  output            empty_fifo,                     // Active low signal
  output            full_fifo,                      // Active low signal
  output [31:0]     data_out
);
  
  reg [3:0]         write_ptr;
  reg [3:0]         read_ptr;
  reg               empty_fifo;
  reg               full_fifo;
  reg [31:0]        data_out;
  
  reg [31:0]        fifo_buffer [7:0];          
  
  
  wire [2:0]        write_pointer;
  wire [2:0]        read_pointer;
  wire              empty;
  wire              full;
  wire              do_read;
  wire              do_write;
  wire [3:0]        read_write; 				    // Prevents reads from empty FIFO, and stop writes to full FIFO
  
  
  assign read_write = write_ptr - read_ptr;
  assign empty = (read_write == 4'b0000);
  assign full = (read_write == 4'b1000);
  assign write_pointer = write_ptr[2:0];		    // Pointer to write data to FIFO
  assign read_pointer = read_ptr[2:0];			    // Pointer to read data from FIFO
  assign do_read = (read_en && empty == 1'b0);
  assign do_write = (write_en && full == 1'b0);
  
  
  always @ (posedge clk) begin
    if (rst)begin
     // for (int i = 0; i < 8; i++)begin
     //   fifo_buffer[i] <= 0;
     // end
        write_ptr <= 3'b000;
        read_ptr <= 3'b000;
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
  logic             clk, 
  logic             rst, 
  logic             read_en, 
  logic             write_en, 
  logic [31:0]      data_in,
  logic             empty_fifo,
  logic             full_fifo,
  logic [31:0]      data_out
endinterface: fifo_if