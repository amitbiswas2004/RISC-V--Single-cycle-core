module pc(
    input [31:0] PC_next,
    input rst,
    input clk,
    output reg [31:0] PC
);

always @(posedge clk or posedge rst) begin
    if (!rst)
        PC <= 32'h00000000;   // reset PC to 0
    else
        PC <= PC_next;        // update PC on clock edge
end

endmodule
