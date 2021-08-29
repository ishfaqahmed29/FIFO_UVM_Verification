import uvm_pkg::*;
`include "uvm_macros.svh"

// ----SEQUENCER---- 

class fifo_sequencer extends uvm_sequencer #(data_item);
    `uvm_component_utils(fifo_sequencer)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new

endclass: fifo_sequencer

/* ----SEQUENCE INSTANCES----
Non-Reset test-1 :  i)  write FIFO from empty -> full -> wrap
                    ii) read FIFO from full -> empty -> wrap

Non-Reset test-2 :  i)  write FIFO from empty -> half-full 
                    ii) read/write concurrently

Reset test :    Toggles "rst_n"
*/

class fifo_seq_test1 extends uvm_sequence #(data_item);
    `uvm_object_utils(fifo_seq_test1)
  
  data_item seq;
  int loop1 = 48;
  int loop2 = 22;
  
  function new(string name = "fifo_seq_test1", uvm_component parent);
    super.new(name);
  endfunction: new
  
  task body();
    for (int i = 0; i < loop1; i++) begin
      seq = data_item::type_id::create("write_seq");
      start_item(seq);
      if (i < loop2) begin
        if (!seq.randomize() with {seq.read_en == 1'b0; seq.write_en == 1'b1;}) begin
          `uvm_error("Sequence", "Randomization failed for Write sequence ")
        end
      end
      else begin
        if (!seq.randomize() with {seq.read_en == 1'b1; seq.write_en == 1'b0}) begin
          `uvm_error("Sequence", "Randomization failed for Read sequence ")
        end
      end
      finish_item(seq);
    end
  endtask: body
  
endclass: fifo_seq_test1

class fifo_seq_test2 extends uvm_sequence #(data_item);
    `uvm_object_utils(fifo_seq_test2)

    data_item seq;
    int loop1 = 68;
    int loop2 = 8;

  function new(string name = "fifo_seq_test2", uvm_component parent);
    super.new(name);
  endfunction: new

  task body();
    for (int i = 0; i < loop1; i++) begin
      seq = data_item::type_id::create("read_seq");
      start_item(seq);
      if (i < loop2) begin
        if (!seq.randomize() with {seq.read_en == 1'b0; seq.write_en == 1'b1;}) begin
          `uvm_error("Sequence", "Randomization failed for Write sequence ")
        end
      end
      else begin
        if (!seq.randomize() with {seq.read_en == 1'b1; seq.write_en == 1'b1;}) begin
          `uvm_error("Sequence", "Randomization failed for Read sequence ")
        end
      end
      finish_item(seq);
    end
  endtask: body

endclass: fifo_seq_test2

class fifo_seq_reset extends uvm_sequence #(data_item);
    `uvm_object_utils(fifo_seq_reset)
    
    data_item seq;

    function new(string name = "fifo_seq_reset", uvm_component parent);
      super.new(name);
    endfunction: new

    task body();
      seq = data_item::type_id::create("reset_seq");
      start_item(seq);
      seq.rst_n = 1'b1;
      @(posedge vif.clk);
      seq.rst_n = 1'b0;
      finish_item(seq);        
    endtask

endclass: fifo_seq_reset