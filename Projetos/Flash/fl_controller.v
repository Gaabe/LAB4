
// Created by fizzim.pl version 5.10 on 2016:07:27 at 18:40:30 (www.fizzim.com)

module fl_controller (
  output reg [22:0] FL_ADDR,
  output wire FL_CE_N,
  output wire FL_OE_N,
  output wire FL_RST_T,
  output wire FL_WE_N,
  output reg [15:0] data_out0,
  output reg [15:0] data_out1,
  output wire finished,
  output wire ready,
  input wire CLOCK_50,
  input wire [7:0] FL_DQ,
  input wire ack,
  input wire rst_n,
  input wire start 
);

  // state bits
  parameter 
  IDLE          = 10'b0000011100, // extra=0000 ready=0 finished=1 FL_WE_N=1 FL_RST_T=1 FL_OE_N=0 FL_CE_N=0 
  Addressing    = 10'b0000001100, // extra=0000 ready=0 finished=0 FL_WE_N=1 FL_RST_T=1 FL_OE_N=0 FL_CE_N=0 
  Buffering0    = 10'b0001001100, // extra=0001 ready=0 finished=0 FL_WE_N=1 FL_RST_T=1 FL_OE_N=0 FL_CE_N=0 
  Buffering1    = 10'b0010001100, // extra=0010 ready=0 finished=0 FL_WE_N=1 FL_RST_T=1 FL_OE_N=0 FL_CE_N=0 
  Getting_ready = 10'b0011001100, // extra=0011 ready=0 finished=0 FL_WE_N=1 FL_RST_T=1 FL_OE_N=0 FL_CE_N=0 
  Pre_Read      = 10'b0100001100, // extra=0100 ready=0 finished=0 FL_WE_N=1 FL_RST_T=1 FL_OE_N=0 FL_CE_N=0 
  Reading0      = 10'b0101001100, // extra=0101 ready=0 finished=0 FL_WE_N=1 FL_RST_T=1 FL_OE_N=0 FL_CE_N=0 
  Reading1      = 10'b0110001100, // extra=0110 ready=0 finished=0 FL_WE_N=1 FL_RST_T=1 FL_OE_N=0 FL_CE_N=0 
  Reading2      = 10'b0111001100, // extra=0111 ready=0 finished=0 FL_WE_N=1 FL_RST_T=1 FL_OE_N=0 FL_CE_N=0 
  Reading3      = 10'b1000001100, // extra=1000 ready=0 finished=0 FL_WE_N=1 FL_RST_T=1 FL_OE_N=0 FL_CE_N=0 
  Reseting      = 10'b1001001100, // extra=1001 ready=0 finished=0 FL_WE_N=1 FL_RST_T=1 FL_OE_N=0 FL_CE_N=0 
  Sending       = 10'b0000101100; // extra=0000 ready=1 finished=0 FL_WE_N=1 FL_RST_T=1 FL_OE_N=0 FL_CE_N=0 

  reg [9:0] state;
  reg [9:0] nextstate;
  reg buffer;
  reg buffer_count;
  reg [4:0] wait_count;
  reg [22:0] next_FL_ADDR;
  reg next_buffer;
  reg next_buffer_count;
  reg [15:0] next_data_out0;
  reg [15:0] next_data_out1;
  reg [4:0] next_wait_count;

  // comb always block
  always @* begin
    nextstate = 10'bxxxxxxxxxx; // default to x because default_state_is_x is set
    next_FL_ADDR[22:0] = FL_ADDR[22:0];
    next_buffer = buffer;
    next_buffer_count = buffer_count;
    next_data_out0[15:0] = data_out0[15:0];
    next_data_out1[15:0] = data_out1[15:0];
    next_wait_count[4:0] = wait_count[4:0];
    case (state)
      IDLE         : begin
        if (start) begin
          nextstate = Reseting;
          next_wait_count[4:0] = 0;
        end
        else begin
          nextstate = IDLE;
        end
      end
      Addressing   : begin
        begin
          nextstate = Pre_Read;
        end
      end
      Buffering0   : begin
        next_data_out0[15:0] = data_out0[15:0] << 8;
        begin
          nextstate = Pre_Read;
          next_buffer_count = 1;
          next_wait_count[4:0] = 1;
        end
      end
      Buffering1   : begin
        next_data_out1[15:0] = data_out1[15:0] << 8;
        begin
          nextstate = Pre_Read;
        end
      end
      Getting_ready: begin
        if (wait_count[4:0] < 2) begin
          nextstate = Getting_ready;
          next_wait_count[4:0] = wait_count[4:0] + 1'b1;
        end
        else begin
          nextstate = Pre_Read;
          next_buffer_count = 0;
          next_wait_count[4:0] = 0;
          next_buffer = 0;
        end
      end
      Pre_Read     : begin
        if (wait_count[4:0]<5) begin
          nextstate = Pre_Read;
          next_wait_count[4:0] = wait_count[4:0] +1'b1;
        end
        else if (!buffer && !buffer_count) begin
          nextstate = Reading0;
        end
        else if (!buffer && buffer_count) begin
          nextstate = Reading1;
        end
        else if (buffer && !buffer_count) begin
          nextstate = Reading2;
        end
        else begin
          nextstate = Reading3;
        end
      end
      Reading0     : begin
        next_data_out0[15:0] = fl_dq;
        begin
          nextstate = Buffering0;
        end
      end
      Reading1     : begin
        next_data_out0[15:0] = data_out0[15:0] + fl_dq;
        begin
          nextstate = Addressing;
          next_buffer_count = 0;
          next_wait_count[4:0] = 1;
          next_buffer = 1;
        end
      end
      Reading2     : begin
        next_data_out1[15:0] = fl_dq;
        begin
          nextstate = Buffering1;
          next_wait_count[4:0] = 1;
          next_buffer_count = 1;
        end
      end
      Reading3     : begin
        next_data_out1[15:0] = data_out1[15:0] + fl_dq;
        begin
          nextstate = Sending;
        end
      end
      Reseting     : begin
        if (wait_count[4:0] < 25) begin
          nextstate = Reseting;
          next_wait_count[4:0] = wait_count[4:0]+1'b1;
        end
        else begin
          nextstate = Getting_ready;
          next_wait_count[4:0] = 0;
        end
      end
      Sending      : begin
        if (ack && fl_addr[22:0] == 8294399) begin
          nextstate = IDLE;
        end
        else if (ack) begin
          nextstate = Addressing;
          next_buffer_count = 0;
          next_wait_count[4:0] = 1;
          next_buffer = 0;
        end
        else begin
          nextstate = Sending;
        end
      end
    endcase
  end

  // Assign reg'd outputs to state bits
  assign FL_CE_N = state[0];
  assign FL_OE_N = state[1];
  assign FL_RST_T = state[2];
  assign FL_WE_N = state[3];
  assign finished = state[4];
  assign ready = state[5];

  // sequential always block
  always @(posedge CLOCK_50) begin
    if (!rst_n) begin
      state <= IDLE;
      FL_ADDR[22:0] <= 0;
      buffer <= 0;
      buffer_count <= 0;
      data_out0[15:0] <= 0;
      data_out1[15:0] <= 0;
      wait_count[4:0] <= 0;
      end
    else begin
      state <= nextstate;
      FL_ADDR[22:0] <= next_FL_ADDR[22:0];
      buffer <= next_buffer;
      buffer_count <= next_buffer_count;
      data_out0[15:0] <= next_data_out0[15:0];
      data_out1[15:0] <= next_data_out1[15:0];
      wait_count[4:0] <= next_wait_count[4:0];
      end
  end

endmodule

