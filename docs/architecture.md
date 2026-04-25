# Architecture Notes

## Current Instruction Coverage
- `addi rd, rs1, imm`
- `lw rd, imm(rs1)`

## Datapath Summary
1. PC fetches instruction from instruction memory.
2. Control unit decodes opcode to generate main control signals.
3. Sign-extension builds 32-bit immediate for I-type operations.
4. ALU computes either arithmetic (`addi`) or address (`lw`).
5. Data memory returns read data for `lw`.
6. Write-back mux selects ALU result or memory data.

## Extension Plan
- Add branch/jump PC mux.
- Add store controls and byte-enable support.
- Add R-type decode refinement in `alu_decoder`.
