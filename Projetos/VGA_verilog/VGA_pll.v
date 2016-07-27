module PLL(clkRef, clkOut, reset);

input clkRef, reset;
output reg clkOut;

always @(posedge clkRef)
begin
	if (reset)
	begin
		clkOut <= 0;
	end
	else
	begin		
		clkOut = ~clkOut;			
	end
end

endmodule
