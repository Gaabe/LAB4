module FIFO (clk, rst, data_in, rd_en, wr_en, data_pixel, empty, freeslots);

input clk, rst, rd_en, wr_en;
input [31:0] data_in ;
output reg empty;
reg full;
output [4:0] freeslots;
output reg [23:0] data_pixel;

reg [4:0] fifo_counter;
reg [2:0] wr_ptr, rd_ptr;
reg [23:0] buf_mem[7:0];

// Seta as flags empty e full
always @(fifo_counter)
begin
   empty = (fifo_counter < 5'd1);
   full = (fifo_counter > 5'd7);
end

assign freeslots = 5'd8 - fifo_counter;

// Atualiza fifo_counter
always @(posedge clk)
begin
	// Se reset, volta p/ 0
   if(rst)
       fifo_counter <= 5'd0;
		 
	// Leitura e escrita simultaneas
   else if( (!full && wr_en) && ( !empty && rd_en ) )
       fifo_counter <= fifo_counter;
		 
	// Escrita sem leitura
   else if( !full && wr_en )
       fifo_counter <= fifo_counter + 5'd1;
		 
	// Leitura sem escrita
   else if( !empty && rd_en )
       fifo_counter <= fifo_counter - 5'd1;
		 
	// Nem leitura nem escrita
   else
      fifo_counter <= fifo_counter;
end

// Lógica de saída (leitura)
always @(posedge clk)
begin
   if(rst)
	begin
		data_pixel <= 0;
	end      
   else
   begin
		// Envio de dados para a saída (leitura)
      if( rd_en && !empty )
		begin
			data_pixel <= buf_mem[rd_ptr];
		end
      else
		begin
			data_pixel <= data_pixel;
		end
   end
end

// Armazenamento da entrada no buffer
always @(posedge clk)
begin

	if (rst)
	begin
		buf_mem[0] <= 255;
		buf_mem[1] <= 255;
		buf_mem[2] <= 255;
		buf_mem[3] <= 255;
		buf_mem[4] <= 255;
		buf_mem[5] <= 255;
		buf_mem[6] <= 255;
		buf_mem[7] <= 255;
	end

   if( wr_en && !full )
	begin
		buf_mem[wr_ptr] <= data_in[31:8];
	end
   else
	begin
		buf_mem[wr_ptr] <= buf_mem[wr_ptr];
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
			wr_ptr <= wr_ptr + 3'd1;
		end
      else 
		begin
			wr_ptr <= wr_ptr;
		end
		
      if( !empty && rd_en )
		begin	
			rd_ptr <= rd_ptr + 3'd1;
		end
      else
		begin
			rd_ptr <= rd_ptr;
		end
   end

end

endmodule
