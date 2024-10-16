package FIFO_test;
    import FIFO_env_pkg::*;
    import seq1_pkg::*;
    import seq2_pkg::*;
    import seq3_pkg::*;
    import seq4_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import config_pkg::*;
    import FIFO_agent_pkg::*;
    import uvm_sequencer_pkg::*;

    class fifo_test extends uvm_test;
        `uvm_component_utils(fifo_test)

        fifo_env env;
        FIFO_reset_sequence FIFO_reset_sequence_inst; //seq1
        FIFO_WRITE_sequence FIFO_WRITE_sequence_inst;  //seq2
        FIFO_READ_sequence FIFO_READ_sequence_inst;  //seq3
        FIFO_READ_WRITE_sequence FIFO_READ_WRITE_sequence_inst;  //seq4


        fifo_config_obj fifo_config_obj_test;


        function new(string name = "fifo_test" , uvm_component parent = null);
            super.new(name, parent);
        endfunction //new()

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            env = fifo_env::type_id::create("env",this);
            fifo_config_obj_test = fifo_config_obj::type_id::create("fifo_config_obj_test");
            //
            FIFO_reset_sequence_inst = FIFO_reset_sequence::type_id::create("FIFO_reset_sequence_inst");
            FIFO_WRITE_sequence_inst = FIFO_WRITE_sequence::type_id::create("FIFO_WRITE_sequence_inst");
            FIFO_READ_sequence_inst = FIFO_READ_sequence::type_id::create("FIFO_READ_sequence_inst");
            FIFO_READ_WRITE_sequence_inst = FIFO_READ_WRITE_sequence::type_id::create("FIFO_READ_WRITE_sequence_inst");
            //
            if(!uvm_config_db #(virtual FIFO_if)::get(this , "" , "FIFO_IF" , fifo_config_obj_test.fifo_config_vif))
            `uvm_fatal("build_phase" , "Test - unable to get the virtual interface");

            uvm_config_db #(fifo_config_obj)::set(this, "*" , "CFG" , fifo_config_obj_test );
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);
            `uvm_info("run_phase","inside the FIFO test seq1" , UVM_MEDIUM)
            FIFO_reset_sequence_inst.start(env.agt.sqr);

            `uvm_info("run_phase","inside the FIFO test seq2" , UVM_MEDIUM)
            FIFO_WRITE_sequence_inst.start(env.agt.sqr);

             `uvm_info("run_phase","inside the ALSU test seq3" , UVM_MEDIUM)
            FIFO_READ_sequence_inst.start(env.agt.sqr);

            `uvm_info("run_phase","inside the ALSU test seq4" , UVM_MEDIUM)
            FIFO_READ_WRITE_sequence_inst.start(env.agt.sqr);
            phase.drop_objection(this);
        endtask

    endclass:fifo_test

endpackage

