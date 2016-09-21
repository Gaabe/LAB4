module PixelLogic (clk, reset, red, green, blue, r, g, b, hsync, vsync, row, column, videoon);

input clk, reset;
input [7:0] red, green, blue;

output reg hsync, vsync;
output [7:0] r, g, b;

output [9:0] row;
output [9:0] column;

output reg videoon;

reg videov, videoh;
reg [9:0] hcount, vcount;

assign row = vcount;
assign column = hcount;

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
			hcount <= hcount + 10'd1;
	end
end

always @(hcount)
begin
	if (hcount > 639)
	begin
		videoh = 1'b0;
	end
	else
	begin
		videoh = 1'b1;
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
				vcount <= vcount + 10'd1;
	end
end

always @(vcount)
begin
	if (vcount > 478)
	begin
		videov = 1'b0;
	end
	else
	begin
		videov = 1'b1;
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

always @(*)
begin
	videoon <= videoh && videov;
end

// colors

assign r = (videoon & ~reset) ? red : 8'd0;
assign g = (videoon & ~reset) ? green : 8'd0;
assign b = (videoon & ~reset) ? blue : 8'd0;

//always @(posedge clk)
//begin
//	if (reset)
//	begin
//		r <= 0;
//		g <= 0;
//		b <= 0;
//	end
//	else
//	begin
//		if (videoon == 1'b1)
//		begin
//			r <= red;
//			g <= green;
//			b <= blue;		
//		end
//		else
//		begin
//			r <= 0;
//			g <= 0;
//			b <= 0;		
//		end
//		
//	end
//end

endmodule

