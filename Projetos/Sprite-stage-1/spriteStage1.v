module spriteStage1(v_sync, row, column, n_reset, clk, sprite_bank, address, sprite1, sprite2, sprite3, sprite4);
input v_sync, n_reset, clk;
input [8:0] row;
input [9:0] column;
input [18:0] sprite_bank;

integer i;

output reg [14:0] sprite1, sprite2, sprite3, sprite4;
output reg [4:0] address;

reg v_sync_active, start, cstate, nstate;
reg [6:0] active_counter;
reg [1:0] sprite_counter;


always@(posedge clk)
begin
	if(n_reset == 0)
	begin
		v_sync_active <= 0;
		active_counter <= 0;
		start <= 0;
		address <= 0;
		sprite_counter <= 0;
	end
	else
	begin
		if(v_sync_active == 1)
			active_counter <= active_counter + 1;
		if(active_counter == 124)
		begin
			start <= 1;
			active_counter <= 0;
		end
		if(cstate == 0)
			address <= address + 1;
		if(v_sync == 0)
		begin
			v_sync_active <= 1;
			start <= 0;
		end
		else
			v_sync_active <= 0;
		if(((row - 15) <= sprite_bank[18:10]) && (sprite_bank[18:10] <= row) && (sprite_bank[9:0] >= (column - 15)) && (sprite_bank[9:0] <= (column + 15)) && cstate == 1)
			sprite_counter = sprite_counter + 1;
		cstate <= nstate;
	end
end

always@(*)
begin
	case(cstate)
		0: begin
				if(start == 1)
					nstate = 1;
				else
					nstate = 0;
			end
		1: nstate = 0;
	endcase
end

always@(*)
begin
	case(cstate)
		0: ;
		1: begin
				if(((row - 15) <= sprite_bank[18:10]) && (sprite_bank[18:10] <= row) && (sprite_bank[9:0] >= (column - 15)) && (sprite_bank[9:0] <= (column + 15)))
				begin
					case(sprite_counter)
						0: begin
								sprite1[14] = 1;
								sprite1[13:9] = (column - sprite_bank[9:0]);
								sprite1[8:5] = (row - sprite_bank[18:10]);
								sprite1[4:0] = address;
							end
						1: begin
								sprite2[14] = 1;
								sprite2[13:9] = (column - sprite_bank[9:0]);
								sprite2[8:5] = (row - sprite_bank[18:10]);
								sprite2[4:0] = address;
							end
						2: begin
								sprite3[14] = 1;
								sprite3[13:9] = (column - sprite_bank[9:0]);
								sprite3[8:5] = (row - sprite_bank[18:10]);
								sprite3[4:0] = address;
							end
						3: begin
								sprite4[14] = 1;
								sprite4[13:9] = (column - sprite_bank[9:0]);
								sprite4[8:5] = (row - sprite_bank[18:10]);
								sprite4[4:0] = address;
							end
					endcase
				end
			end
	endcase
end
endmodule
