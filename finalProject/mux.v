//////////////////////////////////////////////////////////////////////////////////
// Module Name:		mux 
// Description: 	   Module to simulate a MUX
//
// Dependencies: 	   A -
//					      B - 
//					      sel - the operator in which chooses whether A or B is passed through
//					      Y - output
//
// Comments: 		
//
//////////////////////////////////////////////////////////////////////////////////

//Author: Haoze Zhang
 module mux(A, B, sel, Y);

 output [15:0] Y;
 input [15:0] A, B;
 input sel;
 reg [15:0] Y;

 always @(A or B or sel)
 if (sel == 1'b0)
	Y = A;
	else
	Y = B;

 endmodule
