
// Created by fizzim.pl version 5.10 on 2016:08:12 at 00:59:52 (www.fizzim.com)

module image_controller (
  output reg [11:0] RAM_addr,
  output reg RAM_next,
  output reg RAM_reset_n,
  output reg RAM_start,
  input wire CLOCK_100,
  input wire [6:0] FIFO_Free,
  input wire RAM_ready,
  input wire [1:0] TYPE,
  input wire rst_n, 
  input wire [3:0] switch
);

  // state bits
  parameter 
  AtTheBegging   = 4'b0000, 
  ALittleWait    = 4'b0001, 
  ItsOver        = 4'b0010, 
  NewAddrLine    = 4'b0011, 
  NewVGALine     = 4'b0100, 
  ResetingMemory = 4'b0101, 
  StartingMemory = 4'b0110, 
  WaitToRead     = 4'b0111, 
  WaitingFIFO    = 4'b1000, 
  Writing        = 4'b1001; 

  reg [3:0] state;
  reg [3:0] nextstate;
  reg [6:0] FREE;
  reg [9:0] IMG_COUNT_X;
  reg [8:0] IMG_COUNT_Y;
  reg [12:0] IMG_POS_X;
  reg [11:0] IMG_POS_Y;
  reg [9:0] column;
  reg [11:0] row;
  reg [4:0] support_count;
  reg [1:0] tipo ;
  reg [6:0] next_FREE;
  reg [9:0] next_IMG_COUNT_X;
  reg [8:0] next_IMG_COUNT_Y;
  reg [12:0] next_IMG_POS_X;
  reg [11:0] next_IMG_POS_Y;
  reg [9:0] next_column;
  reg [11:0] next_row;
  reg [4:0] next_support_count;
  reg [1:0] next_tipo ;

  // comb always block
  always @* begin
    nextstate = 4'bxxxx; // default to x because default_state_is_x is set
    next_FREE[6:0] = FREE[6:0];
    next_IMG_COUNT_X[9:0] = IMG_COUNT_X[9:0];
    next_IMG_COUNT_Y[8:0] = IMG_COUNT_Y[8:0];
    next_IMG_POS_X[12:0] = IMG_POS_X[12:0];
    next_IMG_POS_Y[11:0] = IMG_POS_Y[11:0];
    next_column[9:0] = column[9:0];
    next_row[11:0] = row[11:0];
    next_support_count[4:0] = support_count[4:0];
    next_tipo [1:0] = tipo [1:0];
    case (state)
      AtTheBegging  : begin
        begin
          nextstate = ResetingMemory;
          next_support_count[4:0] = 0;
        end
      end
      ALittleWait   : begin
        if (support_count[4:0] == 5'd3) begin
          nextstate = Writing;
          next_FREE[6:0] = FREE[6:0] - 1'b1;
		    next_IMG_COUNT_X[9:0] = IMG_COUNT_X[9:0] + 1'b1;
        end
		  else begin
			 nextstate = ALittleWait;
			 next_support_count[4:0] = support_count[4:0] + 1'b1;
		  end
      end
      ItsOver       : begin
        if (FREE[6:0] == 0) begin
          nextstate = WaitingFIFO;
          next_support_count[4:0] = 0;
        end
        else if (FREE[6:0] > 0) begin
          nextstate = WaitToRead;
        end
      end
      NewAddrLine   : begin
        if (FREE[6:0] > 0) begin
          nextstate = WaitToRead;
        end
        else if (FREE[6:0] == 0) begin
          nextstate = WaitingFIFO;
          next_support_count[4:0] = 0;
        end
      end
      NewVGALine    : begin
        if (IMG_COUNT_Y[8:0] == 479) begin
          nextstate = ItsOver;
          next_support_count[4:0] = 0;
          next_IMG_COUNT_X[9:0] = 0;
          next_tipo[1:0] = (TYPE[1:0] == 2'd3) ? 2'b0 : TYPE[1:0];
          next_row[11:0] = 0;
          next_IMG_COUNT_Y[8:0] = 0;
          next_column[9:0] = 0;
        end
        else if (FREE[6:0] == 0) begin
          nextstate = WaitingFIFO;
          next_support_count[4:0] = 0;
        end
        else if (FREE[6:0] > 0) begin
          nextstate = WaitToRead;
        end
      end
      ResetingMemory: begin
        if (support_count[4:0] < 5) begin
          nextstate = ResetingMemory;
          next_support_count[4:0] = support_count[4:0] + 1'b1;
        end
        else if (support_count[4:0] == 5) begin
          nextstate = StartingMemory;
          next_support_count[4:0] = 0;
        end
      end
      StartingMemory: begin
        if (support_count[4:0] < 5) begin
          nextstate = StartingMemory;
          next_support_count[4:0] = support_count[4:0] + 1'b1;
        end
        else if (support_count[4:0] == 5) begin
          nextstate = WaitingFIFO;
          next_tipo [1:0] = (TYPE[1:0] != 3) ? TYPE[1:0] : 2'd0;
        end
      end
      WaitToRead    : begin
        if (RAM_ready) begin
          nextstate = ALittleWait;
          next_FREE[6:0] = FIFO_Free[6:0];
			 next_support_count[4:0] = 5'b0;
        end
        else if (!RAM_ready) begin
          nextstate = WaitToRead;
        end
      end
      WaitingFIFO   : begin
        if (support_count[4:0] < 8 || FIFO_Free[6:0] == 0) begin
          nextstate = WaitingFIFO;
          next_support_count[4:0] = support_count[4:0] + 1'b1;
        end
        else begin
          nextstate = WaitToRead;
        end
      end
      Writing       : begin
        if (FREE[6:0] > 0 && column[9:0] < 1023 && IMG_COUNT_X[9:0] < 640) begin
          nextstate = Writing;
          next_column[9:0] = column[9:0] + 1'b1;
          next_FREE[6:0] = FREE[6:0] - 1'b1;
          next_IMG_COUNT_X[9:0] = IMG_COUNT_X[9:0] + 1'b1;
        end
        else if (IMG_COUNT_X[9:0] == 640 && tipo[1:0] == 0) begin
          nextstate = NewVGALine;
          next_row[11:0] = (column[9:0] < 1023) ? row[11:0] + 12'd5 : row[11:0] + 12'd6;
          next_support_count[4:0] = 0;
          next_IMG_COUNT_X[9:0] = 0;
          next_column[9:0] = (column[9:0] < 1023) ? column[9:0] + 10'd1 : 10'd0;
          next_IMG_COUNT_Y[8:0] = IMG_COUNT_Y[8:0] + 1'b1;
        end
        else if (IMG_COUNT_X[9:0] == 640 && tipo[1:0] == 2) begin
          nextstate = NewVGALine;
          next_column[9:0] = (column[9:0] <= 766) ?  column[9:0] + 10'd257 : column[9:0] - 10'd767;
          next_IMG_COUNT_Y[8:0] = IMG_COUNT_Y[8:0] + 1'b1;
          next_row[11:0] = (column[9:0] <= 766) ?  row[11:0] + 12'd1 : row[11:0] + 12'd2;
          next_IMG_COUNT_X[9:0] = 0;
          next_support_count[4:0] = 0;
        end
        else if (IMG_COUNT_X[9:0] == 640 && tipo[1:0] == 1) begin
          nextstate = NewVGALine;
          next_row[11:0] = (column < 1023) ? row[11:0] : row[11:0] + 1'b1;
          next_IMG_COUNT_X[9:0] = 0;
          next_column[9:0] = (column < 1023) ? column[9:0] + 1'b1 : 1'b0;
          next_IMG_COUNT_Y[8:0] = IMG_COUNT_Y[8:0] + 1'b1;
        end
        else if (column[9:0] == 1023) begin
          nextstate = NewAddrLine;
          next_column[9:0] = 0;
          next_row[11:0] = row[11:0] + 1'b1;
        end
        else if (FREE[6:0] == 0) begin
		  next_column[9:0] = column[9:0] + 1'b1;
          nextstate = WaitingFIFO;
          next_support_count[4:0] = 5'b0;
        end
      end
      default : begin
        nextstate = AtTheBegging; // Added because undefined_states_go_here is set
      end
    endcase
  end

  // Assign reg'd outputs to state bits

  // sequential always block
  always @(posedge CLOCK_100) begin
    if (!rst_n) begin
      state <= AtTheBegging;
      FREE[6:0] <= 4'b0;
      IMG_COUNT_X[9:0] <= 10'b0;
      IMG_COUNT_Y[8:0] <= 9'b0;
      IMG_POS_X[12:0] <= 13'b0;
      IMG_POS_Y[11:0] <= 12'b0;
      column[9:0] <= 10'b0;
      row[11:0] <= 12'b0;
      support_count[4:0] <= 5'b0;
      tipo [1:0] <= 2'b0;
      end
    else begin
      state <= nextstate;
      FREE[6:0] <= next_FREE[6:0];
      IMG_COUNT_X[9:0] <= next_IMG_COUNT_X[9:0];
      IMG_COUNT_Y[8:0] <= next_IMG_COUNT_Y[8:0];
      IMG_POS_X[12:0] <= next_IMG_POS_X[12:0];
      IMG_POS_Y[11:0] <= next_IMG_POS_Y[11:0];
      column[9:0] <= next_column[9:0];
      row[11:0] <= next_row[11:0];
      support_count[4:0] <= next_support_count[4:0];
      tipo [1:0] <= next_tipo [1:0];
      end
  end

  // datapath sequential always block
  always @(posedge CLOCK_100) begin
    if (!rst_n) begin
      RAM_addr[11:0] <= 12'b0;
      RAM_next <= 0;
      RAM_reset_n <= 1;
      RAM_start <= 0;
    end
    else begin
      RAM_addr[11:0] <= 12'b0; // default
      RAM_next <= 0; // default
      RAM_reset_n <= 1; // default
      RAM_start <= 0; // default
      case (nextstate)
        ResetingMemory: begin
          RAM_reset_n <= 0;
        end
        StartingMemory: begin
          RAM_start <= 1;
        end
        WaitToRead    : begin
          RAM_addr[11:0] <= next_row[11:0];
          RAM_next <= 1;
        end
        Writing       : begin
          RAM_addr[9:0] <= next_column[9:0];
          RAM_next <= 1;
        end
      endcase
    end
  end

endmodule

