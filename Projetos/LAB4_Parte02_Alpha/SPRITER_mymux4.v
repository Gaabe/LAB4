module mux4(data0x, data1x, data2x, data3x, sel, result);

input [3:0] data0x, data1x, data2x, data3x;
input [1:0] sel;
output reg [3:0] result;

always @(sel or data0x or data1x or data2x or data3x)
begin
	case (sel)
		2'd0	:	result = data0x;
		2'd1	:	result = data1x;
		2'd2	:	result = data2x;
		2'd3	:	result = data3x;
	endcase
end

endmodule
