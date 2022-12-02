
//////////////////////////////////////////////////////////////////////////////////
// Module Name:	FSM
// Description: 	Finite state machine here
//
// Dependencies: 	
//
// Comments: 		
//
//////////////////////////////////////////////////////////////////////////////////


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