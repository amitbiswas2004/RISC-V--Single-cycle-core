module datamem(
    input clk, WE,
    input [31:0] A, WD,
    output reg [31:0] RD
);

reg [31:0] mem [1023:0];

always @(posedge clk) begin
    if (WE)
        mem[A[11:2]] <= WD;

    RD <= mem[A[11:2]];
end
initial begin
    mem[1] = 32'hDEADBEEF;  // Address 4 → index 1
end
endmodule
