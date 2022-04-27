//signed compare logic
`timescale 1ns / 1ps
module comp8(a, b, agb, eq, bga. overflow, carry);
input [7:0] a;
input [7:0] b;
output agb, eq, bga, overflow, carry;

wire [7:0] b_inv;
NOTN #(.WIDTH(8)) inv_b(.in(b), .out(b_inv));

wire [7:0] diff; //difference

CLA8 cla0(.a(a), .b(b_inv), .Cin(1'b1), .s(diff), .Cout(carry));

ucomp8 eqtest(.a(a), .b(b), .eq(eq));

wire a_not, b_not, d_not, e_not;
inv1$ a_inv(.out(a_not), .in(a[7]));
inv1$ gb_inv(.out(b_not), .in(b[7]));
inv1$ d_inv(.out(d_not), .in(diff[7]));
inv1$ e_inv(.out(e_not), .in(eq));

wire test_sign, same_sign;
xnor2$ same_signs(.out(same_sign), .in0(a[7]), .in1(b[7]));
xnor2$ sign_not_same(.out(test_sign), .in0(a[7]), .in1(d_not));
and2$ overflow_detector(.out(overflow), .in0(same_sign), .in1(test_sign));

wire anotdnotenot, anotbenot, bdnotenot;
and3$ and0(.out(anotdnotenot), .in0(a_not), .in1(d_not), .in2(e_not));
and3$ and1(.out(anotbenot), .in0(a_not), .in1(b[7]), .in2(e_not));
and3$ and2(.out(bdnotenot), .in0(b[7]), .in1(d_not), .in2(e_not));
or3$ agb_out(.out(agb), .in0(anotdnotenot), .in1(anotbenot), .in2(bdnotenot));

wire bnotdenot, abnotenot, adenot;
and3$ and3(.out(bnotdenot), .in0(b_not), .in1(diff[7]), .in2(e_not));
and3$ and4(.out(abnotenot), .in0(a[7]), .in1(b_not), .in2(e_not));
and3$ and5(.out(adenot), .in0(a[7]), .in1(diff[7]), .in2(e_not));
or3$ bga_out(.out(bga), .in0(bnotdenot), .in1(abnotenot), .in2(adenot));

endmodule

`timescale 1ns / 1ps
module comp16(a, b, agb, eq, bga. overflow, carry);
input [15:0] a;
input [15:0] b;
output agb, eq, bga, overflow, carry;

wire [15:0] b_inv;
NOTN #(.WIDTH(16)) inv_b(.in(b), .out(b_inv));

wire [15:0] diff; //difference

CLA16 cla0(.a(a), .b(b_inv), .Cin(1'b1), .s(diff), .Cout(carry));

ucomp16 eqtest(.a(a), .b(b), .eq(eq));

wire a_not, b_not, d_not, e_not;
inv1$ a_inv(.out(a_not), .in(a[15]));
inv1$ gb_inv(.out(b_not), .in(b[15]));
inv1$ d_inv(.out(d_not), .in(diff[15]));
inv1$ e_inv(.out(e_not), .in(eq));

wire test_sign, same_sign;
xnor2$ same_signs(.out(same_sign), .in0(a[15]), .in1(b[15]));
xnor2$ sign_not_same(.out(test_sign), .in0(a[15]), .in1(d_not));
and2$ overflow_detector(.out(overflow), .in0(same_sign), .in1(test_sign));

wire anotdnotenot, anotbenot, bdnotenot;
and3$ and0(.out(anotdnotenot), .in0(a_not), .in1(d_not), .in2(e_not));
and3$ and1(.out(anotbenot), .in0(a_not), .in1(b[15]), .in2(e_not));
and3$ and2(.out(bdnotenot), .in0(b[15]), .in1(d_not), .in2(e_not));
or3$ agb_out(.out(agb), .in0(anotdnotenot), .in1(anotbenot), .in2(bdnotenot));

wire bnotdenot, abnotenot, adenot;
and3$ and3(.out(bnotdenot), .in0(b_not), .in1(diff[15]), .in2(e_not));
and3$ and4(.out(abnotenot), .in0(a[15]), .in1(b_not), .in2(e_not));
and3$ and5(.out(adenot), .in0(a[15]), .in1(diff[15]), .in2(e_not));
or3$ bga_out(.out(bga), .in0(bnotdenot), .in1(abnotenot), .in2(adenot));

endmodule

//signed compare logic
`timescale 1ns / 1ps
module comp32(a, b, agb, eq, bga, comp_out, inv, overflow, carry);
input [31:0] a;
input [31:0] b;
output agb, eq, bga, overflow, carry;

wire [31:0] b_inv;
NOTN #(.WIDTH(32)) inv_b(.in(b), .out(b_inv));

wire [31:0] diff; //difference

CLA32 cla0(.a(a), .b(b_inv), .Cin(1'b1), .s(diff), .Cout(carry));

ucomp32 eqtest(.a(a), .b(b), .eq(eq));

wire a_not, b_not, d_not, e_not;
inv1$ a_inv(.out(a_not), .in(a[31]));
inv1$ gb_inv(.out(b_not), .in(b[31]));
inv1$ d_inv(.out(d_not), .in(diff[31]));
inv1$ e_inv(.out(e_not), .in(eq));

wire test_sign, same_sign, overflow;
xnor2$ same_signs(.out(same_sign), .in0(a[31]), .in1(b[31]));
xnor2$ sign_not_same(.out(test_sign), .in0(a[31]), .in1(d_not));
and2$ overflow_detector(.out(overflow), .in0(same_sign), .in1(test_sign));

wire anotdnotenot, anotbenot, bdnotenot;
and3$ and0(.out(anotdnotenot), .in0(a_not), .in1(d_not), .in2(e_not));
and3$ and1(.out(anotbenot), .in0(a_not), .in1(b[31]), .in2(e_not));
and3$ and2(.out(bdnotenot), .in0(b[31]), .in1(d_not), .in2(e_not));
or3$ agb_out(.out(agb), .in0(anotdnotenot), .in1(anotbenot), .in2(bdnotenot));

wire bnotdenot, abnotenot, adenot;
and3$ and3(.out(bnotdenot), .in0(b_not), .in1(diff[31]), .in2(e_not));
and3$ and4(.out(abnotenot), .in0(a[31]), .in1(b_not), .in2(e_not));
and3$ and5(.out(adenot), .in0(a[31]), .in1(diff[31]), .in2(e_not));
or3$ bga_out(.out(bga), .in0(bnotdenot), .in1(abnotenot), .in2(adenot));

endmodule