module ALP(	input clk,
				input [2:0] i_OP,
				input [3:0] i_DATA_IN,
				input i_COMP,
				input i_LOAD,
				input i_CLR,
				output ERR,
				output [3:0] o_R0,
				output [3:0] o_R1
				);

wire [2:0] alu_op_sig;
wire [1:0] sel_r0_sig, sel_r1_sig, sel_srcA_sig, sel_srcB_sig;
/*
assign o_R0 = {sel_r0_sig, sel_srcA_sig};
assign o_R1 = {sel_r1_sig, alu_op_sig};
*/
datapath datapath_inst
(
	.clk(clk) ,	// input  clk_sig
	.i_ALUOp(alu_op_sig) ,	// input [2:0] i_ALUOp_sig
	.i_sel_srcA(sel_srcA_sig) ,	// input [1:0] i_sel_srcA_sig
	.i_sel_srcB(sel_srcB_sig) ,	// input [1:0] i_sel_srcB_sig
	.i_en_r0(en_r0_sig) ,	// input  i_en_r0_sig
	.i_en_r1(en_r1_sig) ,	// input  i_en_r1_sig
	.i_lft_rght_q(lft_rght_q_sig) ,	// input  i_lft_rght_q_sig
	.i_ser_par_q(ser_par_q_sig) ,	// input  i_ser_par_q_sig
	.i_rst_r0(rst_r0_sig) ,	// input  i_rst_r0_sig
	.i_rst_r1(rst_r1_sig) ,	// input  i_rst_r1_sig
	.i_rst_q(rst_q_sig) ,	// input  i_rst_q_sig
	.i_rst_acc(rst_acc_sig) ,	// input  i_rst_acc_sig
	.i_rst_err_e(rst_err_e_sig), // // input i_rst_err_e_sig
	.i_sel_r1(sel_r1_sig) ,	// input [1:0] i_sel_r1_sig
	.i_sel_r0(sel_r0_sig) ,	// input [1:0] i_sel_r0_sig
	.DATA_IN(i_DATA_IN) ,	// input [3:0] DATA_IN_sig
	.i_shft_sel(shft_sel_sig) ,	// input  i_shft_sel_sig
	.i_r0_r1_sel(sel_r0_r1_sig) ,	// input  i_r0_r1_sel_sig
	.i_err_upd(err_upd_sig) ,	// input  i_err_upd_sig
	.o_r0(o_R0) ,	// output [3:0] o_r0_sig
	.o_r1(o_R1) ,	// output [3:0] o_r1_sig
	.o_E(E_sig) ,	// output  o_E_sig
	.o_r1_sign(r1_sign_sig) ,	// output  o_r1_sign_sig
	.o_r0_sign(r0_sign_sig) ,	// output  o_r0_sign_sig
	.o_Q0(Q0_sig) ,	// output  o_Q0_sig
	.o_acc_sign(acc_sign_sig), 	// output  o_acc_sign_sig
	.o_ERR(ERR)
);


controller_unit controller_unit_inst
(
	.clk(clk) ,	// input  clk_sig
	.i_OP(i_OP) ,	// input [2:0] i_OP_sig
	.i_COMP(i_COMP) ,	// input  i_COMP_sig
	.i_LOAD(i_LOAD) ,	// input  i_LOAD_sig
	.i_CLR(i_CLR) ,	// input  i_CLR_sig
	.i_sign_r0(r0_sign_sig) ,	// input  i_sign_r0_sig
	.i_sign_r1(r1_sign_sig) ,	// input  i_sign_r1_sig
	.i_q_0(Q0_sig) ,	// input  i_q_0_sig
	.i_E(E_sig) ,	// input  i_E_sig
	.i_sign_acc(acc_sign_sig) ,	// input  i_sign_acc_sig
	.o_sel_r0(sel_r0_sig) ,	// output [1:0] o_sel_r0_sig
	.o_sel_r1(sel_r1_sig) ,	// output [1:0] o_sel_r1_sig
	.o_en_r0(en_r0_sig) ,	// output  o_en_r0_sig
	.o_en_r1(en_r1_sig) ,	// output  o_en_r1_sig
	.o_rst_r0(rst_r0_sig) ,	// output  o_rst_r0_sig
	.o_rst_r1(rst_r1_sig) ,	// output  o_rst_r1_sig
	.o_rst_acc(rst_acc_sig) ,	// output  o_rst_acc_sig
	.o_rst_q(rst_q_sig) ,	// output  o_rst_q_sig
	.o_rst_err_e(rst_err_e_sig) ,	// output  o_rst_err_e_sig
	.o_sel_srcA(sel_srcA_sig) ,	// output [1:0] o_sel_srcA_sig
	.o_sel_srcB(sel_srcB_sig) ,	// output [1:0] o_sel_srcB_sig
	.o_alu_op(alu_op_sig) ,	// output [2:0] o_alu_op_sig
	.o_shft_sel(shft_sel_sig) ,	// output  o_shft_sel_sig
	.o_sel_r0_r1(sel_r0_r1_sig) ,	// output  o_sel_r0_r1_sig
	.o_ser_par_q(ser_par_q_sig) ,	// output  o_ser_par_q_sig
	.o_lft_rght_q(lft_rght_q_sig) ,	// output  o_lft_rght_q_sig
	.o_err_upd(err_upd_sig)  	// output  o_err_upd_sig
);
endmodule
