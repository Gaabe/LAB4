module VGA_ftw (CLOCK_50, KEY, VGA_R, VGA_G, VGA_B, VGA_HS, VGA_VS, VGA_BLANK_N, VGA_SYNC_N, VGA_CLK);

input CLOCK_50;
input [3:0] KEY;

output VGA_HS, VGA_VS, VGA_SYNC_N, VGA_BLANK_N;
output [7:0] VGA_R, VGA_B, VGA_G;
output VGA_CLK;

wire [7:0] r, g, b;
assign r = 0;
assign g = 255;
assign b = 0;

assign VGA_SYNC_N = 1'b1;
assign VGA_BLANK_N = 1'b1;

VGA olar(.clk_50(CLOCK_50), .reset(~KEY[0]), .red(r), .green(g), .blue(b), .r(VGA_R), .g(VGA_G), .b(VGA_B), .hsync(VGA_HS), .vsync(VGA_VS), .resetPLL(~KEY[1]), .clkPLL(VGA_CLK));

endmodule
