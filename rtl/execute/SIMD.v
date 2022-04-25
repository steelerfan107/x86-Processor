`timescale 1ns/1ps
module SIMD(mm, mm64, simd_op, out);
input [63:0] mm; //destination operand
input [63:0] mm64; //source operand
input [2:0] simd_op; //indicating SIMD op
output [63:0] out;

    //paddw block, simd_op 000
    wire dummy_carry;
    assign dummy_carry = 0;
    wire [63:0] paddw_out;
    genvar i;
    generate
    for(i = 0; i < 64; i = i+16) begin : cla16_adder_block
        CLA16 instance(.a(mm[(i+15):i]), .b(mm64[(i+15):i]), .Cin(dummy_carry), .s(paddw_out[(i+15):i]));
    end
    endgenerate

    //paddd block, simd_op 001
    wire [63:0] paddd_out;
    generate
    for(i = 0; i < 64; i = i+32) begin : cla32_adder_block
        CLA32 instance(.a(mm[(i+31):i]), .b(mm64[(i+31):i]), .Cin(dummy_carry), .s(paddd_out[(i+31):i]));
    end
    endgenerate

    //pmax/pmin block, simd_op 010, 011
    wire [63:0] pcompare_out;
    wire [3:0] agb;
    wire [3:0] eq;
    wire [3:0] bga;
    wire [3:0] s_comp; //compare select
    wire compare_op; //pmax = 0, pmin = 1
    assign compare_op = simd_op[0];
    generate
    for(i = 0; i < 4; i = i+1) begin : comp16_block
        comp16 comp(.a(mm[((i*16)+15):(i*16)]), .b(mm64[((i*16)+15):(i*16)]), .agb(agb[i]), .eq(eq[i]), .bga(bga[i]));
        xor2$ mux_select(.out(s_comp[i]), .in0(compare_op), .in1(bga[i]));
        mux #(.INPUTS(2), .WIDTH(16)) comp_mux(.Y(pcompare_out[((i*16)+15):(i*16)]), .IN0(mm[((i*16)+15):(i*16)]), .IN1(mm64[((i*16)+15):(i*16)]), .S0(s_comp[i]));
    end
    endgenerate

    //movq block, simd_op 100
    wire [63:0] movq_out;
    assign movq_out = mm64;
    mux #(.INPUTS(5), .WIDTH(64)) simd_out(.in({pcompare_out, pcompare_out, paddd_out, paddw_out, movq_out,}), .out(out), .select(simd_op));
endmodule