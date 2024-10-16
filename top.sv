import uvm_pkg::*;
`include "uvm_macros.svh"
import FIFO_test::*;
module top();

    bit clk;

    initial begin
        forever begin
            #1 clk = ~clk;
        end
    end

    FIFO_if FIFOif (clk);

    FIFO DUT (FIFOif);

    bind FIFO FIFO_sva binding(FIFOif.data_in , FIFOif.rst_n , FIFOif.wr_en , FIFOif.rd_en , FIFOif.data_out , 
    FIFOif.wr_ack , FIFOif.overflow , FIFOif.full , FIFOif.empty , FIFOif.almostfull , FIFOif.almostempty , 
    FIFOif.underflow , FIFOif.clk , DUT.wr_ptr , DUT.rd_ptr , DUT.count );


    initial begin
        uvm_config_db#(virtual FIFO_if)::set(null , "uvm_test_top" , "FIFO_IF" , FIFOif);
        run_test("fifo_test");
    end

endmodule

