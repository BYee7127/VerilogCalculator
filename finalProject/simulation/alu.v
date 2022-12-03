//////////////////////////////////////////////////////////////////////////////////
// Module Name:	alu 
// Description: 	Module to select operation and caculate the result given 2 inputs.
// 					All arithmetic calculations will be done in this module.
//
// Dependencies: 	a - the first operand
//						b - the second operand
//						out - the result from the calculation
//						mode - what operation to carry out
//						neg - whether the number is negative or not
//
// Comments: 		This ALU will operate using the format "a OPERATION b = RESULT"
//
//////////////////////////////////////////////////////////////////////////////////
module alu(a, b, out, mode, neg);
//module alu(a, b, mode, out);
	// definitions of parameters, inputs, outputs, wires, regs...
	input [15:0] a, b;
	
	// FPGA has only 10 switches: 8 will be numbers, 2 will be operations
	// which means some numbers and operations will be a combination of 2 switches.
	input [2:0] mode;

	output reg [15:0] out;
	output reg neg;

	// hardcoded variables names for differing modes
	// initial state defaulted to 3'b100
	parameter ADD = 3'b000;
	parameter SUB = 3'b001;
	parameter MUL = 3'b010;
	parameter DIV = 3'b011;

	wire [15:0] tempA;
	wire [15:0] temp;


	// do something when an input changes
	always@(a, b, mode)
	begin
		// instantiate variables
		out = 16'b0000000000000000;
		neg = 0;

		case(mode)
			ADD:	// 000
			begin
				// should have conditional for negatives
				out = a + b;
				neg = 0;
			end

			SUB:	// 001
			begin
				if(b > a)

				begin
					// a = 1st operand, b = 2nd operand
					// so if b is greater, have it become the first operand and set neg = 1
					out = b - a;
					neg = 1;
				end
				else
				begin
					// otherwise normal operation
					out = a - b;
					neg = 0;
				end

			end

			MUL:	// 010
			begin
				out = a * b;
				// neg = 0 only if both a and b are positive or negative
				neg = 0;
			end

			DIV:	// 011
			begin
				// make sure to catch a divide by zero
				if(b == 0 || a == 0)
				begin
					// have it return 0 for now
					out = 0;
					neg = 0;
				end
				else
				begin
					out = a / b;
				end
			end
		endcase
	end
endmodule
