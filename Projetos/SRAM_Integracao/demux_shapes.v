module demux_shapes(clk, reset, wr_en, data_in, v0, v1, v2, v3, sel);

input reset, wr_en, clk;
input [15:0] data_in;
input [1:0] sel;
output reg [15:0] v0, v1, v2, v3;

always @(posedge clk)
begin
	if (reset)
	begin
		v0 <= 0;
		v1 <= 0;
		v2 <= 0;
		v3 <= 0;
	end
	else
	begin
		if (wr_en)
		begin
			case(sel)
				0: begin
						v0 <= data_in;
						v1 <= v1;
						v2 <= v2;
						v3 <= v3;
					end
				1: begin
						v1 <= data_in;
						v0 <= v0;
						v2 <= v2;
						v3 <= v3;
					end
				2: begin
						v2 <= data_in;
						v1 <= v1;
						v0 <= v0;
						v3 <= v3;
					end
				3: begin
						v3 <= data_in;
						v1 <= v1;
						v2 <= v2;
						v0 <= v0;
					end
				default: begin
								v0 <= 0;
								v1 <= 0;
								v2 <= 0;
								v3 <= 0;
							end
			endcase
		end
		else
		begin
			v0 <= v0;
			v1 <= v1;
			v2 <= v2;
			v3 <= v3;
		end
	end	
end

endmodule
