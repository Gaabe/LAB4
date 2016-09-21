module pipelineStartBuffer(clk, rst_n, row_in, column_in, row_out, column_out);

input clk, rst_n;
input [9:0] row_in;
input [9:0] column_in;

output reg [8:0] row_out;
output reg [9:0] column_out;

always @(posedge clk)
begin
	if (~rst_n)
	begin
		row_out <= 0;
		column_out <= 0;
	end
	else
	begin
		column_out <= column_in;
		if (row_in < 480)
			row_out <= row_in[8:0];
		else
			row_out <= 0;
		
	end
end

endmodule
