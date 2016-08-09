module PLL_old(clkRef, clkOut, reset, rstOut);

input clkRef, reset;
output reg clkOut, rstOut;

reg sendReset;
reg [1:0] counter;

always @(posedge clkRef)
begin
	if (reset)
	begin
		clkOut <= 0;
		sendReset = 1'b1;
		counter = 2'b00;
		rstOut = 1'b0;
	end
	else
	begin		
		clkOut = ~clkOut;			
		if (sendReset)
		begin
			
			if (counter == 2'b11)
			begin
				rstOut = 1'b0;
				sendReset = 1'b0;
			end
			else
			begin
				rstOut = 1'b1;
			end	
			
			counter = counter + 1;
		end
	end
end

endmodule
