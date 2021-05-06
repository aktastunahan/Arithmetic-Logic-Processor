// Copyright (C) 1991-2013 Altera Corporation
// Your use of Altera Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License 
// Subscription Agreement, Altera MegaCore Function License 
// Agreement, or other applicable license agreement, including, 
// without limitation, that your use is for the sole purpose of 
// programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the 
// applicable agreement for further details.

// PROGRAM		"Quartus II 64-Bit"
// VERSION		"Version 13.1.0 Build 162 10/23/2013 SJ Web Edition"
// CREATED		"Mon Apr 19 03:29:06 2021"

module datapath(
	clk,
	i_rst_r0,
	i_rst_r1,
	i_en_r0,
	i_en_r1,
	i_lft_rght_q,
	i_ser_par_q,
	i_rst_q,
	i_rst_acc,
	i_shft_sel,
	i_r0_r1_sel,
	i_err_upd,
	i_rst_err_e,
	DATA_IN,
	i_ALUOp,
	i_sel_r0,
	i_sel_r1,
	i_sel_srcA,
	i_sel_srcB,
	o_E,
	o_r1_sign,
	o_r0_sign,
	o_Q0,
	o_acc_sign,
	o_ERR,
	o_r0,
	o_r1
);


input wire	clk;
input wire	i_rst_r0;
input wire	i_rst_r1;
input wire	i_en_r0;
input wire	i_en_r1;
input wire	i_lft_rght_q;
input wire	i_ser_par_q;
input wire	i_rst_q;
input wire	i_rst_acc;
input wire	i_shft_sel;
input wire	i_r0_r1_sel;
input wire	i_err_upd;
input wire	i_rst_err_e;
input wire	[3:0] DATA_IN;
input wire	[2:0] i_ALUOp;
input wire	[1:0] i_sel_r0;
input wire	[1:0] i_sel_r1;
input wire	[1:0] i_sel_srcA;
input wire	[1:0] i_sel_srcB;
output wire	o_E;
output wire	o_r1_sign;
output wire	o_r0_sign;
output wire	o_Q0;
output wire	o_acc_sign;
output wire	o_ERR;
output wire	[3:0] o_r0;
output wire	[3:0] o_r1;

wire	[3:0] Acc;
wire	[1:0] err_e;
wire	OVF;
wire	[3:0] Q;
wire	[3:0] r0_val;
wire	[3:0] r1_val;
wire	[3:0] result;
wire	SYNTHESIZED_WIRE_0;
wire	[3:0] SYNTHESIZED_WIRE_1;
wire	[3:0] SYNTHESIZED_WIRE_2;
wire	[3:0] SYNTHESIZED_WIRE_3;
wire	SYNTHESIZED_WIRE_4;
wire	SYNTHESIZED_WIRE_5;
wire	SYNTHESIZED_WIRE_6;
wire	[3:0] SYNTHESIZED_WIRE_7;
wire	[3:0] SYNTHESIZED_WIRE_8;
wire	[3:0] SYNTHESIZED_WIRE_9;
wire	[3:0] SYNTHESIZED_WIRE_12;

assign	SYNTHESIZED_WIRE_0 = 1;
assign	SYNTHESIZED_WIRE_4 = 0;
wire	[1:0] GDFX_TEMP_SIGNAL_0;
wire	[3:0] GDFX_TEMP_SIGNAL_1;
wire	[3:0] GDFX_TEMP_SIGNAL_2;


assign	GDFX_TEMP_SIGNAL_0 = {OVF,Q[0]};
assign	GDFX_TEMP_SIGNAL_1 = {result[3],result[3:1]};
assign	GDFX_TEMP_SIGNAL_2 = {Acc[2:0],Q[3]};


shift_register	b2v_Acc_Register(
	.clk(clk),
	.i_rst(i_rst_acc),
	.i_parallel(SYNTHESIZED_WIRE_0),
	
	
	
	.i_parallel_data(SYNTHESIZED_WIRE_1),
	.o_data(Acc));
	defparam	b2v_Acc_Register.W = 4;


alu	b2v_ALU(
	.i_ALUCtrl(i_ALUOp),
	.i_SrcA(SYNTHESIZED_WIRE_2),
	.i_SrcB(SYNTHESIZED_WIRE_3),
	
	.OVF(OVF),
	.N(SYNTHESIZED_WIRE_5),
	
	.result(result));
	defparam	b2v_ALU.W = 4;


constant_value_generator	b2v_cnst_zero(
	.o_value(SYNTHESIZED_WIRE_12));
	defparam	b2v_cnst_zero.VAL = 4'b0000;
	defparam	b2v_cnst_zero.W = 4;


simple_register	b2v_Err_E_Register(
	.clk(clk),
	.i_rst(i_rst_err_e),
	.i_data(GDFX_TEMP_SIGNAL_0),
	.o_data(err_e));
	defparam	b2v_Err_E_Register.W = 2;


mux2x1	b2v_Err_Val(
	.sel(i_err_upd),
	.i_data0(SYNTHESIZED_WIRE_4),
	.i_data1(err_e[1]),
	.o_data(o_ERR));
	defparam	b2v_Err_Val.W = 1;

assign	SYNTHESIZED_WIRE_6 =  ~SYNTHESIZED_WIRE_5;




mux2x1	b2v_Mul_Div(
	.sel(i_r0_r1_sel),
	.i_data0(r0_val),
	.i_data1(r1_val),
	.o_data(SYNTHESIZED_WIRE_7));
	defparam	b2v_Mul_Div.W = 4;


shift_register	b2v_Q_Register(
	.clk(clk),
	.i_rst(i_rst_q),
	.i_parallel(i_ser_par_q),
	.i_right(i_lft_rght_q),
	.i_serial_rdata(SYNTHESIZED_WIRE_6),
	.i_serial_ldata(result[0]),
	.i_parallel_data(SYNTHESIZED_WIRE_7),
	.o_data(Q));
	defparam	b2v_Q_Register.W = 4;


register	b2v_R0(
	.clk(clk),
	.i_rst(i_rst_r0),
	.i_wrt_en(i_en_r0),
	.i_data(SYNTHESIZED_WIRE_8),
	.o_data(r0_val));
	defparam	b2v_R0.W = 4;


mux4x1	b2v_R0_Sel(
	.i_data0(result),
	.i_data1(Q),
	.i_data2(DATA_IN),
	
	.sel(i_sel_r0),
	.o_data(SYNTHESIZED_WIRE_8));
	defparam	b2v_R0_Sel.W = 4;


register	b2v_R1(
	.clk(clk),
	.i_rst(i_rst_r1),
	.i_wrt_en(i_en_r1),
	.i_data(SYNTHESIZED_WIRE_9),
	.o_data(r1_val));
	defparam	b2v_R1.W = 4;


mux4x1	b2v_R1_Sel(
	.i_data0(result),
	.i_data1(Acc),
	.i_data2(r0_val),
	
	.sel(i_sel_r1),
	.o_data(SYNTHESIZED_WIRE_9));
	defparam	b2v_R1_Sel.W = 4;


mux2x1	b2v_shifter(
	.sel(i_shft_sel),
	.i_data0(result),
	.i_data1(GDFX_TEMP_SIGNAL_1),
	.o_data(SYNTHESIZED_WIRE_1));
	defparam	b2v_shifter.W = 4;


mux4x1	b2v_SrcA(
	.i_data0(SYNTHESIZED_WIRE_12),
	.i_data1(r0_val),
	.i_data2(Acc),
	
	.sel(i_sel_srcA),
	.o_data(SYNTHESIZED_WIRE_2));
	defparam	b2v_SrcA.W = 4;


mux4x1	b2v_SrcB(
	.i_data0(SYNTHESIZED_WIRE_12),
	.i_data1(r1_val),
	.i_data2(GDFX_TEMP_SIGNAL_2),
	
	.sel(i_sel_srcB),
	.o_data(SYNTHESIZED_WIRE_3));
	defparam	b2v_SrcB.W = 4;

assign	o_E = err_e[0];
assign	o_r1_sign = r1_val[3];
assign	o_r0_sign = r0_val[3];
assign	o_Q0 = Q[0];
assign	o_acc_sign = Acc[3];
assign	o_r0 = r0_val;
assign	o_r1 = r1_val;

endmodule
