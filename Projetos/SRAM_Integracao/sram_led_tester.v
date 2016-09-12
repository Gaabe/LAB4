module sram_led_tester(KEY, SW, CLOCK_50, LEDR, SRAM_ADDR, SRAM_DQ, SRAM_WE_N, SRAM_CE_N, SRAM_OE_N, SRAM_UB_N, SRAM_LB_N);

input [3:0] KEY;
input [17:0] SW;
input CLOCK_50;

output [19:0] SRAM_ADDR;
output [17:0] LEDR;
inout [15:0] SRAM_DQ;
output SRAM_WE_N, SRAM_CE_N, SRAM_OE_N, SRAM_UB_N, SRAM_LB_N;

//wire clk125;

//pelele pll(.inclk0(CLOCK_50), .c0(clk125));
sram_fsm controller(.CE_N(SRAM_CE_N), .LB_N(SRAM_LB_N), .OE_N(SRAM_OE_N), .UB_N(SRAM_UB_N), .WE_N(SRAM_WE_N), .rd_valid(), .wr_valid(), .clk(CLOCK_50), .rd_en(1'b1), .reset(~KEY[0]), .wr_en(1'b0));
sram_addr_decoder dec(.lineNumber(SW[3:0]), .spriteNumber(5'd0), .address(SRAM_ADDR));

assign LEDR[15:0] = SRAM_DQ;


endmodule
