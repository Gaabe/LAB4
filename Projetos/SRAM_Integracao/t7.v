module t7 (
	input wire [7:0] FIFO_Red,
	input wire [7:0] FIFO_Green,
	input wire [7:0] FIFO_Blue,
	input wire [7:0] Sprites_Red,
	input wire [7:0] Sprites_Green,
	input wire [7:0] Sprites_Blue,
	output wire [7:0] VGA_R,
	output wire [7:0] VGA_G,
	output wire [7:0] VGA_B
);

assign VGA_R = (Sprites_Red == 0 && Sprites_Green == 0 && Sprites_Blue == 0)? FIFO_Red: Sprites_Red;
assign VGA_G = (Sprites_Red == 0 && Sprites_Green == 0 && Sprites_Blue == 0)? FIFO_Green: Sprites_Green;
assign VGA_B = (Sprites_Red == 0 && Sprites_Green == 0 && Sprites_Blue == 0)? FIFO_Blue: Sprites_Blue;

endmodule
