module S1_module(clk_100, clk_sync, address, rwenable, datain, start_flag, row, column, n_reset,  sprite1, sprite2, sprite3, sprite4);

input [4:0] address;
input rwenable;
input [18:0] datain;

input start_flag, n_reset, clk_100, clk_sync;
input [8:0] row;
input [9:0] column;

output [14:0] sprite1, sprite2, sprite3, sprite4;

wire [4:0] realAddress, internalAddress;
wire [18:0] data_bus;

// Se READ, endereço é o interno. Se WRITE, endereço é o da entrada. 
assign realAddress = (rwenable)? internalAddress : address;

anchorMemory buffer(.clk(clk_100), .address(realAddress), .rwenable(rwenable), .datain(datain), .dataout(data_bus), .n_reset(n_reset));
spriteStage1 modulo(.start_flag(start_flag), .row(row), .column(column), .n_reset(n_reset), .clk_100(clk_100), .clk_sync(clk_sync),
					.sprite_bank(data_bus), .address(internalAddress), .sprite1(sprite1), .sprite2(sprite2), .sprite3(sprite3), .sprite4(sprite4));

endmodule
