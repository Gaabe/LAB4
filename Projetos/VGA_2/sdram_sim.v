module sdram_simulator(clkin, rst, freeslots, wr_en, data_out);

input clkin, rst;
input [3:0] freeslots;
output reg wr_en;
output reg [31:0] data_out;

reg [19:0] counter;
always @(posedge clkin)
begin

	if (rst)
	begin
		wr_en = 0;
		data_out = 32'h00000000;
		counter = 0;
	end
	else
	begin
		if (freeslots > 0)
		begin
			wr_en = 1;			
			
			if (counter < 204800) // 640*160*2
				data_out = 32'hFF000000;
			else if (counter < 409600) // 640*160*2*2
				data_out = 32'h00FF0000;
			else if (counter < 614400) // 640*160*3*2
				data_out = 32'h0000FF00;
			else
			begin
				data_out = 32'hFF000000;
				counter = 0;
			end
			
			counter = counter + 1;
		end
		else
		begin
			wr_en = 0;
			data_out = 32'h00000000;
			counter = counter;
		end
	end

end

endmodule
