`timescale 1ns / 1ps
module NOTN(in, out);

    parameter WIDTH = 32;

    input [WIDTH-1:0] in;
    output [WIDTH-1:0] out;

    genvar i;
    generate
    for(i = 0; i < WIDTH; i = i+1) begin : notn_inv_block
        inv1$ instance(.out(out[i]), .in(in[i]));
    end
    endgenerate
endmodule