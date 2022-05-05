`timescale 1ns / 1ps
module CMOVC32(a, b, CF, out);
input [31:0] a;
input [31:0] b;
input CF;
output [31:0] out;

mux #(.INPUTS(2), .WIDTH(32)) cmovc_mux(.in({b,a}), .out(out), .select(CF));

endmodule

`timescale 1ns / 1ps
module CMOVC16(a, b, CF, out);
input [15:0] a;
input [15:0] b;
input CF;
output [15:0] out;

mux #(.INPUTS(2), .WIDTH(16)) cmovc_mux(.in({b,a}), .out(out), .select(CF));

endmodule