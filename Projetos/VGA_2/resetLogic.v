module resetLogic(clkin, locked, rstSignal);

input clkin, locked;
output reg rstSignal;

reg once;
always @(posedge clkin)
begin
	if (~locked)
	begin
		rstSignal = 0;
		once = 1;
	end
	else
	begin
		if (once)
		begin
			rstSignal = 1;
			once = 0;
		end
		else
			rstSignal = 0;	
	end
end


endmodule
