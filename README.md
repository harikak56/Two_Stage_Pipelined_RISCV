# Two-Stage Pipelined RISC-V Processor

## Project Overview

This project implements a **Two-Stage Pipelined RISC-V Processor** using SystemVerilog and Xilinx Vivado.

The processor uses a two-stage architecture to execute instructions through separate instruction fetch and execution stages. Pipeline registers transfer instruction and program counter information between the stages.

## Architecture

The processor consists of two major stages:

### 1. Instruction Fetch (IF)
- Program Counter (PC)
- Instruction Memory
- Instruction Fetch Logic
- Next PC calculation
- Branch and jump redirection support

### 2. Execution Stage (STAGE2)
- Instruction Decoder
- Control Unit
- Immediate Generator
- Register File
- ALU Control Unit
- Arithmetic Logic Unit (ALU)
- Data Memory
- Branch Unit
- Write-back logic

### Pipeline Register

An inter-stage pipeline register connects the IF stage and STAGE2.

It supports:
- Instruction and PC transfer
- Pipeline stall control
- Pipeline flush control
- Reset functionality

## Technology Stack

- **HDL:** SystemVerilog
- **Design and Simulation:** Xilinx Vivado 2025.1
- **Target FPGA Family:** Artix-7
- **Simulation:** Vivado XSim

## Project Structure

```text
Two_Stage_Pipelined_RISCV/
│
├── RTL/
│   ├── IF.sv
│   ├── pc.sv
│   ├── instruction_memory.sv
│   ├── pipeline_register.sv
│   ├── STAGE2.sv
│   ├── instruction_decoder.sv
│   ├── control_unit.sv
│   ├── imm_generator.sv
│   ├── reg_file.sv
│   ├── alu.sv
│   ├── alu_control.sv
│   ├── branch_unit.sv
│   ├── data_memory.sv
│   └── two_stage_riscv.sv
│
├── sim/
│   └── tb_two_stage_riscv.sv
│
└── Two_Stage_Pipelined_RISCV.xpr
```

*The RTL and simulation files are included in the repository. The structure above describes their logical organization.*

## Simulation and Verification

The design was tested using a SystemVerilog testbench in Vivado XSim.

The behavioral simulation completed successfully and produced the following sample results:

```text
RISC-V PROCESSOR TEST RESULTS

x1 = 5
x2 = 10
x3 = 15
x4 = 15
x5 = 16

Memory[0] = 15
```

## How to Open the Project

1. Clone or download this repository.
2. Extract the downloaded files.
3. Open Xilinx Vivado.
4. Select **Open Project**.
5. Browse to `Two_Stage_Pipelined_RISCV.xpr`.
6. Open the project and inspect the RTL hierarchy.
7. Run behavioral simulation using the provided testbench.

## Project Objectives

- Design a two-stage pipelined RISC-V processor.
- Implement instruction fetch and execution stages.
- Integrate ALU, register file, instruction memory and data memory.
- Implement branch and jump handling.
- Verify processor functionality through behavioral simulation.

## Contributors

Developed as an academic processor design project using SystemVerilog and Xilinx Vivado.
