package shared_pkg;
    parameter FIFO_WIDTH = 16;
    parameter FIFO_DEPTH = 8;
    parameter max_fifo_addr = $clog2(FIFO_DEPTH);
    int error_count , correct_count;
    int RD_EN_ON_DIST = 30;
    int WR_EN_ON_DIST = 70;

endpackage      

