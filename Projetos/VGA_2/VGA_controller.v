module FIFO_reader(clk100, clk25, rst, data_pixel, videoon, rd_en, empty, red, green, blue, rstVGA);

input clk100, clk25, rst, videoon, empty;
input [23:0] data_pixel;
output reg rd_en, rstVGA;
output [7:0] red, green, blue;

reg vga_started;

// Lógica de RD_EN
reg [1:0] counter0;
always @(posedge clk100)
begin
	if (rst)
	begin
		rd_en <= 0;
		counter0 <= 0;
	end
	else
	begin
		counter0 <= counter0 + 2'd1;
		if ((counter0 == 2) && vga_started)
		begin
			rd_en <= 1;
		end
		else
		begin
			rd_en <= 0;
		end
	end
end


// Lógica de rstVGA
reg [3:0] counter1;
always @(posedge clk25)
begin
	if (rst)
	begin
		counter1 <= 0;
		rstVGA <= 0;
		vga_started <= 0;
	end
	else
	begin
//		if ((counter1 <= 3)&&(empty == 0))
		if (counter1 == 0)
		begin
			counter1 <= 1;
			rstVGA <= 1;
			vga_started <= 1;
		end
		else
			rstVGA <= 0;
	end

end

// Conexão de I/O
assign red = data_pixel[23:16];
assign green = data_pixel[15:8];
assign blue = data_pixel[7:0];

endmodule
