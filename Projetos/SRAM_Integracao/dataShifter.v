module dataShifter(data, offset, shiftedData);

input [15:0] data;
input [4:0] offset;
output reg [15:0] shiftedData;

// Considerando shift para a esquerda negativo e para a direita positivo
always @(*)
begin
	if (offset[4])
	begin
		shiftedData = data << offset[3:0];
	end
	else
	begin
		shiftedData = data >> offset[3:0];
	end
end

endmodule
