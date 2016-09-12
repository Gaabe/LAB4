module sram_addr_decoder(clk, lineNumber, spriteNumber, address);

input 					clk;
input			[ 3: 0]	lineNumber;
input			[ 4: 0] 	spriteNumber;
output 		[19: 0]	address;

assign address = (20'd16 * spriteNumber) + lineNumber;

endmodule
