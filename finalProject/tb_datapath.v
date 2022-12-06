//This is tb_datapath file
//Author: Haoze Zhang
`timescale 1ns / 1ps
module tb_datapath;



reg clk, regwrite, reset;
reg [3:0] wa;
reg [2:0] aluop;
reg  we_a, we_b, LD_mux_en_a, LD_mux_en_b, pc_en, ld_pc_en,pc_mux; 
wire [3:0] ra1, ra2;
wire [15:0] wd, rd1, rd2;
wire [15:0] pc_counter,result, addr_a, addr_b;
wire [15:0] q_a, q_b;
  

datapath	DP (reset, clk, regwrite, wa, aluop, we_a, 
	we_b, LD_mux_en_a, LD_mux_en_b, pc_en, ld_pc_en,pc_mux);

initial begin
clk = 0;
reset = 1;

wa = 0;
aluop = 0;
we_a = 0;
we_b = 0;
LD_mux_en_a = 0;
LD_mux_en_b = 0;
pc_en = 0;
ld_pc_en = 0;
pc_mux = 0;
#5

// test
clk = ~clk;
reset = 0;
wa = 0;
aluop = 3'b000;
we_a = 0;
we_b = 0;
LD_mux_en_a = 0;
LD_mux_en_b = 0;
pc_en = 1;
ld_pc_en = 0;
pc_mux = 1;
#5;

end

endmodule 
