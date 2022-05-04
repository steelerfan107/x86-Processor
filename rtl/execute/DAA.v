`timescale 1ns / 1ps
module DAA(AL, CF, AF, AL_out, CF_out, AF_out, set_eflags);
input [7:0] AL;
input CF, AF;
output [7:0] AL_out;
output CF_out, AF_out;
output [5:0] set_eflags;

wire [7:0] old_AL;
assign old_AL = AL;
wire old_CF;
assign old_CF = CF;
assign CF = 1'b0;

//AL AND 0FH
wire [7:0] comp_and;
wire [7:0] mask0;
assign mask0 = 8'h0f;
genvar i;
generate
for(i = 0; i < 8; i = i+1) begin : if1_and2_block
    and2$ instance(.out(comp_and[i]), .in0(AL[i]), .in1(mask0[i]));
end
endgenerate

//(AL AND 0FH) > 9
wire comp_out0;
ucomp8 comp0(.a(comp_and), .b(8'h09), .agb(comp_out0));
wire if_out0;
or2$ if0(.out(if_out0), .in0(comp_out0), .in1(AF));

//body of IF (((AL AND 0FH) > 9) OR AF = 1)
wire [7:0] AL_if_true0;
wire if_true_carry0;
CLA8 add6(.a(AL), .b(8'h06), .Cin(1'b0), .s(AL_if_true0), .Cout(if_true_carry0));
wire CF_if_true0;
or2$ cf0(.out(CF_if_true0), .in0(old_CF), .in1(if_true_carry0));
mux2_8$ AL_mux0(.Y(AL), .IN0(AL), .IN1(AL_if_true0), .S0(if_out0));
mux2$ CF_mux0(.outb(CF), .in0(CF), .in1(CF_if_true0), .s0(if_out0));
mux2$ AF_mux0(.outb(AF), .in0(1'b0), .in1(1'b1), .s0(if_out0));

//old_AL > 99H
wire comp_out1;
ucomp8 comp1(.a(old_AL), .b(8'h99), .agb(comp_out1));
wire if_out1;
//IF ((old_AL > 99H) OR (old_CF = 1))
or2$ if1(.out(if_out1), .in0(comp_out1), .in1(old_CF));

//body of IF ((old_AL > 99H) OR (old_CF = 1))
wire [7:0] AL_if_true1;
CLA8 add60H(.a(AL), .b(8'h60), .Cin(1'b0), .s(AL_if_true1));
mux2_8$ AL_mux1(.Y(AL_out), .IN0(AL), .IN1(AL_if_true1), .S0(if_out1));
mux2$ CF_mux1(.outb(CF_out), .in0(1'b0), .in1(1'b1), .s0(if_out1));

assign AF_out = AF;
assign set_eflags = 6'bz11111;

endmodule
