module alu(
    input [31:0] A,
    input [31:0] B,
    input [2:0] Alucontrol,input Z,N,V,C,
    output reg [31:0] result
);

wire [31:0] a_and_b;
wire [31:0] a_or_b;
wire [31:0] not_b;
wire [31:0] ALU_mux;
wire [31:0] sum;
wire cout;
wire [31:0]slt;
assign a_and_b = A & B;
assign a_or_b  = A | B;
assign not_b   = ~B;


// Used for subtraction (2's complement)
assign ALU_mux = (Alucontrol[0]) ? not_b : B;

// ADD or SUB
assign {cout,sum} = A + ALU_mux + Alucontrol[0];

always @(*) begin
    case (Alucontrol)
        3'b000: result = sum;      // ADD
        3'b001: result = sum;      // SUB
        3'b010: result = a_and_b;  // AND
        3'b011: result = a_or_b;   //OR
        3'b101: result = slt;   
        default: result = 32'b0;
    endcase
end
assign Z=&(~result);
assign N=result[31];
assign C=cout&(~(Alucontrol[1]));
assign V=(~Alucontrol[1])&(sum[31]^A[31])&(~(A[31]^B[31]^Alucontrol[0]));
assign slt={31'b0000000000000000000000000000000,sum[31]};
endmodule
