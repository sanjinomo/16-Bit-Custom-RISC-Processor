# 16-bit RISC Processor Design (SystemVerilog)

This project presents the design and implementation of a **custom 16-bit RISC processor** developed using **SystemVerilog**. The processor follows a modular, clean instruction set architecture (ISA) and was synthesized and tested on an FPGA platform as part of an academic processor design project.


## Overview
The processor supports a basic yet functional instruction set, including arithmetic, logical, memory access, and control flow operations. The design emphasizes clarity, modularity, and correct execution rather than aggressive performance optimization.

Key components such as the **datapath**, **control unit**, **register file**, and **ALU** were implemented and verified through simulation and FPGA synthesis.


## Key Features
- Custom **16-bit RISC ISA**
- Modular **datapath and control unit** design
- **Register file**, **ALU**, and **program counter** implementation
- Support for arithmetic, logical, load/store, and branch instructions
- Implemented in **SystemVerilog**
- Synthesized and tested on FPGA hardware


## Processor Architecture
The processor consists of:
- Instruction Fetch and Decode logic  
- Register File  
- Arithmetic Logic Unit (ALU)  
- Control Unit  
- Program Counter and Branch Logic  
- Data and Instruction Memory Interfaces  

The design follows a straightforward execution flow suitable for educational and research purposes.


## How to Run
1. Open the project in **Quartus Prime** or a compatible HDL tool  
2. Compile the SystemVerilog source files  
3. Run simulations using the provided testbenches  
4. Synthesize and program the design on the target FPGA, in this case I used Terassic DE2-115


## Author
**Sanjoy Dev**
