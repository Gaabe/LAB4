module FIFO_reader(clk25, rst, empty, rstVGA, vga_started);

input clk25, rst, empty;
output reg rstVGA, vga_started;

// Lógica de rstVGA
always @(posedge clk25)
begin
	if (rst)
	begin
		rstVGA <= 0;
		vga_started <= 0;
	end
	else
	begin
		rstVGA <= empty;
		vga_started <= ~empty;
	end

end


endmodule
