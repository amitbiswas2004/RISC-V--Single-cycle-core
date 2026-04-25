@echo off
setlocal

set PROGRAM=%1
if "%PROGRAM%"=="" set PROGRAM=programs/test_addi.hex

if not exist waveforms mkdir waveforms

iverilog -g2012 -o simv ^
  tb/tb_riscv_single_cycle.sv ^
  rtl/top/riscv_single_cycle_top.v ^
  rtl/core/pc.v ^
  rtl/core/alu.v ^
  rtl/core/register_file.v ^
  rtl/core/control_unit.v ^
  rtl/core/alu_decoder.v ^
  rtl/core/sign_extend.v ^
  rtl/memory/instr_mem.v ^
  rtl/memory/data_mem.v

vvp simv +program=%PROGRAM%

gtkwave waveforms/riscv_single_cycle.vcd
endlocal
