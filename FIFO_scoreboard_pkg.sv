package FIFO_scoreboard_pkg;
    import uvm_pkg::*;
    import shared_pkg::*;
    `include "uvm_macros.svh"
    import FIFO_seq_item_pkg::*;

    class FIFO_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(FIFO_scoreboard)

        uvm_analysis_export #(FIFO_seq_item) sb_export;
        uvm_tlm_analysis_fifo #(FIFO_seq_item) sb_fifo;
        FIFO_seq_item seq_item_sb;

        bit [FIFO_WIDTH-1:0] data_out_ref;
        bit wr_ack_ref, overflow_ref;
        bit full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref;

        bit [FIFO_WIDTH - 1 : 0] fifo_q [$];

        bit rd_old , wr_old;

        int error_count = 0;
        int correct_count = 0;

        function new (string name = "FIFO_scoreboard" , uvm_component parent = null);
            super.new(name , parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            sb_export = new("sb_export" , this);
            sb_fifo = new("sb_fifo" , this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            sb_export.connect(sb_fifo.analysis_export);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                sb_fifo.get(seq_item_sb);
                ref_model(seq_item_sb);
                if(seq_item_sb.data_out != data_out_ref) begin
                    `uvm_error("run_phase" , "comparison_failed ")
                    $display("comparison_failed out_ref = %d , out = %d" , data_out_ref , seq_item_sb.data_out);
                    error_count++;
                end
                else
                    correct_count++;
            end
        endtask

        task ref_model(FIFO_seq_item seq_item_chk);
        //golden model//
            if(~seq_item_chk.rst_n) begin
                while(fifo_q.size()!==0) begin
                    data_out_ref = fifo_q.pop_front();
                end
                data_out_ref = 0;
                wr_ack_ref=0;
                overflow_ref = 0;
                full_ref=0;
                empty_ref=0; 
                almostfull_ref=0;
                almostempty_ref=0;
                underflow_ref=0;
            end
            else begin
                wr_ack_ref=0;
                overflow_ref = 0;
                full_ref=0;
                empty_ref=0; 
                almostfull_ref=0;
                almostempty_ref=0;
                underflow_ref=0;


                if(fifo_q.size() == 0 && seq_item_chk.rd_en == 1) begin
                    empty_ref = 1;
                    underflow_ref = 1;
                end
                else if(fifo_q.size() == 0) begin
                    empty_ref = 1;
                end
                else if(fifo_q.size() == 1) begin
                    almostempty_ref = 1;
                end
                else if((fifo_q.size() == (FIFO_DEPTH)) && seq_item_chk.wr_en ==1) begin
                    full_ref = 1;
                    overflow_ref = 1;
                    wr_ack_ref = 0;
                end
                else if(fifo_q.size() == (FIFO_DEPTH)) begin
                    full_ref = 1;
                    wr_ack_ref = 0;
                end
                else if(fifo_q.size() == (FIFO_DEPTH -1)) begin
                    almostfull_ref = 1;
                end

                if(seq_item_chk.rd_en && !empty_ref) begin
                    rd_old = 1;
                    if(fifo_q.size() ==0 || empty_ref)
                        data_out_ref = data_out_ref;
                    else begin
                        data_out_ref = fifo_q.pop_front();
                        $display(fifo_q);     
                    end
                end

                else begin
                    rd_old = 0;
                end

                if(seq_item_chk.wr_en && !full_ref) begin
                    fifo_q.push_back(seq_item_chk.data_in);
                    wr_ack_ref = 1;
                    $display(fifo_q);
                end
            end
    endtask
        
    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("report_phase" , $sformatf("number of correct is %0d" , correct_count) , UVM_MEDIUM);
        `uvm_info("report_phase" , $sformatf("number of errors is %0d" , error_count) , UVM_MEDIUM);
    endfunction
    endclass
endpackage

