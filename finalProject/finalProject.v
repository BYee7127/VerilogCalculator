//////////////////////////////////////////////////////////////////////////////////
// Module Name:		finalProject
// Description: 	Main file that runs the entire program, like a main function in a C# program.
//
// Dependencies: 	clk - clock
//      					rst - reset
//					      data - data from the chip interface
//      					data_clk - clock data from the chip interface
//
// Comments: 		  May need more input/outputs; can be determined as project continues.
//
//////////////////////////////////////////////////////////////////////////////////

//Author:Haoze Zhang

module finalProject (clk, reset, r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15);

	input clk, reset;
	wire regwrite;
	wire [3:0] wa, immLo, ra1, ra2;
	wire [7:0] aluop;
	wire  we_a, LD_mux_en_a, pc_en, ld_pc_en,pc_mux,wr_pc;
	wire [15:0] q_a; 
	output [15:0] r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15;

	dataPath DP(reset, clk, r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15);


endmodule 
