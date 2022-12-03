//////////////////////////////////////////////////////////////////////////////////
// Module Name:		Calculator
// Description: 	File with all of the modules placed into one.
//
// Dependencies: 	
//
// Comments: 		This file was created to put all the separate modules into
// 			one for the tapeout.
//
//////////////////////////////////////////////////////////////////////////////////

// main module
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

// datapath module
module dataPath (reset, clk, r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15);
	input clk, reset;
	wire regwrite, flag_en;
	wire [3:0] wa;
	wire [2:0] aluop;
	wire  we_a, LD_mux_en_a, pc_en, ld_pc_en,pc_mux, wr_pc, neg; 
	wire [3:0] ra1, ra2;
	wire [15:0] wd, rd1, rd2;
	wire [15:0] pc_counter,result, addr_a, addr_b, B_value;
	wire [15:0] q_a;
	output [15:0] r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15;

	//Regfile
	regfile Reg(.clk(clk), .regwrite(regwrite), .ra1(ra1), .ra2(ra2), .wa(wa), .wd(wd), .rd1(rd1), .rd2(rd2), .r0(r0), .r1(r1), .r2(r2), .r3(r3), .r4(r4), .r5(r5), .r6(r6), .r7(r7), .r8(r8), .r9(r9), .r10(r10), .r11(r11), .r12(r12), .r13(r13), .r14(r14), .r15(r15));

	//Memory
	Memory Mem(.data_a(rd1), .addr_a(addr_a), .we_a(we_a), .clk(clk), .q_a(q_a));

	//ALU
	alu Alu(.a(rd1), .b(rd2), .mode(aluop), .out(result), .neg(neg));

	//LD_mux
	mux mux1(.A(result), .B(q_a), .sel(LD_mux_en_a), .Y(wd));

	//PC_MUX. 
	mux mux2(.A(rd2),.B(pc_counter), .sel(pc_mux), .Y(addr_a));

	//program counter 
	pc pc1(.clk(clk), .reset(reset), .ld_pc(rd2), .wr_pc(wr_pc), .pc(pc_counter));

	FSM myfsm (clk, reset, q_a, regwrite, wa, aluop, we_a,  LD_mux_en_a, pc_en, ld_pc_en,pc_mux, ra1, ra2, wr_pc);
endmodule

// regfile
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

// memory
module Memory
#(parameter DATA_WIDTH=16, parameter ADDR_WIDTH= 16)
(
	input [(DATA_WIDTH-1):0] data_a,
	input [(ADDR_WIDTH-1):0] addr_a,
	input we_a, clk,
	output reg [(DATA_WIDTH-1):0] q_a
);
 
	// Declare the RAM variable
	reg [DATA_WIDTH-1:0] ram[2**ADDR_WIDTH-1:0]; 
	
	initial begin
	$readmemb("memoryTest.txt", ram);
	end
	
	// Port A 
	always @ (posedge clk)
	begin
		if (we_a) 
		begin
			ram[addr_a] <= data_a;
			q_a <= data_a;
		end
		else 
		begin
			q_a <= ram[addr_a];
		end
	end
endmodule

// ALU
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

// MUX
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

// pc - initial block ignored during synthesis
module pc(input clk,
	input reset,
	input [15:0] ld_pc,
	input wr_pc,
	output reg [15:0] pc);

	initial begin
		pc <= 16'h0000;
	end
	
	always @(posedge clk)
	begin
	    	if (reset == 1)
	    	begin
	    		pc <= 16'h0000;
	    	end
    	else begin
		if (wr_pc == 1) begin
			pc <= ld_pc;
		end
    	end 

	//$display("PC=%h",PCResult);
    end
endmodule

// FSM module
module FSM(clk, reset, instr, regwrite, wa, aluop, we_a,
	 LD_mux_en_a, pc_en, ld_pc_en,pc_mux, ra1, ra2, wr_pc);
	 
	input clk, reset;
	input [15:0] instr;

	output reg regwrite;
	output reg [3:0] wa,ra1, ra2;
	output reg [2:0] aluop;
	output reg  we_a, LD_mux_en_a, pc_en, ld_pc_en,pc_mux, wr_pc; 


	reg [3:0] state, next_state;
	reg [15:0] inst;


	//parameter start = 4'b0010;
	parameter regTomem = 4'b0100;

	//instruction bit 
	parameter ADD = 3'b000;
	parameter SUB = 3'b001;
	parameter MUL = 3'b010;
	parameter DIV = 3'b011;
	
	parameter RESET = 4'b0111;


	always@(posedge clk) begin
		if (reset == 0) begin 
			state <= 4'b0111;
			//change <= 0;
		end	
		else begin 
			state <= next_state;	
			//change <= ~change;
		end	
	end

	always@(negedge clk) begin 

		case (state)
		//initial state
			4'b0111:begin 
			
			//initial with all 0s
				inst = 16'b0000000000000000;
				regwrite = 0;   
				wr_pc = 0;
				wa = 4'b0000;
				we_a = 0;
				pc_en = 1;
				ld_pc_en = 0;
				pc_mux = 1;
				ra1 = 4'b0000;
				ra2 = 4'b0000;
				
				//Initial state with no operation
				aluop = 3'b100;
				
				LD_mux_en_a = 0;  
				inst = instr;
				
				//Last 3 bits are the state and which operation
				next_state = instr[15:13];
				
				if ((next_state == ADD) | (next_state == SUB)| (next_state == MUL) | (next_state == DIV))
					next_state = regTomem;
			
			end 
		
			
			regTomem: begin
				case(next_state)
					ADD:begin
						regwrite = 0;
						wr_pc = 0;
						//Basicly, I am trying to make things complicated that could do more work, as a finacial calculator
						
						//But, we only have basic operation, this is the reason I have some unsed segement. But I will just leave it here. 
						wa = inst[11:8];
						ra1 = inst[11:8];
						ra2 = inst[3:0];
						aluop = ADD;
						LD_mux_en_a = 0;  
						we_a = 0;
						pc_en = 0;
						ld_pc_en = 0;
						pc_mux = 0;	
						//inst = instr;
						next_state = regTomem;
					end	
					SUB:begin
						regwrite = 0;
		
						wr_pc = 0;
						wa = inst[11:8];
						ra1 = inst[11:8];
						ra2 = inst[3:0];
						aluop = SUB;
						LD_mux_en_a = 0;  
						we_a = 0;
						pc_en = 0;
						ld_pc_en = 0;
						pc_mux = 0;	
						//inst = instr;
						next_state = regTomem;
					end	
					MUL:begin
						regwrite = 0;
			
						wr_pc = 0;
						wa = inst[11:8];
						ra1 = inst[11:8];
						ra2 = inst[3:0];
						aluop = MUL;
						LD_mux_en_a = 0;  
						we_a = 0;
						pc_en = 0;
						ld_pc_en = 0;
						pc_mux = 0;	
						//inst = instr;
						next_state = regTomem;
					end	
					DIV:begin
						regwrite = 0;
	 
						wr_pc = 0;
						wa = inst[11:8];
						ra1 = inst[11:8];
						ra2 = inst[3:0];
						aluop = DIV;
						LD_mux_en_a = 0;  
						we_a = 0;
						pc_en = 0;
						ld_pc_en = 0;
						pc_mux = 0;	
						//inst = instr;
						next_state = regTomem;
					end	

			endcase
			end
			
			default: begin 
				inst = 16'b0000000000000000;
				regwrite = 0;   
				//Cin = 0;
				wa = 4'b0000;
				we_a = 0;
				pc_en = 1;
				ld_pc_en = 0;
				pc_mux = 1;
				ra1 = 4'b0000;
				ra2 = 4'b0000;
				aluop = 3'b100;
				LD_mux_en_a = 0;  
			end 
		
		endcase

	end

endmodule 





