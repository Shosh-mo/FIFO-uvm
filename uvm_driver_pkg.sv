package uvm_driver_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import config_pkg::*;
    import FIFO_seq_item_pkg::*;

    class FIFO_driver extends uvm_driver#(FIFO_seq_item);

    `uvm_component_utils(FIFO_driver)
    virtual FIFO_if fifo_driver_vif;
    fifo_config_obj fifo_config_obj_driver;
    FIFO_seq_item stim_seq_item;

    function new(string name = "FIFO_driver" , uvm_component parent = null);
        super.new(name , parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(!uvm_config_db #(fifo_config_obj)::get(this , "" , "CFG" , fifo_config_obj_driver)) begin
            `uvm_fatal("build_phase" , "Test - unable to get the virtual interface");
        end
    endfunction

    function void connect_phase(uvm_phase phase);
        fifo_driver_vif = fifo_config_obj_driver.fifo_config_vif;
    endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);    
            forever begin
                stim_seq_item = FIFO_seq_item::type_id::create("stim_seq_item");

                seq_item_port.get_next_item(stim_seq_item);

                fifo_driver_vif.rst_n = stim_seq_item.rst_n; 
                fifo_driver_vif.wr_en = stim_seq_item.wr_en;
                fifo_driver_vif.rd_en = stim_seq_item.rd_en; 
                fifo_driver_vif.data_in = stim_seq_item.data_in; 

                @(negedge fifo_driver_vif.clk);

                seq_item_port.item_done();
                `uvm_info("run_phase" , stim_seq_item.convert2string_stimilus() , UVM_HIGH)
            end
        endtask
    endclass
endpackage

