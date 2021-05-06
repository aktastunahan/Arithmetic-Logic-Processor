/*	
	THIS FILE IS A MODULE LIBRARY FOR ARM BASED COMPUTER DESIGN.
	THE LIBRARY CONSIST OF SEVERAL MODULES TO BE USED FOR THE
	COMPUTER DESIGN.
*/

//----------------------------------------------------------------------------------------------//

/* 1.2.1*/
// Constant value generator. The module outputs the 'VAL' value as 'W' bit wire.
module constant_value_generator #( parameter W=32, VAL=32'd0) (
											  output [W-1:0] o_value // constant VAL value as W bit output
										);
	assign o_value = VAL;
endmodule

//----------------------------------------------------------------------------------------------//

/* 1.2.2*/
// 2x4 decoder module. Takes 2 bit i_data as input and decodes it as 4 bit o_data output.
module decoder2x4( input  [1:0] i_data, // input data to be decoded
						 output [3:0] o_data	 // decoded value
						 );
	// combinational circuits for the decoder
	assign o_data[0] = ~i_data[0] & ~i_data[1];
	assign o_data[1] =  i_data[0] & ~i_data[1];
	assign o_data[2] = ~i_data[0] &  i_data[1];
	assign o_data[3] =  i_data[0] &  i_data[1];

endmodule

//----------------------------------------------------------------------------------------------//

/* 1.2.3*/
// 2x1 multiplexer module. multiplexes 'W' bit 'i_data0' or 'i_data1' depending on 'sel' input.
module mux2x1 #( parameter W=32 )( 
					  input  [W-1:0] i_data0,	// selected when sel = 0
					  input  [W-1:0] i_data1, 	// selected when sel = 1
					  input  sel,					// select signal
					  output [W-1:0] o_data		// selected data
					);
	// combinational circuit for 2x1 multiplexers for each index, i, from 0 to W-1		

		genvar i;
		generate
		for(i=0;i<W;i=i+1) begin : mux2x1_circuit
			assign o_data[i] = (~sel & i_data0[i]) | (sel & i_data1[i]);
		end
		endgenerate
endmodule

// 4x1 multiplexer module. Multiplexes between 'W' bit 'i_data0', 
// 'i_data1', 'i_data2' or 'i_data3' depending on 'sel' input.
module mux4x1 #( parameter W=32 )( 
					  input  [W-1:0] i_data0, // selected when sel = 0
					  input  [W-1:0] i_data1, // selected when sel = 1
					  input  [W-1:0] i_data2, // selected when sel = 2
					  input  [W-1:0] i_data3, // selected when sel = 3
					  input  [1:0] sel,		// select signal
					  output [W-1:0] o_data   // selected data 
					);
									
	// decode the select (sel) signal
	wire [3:0] sel_sig;
	decoder2x4 select_signal(.i_data(sel), .o_data(sel_sig));
	
	// combinational circuit for 4x1 multiplexers for each index, i, from 0 to W-1
		genvar i;
		generate
		for(i=0;i<W;i=i+1) begin : mux4x1_circuit
			assign o_data[i] = (sel_sig[0] & i_data0[i]) | (sel_sig[1] & i_data1[i])
									 | (sel_sig[2] & i_data2[i]) | (sel_sig[3] & i_data3[i]);
		end
		endgenerate
	
endmodule

//----------------------------------------------------------------------------------------------//

/* 1.2.4*/
// W-bit ALU for logic and 2’s complement arithmetic.
module alu #( parameter W=32 )(
				  input  [2:0] i_ALUCtrl,
				  input  [W-1:0] i_SrcA,
				  input  [W-1:0] i_SrcB,
				  output reg [W-1:0] result,
				  output reg CO, OVF, N, Z
				  );
	wire same_sign_ab = i_SrcA[W-1] ~^ i_SrcB[W-1]; // checks whether the inputs have the same sign
	wire same_sign_ar = i_SrcA[W-1] ~^ result[W-1]; // checks whether the input A and the result have the same sign
	// arithmetic and logic operations depending on i_ALUCtrl input
	always@* begin
	case(i_ALUCtrl)
		3'd0: begin
					{CO, result} <= i_SrcA + i_SrcB;
					OVF <= same_sign_ab & ~same_sign_ar; // A and B has the same sign, result has different
		      end
		3'd1: begin
					{CO, result} <= i_SrcA - i_SrcB;
					OVF <= ~same_sign_ab & ~same_sign_ar; // A and B have different signs, result different than A (same as B).
				end
		3'd2: begin
					{CO, result} <= i_SrcB - i_SrcA;
					OVF <= ~same_sign_ab & same_sign_ar;  // A and B have different signs, result different than B (same as A).
				end
		3'd3: result <= i_SrcA & (~i_SrcB);
		3'd4: result <= i_SrcA & i_SrcB;
		3'd5: result <= i_SrcA | i_SrcB;
		3'd6: result <= i_SrcA ^ i_SrcB;
		3'd7: result <= ~(i_SrcA ^ i_SrcB);
	endcase
		N <= result[W-1]; 	// update N flag any way.
		Z <= (result == 0);  // update Z flag any way.
	end

endmodule

//----------------------------------------------------------------------------------------------//

/* 1.2.5-a*/
// Simple register with synchronous reset
module simple_register #( parameter W=32 )(
							input clk,
							input i_rst,
							input [W-1:0] i_data,
							output reg [W-1:0] o_data
							);
							
	// generate W-bit 0 for reset case
	wire [W-1:0] zero;
	constant_value_generator #(.W(W), .VAL(0)) zero_gen_1 (.o_value(zero) );
	
	// select between 0 and i_data depending on the reset input
	// it is the combinational logic on D input of D-FF
	wire [W-1:0] data;
	mux2x1 #(.W(W)) reg_sel(.i_data0(i_data), .i_data1(zero), .sel(i_rst), .o_data(data));

	// sequential logic
	always@(posedge clk)
		o_data <= data;
endmodule

//----------------------------------------------------------------------------------------------//

/* 1.2.5-b*/
// Register with synchronous reset and write enable
module register #( parameter W=32 )(
							input clk,
							input i_rst,
							input i_wrt_en,
							input [W-1:0] i_data,
							output reg [W-1:0] o_data
							);
							
	// generate W-bit 0 for reset case
	wire [W-1:0] zero;
	constant_value_generator #(.W(W), .VAL(0)) zero_gen_2 (.o_value(zero) );
	
	// {rst, wrt_en}: {00} -> o_data <= o_data, {01} -> o_data <= i_data, {10} -> o_data <= 0, {11} -> o_data <= 0
	// it is the combinational logic on D input of D-FF
	wire [W-1:0] data;
	mux4x1 #(.W(W)) reg_sel(.i_data0(o_data), .i_data1(i_data), .i_data2(zero), .i_data3(zero), .sel({i_rst, i_wrt_en}), .o_data(data));

	// sequential logic
	always@(posedge clk)
		o_data <= data;
		
endmodule

//----------------------------------------------------------------------------------------------//

/* 1.2.5-c*/
// Shift register with parallel and serial load
module shift_register #( parameter W=32 )(
							input clk,
							input i_rst,
							input i_parallel,
							input i_right,
							input [W-1:0] i_parallel_data,
							input i_serial_rdata, i_serial_ldata,
							output reg [W-1:0] o_data
							);
							
	// multiplexer inputs for serial shift case (or D inputs of D-FF): serial shift left and right
	wire [W-1:0] serial_shl;
	wire [W-1:0] serial_shr;
	assign serial_shl = {o_data[W-2: 0] ,i_serial_rdata};  // shift left A and load most sig. bit of the serial input right
	assign serial_shr = {i_serial_ldata, o_data[W-1: 1]};    // shift right A and load most sig. bit of the serial input left
	
	// multiplexer input for reset case. generate W-bit 0
	wire [W-1:0] zero;
	constant_value_generator #(.W(W), .VAL(0)) zero_gen_3 (.o_value(zero) );
	
	
	
	// generate 2-bit select for 4x1 mux ( code the three input into 2 bit )
	wire [1:0] sel;
	assign sel[0] = i_rst | ((~i_parallel) & i_right);
	assign sel[1] = i_rst | i_parallel;
	// if i_rst = 0            : we will have sel=2'b11, independent of other inputs, the mux will select 0
	// else if i_parallel_data is 1 : we will have sel=2'b10, the mux will select parallel input
	// else:     we will have sel={0,i_right}, that is, 00 or 01 the mux will select serial input right or left
	


	// sel: {00} -> o_data <= Shift Left A, {01} -> o_data <= Shift Right A, {10} -> o_data <= A ← Parallel Input, {11} -> o_data <= 0
	// it is the combinational logic on D input of D-FF
	wire [W-1:0] data;
	mux4x1 #(.W(W)) reg_sel(.i_data0(serial_shl), .i_data1(serial_shr), .i_data2(i_parallel_data), .i_data3(zero), .sel(sel), .o_data(data));

	// sequential logic
	always@(posedge clk)
		o_data <= data;
		
endmodule
