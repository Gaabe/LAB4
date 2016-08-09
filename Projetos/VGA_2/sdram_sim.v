module sdram_simulator(clkin, rst, freeslots, wr_en, data_out, LEDR);

input clkin, rst;
input [4:0] freeslots;
output reg wr_en;
output reg [31:0] data_out;

output reg [17:0] LEDR;

reg [19:0] counter;
always @(posedge clkin)
begin

	if (rst)
	begin
		wr_en <= 0;
		data_out <= 32'h00000000;
		counter <= 0;
		LEDR[0] <= 0;
	end
	else
	begin
		if (freeslots !== 0)
		begin
			wr_en <= 1;			
			LEDR[0] <= 1;
			
			if (counter < 1)
			begin
				data_out <= 32'hff000000;
				counter <= counter + 20'd1;
			end
			else
			begin
				if (counter < 2)
				begin
					data_out <= 32'h00ff0000;
					counter <= counter + 20'd1;
				end
				else
				begin
					if (counter < 3)
					begin
						data_out <= 32'h0000ff00;
						counter <= 0;
					end
				end
			end
			
//			if (counter < 204800) // 640*160*2
//			begin
//				data_out <= 32'hff000000;
//				counter <= counter + 20'd1;
//			end
//			else
//			begin
//				if (counter < 409600) // 640*160*2*2
//				begin
//					data_out <= 32'h00ff0000;
//					counter <= counter + 20'd1;
//				end
//				else
//				begin
//					if (counter < 614400) // 640*160*3*2
//					begin
//						data_out <= 32'h0000ff00;
//						counter <= counter + 20'd1;
//					end
//					else
//					begin
//						data_out <= 32'hff000000;
//						counter <= 0;
//					end
//				end
//			end
			
			
		end
		else
		begin			
			wr_en <= 0;
			data_out <= 32'h00000000;
			counter <= counter;
		end
	end

end

endmodule