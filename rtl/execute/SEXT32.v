`timescale 1ns/1ps
module SEXT32(in, out, en);
input [7:0] in;
input en;
output [31:0] out;

wire [31:0] sext_out;
mux #(.INPUTS(2), .WIDTH(32)) sext32_mux(.in({{24'hffffff, in}, {24'h000000, in}}), .out(sext_out), .select(in[7]));
mux #(.INPUTS(2), .WIDTH(32)) sext_en(.in({sext_out,{24'h000000, in}}), .out(out), .select(en));
endmodule