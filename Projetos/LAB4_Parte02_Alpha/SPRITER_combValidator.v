module combValidator(valid_data, dataIn, dataOut);

input valid_data;
input [15:0] dataIn;
output reg [15:0] dataOut;

always @(valid_data or dataIn)
begin
	if (valid_data)
		dataOut = dataIn;
	else
		dataOut = 16'd0;
end

endmodule
