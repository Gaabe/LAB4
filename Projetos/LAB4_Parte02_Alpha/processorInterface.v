module processorInterface(clk_75, reset_n, column_vga, change_rq, sp_num, ancora_in, ready, ancora_out, addr_out, ancora_wren_n);

input clk_75, reset_n;
input [9:0] column_vga;
input change_rq;
input [4:0] sp_num;
input [18:0] ancora_in;

output ready;

// Interface ancoras
output [18:0] ancora_out;
output [4:0] addr_out;
output reg ancora_wren_n;

assign ready = (column_vga > 641 & column_vga < 755);

// Interface ancoras
assign addr_out = sp_num;
assign ancora_out = ancora_in;

// Atualizar Ancoras
always @(posedge clk_75)
begin
	if (~reset_n)
	begin
		ancora_wren_n <= 1'b1;
	end
	else
	begin
		ancora_wren_n = ~(ready & change_rq);
	end
end

endmodule
