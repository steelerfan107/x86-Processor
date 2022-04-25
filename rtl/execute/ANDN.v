`timescale 1ns / 1ps
module ANDN(in0, in1, out);

    parameter WIDTH = 32;

    input [WIDTH-1:0] in0;
    input [WIDTH-1:0] in1;
    output [WIDTH-1:0] out;

    genvar i;
    generate
    for(i = 0; i < WIDTH; i = i+1) begin : andn_and_block
        and2$ instance(.out(out[i]), .in0(in0[i]), .in1(in1[i]));
    end
    endgenerate
endmodule

