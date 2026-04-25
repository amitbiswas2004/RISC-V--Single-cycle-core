`include "PC.v" 
`include "Instruction_memory.v" 
`include "registers.v" 
`include "sign_extender.v" 
`include "ALU.v" 
`include "alu_decoder.v" 
`include "data_memory.v" 
`include "PC_adder.v"
`include "control_unit_top.v"
`include "main_decoder.v"


module single_cycle_top(
    input clk,
    input rst
);

wire [31:0] PC_top, RD_instruction, RD1_top, RD2_top;
wire [31:0] imm_extend_top, ALUresult, readData, PC_plus4;
wire [2:0] alu_contol_top;

wire Regwrite, Alusrc, Memwrite, Resultsrc;
wire zero;

wire [31:0] SrcB, WD3;

// PC
pc pc_module(
    .clk(clk),
    .rst(rst),
    .PC(PC_top),
    .PC_next(PC_plus4)
);

// Instruction Memory
instr_mem IM(
    .rst(rst),
    .A(PC_top),
    .RD(RD_instruction)
);

// Register File
register regis(
    .clk(clk),
    .rst(rst),
    .WE3(Regwrite),
    .WD3(WD3),
    .RD1(RD1_top),
    .RD2(RD2_top),
    .A1(RD_instruction[19:15]),
    .A2(RD_instruction[24:20]),
    .A3(RD_instruction[11:7])
);

// Sign Extend
sign_extend sign_extend(
    .in(RD_instruction),
    .imm_extension(imm_extend_top)
);

// ALU input MUX
assign SrcB = (Alusrc) ? imm_extend_top : RD2_top;

// ALU
alu ALU(
    .A(RD1_top),
    .B(SrcB),
    .Alucontrol(alu_contol_top),
    .Z(),
    .N(),
    .C(),
    .V(),
    .result(ALUresult)
);

// Control Unit
control_unit control_unit_top(
    .zero(zero),
    .op(RD_instruction[6:0]),
    .funct3(RD_instruction[14:12]),
    .funct7(RD_instruction[30]),
    .op5(RD_instruction[5]),
    .Regwrite(Regwrite),
    .Alusrc(Alusrc),
    .Memwrite(Memwrite),
    .Resultsrc(Resultsrc),
    .PCsrc(),
    .Immsrc(),
    .Alucontrol(alu_contol_top)
);

// Data Memory
datamem datamem(
    .clk(clk),
    .WE(Memwrite),
    .A(ALUresult),
    .WD(RD2_top),
    .RD(readData)
);

// Writeback MUX
assign WD3 = (Resultsrc) ? readData : ALUresult;

// PC + 4
PC_adder add(
    .a(PC_top),
    .b(32'd4),
    .c(PC_plus4)
);

endmodule
