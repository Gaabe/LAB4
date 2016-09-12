module S2plusS3(clk_25, clk_sync, n_reset, data_color, att_color, FIFO_Red, FIFO_Green, FIFO_Blue, VGA_R, VGA_G, VGA_B, sprite1, sprite2, sprite3, sprite4);

input n_reset, clk_sync, clk_25;

input [23:0] data_color;                    // Dado da cor vindo da mémoria
input att_color;                            // Sinal para atualizar a memória

input [7:0] FIFO_Red;
input [7:0] FIFO_Green;
input [7:0] FIFO_Blue;
	
output [7:0] VGA_R;
output [7:0] VGA_G;
output [7:0] VGA_B;
	
input [14:0] sprite1, sprite2, sprite3, sprite4;

wire [15:0] v0, v1, v2, v3;
wire [4:0] v0_num, v1_num, v2_num, v3_num;

wire [7:0] red, green, blue;
				
S2_module S2(.clk(clk_25), .reset_n(n_reset), .clkPipeline(clk_sync), .sprite0(sprite1), .sprite1(sprite2), .sprite2(sprite3), .sprite3(sprite4),
			.v0(v0), .v1(v1), .v2(v2), .v3(v3), .v0_num(v0_num), .v1_num(v1_num), .v2_num(v2_num), .v3_num(v3_num));
			
t5_t6 S3(.v0(v0), .v1(v1), .v2(v2), .v3(v3), .sp0(v0_num), .sp1(v1_num), .sp2(v2_num), .sp3(v3_num),
			.clock_25(clk_25), .clock_maior(clk_sync), .rst(~n_reset), .att_color(att_color), .data_color(data_color), .blue(blue), .green(green), .red(red));

t7 exibicao(.FIFO_Red(FIFO_Red),.FIFO_Green(FIFO_Green), .FIFO_Blue(FIFO_Blue), .Sprites_Red(red), .Sprites_Green(green),  .Sprites_Blue(blue), .VGA_R(VGA_R), .VGA_G(VGA_G), .VGA_B(VGA_B));
			
endmodule
