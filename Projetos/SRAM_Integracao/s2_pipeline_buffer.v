module S2_pipeline_buffer(clkPipeline, v0_int, v1_int, v2_int, v3_int, v0num_int, v1num_int, v2num_int, v3num_int, v0, v1, v2, v3, v0_num, v1_num, v2_num, v3_num);

input clkPipeline;

input [15:0] v0_int, v1_int, v2_int, v3_int;
input [4:0] v0num_int, v1num_int, v2num_int, v3num_int;

output reg [15:0] v0, v1, v2, v3;
output reg [4:0] v0_num, v1_num, v2_num, v3_num;

always @(posedge clkPipeline)
begin
	v0 <= v0_int;
	v1 <= v1_int;
	v2 <= v2_int;
	v3 <= v3_int;
	v0_num <= v0num_int;
	v1_num <= v1num_int;
	v2_num <= v2num_int;
	v3_num <= v3num_int;
end

endmodule
