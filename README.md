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

### mux.v
- A mux of arbitrary width for 2, 3, or 4 inputs.
- Inputs : in[WIDTH*INPUTS], sel[log2(INPUTS)-1:0]
- in is packed like {in0, in1, in2, ...}
- Outputs : out[WIDTH]
- Parameters : WIDTH - Width of the selections. INPUTS - Number of Selections. (Can only be 2, 3, 4 for now).

### pipestage.v
- Used as a configurable pipe between stages.
- Inputs :
- Outputs :
- Parameters : 

### ao_mux.v
- A mux controlled by a onehot signal. 
- Inputs :
- Outputs :
- Parameters : 

### pri_arb.v
- A priority arbiter.
- Inputs :
- Outputs :
- Parameters : 

### lut.v
- A lookup table.
- Inputs :
- Outputs :
- Parameters : 

### fifo.v
- A first in first out buffer.
- Inputs :
- Outputs :
- Parameters : 

### stack.v
- A last in first out buffer.
- Inputs :
- Outputs :
- Parameters : 
