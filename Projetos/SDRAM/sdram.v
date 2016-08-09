
// Created by fizzim.pl version 5.10 on 2016:08:01 at 17:37:31 (www.fizzim.com)

module sdram (
  output reg CFL_ack,
  output reg CFL_rst_n,
  output reg CFL_start,
  output reg CGRAM_rdy,
  output reg [12:0] DRAM_ADDR,
  output reg [1:0] DRAM_BA,
  output reg DRAM_CAS_N,
  output reg DRAM_CKE,
  output reg DRAM_CS_N,
  output reg DRAM_DQM0,
  output reg DRAM_DQM1,
  output reg DRAM_DQM2,
  output reg DRAM_DQM3,
  output reg DRAM_RAS_N,
  output reg DRAM_WE_N,
  output reg FIFO_re,
  input wire CFL_finished,
  input wire CFL_ready,
  input wire [11:0] CGRAM_addr,
  input wire CGRAM_next,
  input wire CGRAM_start,
  input wire CLOCK_100,
  input wire rst_n 
);
  // state bits
  parameter 
  Desligado        = 5'b00000, 
  Activating       = 5'b00001, 
  ActivatingR      = 5'b00010, 
  ForeverWaiting   = 5'b00011, 
  IDLE             = 5'b00100, 
  InicializandoNOP = 5'b00101, 
  InicializandoPRE = 5'b00110, 
  InicializandoREF = 5'b00111, 
  LoadMODE         = 5'b01000, 
  NOPTIME2         = 5'b01001, 
  NOPTIME3         = 5'b01010, 
  NOPTIME4         = 5'b01011, 
  NOPTIME5         = 5'b01100, 
  PRECHARGIN       = 5'b01101, 
  REFTIME0         = 5'b01110, 
  REFTIME1         = 5'b01111, 
  REFTIME2         = 5'b10000, 
  RandomAcess      = 5'b10001, 
  Refresh          = 5'b10010, 
  RefreshWrite     = 5'b10011, 
  Reseting_FL      = 5'b10100, 
  Starting_FL      = 5'b10101, 
  Writing_PRE      = 5'b10110; 

  reg [4:0] state;
  reg [4:0] nextstate;
  reg [9:0] Refresh_count;
  reg WR;
  reg [9:0] column_data;
  reg [11:0] row_data;
  reg [1:0] support_count2;
  reg [2:0] support_count;
  reg [9:0] next_Refresh_count;
  reg next_WR;
  reg [9:0] next_column_data;
  reg [11:0] next_row_data;
  reg [1:0] next_support_count2;
  reg [2:0] next_support_count;

  // comb always block
  always @* begin
    nextstate = 5'bxxxxx; // default to x because default_state_is_x is set
    next_Refresh_count[9:0] = Refresh_count[9:0];
    next_WR = WR;
    next_column_data[9:0] = column_data[9:0];
    next_row_data[11:0] = row_data[11:0];
    next_support_count2[1:0] = support_count2[1:0];
    next_support_count[2:0] = support_count[2:0];
    case (state)
      Desligado       : begin
        if (!CGRAM_start) begin
          nextstate = Desligado;
        end
        else if (CGRAM_start) begin
          nextstate = InicializandoNOP;
        end
      end
      Activating      : begin
        begin
          nextstate = NOPTIME2;
          next_Refresh_count[9:0] = Refresh_count[9:0] + 1'b1;
        end
      end
      ActivatingR     : begin
        begin
          nextstate = NOPTIME4;
          next_Refresh_count[9:0] = Refresh_count[9:0] + 1'b1;
        end
      end
      ForeverWaiting  : begin
        if (Refresh_count[9:0] > 700) begin
          nextstate = RefreshWrite;
        end
        else if (!CFL_ready) begin
          nextstate = ForeverWaiting;
          next_Refresh_count[9:0] = Refresh_count[9:0] + 1'b1;
        end
        else if (CFL_ready && Refresh_count[9:0] < 700) begin
          nextstate = Activating;
          next_Refresh_count[9:0] = Refresh_count[9:0] + 1'b1;
        end
        else if (CFL_finished) begin
          nextstate = Refresh;
          next_Refresh_count[9:0] = Refresh_count[9:0] + 1'b1;
          next_support_count[2:0] = 0;
        end
      end
      IDLE            : begin
        if (Refresh_count[9:0] > 700) begin
          nextstate = Refresh;
        end
        else if (WR && Refresh_count[9:0] < 700) begin
          nextstate = Reseting_FL;
          next_Refresh_count[9:0] = Refresh_count[9:0] + 1'b1;
          next_WR = 0;
          next_support_count[2:0] = 0;
        end
        else if (!WR && !CGRAM_next && Refresh_count[9:0] <=700) begin
          nextstate = IDLE;
          next_Refresh_count[9:0] = Refresh_count[9:0] + 1'b1;
        end
        else if (!WR && CGRAM_next && Refresh_count < 700) begin
          nextstate = ActivatingR;
          next_Refresh_count[9:0] = Refresh_count[9:0] + 1'b1;
          next_support_count[2:0] = 0;
        end
      end
      InicializandoNOP: begin
        if (Refresh_count[9:0] < 1023 && support_count2[1:0] < 3) begin
          nextstate = InicializandoNOP;
          next_Refresh_count[9:0] = Refresh_count[9:0] + 1'b1;
        end
        else if (Refresh_count[9:0] == 1023 && support_count[2:0] < 7) begin
          nextstate = InicializandoNOP;
          next_Refresh_count[9:0] = 0;
          next_support_count[2:0] = support_count[2:0] + 1'b1;
        end
        else if (support_count[2:0] == 7 && support_count2[1:0] < 3) begin
          nextstate = InicializandoNOP;
          next_support_count[2:0] = 0;
          next_Refresh_count[9:0] = 0;
        end
        else if (support_count2[1:0] == 3) begin
          nextstate = InicializandoPRE;
        end
      end
      InicializandoPRE: begin
        if (Refresh_count[9:0] < 1) begin
          nextstate = InicializandoPRE;
          next_Refresh_count[9:0] = Refresh_count[9:0] +1'b1;
        end
        else if (Refresh_count[9:0] == 1) begin
          nextstate = InicializandoREF;
          next_support_count[2:0] = 0;
          next_Refresh_count[9:0] = 0;
        end
      end
      InicializandoREF: begin
        begin
          nextstate = REFTIME0;
          next_Refresh_count[9:0] = Refresh_count[9:0] + 1'b1;
        end
      end
      LoadMODE        : begin
        begin
          nextstate = IDLE;
          next_Refresh_count[9:0] = Refresh_count[9:0] + 1'b1;
        end
      end
      NOPTIME2        : begin
        begin
          nextstate = Writing_PRE;
          next_support_count[2:0] = 0;
          next_Refresh_count[9:0] = Refresh_count[9:0] + 1'b1;
        end
      end
      NOPTIME3        : begin
        if (support_count[2:0] < 7) begin
          nextstate = NOPTIME3;
          next_support_count[2:0] = support_count[2:0] + 1'b1;
          next_Refresh_count[9:0] = Refresh_count[9:0] + 1'b1;
        end
        else if (support_count[2:0] == 7) begin
          nextstate = ForeverWaiting;
          next_support_count[2:0] = 0;
          next_Refresh_count[9:0] = Refresh_count[9:0] + 1'b1;
        end
      end
      NOPTIME4        : begin
        begin
          nextstate = RandomAcess;
          next_Refresh_count[9:0] = Refresh_count[9:0];
        end
      end
      NOPTIME5        : begin
        if (support_count[2:0] < 2) begin
          nextstate = NOPTIME5;
          next_Refresh_count[9:0] = Refresh_count[9:0] + 1'b1;
          next_support_count[2:0] = support_count[2:0] + 1'b1;
        end
        else if (support_count[2:0] == 2 && !CGRAM_next) begin
          nextstate = Refresh;
        end
        else if (support_count[2:0] == 2 && CGRAM_next) begin
          nextstate = ActivatingR;
          next_Refresh_count[9:0] = Refresh_count[9:0] +1 'b1;
        end
      end
      PRECHARGIN      : begin
        begin
          nextstate = NOPTIME5;
          next_support_count[2:0] = 0;
          next_Refresh_count[9:0] = Refresh_count[9:0] + 1'b1;
        end
      end
      REFTIME0        : begin
        if (Refresh_count[9:0] < 6) begin
          nextstate = REFTIME0;
          next_Refresh_count[9:0] = Refresh_count[9:0] + 1'b1;
        end
        else if (support_count[2:0] < 7) begin
          nextstate = InicializandoREF;
          next_Refresh_count[9:0] = 0;
          next_support_count[2:0] = support_count[2:0] + 1'b1;
        end
        else if (support_count[2:0] == 7) begin
          nextstate = LoadMODE;
          next_Refresh_count[9:0] = 0;
          next_support_count[2:0] = 0;
        end
      end
      REFTIME1        : begin
        if (support_count[2:0] < 5) begin
          nextstate = REFTIME1;
          next_support_count[2:0] = support_count[2:0] + 1'b1;
        end
        else if (support_count[2:0] == 5) begin
          nextstate = IDLE;
          next_support_count[2:0] = 0;
          next_Refresh_count[9:0] = 0;
        end
      end
      REFTIME2        : begin
        if (support_count[2:0] < 5) begin
          nextstate = REFTIME2;
          next_support_count[2:0] = support_count[2:0] + 1'b1;
        end
        else if (support_count[2:0] == 5) begin
          nextstate = ForeverWaiting;
          next_support_count[2:0] = 0;
          next_Refresh_count[9:0] = 0;
        end
      end
      RandomAcess     : begin
        if (CGRAM_next) begin
          nextstate = RandomAcess;
          next_Refresh_count[9:0] = Refresh_count[9:0] + 1'b1;
        end
        else if (!CGRAM_next) begin
          nextstate = PRECHARGIN;
          next_Refresh_count[9:0] = Refresh_count[9:0] + 1'b1;
        end
      end
      Refresh         : begin
        begin
          nextstate = REFTIME1;
          next_support_count[2:0] = 1'b1;
        end
      end
      RefreshWrite    : begin
        begin
          nextstate = REFTIME2;
          next_support_count[2:0] = 1'b1;
        end
      end
      Reseting_FL     : begin
        if (support_count[2:0] < 7) begin
          nextstate = Reseting_FL;
          next_Refresh_count[9:0] = Refresh_count[9:0] + 1'b1;
          next_support_count[2:0] = support_count[2:0] + 1'b1;
        end
        else if (support_count[2:0] == 7) begin
          nextstate = Starting_FL;
          next_Refresh_count[9:0] = Refresh_count[9:0] + 1'b1;
          next_support_count[2:0] = 0;
        end
      end
      Starting_FL     : begin
        if (support_count[2:0] < 5) begin
          nextstate = Starting_FL;
          next_Refresh_count[9:0] = Refresh_count[9:0] + 1'b1;
          next_support_count[2:0] = support_count[2:0] +1'b1;
        end
        else if (support_count[2:0] == 5) begin
          nextstate = ForeverWaiting;
          next_Refresh_count[9:0] = Refresh_count[9:0] + 1'b1;
          next_support_count[2:0] = 0;
        end
      end
      Writing_PRE     : begin
        if (column_data[9:0] == 1023) begin
          nextstate = NOPTIME3;
          next_column_data[9:0] = 0;
          next_row_data[11:0] = row_data[11:0] +1'b1;
          next_Refresh_count[9:0] = Refresh_count[9:0] + 1'b1;
        end
        else if (column_data[9:0] < 1023) begin
          nextstate = NOPTIME3;
          next_Refresh_count[9:0] = Refresh_count[9:0] + 1'b1;
          next_column_data[9:0] = column_data[9:0] + 1'b1;
        end
      end
      default : begin
        nextstate = Desligado; // Added because undefined_states_go_here is set
      end
    endcase
  end

  // Assign reg'd outputs to state bits

  // sequential always block
  always @(negedge CLOCK_100) begin
    if (!rst_n) begin
      state <= Desligado;
      Refresh_count[9:0] <= 0;
      WR <= 1;
      column_data[9:0] <= 0;
      row_data[11:0] <= 0;
      support_count2[1:0] <= 0;
      support_count[2:0] <= 0;
      end
    else begin
      state <= nextstate;
      Refresh_count[9:0] <= next_Refresh_count[9:0];
      WR <= next_WR;
      column_data[9:0] <= next_column_data[9:0];
      row_data[11:0] <= next_row_data[11:0];
      support_count2[1:0] <= next_support_count2[1:0];
      support_count[2:0] <= next_support_count[2:0];
      end
  end

  // datapath sequential always block
  always @(negedge CLOCK_100) begin
    if (!rst_n) begin
      CFL_ack <= 0;
      CFL_rst_n <= 1;
      CFL_start <= 0;
      CGRAM_rdy <= 0;
      DRAM_ADDR[12:0] <= 13'bx;
      DRAM_BA[1:0] <= 2'b0;
      DRAM_CAS_N <= 1;
      DRAM_CKE <= 1;
      DRAM_CS_N <= 1;
      DRAM_DQM0 <= 1;
      DRAM_DQM1 <= 1;
      DRAM_DQM2 <= 1;
      DRAM_DQM3 <= 1;
      DRAM_RAS_N <= 1;
      DRAM_WE_N <= 1;
      FIFO_re <= 0;
    end
    else begin
      CFL_ack <= 0; 
      CFL_rst_n <= 1;
      CFL_start <= 0; 
      CGRAM_rdy <= 0;
		DRAM_ADDR[12] <= 1'b0;
      DRAM_ADDR[11:0] <= 12'bx; 
      DRAM_BA[1:0] <= 2'b0;
      DRAM_CAS_N <= 0; 
      DRAM_CKE <= 1; 
      DRAM_CS_N <= 0;
      DRAM_DQM0 <= 1; 
      DRAM_DQM1 <= 1;
      DRAM_DQM2 <= 1;
      DRAM_DQM3 <= 1;
      DRAM_RAS_N <= 0;
      DRAM_WE_N <= 0;
      FIFO_re <= 0;
      case (nextstate)
        Desligado       : begin
          DRAM_CAS_N <= 1;
          DRAM_CKE <= 0;
          DRAM_CS_N <= 1;
          DRAM_RAS_N <= 1;
          DRAM_WE_N <= 1;
        end
        Activating      : begin
          DRAM_ADDR[11:0] <= row_data[11:0];
          DRAM_CAS_N <= 1;
          DRAM_WE_N <= 1;
        end
        ActivatingR     : begin
          CGRAM_rdy <= 1;
          DRAM_ADDR[11:0] <= CGRAM_addr[11:0];
          DRAM_CAS_N <= 1;
          DRAM_WE_N <= 1;
        end
        ForeverWaiting  : begin
          DRAM_CAS_N <= 1;
          DRAM_RAS_N <= 1;
          DRAM_WE_N <= 1;
        end
        IDLE            : begin
          DRAM_CAS_N <= 1;
          DRAM_RAS_N <= 1;
          DRAM_WE_N <= 1;
        end
        InicializandoNOP: begin
          DRAM_CAS_N <= 1;
          DRAM_RAS_N <= 1;
          DRAM_WE_N <= 1;
        end
        InicializandoPRE: begin
			 DRAM_ADDR[10] <= 1'b1;
          DRAM_CAS_N <= 1;
        end
        InicializandoREF: begin
          DRAM_WE_N <= 1;
        end
        LoadMODE        : begin
			 DRAM_ADDR[11:10] <= 2'b00;
			 DRAM_ADDR[9:7] <= 3'b000;
			 DRAM_ADDR[6:4] <= 3'b010;
          DRAM_ADDR[3:0] <= 4'b0000;
        end
        NOPTIME2        : begin
          DRAM_CAS_N <= 1;
          DRAM_RAS_N <= 1;
          DRAM_WE_N <= 1;
        end
        NOPTIME3        : begin
          CFL_ack <= 1;
          DRAM_CAS_N <= 1;
          DRAM_RAS_N <= 1;
          DRAM_WE_N <= 1;
        end
        NOPTIME4        : begin
          DRAM_CAS_N <= 1;
          DRAM_RAS_N <= 1;
          DRAM_WE_N <= 1;
        end
        NOPTIME5        : begin
          DRAM_CAS_N <= 1;
          DRAM_RAS_N <= 1;
          DRAM_WE_N <= 1;
        end
        PRECHARGIN      : begin
          DRAM_CAS_N <= 1;
        end
        REFTIME0        : begin
          DRAM_CAS_N <= 1;
          DRAM_RAS_N <= 1;
          DRAM_WE_N <= 1;
        end
        REFTIME1        : begin
          DRAM_CAS_N <= 1;
          DRAM_RAS_N <= 1;
          DRAM_WE_N <= 1;
        end
        REFTIME2        : begin
          DRAM_CAS_N <= 1;
          DRAM_RAS_N <= 1;
          DRAM_WE_N <= 1;
        end
        RandomAcess     : begin
			 DRAM_ADDR[10] <= 1'b0;
          DRAM_ADDR[9:0] <= CGRAM_addr[9:0];
          DRAM_RAS_N <= 1;
          DRAM_WE_N <= 1;
          FIFO_re <= 1;
        end
        Refresh         : begin
          DRAM_WE_N <= 1;
        end
        RefreshWrite    : begin
          DRAM_WE_N <= 1;
        end
        Reseting_FL     : begin
          CFL_rst_n <= 0;
          DRAM_CAS_N <= 1;
          DRAM_RAS_N <= 1;
          DRAM_WE_N <= 1;
        end
        Starting_FL     : begin
          CFL_start <= 1;
          DRAM_CAS_N <= 1;
          DRAM_RAS_N <= 1;
          DRAM_WE_N <= 1;
        end
        Writing_PRE     : begin
          DRAM_ADDR[10] <= 1'b1;
          DRAM_ADDR[9:0] <= column_data[9:0];
          DRAM_RAS_N <= 1;
        end
      endcase
    end
  end

endmodule

