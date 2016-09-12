module t5_t6(v0, v1, v2, v3, sp0, sp1, sp2, sp3, clock_25, clock_maior, rst, att_color, data_color, blue, green, red);
    
	// Sinais básicos de controle
    input clock_25, rst;
    
    // Vetores com as flags indicando a presenca dos sprites em cada uma das 16 posicoes
    input [15:0] v0, v1, v2, v3;

    // Indica o codigo do sprite referente a cada um dos vetores anteriormente definidos
    input [4:0] sp0, sp1, sp2, sp3;
    
    // Entradas para atualização da memória de cor
    input [23:0] data_color;                    // Dado da cor vindo da mémoria
    input att_color;                            // Sinal para atualizar a memória
	
	// Sinal para descarregar os sinais dos barramentos de entreda
	input clock_maior;
    
    //Saidas do modulo
    output wire [7:0] red, green, blue;

    // memória interna de cores da FSM.
	reg [23:0] Color_Memory[0:31];
	
	// memória interna de sprites da FSM
	reg [15:0] sprites[0:3];
	reg [4:0] pos[0:3];
	
	
	// Registradores de suporte
	reg branco;
	reg start;
	reg [1:0] state;
	reg [1:0] next_state;
	reg [4:0] elemento;
	reg [4:0] next_elemento;
	reg [4:0] saida;
	reg [3:0] count;
	reg [3:0] next_count;

	parameter 
	Inicio		=  2'b00,
	Atualizando	=	2'b01,	
	Enviando		=	2'b10,
	Sync			=	2'b11;
	
	always @ * begin
		next_state = 5'bxxxxx;
		next_elemento = elemento;
		next_count = count;
		saida = 5'bx;
		branco = 1'b1;
		case (state)
			Inicio	:begin									// Estado Inicial
				next_state = Atualizando;
			end
			Sync		:begin									// Estado de sincronização com o clock mais lento (25/16 Mhz)
				if (start) begin
					if (count == 15) begin
						next_state = Enviando;
					end
					else begin
						next_state = Sync;
						next_count = count + 1'b1;
					end
				end
				else begin
					next_state = Sync;
				end
			end
			Atualizando	:begin								// Estado para atualizar a tabela de cores.
				if (elemento == 5'd31) begin
					next_elemento = 5'b0;
					next_state = Sync;
				end
				else begin
					next_elemento = elemento + 1'b1;
					next_state = Atualizando;
				end
			end
			Enviando	:begin									// Estado de saída das cores do sprite mais importante
				if (att_color) begin
					next_elemento = 5'b0;
					next_state = Atualizando;
				end
				else begin
					next_state = Enviando;
					branco = 1'b0;
					if (sprites[0][15-elemento[3:0]]) begin
						saida = pos[0];
					end
					else if (sprites[1][15-elemento[3:0]]) begin
						saida = pos[1];
					end
					else if (sprites[2][15-elemento[3:0]]) begin
						saida = pos[2];
					end
					else if (sprites[3][15-elemento[3:0]]) begin
						saida = pos[3];
					end
					else begin
						branco = 1'b1;
					end
					next_elemento = elemento + 1'b1;
				end
			end
			default		:begin
				next_state = Inicio;
			end
		endcase			
	end
	
	assign red		= (branco)? 8'b0 : Color_Memory[saida][23:16];
	assign green	= (branco)? 8'b0 : Color_Memory[saida][15:8];
	assign blue		= (branco)? 8'b0 : Color_Memory[saida][7:0];
	
	always @ (posedge clock_maior) begin
		if (!rst) begin
			sprites[0] <= v0;
			sprites[1] <= v1;
			sprites[2] <= v2;
			sprites[3] <= v3;
			pos[0] <= sp0;
			pos[1] <= sp1;
			pos[2] <= sp2;
			pos[3] <= sp3;
			if (next_state == Sync) begin
				start <= 1'b1;
			end
			else begin
				start <= 1'b0;
			end
		end	
	end
	
	always @ (posedge clock_25) begin
		if (rst) begin
			state <= Inicio;
			elemento <= 5'b0;
			count <= 4'b0;
		end
		else begin
			state <= next_state;
			elemento <= next_elemento;
			count <= next_count;
			if (next_state == Atualizando) begin
				Color_Memory [next_elemento] = data_color;
			end
		end
	end
	
endmodule