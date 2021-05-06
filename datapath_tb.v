`timescale 10ns / 1ps

module datapath_tb();

reg clk, enable, clr;
reg [3:0] DATA_IN_sig;
reg [2:0] i_ALUOp_sig;
reg [1:0] i_sel_srcA_sig, i_sel_srcB_sig, i_sel_r0_sig, i_sel_r1_sig;
reg i_rst_r0_sig, i_rst_r1_sig, i_en_r0_sig, i_en_r1_sig, i_lft_rght_q_sig, i_ser_par_q_sig,
		i_rst_q_sig, i_rst_acc_sig, i_shft_sel_sig, i_r0_r1_sel_sig, i_err_upd_sig, i_e_upd_sig,
		i_rst_err_e_sig;

reg [3:0] errors;
		
wire [3:0] o_r0_sig, o_r1_sig;
wire o_Q0_sig, o_acc_sign_sig, o_r0_sign_sig, o_r1_sign_sig, o_E_sig, o_err;
initial begin
	errors<=0;
	clk <= 0;
	clr <= 0;
	enable <= 1;
	DATA_IN_sig <= 0;
	i_ALUOp_sig <= 0;
	i_sel_srcA_sig <= 0; i_sel_srcB_sig <= 0; i_sel_r0_sig <= 0; i_sel_r1_sig <= 0;
	i_rst_r0_sig<= 0; i_rst_r1_sig<= 0; i_en_r0_sig<= 0; i_en_r1_sig<= 0; i_lft_rght_q_sig<= 0;
	i_ser_par_q_sig<= 0;i_rst_q_sig<= 0; i_rst_acc_sig<= 0; i_shft_sel_sig<= 0; 
	i_r0_r1_sel_sig<= 0; i_err_upd_sig<= 0; i_e_upd_sig<= 0; i_rst_err_e_sig<=0;
end

datapath DUT
(
	.clk(clk) ,	// input  clk_sig
	.i_ALUOp(i_ALUOp_sig) ,	// input [2:0] i_ALUOp_sig
	.i_sel_srcA(i_sel_srcA_sig) ,	// input [1:0] i_sel_srcA_sig
	.i_sel_srcB(i_sel_srcB_sig) ,	// input [1:0] i_sel_srcB_sig
	.i_rst_r0(i_rst_r0_sig) ,	// input  i_rst_r0_sig
	.i_rst_r1(i_rst_r1_sig) ,	// input  i_rst_r1_sig
	.i_en_r0(i_en_r0_sig) ,	// input  i_en_r0_sig
	.i_en_r1(i_en_r1_sig) ,	// input  i_en_r1_sig
	.i_lft_rght_q(i_lft_rght_q_sig) ,	// input  i_lft_rght_q_sig
	.i_ser_par_q(i_ser_par_q_sig) ,	// input  i_ser_par_q_sig
	.i_rst_q(i_rst_q_sig) ,	// input  i_rst_q_sig
	.i_rst_acc(i_rst_acc_sig) ,	// input  i_rst_acc_sig
	.i_rst_err_e(i_rst_err_e_sig),
	.i_sel_r1(i_sel_r1_sig) ,	// input [1:0] i_se_r1l_sig
	.i_sel_r0(i_sel_r0_sig) ,	// input [1:0] i_sel_r0_sig
	.DATA_IN(DATA_IN_sig) ,	// input [3:0] DATA_IN_sig
	.i_shft_sel(i_shft_sel_sig) ,	// input  i_shft_sel_sig
	.i_r0_r1_sel(i_r0_r1_sel_sig) ,	// input  i_r0_r1_sel_sig
	.i_err_upd(i_err_upd_sig) ,	// input  i_err_upd_sig
	.i_e_upd(i_e_upd_sig) ,	// input  i_e_upd_sig
	.o_r0(o_r0_sig) ,	// output [3:0] o_r0_sig
	.o_r1(o_r1_sig) ,	// output [3:0] o_r1_sig
	.o_E(o_E_sig) ,	// output  o_E_sig
	.o_r1_sign(o_r1_sign_sig) ,	// output  o_r1_sign_sig
	.o_r0_sign(o_r0_sign_sig) ,	// output  o_r0_sign_sig
	.o_Q0(o_Q0_sig) ,	// output  o_Q0_sig
	.o_acc_sign(o_acc_sign_sig) , 	// output  o_acc_sign_sig
	.o_ERR(o_err)
);

 always begin
 clk <= 0; #5 ;  clk <= 1; #5 ;
end

always begin
	#17
	// LOAD OP
	// R0 <- 4'b0110;
	DATA_IN_sig <= 4'b0110;
	i_sel_r0_sig[1:0] <= 2'b10;
	i_en_r0_sig <= 1;
	i_sel_r1_sig[1:0] <= 2'b10;
	i_en_r1_sig <= 1;
	#10
	// LOAD OP
	// R0 <- 4'b1001; R1 <- R0 (4'b0110)
	DATA_IN_sig <= 4'b1001;
	i_sel_r0_sig[1:0] <= 2'b10;
	i_en_r0_sig <= 1;
	i_sel_r1_sig[1:0] <= 2'b10;
	i_en_r1_sig <= 1;
	#10
	// R0 <- (-R0)
	i_sel_r0_sig[1:0]=00;
	i_en_r0_sig=1;
	i_en_r1_sig=0;
	i_sel_srcA_sig=01;
	i_sel_srcB_sig=00;
	i_ALUOp_sig=010;
	#10
	if(o_r0_sig != 4'b0111) begin
		$display("ERROR for R0. Expected: %b; Output: %b", 4'b0111, o_r0_sig[3:0]);
		errors = errors + 1;
	end
	// R1 <- (-R1)
	i_sel_r1_sig=00;
	i_en_r0_sig=0;
	i_en_r1_sig=1;
	i_sel_srcA_sig=00;
	i_sel_srcB_sig=01;
	i_ALUOp_sig=001;
	#10;
	if(o_r1_sig != 4'b1010) begin
		$display("ERROR for R0. Expected: %b; Output: %b", 4'b1010, o_r1_sig[3:0]);
		errors = errors + 1;
	end
	// R0 <- (-R0)
	i_sel_r0_sig[1:0]=00;
	i_en_r0_sig=1;
	i_en_r1_sig=0;
	i_sel_srcA_sig=01;
	i_sel_srcB_sig=00;
	i_ALUOp_sig=010;
	
	#10;
	if(o_r0_sig != 4'b1001) begin
		$display("ERROR for R0. Expected: %b; Output: %b", 4'b1001, o_r0_sig[3:0]);
		errors = errors + 1;
	end
	// R1 <- (-R1)
	i_sel_r1_sig=00;
	i_en_r0_sig=0;
	i_en_r1_sig=1;
	i_sel_srcA_sig=00;
	i_sel_srcB_sig=01;
	i_ALUOp_sig=001;
	#10;
	if(o_r1_sig != 4'b0110) begin
		$display("ERROR for R0. Expected: %b; Output: %b", 4'b0110, o_r0_sig[3:0]);
		errors = errors + 1;
	end
	
	$display("%d test completed with %d errors", 4, errors);
	$stop;
end

endmodule
