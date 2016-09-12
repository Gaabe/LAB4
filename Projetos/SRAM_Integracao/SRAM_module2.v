module SRAM_module(clk, reset, rd_en, lineNumber, spriteNumber, valid_rd, q);

input clk, reset, rd_en;
input [3:0] lineNumber;
input [4:0] spriteNumber;

output valid_rd;
output [15:0] q;

wire [19:0] address;

sram_fsm_quartus controller(.reset(reset),.clock(clk),.wr_en(1'b0),.rd_en(rd_en),.valid_rd(valid_rd));
ram_megafunction sram(.address(address), .clock(clk), .data(16'd0), .wren(1'b0), .rden(rd_en), .q(q));
sram_addr_decoder dec(.lineNumber(lineNumber), .spriteNumber(spriteNumber), .address(address));

endmodule

