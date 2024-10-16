package seq3_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import FIFO_seq_item_pkg::*;
    import shared_pkg::*;
    class FIFO_READ_sequence extends uvm_sequence #(FIFO_seq_item);
        `uvm_object_utils(FIFO_READ_sequence);
        FIFO_seq_item seq_item;
        int i;

        function new(string name = "FIFO_READ_sequence");
            super.new(name);
        endfunction

        task body;
        for(i=0;i<8;i=i+1) begin
            seq_item = FIFO_seq_item::type_id::create("seq_item");
            start_item(seq_item);
            seq_item.data_in = 0;
            seq_item.rst_n = 1;
            seq_item.wr_en = 0;
            seq_item.rd_en = 1;
            finish_item(seq_item);
        end
        endtask
    endclass
endpackage
