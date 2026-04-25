`timescale 1ns/1ps

module control_unit (
    input  wire [6:0] opcode,
    output reg        reg_write,
    output reg        alu_src_imm,
    output reg        mem_read,
    output reg        mem_write,
    output reg        wb_sel_mem,
    output reg [1:0]  alu_op_main
);
    localparam OPCODE_OP_IMM = 7'b0010011; // addi
    localparam OPCODE_LOAD   = 7'b0000011; // lw

    always @(*) begin
        // Defaults keep the core safe for unsupported opcodes.
        reg_write  = 1'b0;
        alu_src_imm = 1'b0;
        mem_read   = 1'b0;
        mem_write  = 1'b0;
        wb_sel_mem = 1'b0;
        alu_op_main = 2'b00;

        case (opcode)
            OPCODE_OP_IMM: begin
                reg_write  = 1'b1;
                alu_src_imm = 1'b1;
                wb_sel_mem = 1'b0;
                alu_op_main = 2'b10;
            end
            OPCODE_LOAD: begin
                reg_write  = 1'b1;
                alu_src_imm = 1'b1;
                mem_read   = 1'b1;
                wb_sel_mem = 1'b1;
                alu_op_main = 2'b00;
            end
            default: begin
                // Intentionally left as defaults.
            end
        endcase
    end
endmodule
