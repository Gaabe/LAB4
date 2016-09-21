module spriter_module(	clk_125, clk_25, clk_sync, address, rwenable, datain, row, column,
								n_reset, data_color, att_color, FIFO_Red, FIFO_Green, FIFO_Blue,
								VGA_R, VGA_G, VGA_B);

input [4:0] address;
input rwenable;
input [18:0] datain;

input n_reset, clk_125, clk_sync, clk_25;
input [9:0] row, column;

input [23:0] data_color;                    // Dado da cor vindo da mémoria
input att_color;                            // Sinal para atualizar a memória

input [7:0] FIFO_Red;
input [7:0] FIFO_Green;
input [7:0] FIFO_Blue;
	
output [7:0] VGA_R;
output [7:0] VGA_G;
output [7:0] VGA_B;
	
wire [14:0] sprite0, sprite1, sprite2, sprite3;

wire [15:0] v0, v1, v2, v3;
wire [4:0] v0_num, v1_num, v2_num, v3_num;

wire [7:0] red, green, blue;


S1_module S1(.clk_125(clk_125), .clk_sync(clk_sync), .address(address), .rwenable(rwenable), .datain(datain), .clk_25(clk_25),
				.row(row), .column(column), .n_reset(n_reset), .sprite0(sprite0), .sprite1(sprite1), .sprite2(sprite2), .sprite3(sprite3));
				
S2_module S2(.clk(clk_25), .reset_n(n_reset), .clkPipeline(clk_sync), .sprite0(sprite0), .sprite1(sprite1), .sprite2(sprite2), .sprite3(sprite3),
			.v0(v0), .v1(v1), .v2(v2), .v3(v3), .v0_num(v0_num), .v1_num(v1_num), .v2_num(v2_num), .v3_num(v3_num));
			
//color_preset input_gen(.reset_n(n_reset),.clock(clk_25),.data_color(data_color));

t5_t6 S3(.v0(v0), .v1(v1), .v2(v2), .v3(v3), .sp0(v0_num), .sp1(v1_num), .sp2(v2_num), .sp3(v3_num),
			.clock_25(clk_25), .clock_maior(clk_sync), .rst(~n_reset), .att_color(att_color), .data_color(data_color), .blue(blue), .green(green), .red(red));

t7 exibicao(.FIFO_Red(FIFO_Red),.FIFO_Green(FIFO_Green), .FIFO_Blue(FIFO_Blue), .Sprites_Red(red), .Sprites_Green(green),  .Sprites_Blue(blue), .VGA_R(VGA_R), .VGA_G(VGA_G), .VGA_B(VGA_B));
			
endmodule
