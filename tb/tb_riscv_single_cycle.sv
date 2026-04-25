module single_cycle_top_tb();

reg clk = 1'b1;
reg rst;

// DUT instantiation
single_cycle_top uut (
    .clk(clk),
    .rst(rst)
);

// Dump file
initial begin
    $dumpfile("single_cycle_top.vcd");
    $dumpvars(0, single_cycle_top_tb);
end

// Clock generation
always #50 clk = ~clk;

// Reset sequence
initial begin
    rst = 1'b0;   // apply reset
    #100;
    rst = 1'b1;   // release reset

    #300;
    $finish;
end

endmodule
