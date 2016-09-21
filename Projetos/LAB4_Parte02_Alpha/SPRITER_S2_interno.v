module S2_interno(clk, clkPipeline, reset_n, sp0_num, sp1_num, sp2_num, sp3_num, sp0_line, sp1_line, sp2_line, sp3_line, sp0_offset, sp1_offset, sp2_offset, sp3_offset, sp0_en, sp1_en, sp2_en, sp3_en, v0_int, v1_int, v2_int, v3_int, v0num_int, v1num_int, v2num_int, v3num_int);

input clkPipeline, clk, reset_n;

input [4:0] sp0_num, sp1_num, sp2_num, sp3_num;
input [3:0] sp0_line, sp1_line, sp2_line, sp3_line;
input [4:0] sp0_offset, sp1_offset, sp2_offset, sp3_offset;
input sp0_en, sp1_en, sp2_en, sp3_en;

output [15:0] v0_int, v1_int, v2_int, v3_int;
output [4:0] v0num_int, v1num_int, v2num_int, v3num_int;


wire [15:0] v0_int, v1_int, v2_int, v3_int;
wire [4:0] v0num_int, v1num_int, v2num_int, v3num_int;

wire rd_en, valid_rd;
wire [15:0] data_bus, shiftedData;
wire [3:0] lineNumber;
wire [4:0] spriteNumber, spriteOffset;

wire [1:0] mux_sel;
wire pipeline_rst;

wire [4:0] sp0_num, sp1_num, sp2_num, sp3_num;
wire [3:0] sp0_line, sp1_line, sp2_line, sp3_line;
wire [4:0] sp0_offset, sp1_offset, sp2_offset, sp3_offset;
wire sp0_en, sp1_en, sp2_en, sp3_en;

assign v0num_int = sp0_num;
assign v1num_int = sp1_num;
assign v2num_int = sp2_num;
assign v3num_int = sp3_num;

demux_shapes demux(.clk(clk), .reset(pipeline_rst), .wr_en(valid_rd), .data_in(shiftedData), .v0(v0_int), .v1(v1_int), .v2(v2_int), .v3(v3_int), .sel(mux_sel));

mux5 MUX_spnum(.data0x(sp0_num), .data1x(sp1_num), .data2x(sp2_num), .data3x(sp3_num), .sel(mux_sel), .result(spriteNumber));
mux4 MUX_spline(.data0x(sp0_line), .data1x(sp1_line), .data2x(sp2_line), .data3x(sp3_line), .sel(mux_sel), .result(lineNumber));
SRAM_module SRAM(.clk(clk), .reset(pipeline_rst), .rd_en(rd_en), .lineNumber(lineNumber), .spriteNumber(spriteNumber), .valid_rd(valid_rd), .q(data_bus));

dataShifter offsetter(.data(data_bus), .offset(spriteOffset), .shiftedData(shiftedData));
mux5 MUX_spoffset(.data0x(sp0_offset), .data1x(sp1_offset), .data2x(sp2_offset), .data3x(sp3_offset), .sel(mux_sel), .result(spriteOffset));
s2_controller fsm(.reset_n(reset_n),.clk(clk),.sp0_en(sp0_en),.sp1_en(sp1_en),.sp2_en(sp2_en),.sp3_en(sp3_en),.valid_rd(valid_rd), .clkPipeline(clkPipeline),.mux_sel(mux_sel),.pipeline_rst(pipeline_rst),.rd_en(rd_en));

// reset_n,clk,sp0_en,sp1_en,sp2_en,sp3_en,valid_rd,clkPipeline,dmux_en,mux_sel[1:0],pipeline_rst,rd_en);
endmodule
