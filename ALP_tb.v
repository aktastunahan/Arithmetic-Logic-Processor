`timescale 10ns / 1ps

module ALP_tb();

reg clk, reset;
reg [3:0] i_DATA_IN;
reg [2:0] i_OP;
reg i_COMP, i_LOAD, i_CLR;

wire [3:0] o_R0, o_R1;
wire [4:0] CS, NS;
wire o_ERR;

reg [3:0] e_R0, e_R1;
reg e_ERR;
	
reg [6:0] vectornum, errors;
reg [9:0] testvectors[60:0];

ALP DUT (	.clk(clk),
				.i_OP(i_OP), // input [2:0] ,
				.i_DATA_IN(i_DATA_IN), // input [3:0] 
				.i_COMP(i_COMP),
				.i_LOAD(i_LOAD),
				.i_CLR(i_CLR),
				.ERR(o_ERR),
				.o_R0(o_R0), // output [3:0] o_R0,
				.o_R1(o_R1) // output [3:0] o_R1);
				);
				
// clock generation
	always
		begin
		clk = 0; #5; clk = 1; #5;
		end
		
	// initial block for the beginning of the test
	initial
		begin
		$readmemb("C:/altera/13.1/LabWork#2/alp_test.tv", testvectors); // maybe memh for hex
		vectornum = -1; errors = 0;
		end
	
	// apply test vectors on rising edge of clk
	always @(negedge clk)
		begin
		{i_DATA_IN, i_OP, i_CLR, i_LOAD, i_COMP} = testvectors[vectornum];
		vectornum = vectornum + 1;
		if (testvectors[vectornum] === 10'bx)
			begin
				$stop;
			end
		end
		

/*
initial begin
	clk <= 0;
	i_OP <= 0;
	i_DATA_IN <= 0;
	i_COMP <= 0;
	i_LOAD <= 0;
	i_CLR <= 0;
end

ALP DUT (	.clk(clk),
				.i_OP(i_OP), // input [2:0] ,
				.i_DATA_IN(i_DATA_IN), // input [3:0] 
				.i_COMP(i_COMP),
				.i_LOAD(i_LOAD),
				.i_CLR(i_CLR),
				.ERR(o_ERR),
				.o_R0(o_R0), // output [3:0] o_R0,
				.o_R1(o_R1), // output [3:0] o_R1);
				.CS(CS),
				.NS(NS)
				);

 always begin
 clk <= 0; #5 ;  clk <= 1; #5 ;
end

always begin
	#17
	i_DATA_IN <= 4'b0110;
	i_LOAD <= 1;
	i_CLR <= 0;
	i_COMP <= 0;
	#10
	i_DATA_IN <= 4'b1001;
	i_LOAD <= 1;
	i_CLR <= 0;
	i_COMP <= 0;
	#10
	i_CLR <= 1;
	i_LOAD <= 0;
	i_COMP <= 0;
	#10
	i_DATA_IN <= 4'b0011;
	i_CLR <= 0;
	i_LOAD <= 1;
	i_COMP <= 0;
	#10
	i_DATA_IN <= 4'b1001;
	i_LOAD <= 1;
	i_CLR <= 0;
	i_COMP <= 0;
	#10
	i_DATA_IN <= 4'b0100;
	i_CLR <= 0;
	i_LOAD <= 1;
	i_COMP <= 0;
	#10
	i_DATA_IN <= 4'b0100;
	i_LOAD <= 0;
	i_COMP <= 1;
	i_CLR <= 0;
	i_OP <= 1;
	#20
	i_DATA_IN <= 4'b0100;
	i_LOAD <= 0;
	i_COMP <= 1;
	i_CLR <= 0;
	i_OP <= 2;
	#20
	i_DATA_IN <= 4'b0100;
	i_LOAD <= 0;
	i_COMP <= 1;
	i_CLR <= 0;
	i_OP <= 1;
	#20
	i_CLR <= 1;
	i_LOAD <= 0;
	i_COMP <= 0;
	#10;
	i_DATA_IN <= 4'b0011;
	i_CLR <= 0;
	i_LOAD <= 1;
	i_COMP <= 0;
	#10;
	i_DATA_IN <= 4'b1110;
	i_CLR <= 0;
	i_LOAD <= 1;
	i_COMP <= 0;
	#10;
	i_DATA_IN <= 4'b0101;
	i_CLR <= 0;
	i_LOAD <= 0;
	i_COMP <= 1;
	i_OP <= 5;
	#20
	i_CLR <= 0;
	i_LOAD <= 0;
	i_COMP <= 1;
	i_OP <= 6;
	#20
	i_CLR <= 0;
	i_LOAD <= 0;
	i_COMP <= 1;
	i_OP <= 7;
	#20;
end
*/
endmodule
