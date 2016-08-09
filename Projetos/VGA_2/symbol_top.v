// Copyright (C) 1991-2016 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License 
// Subscription Agreement, the Altera Quartus Prime License Agreement,
// the Altera MegaCore Function License Agreement, or other 
// applicable license agreement, including, without limitation, 
// that your use is for the sole purpose of programming logic 
// devices manufactured by Altera and sold by Altera or its 
// authorized distributors.  Please refer to the applicable 
// agreement for further details.

// PROGRAM		"Quartus Prime"
// VERSION		"Version 16.0.0 Build 211 04/27/2016 SJ Lite Edition"
// CREATED		"Wed Aug 03 11:36:17 2016"

module symbol_top2(
	CLOCK_50,
	KEY,
	VGA_HS,
	VGA_VS,
	column,
	row,
	VGA_B,
	VGA_G,
	VGA_R,
	LEDR
);


input wire	CLOCK_50;
input wire	[1:0] KEY;
output wire	VGA_HS;
output wire	VGA_VS;
output wire	[9:0] column;
output wire	[8:0] row;
output wire	[7:0] VGA_B;
output wire	[7:0] VGA_G;
output wire	[7:0] VGA_R;
output wire [17:0] LEDR;

wire	clk100_sig;
wire	rstLog_sig;
wire	rd_en_sig;
wire	wr_en_sig;
wire	[31:0] data_bus_sig;
wire	clk25_sig;
wire	videoon_sig;
wire	empty_sig;
wire	[23:0] data_pixel_sig;
wire	rstVGA_sig;
wire	[7:0] blue_sig;
wire	[7:0] green_sig;
wire	[7:0] red_sig;
wire	locked_sig;
wire	[3:0] freeslots_sig;


assign rstLog_sig = KEY[1];


FIFO	b2v_buffer(
	.clk(clk100_sig),
	.rst(rstLog_sig),
	.rd_en(rd_en_sig),
	.wr_en(wr_en_sig),
	.data_in(data_bus_sig),
	.empty(empty_sig),
	.data_pixel(data_pixel_sig),
	.freeslots(freeslots_sig));


FIFO_reader	b2v_controller(
	.clk100(clk100_sig),
	.clk25(clk25_sig),
	.rst(rstLog_sig),
	.videoon(videoon_sig),
	.empty(empty_sig),
	.data_pixel(data_pixel_sig),
	.rd_en(rd_en_sig),
	.rstVGA(rstVGA_sig),
	.blue(blue_sig),
	.green(green_sig),
	.red(red_sig));


PixelLogic	b2v_dac_interface(
	.clk(clk25_sig),
	.reset(rstVGA_sig),
	.blue(blue_sig),
	.green(green_sig),
	.red(red_sig),
	.hsync(VGA_HS),
	.vsync(VGA_VS),
	.vga_enabled(videoon_sig),
	.b(VGA_B),
	.column(column),
	.g(VGA_G),
	.r(VGA_R),
	.row(row));


//resetLogic	b2v_inst(
//	.clkin(clk25_sig),
//	.locked(locked_sig),
//	.rstSignal(rstLog_sig));


sdram_simulator	b2v_inst1(
	.clkin(clk100_sig),
	.rst(rstLog_sig),
	.freeslots(freeslots_sig),
	.wr_en(wr_en_sig),
	.data_out(data_bus_sig),
	.LEDR(LEDR));


pll	b2v_pelele(
	.inclk0(CLOCK_50),
	.areset(KEY),
	.c0(clk100_sig),
	.c1(clk25_sig),
	.locked(locked_sig));


endmodule
