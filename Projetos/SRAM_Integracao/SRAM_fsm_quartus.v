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

// Generated by Quartus Prime Version 16.0.0 Build 211 04/27/2016 SJ Lite Edition
// Created on Mon Aug 22 13:44:44 2016

// synthesis message_off 10175

`timescale 1ns/1ns

module sram_fsm_quartus (
    reset,clock,wr_en,rd_en,
    valid_rd);

    input reset;
    input clock;
    input wr_en;
    input rd_en;
    tri0 reset;
    tri0 wr_en;
    tri0 rd_en;
    output valid_rd;
    reg valid_rd;
    reg [2:0] fstate;
    reg [2:0] reg_fstate;
    parameter IDLE=0,READ=1,READ_OK=2;

    always @(posedge clock)
    begin
        if (clock) begin
            fstate <= reg_fstate;
        end
    end

    always @(fstate or reset or wr_en or rd_en)
    begin
        if (reset) begin
            reg_fstate <= IDLE;
            valid_rd <= 1'b0;
        end
        else begin
            valid_rd <= 1'b0;
            case (fstate)
                IDLE: begin
                    if ((rd_en & ~(wr_en)))
                        reg_fstate <= READ;
                    else if ((~(rd_en) | wr_en))
                        reg_fstate <= IDLE;
                    // Inserting 'else' block to prevent latch inference
                    else
                        reg_fstate <= IDLE;

                    valid_rd <= 1'b0;
                end
                READ: begin
                    if (rd_en)
                        reg_fstate <= READ_OK;
                    else if (~(rd_en))
                        reg_fstate <= IDLE;
                    // Inserting 'else' block to prevent latch inference
                    else
                        reg_fstate <= READ;

                    valid_rd <= 1'b0;
                end
                READ_OK: begin
                    reg_fstate <= IDLE;

                    valid_rd <= 1'b1;
                end
                default: begin
                    valid_rd <= 1'bx;
                    $display ("Reach undefined state");
                end
            endcase
        end
    end
endmodule // sram_fsm_quartus