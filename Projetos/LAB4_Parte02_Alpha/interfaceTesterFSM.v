module interfaceTesterFSM (clk, rst_n, ready, change_rq, sp_num, ancora);
//-------------Input Ports-----------------------------
input clk, rst_n, ready;
 //-------------Output Ports----------------------------
output reg change_rq;
output [4:0] sp_num;
output [18:0] ancora;
//-------------Internal Constants--------------------------
parameter SETUP = 3'd0, PRESET = 3'd1, IDLE = 3'd2, WAIT_RDY = 3'd3, ADD = 3'd4;
//-------------Internal Variables---------------------------
reg [2:0] state; // Seq part of the FSM
reg [2:0] next_state; // combo part of FSM
reg [8:0] row;
reg [9:0] column;
reg [6:0] framecount;

assign ancora[18:10] = row;
assign ancora[9:0] = column;

// Sprite do disquete
assign sp_num = 5'd28;

//assign change_rq = (state == PRESET | state == ADD);

always @ (state or ready)
begin : FSM_COMBO
	next_state = 3'd0;
	case(state)
	SETUP :	begin
					if (ready)
						next_state = PRESET;
					else
						next_state = SETUP;
				end
			
   PRESET :	begin
					next_state = IDLE;
				end
					
   IDLE : 	begin
					if (~ready)
						next_state = WAIT_RDY;
					else
						next_state = IDLE;
				end
	
	WAIT_RDY :	begin
						if (ready)
							next_state = ADD;
						else
							next_state = WAIT_RDY;
					end
					
	ADD :	begin
				next_state = IDLE;
			end
	
   default : next_state = SETUP;
  endcase
end

//----------Seq Logic-----------------------------
always @ (posedge clk)
begin : FSM_SEQ
	if (~rst_n)
	begin
		state <= SETUP;
	end
	else
	begin
		state <= next_state;
	end
end

//----------Counters-----------------------------
always @ (posedge clk)
begin
	if (~rst_n)
	begin
		row <= 0;
		column <= 330;
	end
	else
	begin
		if (state == ADD)
		begin
			if (framecount == 127)
			begin
				if (row < 480)
					row <= row + 1;
				else
					row <= 0;
			end
			else
			begin
				row <= row;
			end
		end
	end
end

always @ (posedge clk)
begin
	if (~rst_n)
	begin
		framecount <= 0;
	end
	else
	begin
		if (state == ADD)
		begin
			framecount <= framecount + 1;
		end
		else
		begin
			framecount <= framecount;
		end
	end
end

//----------Output Logic-----------------------------
always @ (posedge clk)
begin : OUTPUT_LOGIC
if (~rst_n)
begin
	change_rq <= 1'b0;
end
else
begin
	change_rq <= (state == PRESET | state == ADD) & (framecount == 127);
end
end // End Of Block OUTPUT_LOGIC

endmodule // End of Module arbiter