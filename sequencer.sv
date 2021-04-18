import uvm_pkg::*;
`include "uvm_macros.svh"

// ----SEQUENCER---- 

class fifo_sequencer extends uvm_sequencer #(data_item);
    `uvm_component_utils(fifo_sequencer)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new

endclass: fifo_sequencer

// ----SEQUENCE INSTANCES----
// test1 : i)  write FIFO from empty -> full 
//         ii) read FIFO from full -> empty 
// test2 : i)  write FIFO from empty -> half-full 
//         ii) read/write concurrently
// reset : Toggles "rst"

class fifo_seq_test1 extends uvm_sequence #(data_item);
    `uvm_object_utils(fifo_seq_test1)
  
  data_item seq;
  
  function new (string name = "fifo_seq_test1");
    super.new(name);
  endfunction: new
  
  task body();
    for(int i = 0; i < 20; i++)begin
      seq = data_item::type_id::create("write_seq");
      start_item(seq);

      if(i < 10)begin
          if(!seq.randomize() with {seq.write_en == 1'b1; seq.read_en == 1'b0;})begin
              `uvm_error("Sequence", "Randomization failed for sequence ")
        end
      end
      else begin
          if(!seq.randomize() with {seq.write_en == 1'b0; seq.read_en == 1'b1;})begin
              `uvm_error("Sequence", "Randomization failed for sequence ")
          end
      end

      finish_item(seq);
    end
  endtask: body
  
endclass: fifo_seq_test1

class fifo_seq_test2 extends uvm_sequence #(data_item);
    `uvm_object_utils(fifo_seq_test2)

    data_item seq;

  function new (string name = "fifo_seq_test2");
    super.new(name);
  endfunction: new

  task body();
    for(int i = 0; i < 40; i++)begin
      seq = data_item::type_id::create("read_seq");
      start_item(seq);

      if(i < 4)begin
          if(!seq.randomize() with {seq.write_en == 1'b1; seq.read_en == 1'b0;})begin
              `uvm_error("Sequence", "Randomization failed for sequence ")
        end
      end
      else begin
          if(!seq.randomize() with {seq.write_en == 1'b1; seq.read_en == 1'b1;})begin
              `uvm_error("Sequence", "Randomization failed for sequence ")
          end
      end

      finish_item(seq);
    end
  endtask: body

endclass: fifo_seq_test2

class fifo_seq_reset extends uvm_sequence #(data_item);
    `uvm_object_utils(fifo_seq_reset)
    
    data_item seq;

    function new(string name = "fifo_seq_reset");
        super.new(name);
    endfunction: new

    task body();
        seq = data_item::type_id::create("reset_seq");
        start.item(seq);
        seq.rst = 1'b1;
        finish.item(seq);

        seq = data_item::type_id::create("reset_seq");
        start.item(seq);
        seq.rst = 1'b0;
        finish.item(seq);        
    endtask

endclass: fifo_seq_reset