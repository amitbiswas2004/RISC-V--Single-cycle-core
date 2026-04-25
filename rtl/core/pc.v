`timescale 1ns/1ps

module pc #(
    parameter XLEN = 32,
    parameter RESET_PC = 32'h0000_0000
) (
    input  wire             clk,
    input  wire             rst_n,
    input  wire [XLEN-1:0]  pc_next,
    output reg  [XLEN-1:0]  pc_curr
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            pc_curr <= RESET_PC;
        else
            pc_curr <= pc_next;
    end
endmodule
