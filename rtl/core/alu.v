`timescale 1ns/1ps

module alu #(
    parameter XLEN = 32
) (
    input  wire [XLEN-1:0] a,
    input  wire [XLEN-1:0] b,
    input  wire [2:0]      alu_op,
    output reg  [XLEN-1:0] y
);
    localparam ALU_ADD = 3'b000;
    localparam ALU_SUB = 3'b001;
    localparam ALU_AND = 3'b010;
    localparam ALU_OR  = 3'b011;

    always @(*) begin
        case (alu_op)
            ALU_ADD: y = a + b;
            ALU_SUB: y = a - b;
            ALU_AND: y = a & b;
            ALU_OR:  y = a | b;
            default: y = {XLEN{1'b0}};
        endcase
    end
endmodule
