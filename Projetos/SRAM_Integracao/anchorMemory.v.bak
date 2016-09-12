module anchorMemory(clk, address, rwenable, datain, dataout);
input [4:0] address;
input rwenable, clk;
input [18:0] datain;

reg [18:0]mem[4:0];

output reg [18:0] dataout;

always@(posedge clk)
begin
	if(rwenable == 1)
		dataout <= mem[address];
	else
		mem[address] <= datain;
end
endmodule
