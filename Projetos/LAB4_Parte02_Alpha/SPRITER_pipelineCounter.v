module pipelineCounter(reset_n, clk_25, clk_sync, column_in, row_in, column_out, start_flag);

input clk_25, clk_sync, reset_n;
input [9:0] column_in, row_in;

output reg [9:0] column_out;
output reg start_flag;

always @(posedge clk_25)
begin
	if (~reset_n)
	begin
		column_out <= 4'd0;
	end
	else
	begin
		if (start_flag)
		begin
			column_out <= column_out + 4'd1;
		end
		else
		begin
			column_out <= 0;
		end
	end
end

always @(posedge clk_sync)
begin
	if (~reset_n)
	begin
		start_flag <= 0;
	end
	else
	begin
		start_flag = (column_in >= 738 | column_in < 579) & (row_in < 479);
	end	
end

endmodule
