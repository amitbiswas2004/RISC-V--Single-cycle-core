# Control Signal Table

| Instruction | reg_write | alu_src_imm | mem_read | mem_write | wb_sel_mem | alu_op_main |
|-------------|-----------|-------------|----------|-----------|------------|-------------|
| addi        | 1         | 1           | 0        | 0         | 0          | 10          |
| lw          | 1         | 1           | 1        | 0         | 1          | 00          |
| default     | 0         | 0           | 0        | 0         | 0          | 00          |
