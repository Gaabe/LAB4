module anchorMemory(clk, address, rwenable, datain, dataout, n_reset);
input [4:0] address;
input rwenable, clk;
input [18:0] datain;
input n_reset;

reg [18:0]mem[4:0];

output reg [18:0] dataout;

always@(posedge clk)
begin
	if (~n_reset)
	begin
		mem[0] = 19'd0;
		mem[1] = 19'b0010000000000000000;
		mem[2] = 19'b0100000000000000000;
		mem[3] = 19'b1000000000000000000;
	end
	else
	begin
		if(rwenable == 1)
			dataout <= mem[address];
		else
			mem[address] <= datain;
	end
end
endmodule
