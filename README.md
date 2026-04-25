# RISC-V Single-Cycle CPU (Verilog)

Industry-style, modular RISC-V single-cycle processor project intended for portfolio and interview demonstration.

## Project Overview
This repository implements a clean and scalable single-cycle RISC-V core in Verilog with a **minimal instruction subset**:
- `addi` (I-type arithmetic immediate)
- `lw` (load word)

The design is intentionally structured to make future extensions (R-type, branches, stores, hazard-aware microarchitecture evolution) straightforward.

## Repository Structure

```text
.
├── rtl/
│   ├── core/
│   │   ├── alu.v
│   │   ├── alu_decoder.v
│   │   ├── control_unit.v
│   │   ├── pc.v
│   │   ├── register_file.v
│   │   └── sign_extend.v
│   ├── memory/
│   │   ├── data_mem.v
│   │   └── instr_mem.v
│   └── top/
│       └── riscv_single_cycle_top.v
├── tb/
│   └── tb_riscv_single_cycle.sv
├── programs/
│   ├── test_addi.hex
│   └── test_lw.hex
├── sim/
│   ├── run.bat
│   └── run.sh
├── docs/
│   ├── architecture.md
│   └── control_signals.md
└── waveforms/
```

## Supported Instructions

| Instruction | Type | Description |
|------------|------|-------------|
| `addi`     | I    | `rd = rs1 + imm` |
| `lw`       | I    | `rd = MEM[rs1 + imm]` |

## Datapath Explanation
1. **PC (`pc.v`)** updates every cycle by `+4` (no branch/jump yet).
2. **Instruction memory (`instr_mem.v`)** returns the fetched instruction; supports `$readmemh` program loading.
3. **Control unit (`control_unit.v`)** decodes opcode into high-level control signals.
4. **Sign extension (`sign_extend.v`)** constructs 32-bit immediate for I-type opcodes.
5. **ALU decoder (`alu_decoder.v`)** maps high-level ALU control + `funct` fields into ALU operation.
6. **Register file (`register_file.v`)** performs async reads and sync write-back.
7. **ALU (`alu.v`)** computes arithmetic result or effective memory address.
8. **Data memory (`data_mem.v`)** serves `lw` read path (store path prewired for future use).
9. **Write-back mux** selects ALU result (`addi`) or data memory output (`lw`).

## Main Control Signal Table

| Instruction | reg_write | alu_src_imm | mem_read | mem_write | wb_sel_mem | alu_op_main |
|-------------|-----------|-------------|----------|-----------|------------|-------------|
| `addi`      | 1         | 1           | 0        | 0         | 0          | `10`        |
| `lw`        | 1         | 1           | 1        | 0         | 1          | `00`        |

## How to Run Simulation

### Linux/macOS
```bash
chmod +x sim/run.sh
./sim/run.sh programs/test_addi.hex
./sim/run.sh programs/test_lw.hex
```

### Windows
```bat
sim\run.bat programs\test_addi.hex
sim\run.bat programs\test_lw.hex
```

The testbench will:
- Generate clock/reset
- Load the selected `.hex` file into instruction memory
- Initialize a known data memory word for `lw`
- Dump `waveforms/riscv_single_cycle.vcd`

## Example Program Files
- `programs/test_addi.hex`: writes immediate values into registers
- `programs/test_lw.hex`: loads from memory address `0x10` into register `x4`

## Waveform Guidance
Open `waveforms/riscv_single_cycle.vcd` in GTKWave and inspect:
- `pc_curr` increments by 4 each cycle
- instruction decode fields (`opcode`, `rs1`, `rd`)
- `alu_result` equals `rs1 + imm`
- for `lw`, `wb_data` follows `dmem_rdata`

## Future Work
- Add R-type ALU operations (`add`, `sub`, logical ops)
- Add store instruction (`sw`) path and byte enables
- Add branch/jump control and PC muxing
- Add pipelined architecture (IF/ID/EX/MEM/WB)
- Add hazard detection/forwarding for performance scaling
- Add constrained-random and compliance-oriented verification
