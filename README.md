# x86-Processor
Project for Microarchitecture

## Specification
### Project
Specification  | Links
------------- | -------------
Project Specification  | [Link](http://users.ece.utexas.edu/~patt/22s.382N/problemset/project/spec.html "Specification")
List of Supported Instructions | [Link](http://users.ece.utexas.edu/~patt/22s.382N/problemset/project/inst.html "List of Instructions") 

### x86
Specification  | Links
------------- | -------------
Volume 1: Basic Arch | [Link](http://users.ece.utexas.edu/~patt/22s.382N/handouts/x86%20Basic%20Architecture.pdf "Volume 1: Basic Arch.") 
Volume 2: Instruction Set Reference |[Link](http://users.ece.utexas.edu/~patt/22s.382N/handouts/x86%20Instruction%20Set%20Reference.pdf "Volume 2: Instruction Set Reference") 
Volume 3: System Programming Guide |[Link](http://users.ece.utexas.edu/~patt/22s.382N/handouts/x86%20System%20Programming%20Guide.pdf "Volume 3: System Programming Guide") 

## lst_to_hex.py
Run this while in scripts dir:
python3 lst_to_hex.py tests/<test_name> <memory_name> <total_width_of_bus(bytes)> <memory_width (bytes)> <memory_depth (lines)> <total_memory (bytes)> <test_name>

This will generate output files in the test_generation dir. There will be a <test_name>_readable file and a set of memory files with _y_x postfixes.

The lst file is in the format:

```
// Reg32 Sanity Test
// Eric T.

0x0:     B8 00 00 11 11 // Move 0x1111_1111 to EAX (Move imm to r32) - Row 61
         89 99          // This is an illegal op but just to show format.
                        // Another Comment
0x7:     B9 00 00 00 01 // Move 0x1111_1111 to ECX (Move imm to r32) - Row 61
0x2000:  B9 00 00 00 01 // Can do jumps also
```

## Using the Space
### Setup 
1. source scripts/setup.csh

### Build Top Level RTL
1. cd scripts
2. vcs -full64 -debug_all -f flist -v2005

### Build and Run Library Testbench
1. ...

## Library Elements

### register.v
- A register of configurable width.
- Inputs: clk, reset, din[WIDTH-1:0] , en
- Outputs : q[WIDTH-1:0], q_bar[WIDTH-1:0]
- Parameters : WIDTH - Width of register.
- 
### compare.v
- Compares two inputs.
- Inputs: a, b
- Outputs : out
- Parameters : WIDTH - Width of inputs

### mux.v
- A mux of arbitrary width for 2, 3, or 4 inputs.
- Inputs : in[WIDTH*INPUTS], sel[log2(INPUTS)-1:0]
- in is packed like {..., in2, in1, in0}
- Outputs : out[WIDTH]
- Parameters : WIDTH - Width of the selections. INPUTS - Number of Selections. (Can only be 2, 3, 4 for now).

### slow_addr.v
- Slow Addition module used for small adds.
- Inputs: a, b
- Outputs : out, carry
- Parameters : WIDTH - Width of inputs/output/operation

### pipestage.v
- Used as a configurable pipe between stages.
- Inputs : in_valid (Indicated in Data is Valid), out_ready (Indicates that data is ready to be accepted from pipe), in_data (data into the pipe), clk, reset
- Outputs : out_valid (Indicated out Data is Valid), in_ready (Indicates that data is ready to be accepted to pipe), out_data (data out of the pipe)
- Parameters : BYPASS (0,1) - Makes block pass through, WIDTH - Width of the data

### logic_tree.v
- A structure which applies an operation over a bus width in a tree structure for optimal timing. 
- Inputs : in[WIDTH-1:0]
- Outputs : out
- Parameters : WIDTH - width of in, OPERATION - 0 Add, 1 Or

### logic_tree_bus.v
- A structure which applies an operation over a multiple bus widths in a tree structure for optimal timing.
- Note: This goes through the WIDTH and does NINPUT logic busses and not the other way around.  
- Inputs : in[WIDTH*NINPUTS-1:0]
- Outputs : out[WIDTH-1:0]
- Parameters : WIDTH - WIdth of Bus, NINPUTS - Number of Inputs, OPERATION - 0 Add, 1 Or

### ao_mux.v
- A mux controlled by a onehot signal. 
- Inputs : in[WIDTH*NINPUTS-1:0], sel[NINPUTS-1:0]
- Outputs : out[WIDTH-1:0]
- Parameters :  WIDTH - Width of Selection, NINPUTS - Number of Inputs

### lut_select.v
- A lookup table select portion. The input tble can be made either through constants or configurable 
- registers from outside this block. The input vector will then be compared and out will indicate all matches.
- Inputs : tble[WIDTH*TABLESIZE - 1:0], vector[WIDTH - 1:0]
- Outputs : out[TABLESIZE-1:0], match
- Parameters : TABLESIZE - The amount of entries in the table. WIDTH - The width of the table vectors

### find_first.v
- Block that finds the first asserted bit left to right or right to left.
- Inputs : in[WIDTH-1:0]
- Outputs : out[WIDTH-1:0]
- Parameters : WIDTH - Width of Vector, OPERATION - 0 Left to Right, 1 - Right to Left

### fifo.v
- A first in first out buffer.
- Inputs :
- Outputs :
- Parameters : 
