`timescale 1ns/1ps

module data_mem #(
    parameter XLEN = 32,
    parameter DEPTH_WORDS = 256
) (
    input  wire             clk,
    input  wire             mem_read,
    input  wire             mem_write,
    input  wire [XLEN-1:0]  addr,
    input  wire [XLEN-1:0]  wdata,
    output wire [XLEN-1:0]  rdata
);
    reg [XLEN-1:0] mem [0:DEPTH_WORDS-1];

    integer i;
    initial begin
        for (i = 0; i < DEPTH_WORDS; i = i + 1)
            mem[i] = {XLEN{1'b0}};
    end

    always @(posedge clk) begin
        if (mem_write)
            mem[addr[XLEN-1:2]] <= wdata;
    end

    assign rdata = mem_read ? mem[addr[XLEN-1:2]] : {XLEN{1'b0}};
endmodule
