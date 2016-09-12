module spriter_prototype(clk, lineNumber, spriteNumber, validData, data, rd_en);

input clk;
input validData;
input [15:0] data;
output [3:0] lineNumber;
output [4:0] spriteNumber;
output rd_en;

endmodule
