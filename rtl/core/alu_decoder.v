module alu_decoder(

    input op5, funct7,
    input [1:0] Aluop,
    input [2:0] funct3,
    output reg [2:0] Alucontrol

);

wire [1:0] concatenation;
assign concatenation = {op5, funct7};

always @(*) begin
    case (Aluop)

        2'b00: Alucontrol = 3'b000; // Add
        2'b01: Alucontrol = 3'b001; // Subtract

        2'b10: begin
            case (funct3)
                3'b000: Alucontrol = (concatenation == 2'b11) ? 3'b001 : 3'b000;
                3'b010: Alucontrol = 3'b101;
                3'b110: Alucontrol = 3'b011;
                3'b111: Alucontrol = 3'b010;
                default: Alucontrol = 3'b000;
            endcase
        end

        default: Alucontrol = 3'b000;

    endcase
end

endmodule
