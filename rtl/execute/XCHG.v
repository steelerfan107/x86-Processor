`timescale 1ns/1ps
module XCHG(dest, src, out);
input [31:0] dest;
input [31:0] src;
output [63:0] out;

wire [31:0] in0, in1;

//dest is the contents of dest (r/m) to be written into src (a register)
assign out[63:32] = in0;
//src is the contents of src (register) to be written into dest (r/m)
assign out[31:0] = in1;

endmodule
