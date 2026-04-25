module control_unit(
    input zero,
    input [6:0] op,
    input [2:0] funct3,
    input funct7,
    input op5,

    output Regwrite, Alusrc, Memwrite, Resultsrc, PCsrc,
    output [1:0] Immsrc,
    output [2:0] Alucontrol
);

wire [1:0] Aluop;

// Instantiate MAIN DECODER
main_decoder md (
    .zero(zero),
    .op(op),
    .Regwrite(Regwrite),
    .Alusrc(Alusrc),
    .Memwrite(Memwrite),
    .Resultsrc(Resultsrc),
    .PCsrc(PCsrc),
    .Immsrc(Immsrc),
    .Aluop(Aluop)
);

// Instantiate ALU DECODER
alu_decoder ad (
    .op5(op5),
    .funct7(funct7),
    .Aluop(Aluop),
    .funct3(funct3),
    .Alucontrol(Alucontrol)
);

endmodule
