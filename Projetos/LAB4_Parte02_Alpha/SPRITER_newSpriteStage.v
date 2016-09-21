module newSpriteStage(clk, reset_n, clk_sync, start_flag, wrAddress, wenable, data_in, row_vga, column_vga, address, sprite0, sprite1, sprite2, sprite3);

input clk, reset_n, clk_sync, start_flag, wenable;
input [9:0] column_vga;
input [8:0] row_vga;
input [4:0] wrAddress;
input [18:0] data_in;

wire [8:0] row_link;
wire [9:0] column_link;

output reg [5:0] address;
output reg [14:0] sprite0, sprite1, sprite2, sprite3;

parameter START = 3'd0, WAIT0 = 3'd1, WAIT1 = 3'd2, WAIT2 = 3'd3, WAIT3 = 3'd4, IDLE0 = 3'd5, IDLE1 = 3'd6;

reg [2:0] state, next_state;

reg sp0_en,sp1_en,sp2_en,sp3_en;
reg [3:0] sp0_line,sp1_line,sp2_line,sp3_line;
reg [5:0] sp0_num,sp1_num,sp2_num,sp3_num;
reg [9:0] sp0_offset,sp1_offset,sp2_offset,sp3_offset;
reg sp0_sig, sp1_sig, sp2_sig, sp3_sig;

reg [18:0]mem[31:0];

assign row_link = mem[address][18:10];
assign column_link = mem[address][9:0];

// Memória
always@(posedge clk)
begin
	if (~reset_n)
	begin
		mem[0] <= 19'b0000000000000100000;
		mem[1] <= 19'b0000000001001011000;
		mem[2] <= 19'b0001100100000010100;
		mem[3] <= 19'b0001100100000010111;
		mem[4] <= 19'b1100100000111110100;
		mem[5] <= 19'b1100100000111110100;
		mem[6] <= 19'b0010100000001000001;
		mem[7] <= 19'b0011000110101101101;
		mem[8] <= 19'b0110001100010011001;
		mem[9] <= 19'b0011110111001100010;
		mem[10] <= 19'b1010000010111111110;
		mem[11] <= 19'b1110000100110011010;
		mem[12] <= 19'b1010111100100110110;
		mem[13] <= 19'b0111110100011010010;
		mem[14] <= 19'b0100101100001101110;
		mem[15] <= 19'b0011001000000001010;
		mem[16] <= 19'b0110010000000010100;
		mem[17] <= 19'b0000000000000000000;
		mem[18] <= 19'b1001011000001111000;
		mem[19] <= 19'b0000000000000000000;
		mem[20] <= 19'b1100100000011011100;
		mem[21] <= 19'b1110011000101000000;
		mem[22] <= 19'b1010011010110100100;
		mem[23] <= 19'b0110111101000001000;
		mem[24] <= 19'b0011011111001101100;
		mem[25] <= 19'b0000100011001110110;
		mem[26] <= 19'b0010010111000010010;
		mem[27] <= 19'b1100001100110101110;
		mem[28] <= 19'b0100110110101001010;
		mem[29] <= 19'b1101111000011100110;
		mem[30] <= 19'b1011000100010100101;
		mem[31] <= 19'b0011011110110101001;
	end
	else
	begin
		if(wenable == 1)
			mem[wrAddress] <= data_in;
	end
end

// Lógica de próximo estado
always @ (state or clk_sync or start_flag or sp0_en or sp1_en or sp2_en or sp3_en or address)
begin 
	next_state = START;
	case(state)
		START : 	begin
						if (start_flag)
							next_state = WAIT0;
						else
							next_state = START;
					end
					
		WAIT0 :	begin
						if (~sp0_en & address < 31)
							next_state = WAIT0;
						else
						begin
							if (sp0_en)
								next_state = WAIT1;
							else
							begin
								if (address == 31)
								begin
									if (clk_sync)
										next_state = IDLE1;
									else
										next_state = IDLE0;
								end
								else
									next_state = WAIT0;
							end
						end
					end
					
		WAIT1 : 	begin
						if (~sp1_en & address < 31)
							next_state = WAIT1;
						else
						begin
							if (sp1_en)
								next_state = WAIT2;
							else
							begin
								if (address == 31)
								begin
									if (clk_sync)
										next_state = IDLE1;
									else
										next_state = IDLE0;
								end
								else
									next_state = WAIT1;
							end
						end
					end
					
		WAIT2 : 	begin
						if (~sp2_en & address < 31)
							next_state = WAIT2;
						else
						begin
							if (sp2_en)
								next_state = WAIT3;
							else
							begin
								if (address == 31)
								begin
									if (clk_sync)
										next_state = IDLE1;
									else
										next_state = IDLE0;
								end
								else
									next_state = WAIT2;
							end
						end
					end
					
		WAIT3 : 	begin
						if (~sp3_en & address < 31)
							next_state = WAIT3;
						else
						begin
							if (address == 31 | sp3_en)
							begin
								if (clk_sync)
									next_state = IDLE1;
								else
									next_state = IDLE0;
							end
							else
								next_state = WAIT3;
						end
					end
					
		IDLE0 : 	begin
						if (clk_sync)
							next_state = START;
						else
							next_state = IDLE0;
					end
					
		IDLE1 :	begin
						if (~clk_sync)
							next_state = IDLE0;
						else
							next_state = IDLE1;		
					end
					
		default : next_state = START;
		
	endcase
end

// Atualiza Estado Atual
always @ (posedge clk)
begin
	if (~reset_n)
	begin
		state <= START;
	end else
	begin
		state <= next_state;
	end
end

// Atualiza o Endereço
always @ (posedge clk)
begin
	if (~reset_n | state == START)
	begin
		address <= 0;
	end
	else
	begin
		if (address < 31)
		begin
			address <= address + 5'd1;
		end
	end
end

// Atualiza o SPOS e salva valores
always @(posedge clk)
begin
	if (~reset_n | state == START)
	begin
		sp0_en <= 0;
		sp1_en <= 0;
		sp2_en <= 0;
		sp3_en <= 0;
		sp0_line <= 0;
		sp1_line <= 0;
		sp2_line <= 0;
		sp3_line <= 0;
		sp0_num <= 0;
		sp1_num <= 0;
		sp2_num <= 0;
		sp3_num <= 0;
		sp0_offset <= 0;
		sp1_offset <= 0;
		sp2_offset <= 0;
		sp3_offset <= 0;
		sp0_sig <= 0;
		sp1_sig <= 0;
		sp2_sig <= 0;
		sp3_sig <= 0;
	
	end
	else
	begin
		if ((row_vga >= row_link & row_vga < row_link + 16) & (column_link < column_vga +16 & column_vga < column_link + 16))
		begin	
			case (state)
			WAIT0 :	begin							
							sp0_en <= 1;
							sp0_line <= row_vga - row_link;
							sp0_num <= address;
							if (column_link > column_vga)
							begin
								sp0_offset <= column_link - column_vga;
								sp0_sig <= 1'b0;
							end
							else
							begin
								sp0_offset <= column_vga - column_link;
								sp0_sig <= 1'b1;
							end
							
						end
			WAIT1 :	begin
							sp1_en <= 1;
							sp1_line <= row_vga - row_link;
							sp1_num <= address;
							if (column_link > column_vga)
							begin
								sp1_offset <= column_link - column_vga;
								sp1_sig <= 1'b0;
							end
							else
							begin
								sp1_offset <= column_vga - column_link;
								sp1_sig <= 1'b1;
							end
						end
			WAIT2 :	begin
							sp2_en <= 1;
							sp2_line <= row_vga - row_link;
							sp2_num <= address;
							if (column_link > column_vga)
							begin
								sp2_offset <= column_link - column_vga;
								sp2_sig <= 1'b0;
							end
							else
							begin
								sp2_offset <= column_vga - column_link;
								sp2_sig <= 1'b1;
							end
						end
			WAIT3 :	begin
							sp3_en <= 1;
							sp3_line <= row_vga - row_link;
							sp3_num <= address;
							if (column_link > column_vga)
							begin
								sp3_offset <= column_link - column_vga;
								sp3_sig <= 1'b0;
							end
							else
							begin
								sp3_offset <= column_vga - column_link;
								sp3_sig <= 1'b1;
							end
						end					
			endcase				
			
		end
	end
end

always @(posedge clk_sync)
begin
	sprite0[14] <= sp0_en;
	sprite0[13] <= sp0_sig;
	sprite0[12:9] <= sp0_offset[3:0];
	sprite0[8:5] <= sp0_line;
	sprite0[4:0] <= sp0_num[4:0];
	
	sprite1[14] <= sp1_en;
	sprite1[13] <= sp1_sig;
	sprite1[12:9] <= sp1_offset[3:0];
	sprite1[8:5] <= sp1_line;
	sprite1[4:0] <= sp1_num[4:0];
	
	sprite2[14] <= sp2_en;
	sprite2[13] <= sp2_sig;
	sprite2[12:9] <= sp2_offset[3:0];
	sprite2[8:5] <= sp2_line;
	sprite2[4:0] <= sp2_num[4:0];
	
	sprite3[14] <= sp3_en;
	sprite3[13] <= sp3_sig;
	sprite3[12:9] <= sp3_offset[3:0];
	sprite3[8:5] <= sp3_line;
	sprite3[4:0] <= sp3_num[4:0];
	
end

endmodule
