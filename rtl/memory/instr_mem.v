`timescale 1ns/1ps

module instr_mem #(
    parameter XLEN = 32,
    parameter DEPTH_WORDS = 256,
    parameter INIT_FILE = ""
) (
    input  wire [XLEN-1:0] addr,
    output wire [31:0]     instruction
);
    reg [31:0] mem [0:DEPTH_WORDS-1];

    integer i;
    initial begin
        for (i = 0; i < DEPTH_WORDS; i = i + 1)
            mem[i] = 32'h0000_0013; // NOP = addi x0, x0, 0

        if (INIT_FILE != "")
            $readmemh(INIT_FILE, mem);
    end

    assign instruction = mem[addr[XLEN-1:2]];
endmodule
