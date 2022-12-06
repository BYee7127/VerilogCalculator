//////////////////////////////////////////////////////////////////////////////////
// Module Name:		datapath
// Description: 	The datapath should be the module that handles the interactions between
//               the ALU and register file. It could also be used to communicat between
//               the chip and the FPGA.
//
// Dependencies: 	clk - clock
//                rst - reset
//
// Comments: 		Many of the declarations of the other modules
//
//////////////////////////////////////////////////////////////////////////////////


//Author:Haoze Zhang
module dataPath (reset, clk, r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15);

input clk, reset;
wire regwrite;
wire [3:0] wa;
wire [2:0] aluop;
wire  we_a, LD_mux_en_a, pc_en, ld_pc_en,pc_mux, wr_pc, neg; 
wire [3:0] ra1, ra2;
//wire we_b;
wire [15:0] wd, rd1, rd2;
wire [15:0] pc_counter,result, addr_a, addr_b, B_value;
wire [15:0] q_a;
output [15:0] r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15;

 


//Regfile
regfile Reg(.clk(clk), .regwrite(regwrite), .ra1(ra1), .ra2(ra2), .wa(wa), .wd(wd), .rd1(rd1), .rd2(rd2), .r0(r0), .r1(r1), .r2(r2), .r3(r3), .r4(r4), .r5(r5), .r6(r6), .r7(r7), .r8(r8), .r9(r9), .r10(r10), .r11(r11), .r12(r12), .r13(r13), .r14(r14), .r15(r15));


//Memory
memory Mem(.address(addr_a), .clock(clk), .data(rd1), .wren(we_a), .q(q_a));


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
