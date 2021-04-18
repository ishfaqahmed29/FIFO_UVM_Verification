import uvm_pkg::*;
`include "uvm_macros.svh"

// ----AGENT----

class fifo_agent extends uvm_agent;
    `uvm_component_utils(fifo_agent)
    protected uvm_active_passive_enum is_active = UVM_ACTIVE;

    fifo_sequencer      sequencer;
    fifo_driver         driver;
    fifo_monitor        monitor;

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new


    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(is_active == UVM_ACTIVE)begin
        sequencer = fifo_sequencer::type_id::create("sequencer", this);
        driver = fifo_driver::type_id::create("driver", this);            
        end
        monitor = fifo_monitor::type_id::create("monitor", this);
    endfunction: build_phase


    function void connect_phase(uvm_phase phase);
        if(is_active == UVM_ACTIVE)
        driver.seq_item_port.connect(sequencer.seq_item_export);
        `uvm_info(get_full_name(), "Driver connected to sequencer! ", UVM_LOW)
    endfunction: connect_phase

endclass: fifo_agent

// ----ENVIRONMENTS----

class agent_env extends uvm_env;
    fifo_agent agent;

    `uvm_component_utils(fifo_agent)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent = fifo_agent::type_id::create("agent", this);
    endfunction: build_phase
endclass: agent_env


class fifo_env extends uvm_env;
    `uvm_component_utils(fifo_env)

    agent_env fifo_in_env;
    agent_env fifo_out_env;
    fifo_scoreboard fifo_sb;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        `uvm_config_db#(int)::set(this, "fifo_in_env.agent", "is_active", UVM_ACTIVE);
        `uvm_config_db#(int)::set(this, "fifo_out_env.agent", "is_active", UVM_PASSIVE);

        `uvm_config_db#(string)::set(this, "fifo_in_env.agent.monitor", "monitor_intf", "input_intf");
        `uvm_config_db#(string)::set(this, "fifo_out_env.agent.monitor", "monitor_intf", "output_intf");

        fifo_in_env = agent_env::type_id::create("fifo_in_env", this);
        fifo_out_env = agent_env::type_id::create("fifo_out_env", this);
        sb = fifo_scoreboard::type_id::create("fifo_sb", this);

        `uvm_info(get_full_name(), "Build stage done! ", UVM_LOW)
    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
        fifo_in_env.agent.monitor.pkt_collected_port.connect();
        fifo_out_env.agent.monitor.pkt_collected_port.connect();
        `uvm_info(get_full_name(), "Connect stage done! ", UVM_LOW)
    endfunction: connect_phase

endclass: fifo_env