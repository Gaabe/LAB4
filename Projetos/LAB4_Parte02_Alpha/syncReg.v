module syncReset(clk, inPort, outPort, rst_n);

input clk, inPort, rst_n;
output reg outPort;

always @(posedge clk)
begin
	if (~rst_n)
		outPort <= 1'b0;
	else
		outPort <= inPort;
end

endmodule
