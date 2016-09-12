// megafunction wizard: %LPM_MUX%
// GENERATION: STANDARD
// VERSION: WM1.0
// MODULE: LPM_MUX 

// ============================================================
// File Name: mux_offset.v
// Megafunction Name(s):
// 			LPM_MUX
//
// Simulation Library Files(s):
// 			lpm
// ============================================================
// ************************************************************
// THIS IS A WIZARD-GENERATED FILE. DO NOT EDIT THIS FILE!
//
// 16.0.1 Build 218 06/01/2016 SJ Lite Edition
// ************************************************************


//Copyright (C) 1991-2016 Altera Corporation. All rights reserved.
//Your use of Altera Corporation's design tools, logic functions 
//and other software and tools, and its AMPP partner logic 
//functions, and any output files from any of the foregoing 
//(including device programming or simulation files), and any 
//associated documentation or information are expressly subject 
//to the terms and conditions of the Altera Program License 
//Subscription Agreement, the Altera Quartus Prime License Agreement,
//the Altera MegaCore Function License Agreement, or other 
//applicable license agreement, including, without limitation, 
//that your use is for the sole purpose of programming logic 
//devices manufactured by Altera and sold by Altera or its 
//authorized distributors.  Please refer to the applicable 
//agreement for further details.


// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on
module mux_offset (
	data0x,
	data1x,
	data2x,
	data3x,
	sel,
	result);

	input	[4:0]  data0x;
	input	[4:0]  data1x;
	input	[4:0]  data2x;
	input	[4:0]  data3x;
	input	[1:0]  sel;
	output	[4:0]  result;

	wire [4:0] sub_wire0;
	wire [4:0] sub_wire5 = data3x[4:0];
	wire [4:0] sub_wire4 = data2x[4:0];
	wire [4:0] sub_wire3 = data1x[4:0];
	wire [4:0] result = sub_wire0[4:0];
	wire [4:0] sub_wire1 = data0x[4:0];
	wire [19:0] sub_wire2 = {sub_wire5, sub_wire4, sub_wire3, sub_wire1};

	lpm_mux	LPM_MUX_component (
				.data (sub_wire2),
				.sel (sel),
				.result (sub_wire0)
				// synopsys translate_off
				,
				.aclr (),
				.clken (),
				.clock ()
				// synopsys translate_on
				);
	defparam
		LPM_MUX_component.lpm_size = 4,
		LPM_MUX_component.lpm_type = "LPM_MUX",
		LPM_MUX_component.lpm_width = 5,
		LPM_MUX_component.lpm_widths = 2;


endmodule

// ============================================================
// CNX file retrieval info
// ============================================================
// Retrieval info: PRIVATE: INTENDED_DEVICE_FAMILY STRING "Cyclone IV E"
// Retrieval info: PRIVATE: SYNTH_WRAPPER_GEN_POSTFIX STRING "0"
// Retrieval info: PRIVATE: new_diagram STRING "1"
// Retrieval info: LIBRARY: lpm lpm.lpm_components.all
// Retrieval info: CONSTANT: LPM_SIZE NUMERIC "4"
// Retrieval info: CONSTANT: LPM_TYPE STRING "LPM_MUX"
// Retrieval info: CONSTANT: LPM_WIDTH NUMERIC "5"
// Retrieval info: CONSTANT: LPM_WIDTHS NUMERIC "2"
// Retrieval info: USED_PORT: data0x 0 0 5 0 INPUT NODEFVAL "data0x[4..0]"
// Retrieval info: USED_PORT: data1x 0 0 5 0 INPUT NODEFVAL "data1x[4..0]"
// Retrieval info: USED_PORT: data2x 0 0 5 0 INPUT NODEFVAL "data2x[4..0]"
// Retrieval info: USED_PORT: data3x 0 0 5 0 INPUT NODEFVAL "data3x[4..0]"
// Retrieval info: USED_PORT: result 0 0 5 0 OUTPUT NODEFVAL "result[4..0]"
// Retrieval info: USED_PORT: sel 0 0 2 0 INPUT NODEFVAL "sel[1..0]"
// Retrieval info: CONNECT: @data 0 0 5 0 data0x 0 0 5 0
// Retrieval info: CONNECT: @data 0 0 5 5 data1x 0 0 5 0
// Retrieval info: CONNECT: @data 0 0 5 10 data2x 0 0 5 0
// Retrieval info: CONNECT: @data 0 0 5 15 data3x 0 0 5 0
// Retrieval info: CONNECT: @sel 0 0 2 0 sel 0 0 2 0
// Retrieval info: CONNECT: result 0 0 5 0 @result 0 0 5 0
// Retrieval info: GEN_FILE: TYPE_NORMAL mux_offset.v TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL mux_offset.inc FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL mux_offset.cmp FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL mux_offset.bsf FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL mux_offset_inst.v FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL mux_offset_bb.v FALSE
// Retrieval info: LIB_FILE: lpm
