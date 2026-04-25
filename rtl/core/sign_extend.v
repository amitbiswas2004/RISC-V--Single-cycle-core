`timescale 1ns/1ps

module sign_extend #(
    parameter XLEN = 32
) (
    input  wire [31:0] instruction,
    output reg  [XLEN-1:0] imm_ext
);
    wire [6:0] opcode;
    assign opcode = instruction[6:0];

    localparam OPCODE_OP_IMM = 7'b0010011; // addi
    localparam OPCODE_LOAD   = 7'b0000011; // lw

    always @(*) begin
        case (opcode)
            OPCODE_OP_IMM,
            OPCODE_LOAD: imm_ext = {{20{instruction[31]}}, instruction[31:20]};
            default:     imm_ext = {XLEN{1'b0}};
        endcase
    end
endmodule
