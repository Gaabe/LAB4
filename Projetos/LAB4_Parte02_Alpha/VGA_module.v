module VGA_module	(	clk75, clk25, clk_sync, reset, 																	// interface PLL
							data_bgr, wr_en, freeslots,													// interface SDRAM
							VGA_B, VGA_G, VGA_R, VGA_HS, VGA_VS, VGA_SYNC_N, VGA_BLANK_N, 	// interface DAC
							row, column																					// interface interna
						);

input clk75, clk25, reset, clk_sync;

input [23:0] data_bgr;
output [6:0] freeslots;
wire [6:0] wrusedw;
input wr_en;

output VGA_HS, VGA_VS, VGA_SYNC_N, VGA_BLANK_N;
output [7:0] VGA_R, VGA_G, VGA_B;
output [9:0] row, column;

wire resetSig, rd_enSig, emptySig, rstVGASig, videoon;
wire [23:0] data_pxSig;
wire [7:0] redSig, greenSig, blueSig;

wire [23:0] data_rgb;

assign resetSig = ~reset;

//assign data_rgb = 24'hcccccc;
assign data_rgb[23:16] = data_bgr[7:0];
assign data_rgb[15:8] = data_bgr[15:8];
assign data_rgb[7:0] = data_bgr[23:16];

assign redSig = data_pxSig[23:16];
assign greenSig = data_pxSig[15:8];
assign blueSig = data_pxSig[7:0];

assign VGA_SYNC_N = 1'b1;
assign VGA_BLANK_N = VGA_HS | VGA_VS;

assign rd_enSig = videoon & ~emptySig;
assign freeslots = 7'd64 - wrusedw;

//FIFO buffer (	.clk(clk75),
//					.data_in(data_rgb),
//					.rd_en(rd_enSig),
//					.rst(resetSig),
//					.wr_en(wr_en),
//					.data_pixel(data_pxSig),
//					.empty(emptySig),
//					.freeslots(freeslots)
//				);

VGA_fifoIP buffer	(.aclr(resetSig),
						.data(data_rgb),
						.rdclk(clk25),
						.rdreq(rd_enSig),
						.wrclk(clk75),
						.wrreq(wr_en),
						.q(data_pxSig),
						.rdempty(emptySig),
						.wrfull(),
						.wrusedw(wrusedw)
						);
				
FIFO_reader controller 	(	.clk25(clk_sync),
									.empty(emptySig),
									.rst(resetSig),
									.rstVGA(rstVGASig),
									.vga_started()
								);
					
PixelLogic dac_interface	(	.red(redSig),	
										.green(greenSig),
										.blue(blueSig),
										.clk(clk25),
										.reset(rstVGASig),
										.r(VGA_R),
										.g(VGA_G),
										.b(VGA_B),
										.hsync(VGA_HS),
										.vsync(VGA_VS),
										.column(column),
										.row(row),
										.videoon(videoon)
									);
						
						
endmodule
