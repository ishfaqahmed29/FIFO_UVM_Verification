# SYNCHRONOUS FIFO TESTBENCH 

![FIFO](https://user-images.githubusercontent.com/34355989/131266987-d41cd93f-4aff-4437-a54e-0e49d5e2a28b.jpg)

- Getting familiar with SystemVerilog and UVM Testbenches
- Device Under Test (DUT) is a single-clock Register-based FIFO 
- The circular buffer has a maximum capacity of 16, with an active LOW Reset
- Has Enable signals for READ and WRITE operations, and flags to determine EMPTY and FULL status
- Made reusable testbench components like sequences, drivers, monitors, agents
