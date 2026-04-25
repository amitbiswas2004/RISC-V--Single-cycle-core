module register(
    input [4:0] A1, A2, A3,
    input [31:0] WD3,
    input clk, rst, WE3,
    output [31:0] RD1, RD2
);

reg [31:0] reg_files [31:0];
integer i;

// Read ports (combinational)
assign RD1 = (A1 == 5'b00000) ? 32'b0 : reg_files[A1];
assign RD2 = (A2 == 5'b00000) ? 32'b0 : reg_files[A2];

// Write + reset
always @(posedge clk) begin
    if (!rst) begin
        for (i = 0; i < 32; i = i + 1)
            reg_files[i] <= 32'b0;
    end else if (WE3 && (A3 != 5'b00000)) begin
        reg_files[A3] <= WD3;
    end
end

endmodule
