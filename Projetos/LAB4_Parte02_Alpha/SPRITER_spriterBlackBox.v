module spriter_blackBox(clk_75, clk_25, clk_sync, row, column, change_rq, sp_num, ancora_in, ready,
								n_reset, data_color, att_color, FIFO_Red, FIFO_Green, FIFO_Blue,
								VGA_R, VGA_G, VGA_B);

input n_reset, clk_75, clk_sync, clk_25;
input [9:0] row, column;

input [23:0] data_color;                    // Dado da cor vindo da mémoria
input att_color;                            // Sinal para atualizar a memória

input [7:0] FIFO_Red;
input [7:0] FIFO_Green;
input [7:0] FIFO_Blue;

input change_rq;
input [4:0] sp_num;
input [18:0] ancora_in;

output ready;
	
output [7:0] VGA_R;
output [7:0] VGA_G;
output [7:0] VGA_B;

wire [4:0] address;
wire [18:0] datain;
wire rwenable;

spriter_module spriter(	.clk_75(clk_75), .clk_25(clk_25), .clk_sync(clk_sync), .address(address), .rwenable(rwenable), .datain(datain), .row(row), .column(column),
								.n_reset(n_reset), .data_color(data_color), .att_color(att_color), .FIFO_Red(FIFO_Red), .FIFO_Green(FIFO_Green), .FIFO_Blue(FIFO_Blue),
								.VGA_R(VGA_R), .VGA_G(VGA_G), .VGA_B(VGA_B));

processorInterface(.clk_75(clk_75), .reset_n(n_reset), .column_vga(column), .change_rq(change_rq), .sp_num(sp_num), .ancora_in(ancora_in), .ready(ready), .ancora_out(datain), .addr_out(address), .ancora_wren_n(rwenable));

endmodule
