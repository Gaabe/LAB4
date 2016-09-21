module splitter(sprite0, sprite1, sprite2, sprite3, sp0_num, sp1_num, sp2_num, sp3_num, sp0_line, sp1_line, sp2_line, sp3_line, sp0_offset, sp1_offset, sp2_offset, sp3_offset, sp0_en, sp1_en, sp2_en, sp3_en);

input [14:0] sprite0, sprite1, sprite2, sprite3;
output [4:0] sp0_num, sp1_num, sp2_num, sp3_num;
output [3:0] sp0_line, sp1_line, sp2_line, sp3_line;
output [4:0] sp0_offset, sp1_offset, sp2_offset, sp3_offset;
output sp0_en, sp1_en, sp2_en, sp3_en;

assign sp0_num = sprite0[4:0];
assign sp1_num = sprite1[4:0];
assign sp2_num = sprite2[4:0];
assign sp3_num = sprite3[4:0];

assign sp0_line = sprite0[8:5];
assign sp1_line = sprite1[8:5];
assign sp2_line = sprite2[8:5];
assign sp3_line = sprite3[8:5];

assign sp0_offset = sprite0[13:9];
assign sp1_offset = sprite1[13:9];
assign sp2_offset = sprite2[13:9];
assign sp3_offset = sprite3[13:9];

assign sp0_en = sprite0[14];
assign sp1_en = sprite1[14];
assign sp2_en = sprite2[14];
assign sp3_en = sprite3[14];

endmodule
