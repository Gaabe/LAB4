
// Created by fizzim.pl version 5.10 on 2016:07:30 at 23:49:39 (www.fizzim.com)

module fl_controller (
  output reg [22:0] FL_ADDR,
  output wire FL_CE_N,
  output wire FL_OE_N,
  output wire FL_RST_N,
  output wire FL_WE_N,
  output wire finished,
  output wire ready,
  output wire [15:0] data_out0,
  output wire [15:0] data_out1,
  input wire clk_25,
  input wire [7:0] FL_DQ,
  input wire ack,
  input wire rst_n,
  input wire start 
);

  // state bits
  parameter 
  IDLE          = 4'b0000, // ready=0 finished=1 FL_WE_N=1 FL_RST_N=1 FL_OE_N=1 FL_CE_N=1 
  Addressing    = 4'b0001, // ready=0 finished=0 FL_WE_N=1 FL_RST_N=1 FL_OE_N=0 FL_CE_N=0 
  Getting_ready = 4'b0010, // ready=0 finished=0 FL_WE_N=1 FL_RST_N=1 FL_OE_N=1 FL_CE_N=1 
  Pre_Read      = 4'b0011, // ready=0 finished=0 FL_WE_N=1 FL_RST_N=1 FL_OE_N=0 FL_CE_N=0 
  Reading0      = 4'b0100, // ready=0 finished=0 FL_WE_N=1 FL_RST_N=1 FL_OE_N=0 FL_CE_N=0 
  Reading1      = 4'b0101, // ready=0 finished=0 FL_WE_N=1 FL_RST_N=1 FL_OE_N=0 FL_CE_N=0 
  Reading2      = 4'b0110, // ready=0 finished=0 FL_WE_N=1 FL_RST_N=1 FL_OE_N=0 FL_CE_N=0 
  Reseting      = 4'b0111, // ready=0 finished=0 FL_WE_N=1 FL_RST_N=0 FL_OE_N=1 FL_CE_N=1 
  Sending       = 4'b1000, // ready=1 finished=0 FL_WE_N=1 FL_RST_N=1 FL_OE_N=0 FL_CE_N=0 
  Stabilizing   = 4'b1001; // ready=0 finished=0 FL_WE_N=1 FL_RST_N=1 FL_OE_N=0 FL_CE_N=0 

  reg [3:0] state;
  reg [3:0] nextstate;
  reg buffer;
  reg buffer_count;
  reg [15:0] current_data0;
  reg [15:0] current_data1;
  reg [3:0] wait_count;
  reg [22:0] next_FL_ADDR;
  reg next_buffer;
  reg next_buffer_count;
  reg [15:0] next_current_data0;
  reg [15:0] next_current_data1;
  reg [3:0] next_wait_count;

  // comb always block
  always @* begin
    nextstate = 4'bxxxx; // default to x because default_state_is_x is set
    next_FL_ADDR[22:0] = FL_ADDR[22:0];
    next_buffer = buffer;
    next_buffer_count = buffer_count;
    next_current_data0[15:0] = current_data0[15:0];
    next_current_data1[15:0] = current_data1[15:0];
    next_wait_count[3:0] = wait_count[3:0];
    case (state)
      IDLE         : begin
        next_FL_ADDR[22:0] = 0;
        if (start) begin
          nextstate = Reseting;
          next_wait_count[3:0] = 0;
        end
        else begin
          nextstate = IDLE;
        end
      end
      Addressing   : begin
        next_FL_ADDR[22:0] = FL_ADDR[22:0] + 1'b1;
        begin
          nextstate = Pre_Read;
          next_wait_count[3:0] = 0;
        end
      end
      Getting_ready: begin
        if (wait_count[3:0] < 1) begin
          nextstate = Getting_ready;
          next_wait_count[3:0] = wait_count[3:0] +1'b1;
        end
        else begin
          nextstate = Pre_Read;
          next_buffer_count = 0;
          next_wait_count[3:0] = 0;
          next_buffer = 0;
        end
      end
      Pre_Read     : begin
        if (wait_count[3:0] < 2) begin
          nextstate = Pre_Read;
          next_wait_count[3:0] = wait_count[3:0] + 1'b1;
        end
        else if (!buffer && !buffer_count) begin
          nextstate = Reading0;
          next_wait_count[3:0] = 0;
        end
        else if (!buffer && buffer_count) begin
          nextstate = Reading1;
        end
        else if (buffer && !buffer_count) begin
          nextstate = Reading2;
        end
      end
      Reading0     : begin
        next_current_data0[15:0] = FL_DQ[7:0] << 8;
        begin
          nextstate = Addressing;
          next_buffer_count = 1;
        end
      end
      Reading1     : begin
        next_current_data0[15:0] = current_data0[15:0] + FL_DQ[7:0];
        begin
          nextstate = Addressing;
          next_buffer_count = 0;
          next_buffer = 1;
        end
      end
      Reading2     : begin
        next_current_data1[15:0] = FL_DQ[7:0] << 8;
        begin
          nextstate = Stabilizing;
        end
      end
      Reseting     : begin
        if (wait_count[3:0] < 12) begin
          nextstate = Reseting;
          next_wait_count[3:0] = wait_count[3:0] + 1'b1;
        end
        else begin
          nextstate = Getting_ready;
          next_wait_count[3:0] = 0;
        end
      end
      Sending      : begin
        if (ack && FL_ADDR[22:0] == 8294399) begin
          nextstate = IDLE;
        end
        else if (ack) begin
          nextstate = Addressing;
          next_buffer_count = 0;
          next_buffer = 0;
        end
        else begin
          nextstate = Sending;
        end
      end
      Stabilizing  : begin
        begin
          nextstate = Sending;
        end
      end
      default : begin
        nextstate = IDLE; // Added because undefined_states_go_here is set
      end
    endcase
  end

  // Assign reg'd outputs to state bits
  assign FL_CE_N = (state == IDLE || state == Reseting || state == Getting_ready) ? 1'b1 : 1'b0;
  assign FL_OE_N = (state == IDLE || state == Reseting || state == Getting_ready) ? 1'b1 : 1'b0;
  assign FL_RST_N = (state == Reseting) ? 1'b0 : 1'b1;
  assign FL_WE_N = 1'b1;
  assign finished = (state == IDLE) ? 1'b1 : 1'b0;
  assign ready = (state == Sending) ? 1'b1 : 1'b0;
  assign data_out0 = (state != IDLE) ? current_data0[15:0] : 16'bz;
  assign data_out1 = (state != IDLE) ? current_data1[15:0] : 16'bz;

  // sequential always block
  always @(posedge clk_25) begin
    if (!rst_n) begin
      state <= IDLE;
      FL_ADDR[22:0] <= 0;
      buffer <= 0;
      buffer_count <= 0;
      current_data0[15:0] <= 0;
      current_data1[15:0] <= 0;
      wait_count[3:0] <= 0;
      end
    else begin
      state <= nextstate;
      FL_ADDR[22:0] <= next_FL_ADDR[22:0];
      buffer <= next_buffer;
      buffer_count <= next_buffer_count;
      current_data0[15:0] <= next_current_data0[15:0];
      current_data1[15:0] <= next_current_data1[15:0];
      wait_count[3:0] <= next_wait_count[3:0];
      end
  end

endmodule
