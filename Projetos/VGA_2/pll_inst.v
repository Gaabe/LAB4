module pll_inst(areset, inclk0, c0, c1, locked);

	input areset, inclk0;
	output c0, c1, locked;
	
	pll pelele(.areset(areset), .inclk0(inclk0), .c0(c0), .c1(c1), .locked(locked));

endmodule
