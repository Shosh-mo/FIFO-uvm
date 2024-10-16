package coverage_collector_pkg;
    import uvm_pkg::*;
    import FIFO_seq_item_pkg::*;
    import shared_pkg::*;
    `include "uvm_macros.svh"

    class FIFO_coverage extends uvm_component;
        `uvm_component_utils(FIFO_coverage)

        uvm_analysis_export #(FIFO_seq_item) cov_export;
        uvm_tlm_analysis_fifo #(FIFO_seq_item) cov_fifo;
        FIFO_seq_item seq_item_cov;

        //////////////cover group///////////////
            covergroup cvr_gp;
            wr_en_cp:coverpoint seq_item_cov.wr_en;
            rd_en_cp:coverpoint seq_item_cov.rd_en;
            wr_ack_cp:coverpoint seq_item_cov.wr_ack;
            overflow_cp: coverpoint seq_item_cov.overflow;
            full_cp:coverpoint seq_item_cov.full;
            empty_cp:coverpoint seq_item_cov.empty;
            almostfull_cp:coverpoint seq_item_cov.almostfull;
            almostempty_cp:coverpoint seq_item_cov.almostempty;
            underflow_cp:coverpoint seq_item_cov.underflow;

            cross wr_en_cp , rd_en_cp , wr_ack_cp{
                ignore_bins bi1 = binsof(wr_en_cp) intersect {0} && binsof(wr_ack_cp) intersect{1};
            }
            cross wr_en_cp , rd_en_cp , overflow_cp{
                ignore_bins bi2 = binsof(wr_en_cp) intersect {0} && binsof(overflow_cp) intersect{1};
            }
            cross wr_en_cp , rd_en_cp , full_cp{
                ignore_bins bi3 = binsof(rd_en_cp) intersect {1} && binsof(full_cp) intersect{1};
            }
            cross wr_en_cp , rd_en_cp , empty_cp;
            cross wr_en_cp , rd_en_cp , almostfull_cp;
            cross wr_en_cp , rd_en_cp , almostempty_cp;
            cross wr_en_cp , rd_en_cp , underflow_cp{
                ignore_bins bi4 = binsof(rd_en_cp) intersect {0} && binsof(underflow_cp) intersect{1};
            }

        endgroup
        /////////////////////////////////////////

        function new (string name = "FIFO_coverage" , uvm_component parent = null);
            super.new(name , parent);
            //creating the cover group
            cvr_gp = new();
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            cov_export = new("cov_export" , this);
            cov_fifo = new("cov_fifo" , this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            cov_export.connect(cov_fifo.analysis_export);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                cov_fifo.get(seq_item_cov);
                cvr_gp.sample();
            end
        endtask
    endclass
endpackage
