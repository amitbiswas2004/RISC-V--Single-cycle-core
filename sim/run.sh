#!/usr/bin/env bash
set -euo pipefail

PROGRAM=${1:-programs/test_addi.hex}
SIM_OUT=simv
VCD_OUT=waveforms/riscv_single_cycle.vcd

mkdir -p waveforms

iverilog -g2012 -o "$SIM_OUT" \
  tb/tb_riscv_single_cycle.sv \
  rtl/top/riscv_single_cycle_top.v \
  rtl/core/pc.v \
  rtl/core/alu.v \
  rtl/core/register_file.v \
  rtl/core/control_unit.v \
  rtl/core/alu_decoder.v \
  rtl/core/sign_extend.v \
  rtl/memory/instr_mem.v \
  rtl/memory/data_mem.v

vvp "$SIM_OUT" +program="$PROGRAM"

if command -v gtkwave >/dev/null 2>&1; then
  gtkwave "$VCD_OUT" &
else
  echo "GTKWave not found. Open $VCD_OUT manually when installed."
fi
