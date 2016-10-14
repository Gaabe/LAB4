module mux24(sel, in0, in1, out);

input sel;
input [23:0] in0, in1;
output [23:0] out;

assign out = (sel)? in1 : in0;

endmodule
