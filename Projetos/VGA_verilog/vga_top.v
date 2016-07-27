module VGA (CLOCK_50, KEY, VGA_R, VGA_G, VGA_B, VGA_HS, VGA_VS, VGA_BLANK_N, VGA_SYNC_N, VGA_CLK);

input CLOCK_50;
input [3:0] KEY;

output VGA_HS, VGA_VS, VGA_SYNC_N, VGA_BLANK_N;
output [7:0] VGA_R, VGA_B, VGA_G;
output VGA_CLK;

wire [23:0] rgb;
wire full, empty;
wire [7:0] r, g, b;
//assign r = 0;
//assign g = 255;
//assign b = 0;

assign VGA_SYNC_N = 1'b1;
assign VGA_BLANK_N = 1'b1;

wire clk25;

assign VGA_CLK = clk25;

PLL pelele(.clkRef(CLOCK_50), .clkOut(clk25), .reset(~KEY[1]));
PixelLogic pixellog(.clk(clk25), .reset(~KEY[0]), .red(r), .green(g), .blue(b), .r(VGA_R), .g(VGA_G), .b(VGA_B), .hsync(VGA_HS), .vsync(VGA_VS));
ControladorSDRAM_VGA controller(.blue(b), .red(r), .green(g), .full(full), .empty(empty), .datain(rgb), .clk(CLOCK_50));
FIFO_syn buffer(.clk(CLOCK_50), .rst(~KEY[0]), .wr_cs(), .rd_cs(), .data_in(), .rd_en(), .wr_en(), .data_out(rgb), .empty(empty), .full(full));

endmodule
