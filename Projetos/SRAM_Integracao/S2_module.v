module S2_module(clk, reset_n, clkPipeline, sprite0, sprite1, sprite2, sprite3, v0, v1, v2, v3, v0_num, v1_num, v2_num, v3_num);

input clk, clkPipeline, reset_n;
input [14:0] sprite0, sprite1, sprite2, sprite3;
output [15:0] v0, v1, v2, v3;
output [4:0] v0_num, v1_num, v2_num, v3_num;

wire [15:0] v0_int, v1_int, v2_int, v3_int;
wire [4:0] v0num_int, v1num_int, v2num_int, v3num_int;

wire rd_en, valid_rd;
wire [15:0] data_bus, shiftedData;
wire [3:0] lineNumber;
wire [4:0] spriteNumber, spriteOffset;

wire [1:0] mux_sel;
wire dmux_en, pipeline_rst;

wire [4:0] sp0_num, sp1_num, sp2_num, sp3_num;
wire [3:0] sp0_line, sp1_line, sp2_line, sp3_line;
wire [4:0] sp0_offset, sp1_offset, sp2_offset, sp3_offset;
wire sp0_en, sp1_en, sp2_en, sp3_en;

splitter wires(sprite0, sprite1, sprite2, sprite3, sp0_num, sp1_num, sp2_num, sp3_num, sp0_line, sp1_line, sp2_line, sp3_line, sp0_offset, sp1_offset, sp2_offset, sp3_offset, sp0_en, sp1_en, sp2_en, sp3_en);
S2_pipeline_buffer saida(.clkPipeline(clkPipeline), .v0_int(v0_int), .v1_int(v1_int), .v2_int(v2_int), .v3_int(v3_int), .v0num_int(v0num_int), .v1num_int(v1num_int), .v2num_int(v2num_int), .v3num_int(v3num_int), .v0(v0), .v1(v1), .v2(v2), .v3(v3), .v0_num(v0_num), .v1_num(v1_num), .v2_num(v2_num), .v3_num(v3_num));
S2_interno async_s2(.clk(clk), .reset_n(reset_n), .clkPipeline(clkPipeline), .sp0_num(sp0_num), .sp1_num(sp1_num), .sp2_num(sp2_num), .sp3_num(sp3_num), .sp0_line(sp0_line), .sp1_line(sp1_line), .sp2_line(sp2_line), .sp3_line(sp3_line), .sp0_offset(sp0_offset), .sp1_offset(sp1_offset), .sp2_offset(sp2_offset), .sp3_offset(sp3_offset), .sp0_en(sp0_en), .sp1_en(sp1_en), .sp2_en(sp2_en), .sp3_en(sp3_en), .v0_int(v0_int), .v1_int(v1_int), .v2_int(v2_int), .v3_int(v3_int), .v0num_int(v0num_int), .v1num_int(v1num_int), .v2num_int(v2num_int), .v3num_int(v3num_int));

endmodule
