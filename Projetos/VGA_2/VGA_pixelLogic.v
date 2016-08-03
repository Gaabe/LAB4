module PixelLogic (clk, reset, red, green, blue, r, g, b, hsync, vsync, row, column, videoon);

input clk, reset;
input [7:0] red, green, blue;

output reg hsync, vsync;
output reg [7:0] r, g, b;

output reg [8:0] row;
output reg [9:0] column;

output videoon;

reg videov, videoh;
reg [9:0] hcount, vcount;

// hcounter

always @(posedge clk)
begin
	if (reset)
		hcount <= 0;
	else
	begin
		if (hcount == 799)
			hcount <= 0;
		else
			hcount <= hcount + 1;
	end
end

always @(hcount)
begin
	if (hcount > 639)
	begin
		videoh = 1'b0;
		column = 0;
	end
	else
	begin
		videoh = 1'b1;
		column = hcount;
	end
end

// vcounter

always @(posedge clk)
begin
	if (reset)
		vcount <= 0;
	else
	begin
		if (hcount==699)
			if (vcount == 524)
				vcount <= 0;
			else
				vcount <= vcount + 1;
	end
end

always @(vcount)
begin
	if (vcount > 479)
	begin
		videov = 1'b0;
		row = 0;
	end
	else
	begin
		videov = 1'b1;
		row = vcount[8:0];
	end

end

// sync

always @(posedge clk)
begin
	if (reset)
	begin
		hsync <= 1'b1;
		vsync <= 1'b1;
	end
	else
	begin
		if ((hcount <= 755) && (hcount >= 659))
			hsync <= 1'b0;
		else
			hsync <= 1'b1;
		
		if ((vcount <= 494) && (vcount >= 493))
			vsync <= 1'b0;
		else
			vsync <= 1'b1;
	end
end

assign videoon = videoh && videov;

// colors

always @(posedge clk)
begin
	if (reset)
	begin
		r <= 0;
		g <= 0;
		b <= 0;
	end
	else
	begin
		if (videoon == 1'b1)
		begin
			r <= red;
			g <= green;
			b <= blue;		
		end
		else
		begin
			r <= 0;
			g <= 0;
			b <= 0;		
		end
		
	end
end
endmodule

