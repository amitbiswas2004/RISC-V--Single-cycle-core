`timescale 1ns/1ps

module tb_riscv_single_cycle;
    localparam CLK_PERIOD = 10;

    reg clk;
    reg rst_n;

    // Default program, can be overridden by +program=<path>
    reg [8*256-1:0] program_path;

    riscv_single_cycle_top #(
        .IMEM_INIT_FILE("programs/test_addi.hex")
    ) dut (
        .clk(clk),
        .rst_n(rst_n)
    );

    // 100 MHz clock
    initial begin
        clk = 1'b0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    initial begin
        if (!$value$plusargs("program=%s", program_path))
            program_path = "programs/test_addi.hex";

        // Override instruction memory contents at runtime.
        $display("[TB] Loading program: %0s", program_path);
        $readmemh(program_path, dut.u_imem.mem);

        // Deterministic memory content for lw test:
        // lw x4, 16(x0) should read this value from address 0x10.
        dut.u_dmem.mem[4] = 32'h1234_ABCD;

        rst_n = 1'b0;
        repeat (2) @(posedge clk);
        rst_n = 1'b1;

        repeat (12) @(posedge clk);

        $display("[TB] x1 = 0x%08h", dut.u_regfile.regs[1]);
        $display("[TB] x2 = 0x%08h", dut.u_regfile.regs[2]);
        $display("[TB] x4 = 0x%08h", dut.u_regfile.regs[4]);

        $finish;
    end

    initial begin
        $dumpfile("waveforms/riscv_single_cycle.vcd");
        $dumpvars(0, tb_riscv_single_cycle);
    end
endmodule
