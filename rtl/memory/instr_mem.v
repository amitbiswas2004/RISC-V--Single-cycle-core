module instr_mem(
    input [31:0] A,
    input rst,
    output [31:0] RD
);

reg [31:0] mem [0:1023];

// Initialize instructions
initial begin
    // Program:
    // x1 = 4
    // x2 = MEM[x1 + 0]

    mem[0] = 32'h00400093; // addi x1, x0, 4
    mem[1] = 32'h0000A103; // lw   x2, 0(x1)

    // Optional NOPs
    mem[2] = 32'h00000013;
    mem[3] = 32'h00000013;
end

// Instruction fetch (no reset blocking)
assign RD = mem[A[31:2]];

endmodule
