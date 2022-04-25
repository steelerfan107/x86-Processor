`timescale 1ns / 1ps
module ALU(a, b, opsize, alu_op, alu_out, set_eflags, eflags_out);
input [31:0] a;
input [31:0] b;
input [1:0] opsize;
input [2:0] alu_op;
output [31:0] alu_out;
output [5:0] set_eflags; 
output [5:0] eflags_out; 

//ADD
wire [31:0] add8b_out; 
wire [31:0] add16b_out; 
wire [31:0] add32b_out;
wire [31:0] add_out;
wire [5:0] add_set_eflags;
wire [5:0] add_eflags_out;
wire add8b_carry, add16b_carry, add32b_carry;
CLA8 add8b(.a(a[7:0]), .b(b[7:0]), .Cin(1'b0), .s(add8b_out), .Cout(add8b_carry));
CLA16 add16b(.a(a[15:0]), .b(b[15:0]), .Cin(1'b0), .s(add16b_out), .Cout(add16b_carry));
CLA32 add32b(.a(a[31:0]), .b(b[31:0]), .Cin(1'b0), .s(add32b_out), .Cout(add32b_carry));
//8b, 16b OPs are stored into 8b or 16b memory locations so type of bit-extension doesn't necessarily matter
assign add8b_out [31:8] = 24'h000000;
assign add16b_out [31:16] = 16'h0000;
assign add_set_eflags = 6'b111111;
mux #(.WIDTH(32), .INPUTS(3)) add_mux(.in({add32b_out, add16b_out, add8b_out}), .out(add_out), .select(opsize));

//AND
wire [31:0] and8b_out; 
wire [31:0] and16b_out; 
wire [31:0] and32b_out;
wire [31:0] and_out;
wire [5:0] and_set_eflags;
ANDN #(.WIDTH(8)) and8b(.in0(a[7:0]), .in1(b[7:0]), .out(and8b_out[7:0]));
ANDN #(.WIDTH(16)) and16b(.in0(a[15:0]), .in1(b[15:0]), .out(and16b_out[15:0]));
ANDN #(.WIDTH(32)) and32b(.in0(a[31:0]), .in1(b[31:0]), .out(and32b_out));
//8b, 16b OPs are stored into 8b or 16b memory locations so type of bit-extension doesn't necessarily matter
assign and8b_out [31:8] = 24'h000000;
assign and16b_out [31:16] = 16'h0000;
assign and_set_eflags = 6'b111z11;
mux #(.WIDTH(32), .INPUTS(3)) and_mux(.in({and32b_out, and16b_out, and8b_out}), .out(and_out), .select(opsize));

//BSF
wire [31:0] bsf16b_out; 
wire [31:0] bsf32b_out;
wire [31:0] bsf_out;
wire bsf_v;
wire [5:0] bsf_set_eflags;
BSF16 bsf16(.in(b[15:0]), .out(bsf16b_out), .v(bsf_v));
BSF32 bsf32(.in(b[31:0]), .out(bsf32b_out), .v(bsf_v));
assign bsf_set_eflags = 6'bzz1zzz;
mux #(.WIDTH(32), .INPUTS(2)) bsf_mux(.in({bsf32b_out, bsf16b_out}), .out(bsf_out), .select(opsize[1]));

//NOT
wire [31:0] not8b_out; 
wire [31:0] not16b_out; 
wire [31:0] not32b_out;
wire [31:0] not_out;
wire [5:0] not_set_eflags;
NOTN #(.WIDTH(8)) not8b(.in(a[7:0]), .out(not8b_out[7:0]));
NOTN #(.WIDTH(16)) not16b(.in(a[15:0]), .out(not16b_out[15:0]));
NOTN #(.WIDTH(32)) not32b(.in(a[31:0]), .out(not32b_out));
//8b, 16b OPs are stored into 8b or 16b memory locations so type of bit-extension doesn't necessarily matter
assign not8b_out [31:8] = 24'h000000;
assign not16b_out [31:16] = 16'h0000;
assign not_set_eflags = 6'b000000;
mux #(.WIDTH(32), .INPUTS(3)) not_mux(.in({not32b_out, not16b_out, not8b_out}), .out(not_out), .select(opsize));

wire [31:0] or8b_out; 
wire [31:0] or16b_out; 
wire [31:0] or32b_out;
wire [31:0] or_out;
wire [5:0] or_set_eflags;
ORN #(.WIDTH(8)) or8b(.in0(a[7:0]), .in1(b[7:0]), .out(or8b_out[7:0]));
ORN #(.WIDTH(16)) or16b(.in0(a[15:0]), .in1(b[15:0]), .out(or16b_out[15:0]));
ORN #(.WIDTH(32)) or32b(.in0(a[31:0]), .in1(b[31:0]), .out(or32b_out));
//8b, 16b OPs are stored into 8b or 16b memory locations so type of bit-extension doesn't necessarily matter
assign or8b_out [31:8] = 24'h000000;
assign or16b_out [31:16] = 16'h0000;
assign or_set_eflags = 6'b111z11;
mux #(.WIDTH(32), .INPUTS(3)) or_mux(.in({or32b_out, or16b_out, or8b_out}), .out(or_out), .select(opsize));

//pass/mov
wire [31:0] pass_out;
wire [5:0] pass_set_eflags;
assign pass_set_eflags = 6'b000000;
assign pass_out = b;

//SAL/SAR
wire count_one;
wire shift_zero;
ucomp8 count_equal_one(.a(8'h01), .b(b[7:0]), .eq(count_one));
ucomp8 shift_equal_zero(.a(8'h00), .b(b[7:0]), .eq(shift_zero));

wire [31:0] sal_out;
wire sal_carry;
wire [5:0] sal_set_eflags;
LBSHF sal(.in(a), .s(b[7:0]), .out(sal_out), .c(sal_carry));
wire sal_xor, sal_of;
xor2$ sal_xorg(.out(sal_xor), .in0(a[31]), .in1(sal_carry));
mux2$ sal_of_mux(.outb(sal_of), .in0(1'bz), .in1(sal_xor), .s0(count_one));
mux #(.WIDTH(6), .INPUTS(2)) sal_eflags_mux(.in({6'b000000, {sal_of,5'b11z11}}), .out(sal_set_eflags), .select(shift_zero));

wire [31:0] sar_out;
wire sar_carry;
wire [5:0] sar_set_eflags;
RBSHF sar(.in(a), .s(b[7:0]), .out(sar_out), .c(sar_carry));
wire sar_of;
mux2$ sar_of_mux(.outb(sar_of), .in0(1'bz), .in1(1'b0), .s0(count_one));
mux #(.WIDTH(6), .INPUTS(2)) sar_eflags_mux(.in({6'b000000, {sar_of,5'b11z11}}), .out(sar_set_eflags), .select(shift_zero));

mux #(.WIDTH(32), .INPUTS(8)) alu_out_mux(.in({sar_out, sal_out, pass_out, or_out, not_out, bsf_out, and_out, add_out}), .out(alu_out), .select(alu_op));
mux #(.WIDTH(6), .INPUTS(8)) set_eflags_mux(.in({sar_set_eflags, sal_set_eflags, pass_set_eflags, or_set_eflags, not_set_eflags, bsf_set_eflags, and_set_eflags, add_set_eflags}), .out(set_eflags), .select(alu_op));

//eflags_out
mux #(.WIDTH(1), .INPUTS(8)) of_mux(.in({sar_set_eflags, sal_set_eflags, pass_set_eflags, or_set_eflags, not_set_eflags, bsf_set_eflags, and_set_eflags, add_set_eflags}), .out(set_eflags), .select(alu_op));
pfgen alu_pf_out(.in(alu_out[7:0]), .pf(eflags_out[0]));

endmodule
