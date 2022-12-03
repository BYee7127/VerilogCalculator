//This is tb_alu file
`timescale 1ns / 1ps

module tb_alu;

	//Test pass

/*
	parameter WIDTH = 16;
	reg [2:0]  mode;
	wire [WIDTH -1: 0] out;
	reg neg;

	alu AA(.a(A), .b(B), .mode(mo
	reg [WIDTH -1:0] A,B;de), .out(out));
*/

	// Inputs
	reg [15:0] A;
	reg [15:0] B;
	reg [2:0] mode;
	
	// Outputs
	wire [15:0] out;
	wire neg;
	
	// instantiate ALU
	alu aa(.a(A), .b(B), .mode(mode), .out(out), .neg(neg));
	
	parameter ADD = 3'b000;
	parameter SUB = 3'b001;
	parameter MUL = 3'b010;
	parameter DIV = 3'b011;
	
	initial begin
		$display("Testing Add");
		mode = ADD;
		A = 8;
		B = 9;

		#15;
		$display(A, "   +", B, "   =", out, "; neg = ", neg);

		
		A = 80;
		B = 90;
		#15;
		$display(A, "   +", B, "   =", out, "; neg = ", neg);

		
		$display("Testing Subtraction");
		mode = SUB;
		A = 9;
		B = 7;
		
		#15;
		$display(A, "   -", B, "   =", out, "; neg = ", neg);		
		
		A = 9;
		B = 70;
		
		#15;
		$display(A, "   -", B, "   =", out, "; neg = ", neg);
		
		$display("Testing Multiple");
		mode = MUL;
		A = 6;
		B = 9;

		#15;
		$display(A, "   *", B, "   =", out, "; neg = ", neg);

		
		A = 60;
		B = 90;
		#15;
		$display(A, "   *", B, "   =", out, "; neg = ", neg);
		
		$display("Testing Division");
		mode = DIV;
		A = 5;
		B = 9;

		#15;
		$display(A, "   /", B, "   =", out, "; neg = ", neg);

		
		A = 0;
		B = 90;
		#15;
		$display(A, "   /", B, "   =", out, "; neg = ", neg); 
		
	end



endmodule
