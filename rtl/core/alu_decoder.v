`timescale 1ns/1ps

module alu_decoder (
    input  wire [1:0] alu_op_main,
    input  wire [2:0] funct3,
    input  wire [6:0] funct7,
    output reg  [2:0] alu_op
);
    localparam ALU_ADD = 3'b000;
    localparam ALU_SUB = 3'b001;
    localparam ALU_AND = 3'b010;
    localparam ALU_OR  = 3'b011;

    always @(*) begin
        case (alu_op_main)
            2'b00: alu_op = ALU_ADD; // load/store address calc
            2'b01: alu_op = ALU_SUB; // branch compare (future)
            2'b10: begin
                // I-type / R-type decode hook for future scaling.
                case (funct3)
                    3'b000: alu_op = ALU_ADD; // addi / add / sub (with funct7)
                    3'b111: alu_op = ALU_AND;
                    3'b110: alu_op = ALU_OR;
                    default: alu_op = ALU_ADD;
                endcase
                if ((funct3 == 3'b000) && (funct7 == 7'b0100000))
                    alu_op = ALU_SUB;
            end
            default: alu_op = ALU_ADD;
        endcase
    end
endmodule
