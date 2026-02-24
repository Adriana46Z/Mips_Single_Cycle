# Mips_Single_Cycle

## Description

A simplified MIPS32 single-cycle processor implemented in VHDL. The design covers the full instruction execution pipeline — fetch, decode, execute, memory access, and write-back — all completed within a single clock cycle. The project was developed and synthesized using Xilinx Vivado and tested both in simulation and on physical hardware.

---

## Table of Contents

- [Features](#features)
- [Tech Stack](#tech-stack)
- [Implemented Instructions](#implemented-instructions)
- [Components](#components)
- [Getting Started](#getting-started)
- [Project Structure](#project-structure)
- [Testing](#testing)

---

## Features

- Single-cycle MIPS32 processor architecture implemented in VHDL
- Support for R-type, I-type, and J-type instructions
- Full instruction fetch, decode, execute, memory, and write-back pipeline in one cycle
- Real-time display on a 7-segment display (SSD) via FPGA board
- Button debouncing via MPG component
- Modular design with clearly separated components connected through port maps

---

## Tech Stack

| Layer | Technology |
|---|---|
| Hardware Description Language | VHDL |
| Design & Synthesis Tool | Xilinx Vivado |
| Target Platform | FPGA development board |
| Project Format | Vivado project (.xpr) |

Language breakdown: VHDL (8.4%), Tcl (27%), HTML (34.7%), JavaScript (21.9%), Shell (7%), Batchfile (0.6%), Pascal (0.4%)

---

## Implemented Instructions

### R-Type Instructions

| Instruction | Description |
|---|---|
| ADD | Integer addition |
| SUB | Integer subtraction |
| AND | Bitwise AND |
| OR | Bitwise OR |
| SLL | Shift left logical |
| SRL | Shift right logical |
| SLT | Set on less than: sets $d = 1 if $s < $t, else $d = 0 |

**SLT — RTL:** `PC <- PC + 4; if $s < $t then $d <- 1 else $d <- 0`
Binary format: `000000 sssss ttttt ddddd 00000 101010`
Control signals: `RegDst = 1, RegWrite = 1`

---

### I-Type Instructions

| Instruction | Description |
|---|---|
| ADDI | Add immediate |
| LW | Load word from memory |
| SW | Store word to memory |
| BEQ | Branch if equal |
| BNE | Branch if not equal |
| ANDI | Bitwise AND with immediate (zero-extended) |
| ORI | Bitwise OR with immediate (zero-extended) |

**BNE — RTL:** `if $s != $t then PC <- (PC + 4) + (SE(offset) << 2) else PC <- PC + 4`
Binary format: `000101 sssss ttttt oooooooooooooooo`
Control signals: `ExtOp = 1, BNE = 1`

**ANDI — RTL:** `$t <- $s & ZE(imm); PC <- PC + 4`
Binary format: `001100 sssss ttttt iiiiiiiiiiiiiiii`
Control signals: `ALUSrc = 1, RegWrite = 1`

**ORI — RTL:** `$t <- $s | ZE(imm); PC <- PC + 4`
Binary format: `001101 sssss ttttt iiiiiiiiiiiiiiii`
Control signals: `ALUSrc = 1, RegWrite = 1`

---

### J-Type Instructions

| Instruction | Description |
|---|---|
| J | Unconditional jump |

---

## Components

| Module | Role |
|---|---|
| IFetch | Fetches instructions from memory and updates the Program Counter (PC) |
| ID | Decodes instructions and manages register file read/write |
| EX | Executes arithmetic and logic operations via the ALU |
| MEM | Handles data memory read and write operations |
| UC1 | Control unit — generates control signals based on the instruction opcode |
| test_env | Top-level module integrating all components via port maps |
| MPG | Button debouncing component for FPGA input |
| SSD | 7-segment display driver for on-board output |

---

## Getting Started

### Prerequisites

- [Xilinx Vivado](https://www.xilinx.com/support/download.html) (2020.x or later recommended)
- A compatible Xilinx FPGA development board (optional, for hardware testing)

### Opening the Project

1. Clone the repository

   ```bash
   git clone https://github.com/Adriana46Z/Mips_Single_Cycle.git
   cd Mips_Single_Cycle
   ```

2. Open Vivado and load the project

   - Launch Vivado
   - Select **File > Open Project**
   - Navigate to the cloned folder and open `mipscorect.xpr`

3. Run simulation

   - In the Flow Navigator, click **Run Simulation > Run Behavioral Simulation**
   - Observe waveforms to verify instruction execution

4. Synthesize and implement (optional, for FPGA deployment)

   - Click **Run Synthesis**, then **Run Implementation**
   - Generate bitstream and program the FPGA board

---

## Project Structure

```
Mips_Single_Cycle/
├── mipscorect.srcs/       
├── mipscorect.hw/        
├── mipscorect.runs/       
├── mipscorect.cache/      
├── mipscorect.xpr         
├── vivado.jou             
├── vivado.log             
└── README.md
```

---

## Testing

The project was tested both in simulation (Vivado Behavioral Simulation) and on physical FPGA hardware. During development, the following issues were encountered and resolved:

- Incorrect signal initialization in the control unit
- The processor entering an infinite loop due to PC update errors
- Branch instructions not jumping to the correct target address

All issues were resolved before final hardware verification.
