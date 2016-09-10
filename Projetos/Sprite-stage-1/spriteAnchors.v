module anchorMemory(clk, address, r_enable, w_enable, datain, dataout);
input [4:0] address;
input r_enable, clk, w_enable;
input [18:0] datain;

reg [18:0]mem[4:0];

output reg [18:0] dataout;

always@(posedge clk)
begin
	if(r_enable == 1)
		dataout <= mem[address];
	if(w_enable == 1)
		mem[address] <= datain;
end
endmodule
