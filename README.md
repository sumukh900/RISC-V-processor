# 32-bit RISC-V Processor Implementation

A comprehensive implementation of a 32-bit RISC-V processor core written in Verilog, featuring a complete instruction set architecture with advanced arithmetic operations, memory management, and pipeline control.

## Overview

This project implements a fully functional RISC-V processor that supports the base integer instruction set (RV32I) with additional features for multiplication, division, and advanced logical operations. The design follows a modular approach with separate components for different processor subsystems, making it easy to understand, modify, and extend.

## Architecture

The processor implements a multi-cycle finite state machine (FSM) based architecture. Unlike pipelined processors that execute multiple instructions simultaneously, this design completes one instruction at a time through a sequence of well-defined states:

1. **FETCH** - Retrieves the current instruction from instruction memory
2. **DECODE** - Decodes the instruction and prepares control signals
3. **EXECUTE** - Performs ALU operations and address calculations  
4. **MEMORY** - Handles load/store operations with data memory
5. **WRITEBACK** - Writes results back to the register file

Each instruction progresses through these states sequentially, with the control unit managing state transitions based on instruction type and operation completion. This approach provides clear educational insight into processor operation while handling variable-latency operations like division through proper state machine control.

### Key Components

#### ALU32 - Arithmetic Logic Unit
The heart of the processor, supporting 12 different operations:
- **Arithmetic**: Addition, Subtraction, Multiplication, Division
- **Logical**: AND, OR, XOR operations
- **Shift**: Logical left shift, Logical right shift
- **Comparison**: Equal, Greater than, Less than operations

The ALU features advanced implementations including:
- Look-ahead carry adder for fast addition/subtraction
- Booth multiplier for efficient signed multiplication
- SRT division algorithm for hardware division
- Comprehensive flag generation (Zero, Overflow, comparison flags)

#### RegisterFile32 - Register File
Implements the RISC-V register file with 32 general-purpose registers:
- Dual-port read capability for simultaneous access to two source registers
- Single-port write with write-enable control
- Hardware enforcement of x0 as constant zero register
- Synchronous write, asynchronous read for optimal performance

#### ControlUnit32 - Control Unit
Finite state machine based control unit orchestrating instruction execution:
- Instruction decoding for R-type, I-type, Load, and Store instructions
- Generation of all control signals for datapath coordination
- State transition management for multi-cycle instruction execution
- Support for variable-latency operations like division through proper state sequencing

#### Memory Subsystem
- **InstructionMemory**: Read-only memory containing the program instructions
- **SRAM32**: Data memory supporting both read and write operations
- Word-aligned memory access for 32-bit data transfers

## Supported Instructions

### R-Type Instructions (Register-Register)
- `ADD` - Addition
- `SUB` - Subtraction  
- `AND` - Bitwise AND
- `OR` - Bitwise OR
- `XOR` - Bitwise XOR
- `SLL` - Shift Left Logical
- `SRL` - Shift Right Logical

### I-Type Instructions (Immediate)
- `ADDI` - Add Immediate
- `ANDI` - AND Immediate
- `ORI` - OR Immediate
- `XORI` - XOR Immediate

### Memory Instructions
- `LW` - Load Word
- `SW` - Store Word

## File Structure

```
├── RISCVProcessor.v          # Top-level processor module
├── ALU32.v                   # 32-bit Arithmetic Logic Unit
├── RegisterFile32.v          # 32-register file implementation
├── ControlUnit32.v           # Pipeline control and instruction decode
├── InstructionMemory.v       # Instruction memory with test programs
├── SRAM32.v                  # Data memory implementation
├── LookAheadCarryAdder32.v   # Fast adder implementation
├── BoothMultiplier32.v       # Efficient multiplication unit
├── Divider32.v               # Hardware division unit
├── LogicalOperations32.v     # Logical and shift operations
├── Comparator32.v            # Comparison operations
└── RISCVProcessor_tb.v       # Testbench for simulation
```

## Getting Started

### Prerequisites
- Verilog simulator (ModelSim, Vivado, Icarus Verilog, or similar)
- Basic understanding of digital design and computer architecture
- Familiarity with RISC-V instruction set architecture

### Running the Simulation

1. **Compile all Verilog files** in your simulator environment
2. **Set the testbench** (`RISCVProcessor_tb.v`) as the top-level module
3. **Run the simulation** to see the processor execute the test program
4. **Monitor the outputs** using the built-in display statements

### Example Test Program

The instruction memory comes preloaded with a test program that demonstrates:

```assembly
addi x1, x0, 1      # Load immediate value 1 into register x1
addi x2, x0, 2      # Load immediate value 2 into register x2  
add  x3, x1, x2     # Add registers x1 and x2, store in x3
sub  x3, x1, x2     # Subtract x2 from x1, store in x3
andi x3, x1, 2      # AND x1 with immediate 2, store in x3
ori  x3, x1, 2      # OR x1 with immediate 2, store in x3
xori x3, x1, 2      # XOR x1 with immediate 2, store in x3
lw   x4, 0(x0)      # Load word from memory address 0 into x4
sw   x4, 0(x0)      # Store word from x4 to memory address 0
```

## Features

### Advanced ALU Operations
- **64-bit multiplication results** for handling overflow
- **Hardware division** with quotient and remainder
- **Comprehensive flag generation** for conditional operations
- **Efficient algorithms** (Booth multiplication, SRT division)

### Robust Control Logic
- **Finite state machine control** for clear instruction sequencing through defined states
- **Multi-cycle operation support** with proper state transitions for complex instructions
- **Variable-latency handling** for operations like division that require multiple clock cycles

### Memory Management
- **Separate instruction and data memory** (Harvard architecture)
- **Word-aligned access** for optimal performance
- **Configurable memory sizes** for different applications

## Customization and Extension

### Adding New Instructions
1. Update the ALU with new operation codes in `ALU32.v`
2. Modify the control unit to decode new instruction formats in `ControlUnit32.v`
3. Add test cases to the instruction memory in `InstructionMemory.v`

### Memory Configuration
- Modify memory array sizes in `InstructionMemory.v` and `SRAM32.v`
- Adjust address bus widths for larger memory spaces
- Implement cache hierarchies for improved performance

### Pipeline Enhancements
- Convert to pipelined architecture for higher instruction throughput
- Add forwarding logic to enable concurrent instruction execution
- Implement branch prediction and hazard detection for pipeline efficiency
- Add exception handling and interrupt support

## Testing and Verification

The included testbench (`RISCVProcessor_tb.v`) provides:
- Clock generation for sequential operation
- Reset sequence for proper initialization  
- Monitoring of key processor signals
- Automatic simulation termination

### Debugging Features
- Program counter output for instruction tracking
- ALU result monitoring for arithmetic verification
- Data memory output for load/store validation

## Performance Characteristics

- **Execution Model**: Multi-cycle FSM (one instruction completes before the next begins)
- **Clock Frequency**: Depends on synthesis tool and target technology
- **Instruction Latency**: Variable cycles per instruction based on complexity
- **Throughput**: Lower than pipelined designs but conceptually simpler for educational purposes
- **Memory Access**: Single cycle for both instruction and data memory

## Future Enhancements

Potential areas for expansion include:
- Implementation of remaining RISC-V instruction sets (M, F, D extensions)
- Addition of privilege levels and system instructions
- Integration of cache memory hierarchy
- Support for interrupts and exceptions
- Implementation of virtual memory management
I plan to extend this processor into a 5-stage pipelined RISC-V architecture, addressing:
- Data hazards using forwarding and hazard detection units
- Control hazards via basic branch prediction and stall logic
- Structural hazards through resource duplication and scheduling

## References

- RISC-V Instruction Set Manual, Volume I: User-Level ISA
- Computer Organization and Design: The Hardware/Software Interface
- Digital Design and Computer Architecture by Harris & Harris

---
