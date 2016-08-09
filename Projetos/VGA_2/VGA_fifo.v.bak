module FIFO (clk, rst, data_in, rd_en, wr_en, data_R, data_G, data_B, empty, full);

input clk, rst, rd_en, wr_en;
input [31:0] data_in ;
output reg full, empty;
output reg [7:0] data_R, data_G, data_B;

reg [4:0] fifo_counter;
reg [4:0] wr_ptr, rd_ptr;
reg [7:0] buf_mem[15:0];

// Seta as flags empty e full
always @(fifo_counter)
begin
   empty = (fifo_counter < 3);
   full = (fifo_counter > 12);
end

// Atualiza fifo_counter
always @(posedge clk)
begin
	// Se reset, volta p/ 0
   if(rst)
       fifo_counter <= 0;
		 
	// Leitura e escrita simultaneas
   else if( (!full && wr_en) && ( !empty && rd_en ) )
       fifo_counter <= fifo_counter + 1;
		 
	// Escrita sem leitura
   else if( !full && wr_en )
       fifo_counter <= fifo_counter + 4;
		 
	// Leitura sem escrita
   else if( !empty && rd_en )
       fifo_counter <= fifo_counter - 3;
		 
	// Nem leitura nem escrita
   else
      fifo_counter <= fifo_counter;
end

// Lógica de saída (leitura)
always @(posedge clk)
begin
   if(rst)
	begin
		data_R <= 0;
		data_G <= 0;
		data_B <= 0;
	end      
   else
   begin
		// Envio de dados para a saída (leitura)
      if( rd_en && !empty )
		begin
			data_R <= buf_mem[rd_ptr];
			data_G <= buf_mem[(rd_ptr+1) % 16];
			data_B <= buf_mem[(rd_ptr+2) % 16];
		end
      else
		begin
			data_R <= data_R;
			data_G <= data_G;
			data_B <= data_B;
		end
   end
end

// Armazenamento da entrada no buffer
always @(posedge clk)
begin
   if( wr_en && !full )
	begin
		buf_mem[wr_ptr] <= data_in[31:24];
		buf_mem[(wr_ptr+1) % 16] <= data_in[23:16];
		buf_mem[(wr_ptr+2) % 16] <= data_in[15:8];
		buf_mem[(wr_ptr+3) % 16] <= data_in[7:0];
	end
   else
	begin
		buf_mem[wr_ptr] <= buf_mem[wr_ptr];
		buf_mem[(wr_ptr+1) % 16] <= buf_mem[(wr_ptr+1) % 16];
		buf_mem[(wr_ptr+2) % 16] <= buf_mem[(wr_ptr+2) % 16];
		buf_mem[(wr_ptr+3) % 16] <= buf_mem[(wr_ptr+3) % 16];
	end
end

// Lógica de incremento dos wr e rd pointers
always@(posedge clk)
begin
   if(rst)
   begin
      wr_ptr <= 0;
      rd_ptr <= 0;
   end
   else
   begin
      if(!full && wr_en)
		begin
			wr_ptr <= (wr_ptr + 4) % 16;
		end
      else 
		begin
			wr_ptr <= wr_ptr;
		end
		
      if( !empty && rd_en )
		begin	
			rd_ptr <= (rd_ptr + 3) % 16;
		end
      else
		begin
			rd_ptr <= rd_ptr;
		end
   end

end

endmodule
