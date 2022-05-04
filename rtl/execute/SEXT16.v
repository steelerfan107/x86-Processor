`timescale 1ns/1ps
module SEXT16(in, out, en);
input [7:0] in;
input en;
output [15:0] out;

wire [15:0] sext_out;
mux #(.INPUTS(2), .WIDTH(16)) sext16_mux(.in({{8'hff, in}, {8'h00, in}}), .out(sext_out), .select(in[7]));
mux #(.INPUTS(2), .WIDTH(16)) sext_en(.in({sext_out,{8'h00, in}}), .out(out), .select(en));
endmodule