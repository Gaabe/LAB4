module spriteStage1(start_flag, row, column, n_reset, clk_100, clk_sync, sprite_bank, address, sprite1, sprite2, sprite3, sprite4);
input start_flag, n_reset, clk_100, clk_sync;
input [8:0] row;
input [9:0] column;
input [18:0] sprite_bank;

output reg [14:0] sprite1, sprite2, sprite3, sprite4;
output reg [4:0] address;

reg [14:0] sprite1reg, sprite2reg, sprite3reg, sprite4reg;
reg cstate, nstate;
reg [1:0] sprite_counter;

always@(posedge clk_sync)
begin
	if(n_reset == 0)
	begin
		sprite1 <= 0;
		sprite2 <= 0;
		sprite3 <= 0;
		sprite4 <= 0;
	end
	else
	begin
		sprite1 <= sprite1reg;
		sprite2 <= sprite2reg;
		sprite3 <= sprite3reg;
		sprite4 <= sprite4reg;
	end
end

always@(posedge clk_100)
begin
	if(n_reset == 0 && clk_sync == 1)
	begin
		address <= 0;
		sprite_counter <= 0;
		cstate <= 0;
	end
	else
	begin
		if(cstate == 1)
			address <= address + 1;
		if(((row - 15) <= sprite_bank[18:10]) && (sprite_bank[18:10] <= row) && (sprite_bank[9:0] >= (column - 15)) && (sprite_bank[9:0] <= (column + 15)) && cstate == 1)
			sprite_counter <= sprite_counter + 1;
		cstate <= nstate;
	end
end

always@(*)
begin
	case(cstate)
		0: begin
				if(start_flag == 1)
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
								sprite1reg[14] = 1;
								sprite1reg[13:9] = (column - sprite_bank[9:0]);
								sprite1reg[8:5] = (row - sprite_bank[18:10]);
								sprite1reg[4:0] = address;
							end
						1: begin
								sprite2reg[14] = 1;
								sprite2reg[13:9] = (column - sprite_bank[9:0]);
								sprite2reg[8:5] = (row - sprite_bank[18:10]);
								sprite2reg[4:0] = address;
							end
						2: begin
								sprite3reg[14] = 1;
								sprite3reg[13:9] = (column - sprite_bank[9:0]);
								sprite3reg[8:5] = (row - sprite_bank[18:10]);
								sprite3reg[4:0] = address;
							end
						3: begin
								sprite4reg[14] = 1;
								sprite4reg[13:9] = (column - sprite_bank[9:0]);
								sprite4reg[8:5] = (row - sprite_bank[18:10]);
								sprite4reg[4:0] = address;
							end
					endcase
				end
			end
	endcase
end
endmodule

