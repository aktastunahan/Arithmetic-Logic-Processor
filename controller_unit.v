module controller_unit( input clk,
								input [2:0] i_OP,
								input i_COMP,
								input i_LOAD,
								input i_CLR,
								input i_sign_r0,
								input i_sign_r1,
								input i_q_0,
								input i_E,
								input i_sign_acc,
								output reg [1:0] o_sel_r0,
								output reg [1:0] o_sel_r1,
								output reg o_en_r0,
								output reg o_en_r1,
								output reg o_rst_r0,
								output reg o_rst_r1,
								output reg o_rst_acc,
								output reg o_rst_q,
								output reg o_rst_err_e,
								output reg [1:0] o_sel_srcA,
								output reg [1:0] o_sel_srcB,
								output reg [2:0] o_alu_op,
								output reg o_shft_sel,
								output reg o_sel_r0_r1,
								output reg o_ser_par_q,
								output reg o_lft_rght_q,
								output reg o_e_upd,
								output reg o_err_upd,
								// deneme
								output reg [4:0] CSs,
								output reg [4:0] NSs
);
// initial state
parameter [4:0] ST_IDLE = 0; 
// states for operations except multiplication and division
parameter [4:0] ST_OP = 1; 
// states for multiplication
parameter [4:0] ST_MUL_IDLE = 2, ST_MUL_END = 4;
parameter [4:0] ST_MUL_OP = 3;
// states for division
parameter [4:0] ST_DIV_IDLE_0 = 5, ST_DIV_IDLE_1 = 6, ST_DIV_IDLE_2 = 7;
parameter [4:0] ST_DIV_OP = 8;
parameter [4:0] ST_DIV_END_0 = 9, ST_DIV_END_1 = 10, ST_DIV_END_2 = 11;

reg [4:0] CS, NS;

initial begin
	CS <= ST_IDLE;
	NS <= ST_IDLE;
end

// state counter
reg [3:0] sc;
reg load_sc, clr_sc, cnt_sc;
always@(posedge clk)
	if(clr_sc)
		sc <= 3'b011;
	else if(cnt_sc)
		sc <= sc-1;
	else
		sc <= sc;
		
always@*  begin
	CSs = CS;
	NSs = NS;
	case(CS)
	
		// box 1
		ST_IDLE: begin
			o_err_upd = 0;
			o_e_upd = 0;
			if(i_LOAD) begin
				o_sel_r0[1:0] = 2'b10;
				o_en_r0 = 1;
				o_sel_r1[1:0] = 2'b10;
				o_en_r1 = 1;
				o_rst_r0 = 0;
				o_rst_r1 = 0;
				o_rst_acc = 0;
				o_rst_q = 0;
				o_rst_err_e = 1;
			end
			else begin
				if(i_CLR) begin
					o_rst_r0 = 1;
					o_rst_r1 = 1;
					o_rst_acc = 1;
					o_rst_q = 1;
					o_rst_err_e = 1;
				end
				else begin
					if(i_COMP) begin // BOX 2
						o_sel_r0 = 2'b00;
						o_en_r0 = 1;
						o_rst_r0 = 0;
						o_rst_r1 = 1;
						o_sel_srcA = 2'b01;
						o_sel_srcB = 2'b01;
						o_rst_err_e = 0;
						case(i_OP[2:0])
							3'b000: begin // add
								o_alu_op = 3'b000;
								o_err_upd = 1;
							end
							3'b001: begin // subs
								o_alu_op = 3'b001;
								o_err_upd = 1;
							end
							3'b100: begin // and
								o_alu_op = 3'b100;
								o_err_upd = 0;
							end
							3'b101: begin // or
								o_alu_op = 3'b101;
								o_err_upd = 0;				
							end
							3'b110: begin // exor
								o_alu_op = 3'b110;
								o_err_upd = 0;				
							end
							3'b111: begin // bıc
								o_alu_op = 3'b011;
								o_err_upd = 0;				
							end
							default: begin
							  o_en_r0 = 0;
							  o_en_r1 = 0;
							  o_rst_r0 = 0;
							  o_rst_r1 = 0;
							end
						endcase
					end
					else begin
						o_en_r0 = 0;
						o_en_r1 = 0;
						o_rst_r0 = 0;
						o_rst_r1 = 0;
					end
				end
			end
		end

		// box 3
		ST_MUL_IDLE: begin
			o_rst_acc = 1;
			o_ser_par_q = 1;
			o_sel_r0_r1 = 0;
			o_rst_err_e = 1;
			clr_sc = 1;
			cnt_sc = 0;
			o_en_r1 = 0;
			o_en_r0 = 0;
			o_e_upd = 1;
		end
		
		ST_MUL_OP: begin
			o_sel_r0 = 2'b01;
			o_rst_acc = 0;
			o_rst_err_e = 0;
			clr_sc = 0;
			cnt_sc = 1;
			o_ser_par_q = 0;
			o_lft_rght_q = 1;
			o_shft_sel = 1;
			o_sel_srcA = 2'b10;
			o_en_r0 = 1;
			if( {i_q_0, i_E} == 2'b10 ) begin
			// substract and shift
				o_sel_srcB = 2'b01;
				o_alu_op = 3'b001;

			end
			else if( {i_q_0, i_E} == 2'b01 ) begin
			// add and shift
				o_sel_srcB = 2'b01;
				o_alu_op = 3'b000;

			end
			else begin
			// just shift
				o_sel_srcB = 2'b00;
				o_alu_op = 3'b000;		
			end
		end
		ST_MUL_END: begin
			o_sel_r0 = 2'b01;
			o_sel_r1 = 2'b01;
			o_en_r0 = 1;
			o_en_r1 = 1;
			clr_sc = 1;
			cnt_sc = 0;
			o_e_upd = 0;
		end
	endcase
end

always@* begin
	
	// box 1
	case(CS)
		ST_IDLE: begin
			if(i_LOAD) 
				NS = ST_IDLE;
			else if(i_CLR)
				NS = ST_IDLE;
			else if(!i_COMP)
				NS = ST_IDLE;
			else begin
				if(i_OP == 3'b011)
					NS = ST_DIV_IDLE_0;
				else if(i_OP == 3'b010)
					NS = ST_MUL_IDLE;
				else
					NS = ST_IDLE;
			end
		 end
		 
		// box 2	
		ST_OP: begin
			NS = ST_IDLE;
		end
		
		// box 3
		ST_MUL_IDLE: begin
			NS = ST_MUL_OP;
		end
		ST_MUL_OP: begin
			if(sc == 0)
				NS = ST_MUL_END;
			else
				NS = ST_MUL_OP;
		end
		ST_MUL_END: begin
			NS = ST_IDLE;
		end
	endcase
end

always@(posedge clk, posedge i_CLR)
	if(i_CLR)
		CS <= ST_IDLE;
	else
		CS <= NS;
endmodule
