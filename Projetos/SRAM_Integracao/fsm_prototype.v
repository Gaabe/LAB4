module fsm_prototype(clk, clkPipeline, valid_rd, rd_en, mux_sel, sp0_en, sp1_en, sp2_en, sp3_en, dmux_en, pipeline_rst);

input clk, clkPipeline;
input valid_rd;
input sp0_en, sp1_en, sp2_en, sp3_en;

output rd_en, dmux_en, pipeline_rst;
output [1:0] mux_sel;

endmodule
