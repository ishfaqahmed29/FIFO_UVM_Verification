# SYNCHRONOUS FIFO TESTBENCH 

![Capture1](https://user-images.githubusercontent.com/34355989/115605371-6f4a0d80-a2b0-11eb-9568-1a6a4306051c.PNG)

- Just getting familiar with SystemVerilog, UVM and making testbenches
- Device Under Test (DUT) is a single-clock Register-based FIFO 
- The circular buffer has a maximum capacity of 16, with an active LOW Reset
- Has Enable signals for READ and WRITE operations, and flags to determine EMPTY and FULL status
- Made reusable testbench components like sequences, drivers, monitors, agents
