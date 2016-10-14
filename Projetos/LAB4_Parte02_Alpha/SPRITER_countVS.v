module count_x_vsync(clk_25, rst_n, x, row, alert);

input clk_25, rst_n;
input [9:0] row;
input [5:0] x;
output reg alert;

reg [5:0] counter;

always @(posedge clk_25)
begin
	if (~rst_n)
	begin
		counter <= 0;
		alert <= 0;
	end
	else
	begin
		if (counter < x)
		begin
			if (row >= 493)
			begin
				counter <= counter + 1;
				alert <= 0;
			end
		end
		else
		begin			
			if (counter == x)
			begin
				alert <= 1;
				counter <= 0;
			end
			else
			begin
				alert <= 0;
			end
		end
	end	
end

endmodule
