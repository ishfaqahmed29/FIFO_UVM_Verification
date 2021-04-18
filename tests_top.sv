import uvm_pkg::*;
`include "uvm_macros.svh"

// ----TEST TOPOLOGY----

class fifo_base_test extends uvm_test;
    `uvm_component_utils(fifo_base_test)

    fifo_env env;
    uvm_table_printer printer;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = fifo_env::type_id::create("env", this);
        printer = new();
        printer.knobs.depth = 6;
    endfunction: build_phase

    function void end_of_elaboration_phase(uvm_phase phase);
        `uvm_info(get_type_name(), $sformatf("Printing the test topology :\n%s", this.sprint(printer)), UVM_DEBUG)
    endfunction: end_of_elaboration_phase

    virtual task run_phase(uvm_phase phase);
        phase.phase_done.set_drain_time(this, 50);
    endtask: run_phase

endclass: fifo_base_test


class sample_test extends fifo_base_test;
    `uvm_component_utils(sample_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction: build_phase

    virtual task run_phase(uvm_phase phase);
        random_sequence seq;

        super.run_phase(phase);
        phase.raise_objection(this);
        seq = random_sequence::type_id::create("seq");
        seq.start(env.penv_in.agent.sequencer);
        phase.drop_objection(this);
    endtask: run_phase

endclass: sample_test    