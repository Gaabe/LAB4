module VGA (clk, reset, red, green, blue, r, g, b, hsync, vsync, row, column );

input clk, reset;
input red, green, blue;

output reg r, g, b, hsync, vsync;
output reg [8:0] row;
output reg [9:0] column;

reg videoon, videov, videoh;
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
	videoh = 1'b1;
	column = hcount;
	
	if (hcount > 639)
	begin
		videoh = 1'b0;
		column = 0;
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
	videov = 1'b1;
	row = vcount[8:0];
	
	if (vcount > 479)
	begin
		videov = 1'b0;
		row = 0;
	end

end

// sync

always @(posedge clk)
begin
	if (reset)
	begin
		hsync <= 1'b0;
		vsync <= 1'b0;
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

always videoon = videoh && videov;

// colors

always @(posedge clk)
begin
	if (reset)
	begin
		r <= 1'b0;
		g <= 1'b0;
		b <= 1'b0;
	end
	else
	begin
		r <= red && videoon;
		g <= green && videoon;
		b <= blue && videoon;
	end
end
endmodule