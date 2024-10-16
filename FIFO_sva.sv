import shared_pkg::*;
import FIFO_scoreboard_pkg::*;
import FIFO_seq_item_pkg::*;

module FIFO_sva(data_in , rst_n , wr_en , rd_en , data_out , wr_ack , overflow , full , empty ,
    almostfull ,almostempty , underflow , clk , wr_ptr , rd_ptr , count);

	input clk;
    input [FIFO_WIDTH-1:0] data_in;
    input rst_n, wr_en, rd_en;
    input [FIFO_WIDTH-1:0] data_out;
    input wr_ack, overflow;
    input full, empty, almostfull, almostempty, underflow;
	input [max_fifo_addr-1:0] wr_ptr, rd_ptr;
	input [max_fifo_addr:0] count;


always_comb begin
	if(FIFOif.rst_n == 0) 
		a_reset: assert final(FIFOif.data_out == 0 && wr_ptr == 0 && rd_ptr == 0);
end
//full 
always_comb begin
	if(count == FIFO_DEPTH) 
		a_full: assert final(FIFOif.full == 1);
end
//empty
always_comb begin
	if(count == 0) 
		a_empty: assert final(FIFOif.empty == 1);
end


//almostfull
always_comb begin
	if(count == FIFO_DEPTH - 1) 
		a_almostfull: assert final(FIFOif.almostfull == 1);
end
//almostempty
always_comb begin
	if(count == 1) 
		a_almostempty: assert final(FIFOif.almostempty == 1);
end

//wr_ptr
property p1;
	@(posedge FIFOif.clk)
	disable iff(!FIFOif.wr_en || FIFOif.full || !FIFOif.rst_n || !wr_ptr)
	 (FIFOif.wr_en && !FIFOif.full && FIFOif.rst_n) |=>(wr_ptr == $past(wr_ptr) + 1);
endproperty

//rd_ptr
property p2;
	@(posedge FIFOif.clk)
	disable iff(!FIFOif.rd_en || FIFOif.empty || !FIFOif.rst_n || !rd_ptr)
	 (FIFOif.rd_en && !FIFOif.empty && FIFOif.rst_n) |=>(rd_ptr == $past(rd_ptr) + 1);
endproperty

//overflow
property p3;
	disable iff(~FIFOif.wr_en || ~FIFOif.full)
	@(posedge FIFOif.clk) (FIFOif.wr_en && FIFOif.full) |=>(FIFOif.overflow ==  1);
endproperty

//underflow
property p4;
	@(posedge FIFOif.clk)
	disable iff(~FIFOif.rd_en || ~FIFOif.empty || !FIFOif.rst_n)
	(FIFOif.rd_en && FIFOif.empty && FIFOif.rst_n) |=> (FIFOif.underflow ==  1);
endproperty

//wr_ack
property p5;
	@(posedge FIFOif.clk) 
	disable iff(~FIFOif.wr_en || FIFOif.full || !FIFOif.rst_n) 
	(FIFOif.wr_en && !FIFOif.full && FIFOif.rst_n) |=>(FIFOif.wr_ack ==  1);
endproperty

as1: assert property (p1);
as2: assert property (p2);
as3: assert property (p3);
as4: assert property (p4);
as5: assert property (p5);

c1: cover property(p1);
c2: cover property(p2);
c3: cover property(p3);
c4: cover property(p4);
c5: cover property(p5);

endmodule
