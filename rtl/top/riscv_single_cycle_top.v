`timescale 1ns/1ps

module riscv_single_cycle_top #(
    parameter XLEN = 32,
    parameter IMEM_DEPTH_WORDS = 256,
    parameter DMEM_DEPTH_WORDS = 256,
    parameter IMEM_INIT_FILE = ""
) (
    input  wire clk,
    input  wire rst_n
);
    // =========================
    // Fetch stage wires
    // =========================
    wire [XLEN-1:0] pc_curr;
    wire [XLEN-1:0] pc_next;
    wire [31:0]     instruction;

    // =========================
    // Decode stage wires
    // =========================
    wire [6:0] opcode = instruction[6:0];
    wire [4:0] rd     = instruction[11:7];
    wire [2:0] funct3 = instruction[14:12];
    wire [4:0] rs1    = instruction[19:15];
    wire [4:0] rs2    = instruction[24:20];
    wire [6:0] funct7 = instruction[31:25];

    wire [XLEN-1:0] rs1_data;
    wire [XLEN-1:0] rs2_data;
    wire [XLEN-1:0] imm_ext;

    // =========================
    // Control wires
    // =========================
    wire        reg_write;
    wire        alu_src_imm;
    wire        mem_read;
    wire        mem_write;
    wire        wb_sel_mem;
    wire [1:0]  alu_op_main;
    wire [2:0]  alu_op;

    // =========================
    // Execute / Memory / WB wires
    // =========================
    wire [XLEN-1:0] alu_in_b;
    wire [XLEN-1:0] alu_result;
    wire [XLEN-1:0] dmem_rdata;
    wire [XLEN-1:0] wb_data;

    // Program counter update: no branch/jump yet.
    assign pc_next = pc_curr + 32'd4;

    pc #(.XLEN(XLEN)) u_pc (
        .clk(clk),
        .rst_n(rst_n),
        .pc_next(pc_next),
        .pc_curr(pc_curr)
    );

    instr_mem #(
        .XLEN(XLEN),
        .DEPTH_WORDS(IMEM_DEPTH_WORDS),
        .INIT_FILE(IMEM_INIT_FILE)
    ) u_imem (
        .addr(pc_curr),
        .instruction(instruction)
    );

    control_unit u_control (
        .opcode(opcode),
        .reg_write(reg_write),
        .alu_src_imm(alu_src_imm),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .wb_sel_mem(wb_sel_mem),
        .alu_op_main(alu_op_main)
    );

    sign_extend #(.XLEN(XLEN)) u_sign_extend (
        .instruction(instruction),
        .imm_ext(imm_ext)
    );

    alu_decoder u_alu_decoder (
        .alu_op_main(alu_op_main),
        .funct3(funct3),
        .funct7(funct7),
        .alu_op(alu_op)
    );

    register_file #(.XLEN(XLEN)) u_regfile (
        .clk(clk),
        .we(reg_write),
        .rs1_addr(rs1),
        .rs2_addr(rs2),
        .rd_addr(rd),
        .rd_data(wb_data),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data)
    );

    assign alu_in_b = alu_src_imm ? imm_ext : rs2_data;

    alu #(.XLEN(XLEN)) u_alu (
        .a(rs1_data),
        .b(alu_in_b),
        .alu_op(alu_op),
        .y(alu_result)
    );

    data_mem #(
        .XLEN(XLEN),
        .DEPTH_WORDS(DMEM_DEPTH_WORDS)
    ) u_dmem (
        .clk(clk),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .addr(alu_result),
        .wdata(rs2_data),
        .rdata(dmem_rdata)
    );

    assign wb_data = wb_sel_mem ? dmem_rdata : alu_result;
endmodule
