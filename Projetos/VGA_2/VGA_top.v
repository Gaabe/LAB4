//module VGA (CLOCK_50, KEY, VGA_R, VGA_G, VGA_B, VGA_HS, VGA_VS, VGA_BLANK_N, VGA_SYNC_N, VGA_CLK);
module VGA (CLOCK_50, data_in, full, wr_en, KEY, VGA_R, VGA_G, VGA_B, VGA_HS, VGA_VS, VGA_BLANK_N, VGA_SYNC_N, VGA_CLK);

input [31:0] data_in;
input wr_en;
output full;

input CLOCK_50;
input [3:0] KEY;

output VGA_HS, VGA_VS, VGA_SYNC_N, VGA_BLANK_N;
output [7:0] VGA_R, VGA_B, VGA_G;
output VGA_CLK;

wire full, empty;
wire [7:0] r, g, b, data_R, data_B, data_G;


wire [15:0] membank0, membank1;
wire [31:0] data_in;

//assign data_in = {membank0, membank1};

assign VGA_SYNC_N = 1'b1;
assign VGA_BLANK_N = 1'b1;

wire rd_en, wr_en;
wire clk25, clk100;
wire rstSignal;

assign VGA_CLK = clk25;

//PLL pelele(.clkRef(CLOCK_50), .clkOut(clk25), .clk100(clk100) , .reset(~KEY[0]), .rstOut(rstSignal));
PixelLogic pixellog(.clk(clk25), .reset(rstSignal), .red(r), .green(g), .blue(b), .r(VGA_R), .g(VGA_G), .b(VGA_B), .hsync(VGA_HS), .vsync(VGA_VS), .row(), .column());
FIFO_reader mux(.clk(clk100), .rst(rstSignal) , .data_R(data_R), .data_G(data_G), .data_B(data_B), .red(r), .green(g), .blue(b), .empty(empty), .rd_en(rd_en));
FIFO buffer(.clk(clk100), .rst(rstSignal), .data_in(data_in), .rd_en(rd_en), .wr_en(wr_en), .data_R(data_R), .data_G(data_G), .data_B(data_B), .empty(empty), .full(full));
//FIFO_writer sdram_control(.full(full), .wr_en(wr_en), .data0(membank0), .data1(membank1));

endmodule
