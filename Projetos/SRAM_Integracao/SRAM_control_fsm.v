
// Created by fizzim.pl version 5.10 on 2016:08:16 at 15:06:16 (www.fizzim.com)

module sram_fsm (
  output wire CE_N,
  output wire LB_N,
  output wire OE_N,
  output wire UB_N,
  output wire WE_N,
  output wire rd_valid,
  output wire wr_valid,
  input wire clk,
  input wire rd_en,
  input wire reset,
  input wire wr_en 
);

  // state bits
  parameter 
  IDLE     = 7'b0011111, // wr_valid=0 rd_valid=0 WE_N=1 UB_N=1 OE_N=1 LB_N=1 CE_N=1 
  READ     = 7'b0010000, // wr_valid=0 rd_valid=0 WE_N=1 UB_N=0 OE_N=0 LB_N=0 CE_N=0 
  READ_OK  = 7'b0110000, // wr_valid=0 rd_valid=1 WE_N=1 UB_N=0 OE_N=0 LB_N=0 CE_N=0 
  WRITE    = 7'b0010100, // wr_valid=0 rd_valid=0 WE_N=1 UB_N=0 OE_N=1 LB_N=0 CE_N=0 
  WRITE_OK = 7'b1000000; // wr_valid=1 rd_valid=0 WE_N=0 UB_N=0 OE_N=0 LB_N=0 CE_N=0 

  reg [6:0] state;
  reg [6:0] nextstate;

  // comb always block
  always @* begin
    // Warning I2: Neither implied_loopback nor default_state_is_x attribute is set on state machine - defaulting to implied_loopback to avoid latches being inferred 
    nextstate = state; // default to hold value because implied_loopback is set
    case (state)
      IDLE    : begin
        // Warning P3: State IDLE has multiple exit transitions, and transition trans0 has no defined priority 
        // Warning P3: State IDLE has multiple exit transitions, and transition trans3 has no defined priority 
        // Warning P3: State IDLE has multiple exit transitions, and transition trans6 has no defined priority 
        if (rd_en && ~wr_en) begin
          nextstate = READ;
        end
        else if (wr_en) begin
          nextstate = WRITE;
        end
        else if (~rd_en && ~wr_en) begin
          nextstate = IDLE;
        end
      end
      READ    : begin
        begin
          nextstate = READ_OK;
        end
      end
      READ_OK : begin
        begin
          nextstate = IDLE;
        end
      end
      WRITE   : begin
        begin
          nextstate = WRITE_OK;
        end
      end
      WRITE_OK: begin
        begin
          nextstate = IDLE;
        end
      end
    endcase
  end

  // Assign reg'd outputs to state bits
  assign CE_N = state[0];
  assign LB_N = state[1];
  assign OE_N = state[2];
  assign UB_N = state[3];
  assign WE_N = state[4];
  assign rd_valid = state[5];
  assign wr_valid = state[6];

  // sequential always block
  always @(posedge clk) begin
    if (reset)
      state <= IDLE;
    else
      state <= nextstate;
  end

  // This code allows you to see state names in simulation
  `ifndef SYNTHESIS
  reg [63:0] statename;
  always @* begin
    case (state)
      IDLE    :
        statename = "IDLE";
      READ    :
        statename = "READ";
      READ_OK :
        statename = "READ_OK";
      WRITE   :
        statename = "WRITE";
      WRITE_OK:
        statename = "WRITE_OK";
      default :
        statename = "XXXXXXXX";
    endcase
  end
  `endif

endmodule

