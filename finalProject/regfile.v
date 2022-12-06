//////////////////////////////////////////////////////////////////////////////////
// Module Name:		regfile
// Description: 	may not need this file
//
// Dependencies: 	
//
// Comments: 		
//
//////////////////////////////////////////////////////////////////////////////////

//Author: Haoze Zhang
module regfile #(parameter WIDTH = 16, REGBITS = 4)
                (input                clk, 
                 input                regwrite, 
                 input  [REGBITS-1:0] ra1, ra2, wa, 
                 input  [WIDTH-1:0]   wd, 
                 output [WIDTH-1:0]   rd1, rd2, r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15);

   reg  [WIDTH-1:0] RAM [(1<<REGBITS)-1:0];

   // three ported register file
   // read two ports combinationally
   // write third port on rising edge of clock
   // register 0 hardwired to 0
   always @(posedge clk)
      if (regwrite) RAM[wa] <= wd;	

   assign rd1 = ra1 ? RAM[ra1] : 16'd0;
   assign rd2 = ra2 ? RAM[ra2] : 16'd0;
	
	assign r0 = RAM[4'b0000];
	assign r1 = RAM[4'b0001];
	assign r2 = RAM[4'b0010];
	assign r3 = RAM[4'b0011];
	assign r4 = RAM[4'b0100];
	assign r5 = RAM[4'b0101];
	assign r6 = RAM[4'b0110];
	assign r7 = RAM[4'b0111];
	assign r8 = RAM[4'b1000];
	assign r9 = RAM[4'b1001];
	assign r10 = RAM[4'b1010];
	assign r11 = RAM[4'b1011];
	assign r12 = RAM[4'b1100];
	assign r13 = RAM[4'b1101];
	assign r14 = RAM[4'b1110];
	assign r15 = RAM[4'b1111];
	
endmodule 
