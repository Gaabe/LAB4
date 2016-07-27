module FIFO_syn (clk, rst, wr_cs, rd_cs, data_in, rd_en, wr_en, data_out, empty, full);

input clk, rst, wr_cs, rd_cs, rd_en, wr_en ;
input [31:0] data_in ;
output full, empty;
output [23:0] data_out;

endmodule
