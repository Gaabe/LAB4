module interfaceTester(instruction, sp_num, ancora);

output instruction;
output [4:0] sp_num;
output [18:0] ancora; 

assign instruction = 1'b1;
assign sp_num = 5'd0;
assign ancora = 19'b0010001100000000000;

endmodule
