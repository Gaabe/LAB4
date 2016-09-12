module demux_num(reset, wr_en, sp_num, v0_num, v1_num, v2_num, v3_num, sel);

input reset, wr_en;
input [4:0] sp_num;
input [1:0] sel;
output reg [4:0] v0_num, v1_num, v2_num, v3_num;

always @(sel, sp_num, reset, wr_en)
begin
	if (reset)
	begin
		v0_num = 0;
		v1_num = 0;
		v2_num = 0;
		v3_num = 0;
	end
	else
	begin
		if (wr_en)
		begin
			case(sel)
				0: begin
						v0_num = sp_num;
					end
				1: begin
						v1_num = sp_num;
					end
				2: begin
						v2_num = sp_num;
					end
				3: begin
						v3_num = sp_num;
					end
				default: begin
								v0_num = 0;
								v1_num = 0;
								v2_num = 0;
								v3_num = 0;
							end
			endcase
		end
		else
		begin
			v0_num = v0_num;
			v1_num = v1_num;
			v2_num = v2_num;
			v3_num = v3_num;
		end
	end	
end

endmodule
