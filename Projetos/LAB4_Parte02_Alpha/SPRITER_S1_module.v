module S1_module(clk_125, clk_25, clk_sync, address, rwenable, datain, row, column, n_reset, sprite0, sprite1, sprite2, sprite3);

input [4:0] address;
input rwenable;
input [18:0] datain;

input n_reset, clk_125, clk_sync, clk_25;
input [9:0] row, column;

output [14:0] sprite0, sprite1, sprite2, sprite3;

wire [4:0] realAddress;
wire [5:0] internalAddress;
wire [18:0] data_bus;

wire start_flag;
wire [8:0] row_out;

wire [9:0] column_ppline;
wire [9:0] column_out;

// Se READ, endereço é o interno. Se WRITE, endereço é o da entrada. 
assign realAddress = (rwenable)? internalAddress[4:0] : address;

pipelineCounter cols(.reset_n(n_reset), .clk_25(clk_25), .clk_sync(clk_sync), .column_in(column), .row_in(row), .column_out(column_ppline), .start_flag(start_flag));
pipelineStartBuffer regs(.clk(clk_sync), .rst_n(n_reset), .row_in(row), .column_in(column_ppline), .row_out(row_out), .column_out(column_out));
//anchorMemory RAM(.clk(clk_100), .address(realAddress), .rwenable(rwenable), .datain(datain), .dataout(data_bus), .n_reset(n_reset));
newSpriteStage FSM(.clk(clk_125), .reset_n(n_reset), .clk_sync(clk_sync), .start_flag(start_flag),
							.wenable(~rwenable), .wrAddress(realAddress), .data_in(datain),
							.row_vga(row_out), .column_vga(column_out), .address(internalAddress),
							.sprite0(sprite0), .sprite1(sprite1), .sprite2(sprite2), .sprite3(sprite3));

					
endmodule
