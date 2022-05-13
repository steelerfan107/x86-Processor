`timescale 1ns/1ps
module CLA2(input [1:0] a,
input [1:0] b, 
input Cin, 
output Gg, 
output Pg, 
output [1:0] s, 
output Cout);

wire g0, g1, g2, g3;
wire p0, p1, p2, p3;
wire c1, c2, c3;

halfadder h0(.in0(a[0]), .in1(b[0]), .Cin(Cin), .g(g0), .p(p0), .s(s[0]));
//Lookahead logic for c1
wire and0;
and2$ g_and0(.in0(p0), .in1(Cin), .out(and0));
or2$ g_c1(.in0(g0), .in1(and0), .out(c1));

halfadder h1(.in0(a[1]), .in1(b[1]), .Cin(c1), .g(g1), .p(p1), .s(s[1]));
//Lookahead logic for c2
wire and1, and2;
and2$ g_and1(.in0(p1), .in1(g0), .out(and1));
and3$ g_and2(.in0(p1), .in1(p0), .in2(Cin), .out(and2));
or3$ g_c2(.in0(g1), .in1(and1), .in2(and2), .out(c2));

assign Cout = c2;
endmodule

module CLA3(input [2:0] a,
input [2:0] b, 
input Cin, 
output Gg, 
output Pg, 
output [2:0] s, 
output Cout);

wire g0, g1, g2, g3;
wire p0, p1, p2, p3;
wire c1, c2, c3;

halfadder h0(.in0(a[0]), .in1(b[0]), .Cin(Cin), .g(g0), .p(p0), .s(s[0]));
//Lookahead logic for c1
wire and0;
and2$ g_and0(.in0(p0), .in1(Cin), .out(and0));
or2$ g_c1(.in0(g0), .in1(and0), .out(c1));

halfadder h1(.in0(a[1]), .in1(b[1]), .Cin(c1), .g(g1), .p(p1), .s(s[1]));
//Lookahead logic for c2
wire and1, and2;
and2$ g_and1(.in0(p1), .in1(g0), .out(and1));
and3$ g_and2(.in0(p1), .in1(p0), .in2(Cin), .out(and2));
or3$ g_c2(.in0(g1), .in1(and1), .in2(and2), .out(c2));

halfadder h2(.in0(a[2]), .in1(b[2]), .Cin(c2), .g(g2), .p(p2), .s(s[2]));
//Lookahead logic for c3
wire and3, and4, and5;
and2$ g_and3(.in0(p2), .in1(g1), .out(and3));
and3$ g_and4(.in0(p2), .in1(p1), .in2(g0), .out(and4));
and4$ g_and5(.in0(p2), .in1(p1), .in2(p0), .in3(Cin), .out(and5));
or4$ g_c3(.in0(g2), .in1(and3), .in2(and4), .in3(and5), .out(c3));

assign Cout = c3;

//Logic for Gg and Pg, edit if necessary
//and4$ g_pg(.in0(p3), .in1(p2), .in2(p1), .in3(p0), .out(Pg)); //group propogate logic
//or4$ g_gg(.in0(g3), .in1(and6), .in2(and7), .in3(and8), .out(Gg)); //group generate logic
endmodule

`timescale 1ns/1ps
module CLA4(input [3:0] a,
input [3:0] b, 
input Cin, 
output Gg, 
output Pg, 
output [3:0] s, 
output Cout,
output overflow);

wire g0, g1, g2, g3;
wire p0, p1, p2, p3;
wire c1, c2, c3;

halfadder h0(.in0(a[0]), .in1(b[0]), .Cin(Cin), .g(g0), .p(p0), .s(s[0]));
//Lookahead logic for c1
wire and0;
and2$ g_and0(.in0(p0), .in1(Cin), .out(and0));
or2$ g_c1(.in0(g0), .in1(and0), .out(c1));

halfadder h1(.in0(a[1]), .in1(b[1]), .Cin(c1), .g(g1), .p(p1), .s(s[1]));
//Lookahead logic for c2
wire and1, and2;
and2$ g_and1(.in0(p1), .in1(g0), .out(and1));
and3$ g_and2(.in0(p1), .in1(p0), .in2(Cin), .out(and2));
or3$ g_c2(.in0(g1), .in1(and1), .in2(and2), .out(c2));

halfadder h2(.in0(a[2]), .in1(b[2]), .Cin(c2), .g(g2), .p(p2), .s(s[2]));
//Lookahead logic for c3
wire and3, and4, and5;
and2$ g_and3(.in0(p2), .in1(g1), .out(and3));
and3$ g_and4(.in0(p2), .in1(p1), .in2(g0), .out(and4));
and4$ g_and5(.in0(p2), .in1(p1), .in2(p0), .in3(Cin), .out(and5));
or4$ g_c3(.in0(g2), .in1(and3), .in2(and4), .in3(and5), .out(c3));

halfadder h3(.in0(a[3]), .in1(b[3]), .Cin(c3), .g(g3), .p(p3), .s(s[3]));
//Lookahead logic for c4
wire and6, and7, and8, and9;
and2$ g_and6(.in0(p3), .in1(g2), .out(and6));
and3$ g_and7(.in0(p3), .in1(p2), .in2(g1), .out(and7));
and4$ g_and8(.in0(p3), .in1(p2), .in2(p1), .in3(g0), .out(and8));
and5$ g_and9(.in0(p3), .in1(p2), .in2(p1), .in3(p0), .in4(Cin), .out(and9));
or5$ g_Cout(.in0(g3), .in1(and6), .in2(and7), .in3(and8), .in4(and9), .out(Cout));

//Logic for Gg and Pg
and4$ g_pg(.in0(p3), .in1(p2), .in2(p1), .in3(p0), .out(Pg)); //group propogate logic
or4$ g_gg(.in0(g3), .in1(and6), .in2(and7), .in3(and8), .out(Gg)); //group generate logic

wire input_signs, output_sign_not, in_out_signs;
xnor2$ signs_xnor(.out(input_signs), .in0(a[3]), .in1(b[3]));
inv1$ output_sign_inv(.out(output_sign_not), .in(s[3]));
xnor2$ in_out_signs_xnor(.out(in_out_signs), .in0(output_sign_not), .in1(b[3]));
and2$ overflow_and(.out(overflow), .in0(in_out_signs), .in1(input_signs));
endmodule

`timescale 1ns/1ps
module CLA5(
    input [4:0] a, 
    input [4:0] b, 
    input Cin, 
    output [4:0] s, 
    output Cout,
    output overflow
);
    wire dummy_carry, g0, p0;
    CLA3 cla0(.a(a[2:0]), .b(b[2:0]), .Cin(Cin), .Gg(g0), .Pg(p0), .s(s[2:0]), .Cout(dummy_carry));
    //Lookahead logic for c3
    wire and0, c3;
    and2$ g_and0(.in0(p0), .in1(Cin), .out(and0));
    or2$ g_c3(.in0(g0), .in1(and0), .out(c3));

    wire g3, p3;
    CLA2 cla3(.a(a[4:3]), .b(b[4:3]), .Cin(c3), .Gg(g3), .Pg(p3), .s(s[4:3]), .Cout(dummy_carry));
    //Lookahead logic for Cout
    wire and1, and2;
    and2$ g_and1(.in0(p3), .in1(g0), .out(and1));
    and3$ g_and2(.in0(p3), .in1(p0), .in2(Cin), .out(and2));
    or3$ g_c2(.in0(g3), .in1(and1), .in2(and2), .out(Cout));

    wire input_signs, output_sign_not, in_out_signs;
    xnor2$ signs_xnor(.out(input_signs), .in0(a[4]), .in1(b[4]));
    inv1$ output_sign_inv(.out(output_sign_not), .in(s[4]));
    xnor2$ in_out_signs_xnor(.out(in_out_signs), .in0(output_sign_not), .in1(b[4]));
    and2$ overflow_and(.out(overflow), .in0(in_out_signs), .in1(input_signs));
endmodule

`timescale 1ns/1ps
module CLA6(
    input [5:0] a, 
    input [5:0] b, 
    input Cin, 
    output [5:0] s, 
    output Cout,
    output overflow
);
    wire dummy_carry, g0, p0;
    CLA3 cla0(.a(a[2:0]), .b(b[2:0]), .Cin(Cin), .Gg(g0), .Pg(p0), .s(s[2:0]), .Cout(dummy_carry));
    //Lookahead logic for c3
    wire and0, c3;
    and2$ g_and0(.in0(p0), .in1(Cin), .out(and0));
    or2$ g_c3(.in0(g0), .in1(and0), .out(c3));

    wire g3, p3;
    CLA3 cla3(.a(a[5:3]), .b(b[5:3]), .Cin(c3), .Gg(g3), .Pg(p3), .s(s[5:3]), .Cout(dummy_carry));
    //Lookahead logic for Cout
    wire and1, and2;
    and2$ g_and1(.in0(p3), .in1(g0), .out(and1));
    and3$ g_and2(.in0(p3), .in1(p0), .in2(Cin), .out(and2));
    or3$ g_c2(.in0(g3), .in1(and1), .in2(and2), .out(Cout));

    wire input_signs, output_sign_not, in_out_signs;
    xnor2$ signs_xnor(.out(input_signs), .in0(a[5]), .in1(b[5]));
    inv1$ output_sign_inv(.out(output_sign_not), .in(s[5]));
    xnor2$ in_out_signs_xnor(.out(in_out_signs), .in0(output_sign_not), .in1(b[5]));
    and2$ overflow_and(.out(overflow), .in0(in_out_signs), .in1(input_signs));
endmodule

`timescale 1ns/1ps
module CLA7(
    input [6:0] a, 
    input [6:0] b, 
    input Cin, 
    output [6:0] s, 
    output Cout,
    output overflow
);
    wire dummy_carry, g0, p0;
    CLA4 cla0(.a(a[3:0]), .b(b[3:0]), .Cin(Cin), .Gg(g0), .Pg(p0), .s(s[3:0]), .Cout(dummy_carry));
    //Lookahead logic for c4
    wire and0, c4;
    and2$ g_and0(.in0(p0), .in1(Cin), .out(and0));
    or2$ g_c4(.in0(g0), .in1(and0), .out(c4));

    wire g4, p4;
    CLA3 cla3(.a(a[6:4]), .b(b[6:4]), .Cin(c4), .Gg(g4), .Pg(p4), .s(s[6:4]), .Cout(dummy_carry));
    //Lookahead logic for Cout
    wire and1, and2;
    and2$ g_and1(.in0(p4), .in1(g0), .out(and1));
    and3$ g_and2(.in0(p4), .in1(p0), .in2(Cin), .out(and2));
    or3$ g_c2(.in0(g4), .in1(and1), .in2(and2), .out(Cout));

    wire input_signs, output_sign_not, in_out_signs;
    xnor2$ signs_xnor(.out(input_signs), .in0(a[6]), .in1(b[6]));
    inv1$ output_sign_inv(.out(output_sign_not), .in(s[6]));
    xnor2$ in_out_signs_xnor(.out(in_out_signs), .in0(output_sign_not), .in1(b[6]));
    and2$ overflow_and(.out(overflow), .in0(in_out_signs), .in1(input_signs));
endmodule

`timescale 1ns/1ps
module CLA8(
    input [7:0] a, 
    input [7:0] b, 
    input Cin, 
    output [7:0] s, 
    output Cout,
    output overflow
);
    wire dummy_carry, g0, p0;
    CLA4 cla0(.a(a[3:0]), .b(b[3:0]), .Cin(Cin), .Gg(g0), .Pg(p0), .s(s[3:0]), .Cout(dummy_carry));
    //Lookahead logic for c4
    wire and0, c4;
    and2$ g_and0(.in0(p0), .in1(Cin), .out(and0));
    or2$ g_c4(.in0(g0), .in1(and0), .out(c4));

    wire g4, p4;
    CLA4 cla4(.a(a[7:4]), .b(b[7:4]), .Cin(c4), .Gg(g4), .Pg(p4), .s(s[7:4]), .Cout(dummy_carry));
    //Lookahead logic for Cout
    wire and1, and2;
    and2$ g_and1(.in0(p4), .in1(g0), .out(and1));
    and3$ g_and2(.in0(p4), .in1(p0), .in2(Cin), .out(and2));
    or3$ g_c2(.in0(g4), .in1(and1), .in2(and2), .out(Cout));

    wire input_signs, output_sign_not, in_out_signs;
    xnor2$ signs_xnor(.out(input_signs), .in0(a[7]), .in1(b[7]));
    inv1$ output_sign_inv(.out(output_sign_not), .in(s[7]));
    xnor2$ in_out_signs_xnor(.out(in_out_signs), .in0(output_sign_not), .in1(b[7]));
    and2$ overflow_and(.out(overflow), .in0(in_out_signs), .in1(input_signs));
endmodule

`timescale 1ns/1ps
module CLA16(input [15:0] a, 
input [15:0] b, 
input Cin,
output Gg, 
output Pg,  
output [15:0] s, 
output Cout,
output overflow);

wire g0, g4, g8, g12;
wire p0, p4, p8, p12;
wire c4, c8, c12;
wire dummy_carry;

CLA4 cla0(.a(a[3:0]), .b(b[3:0]), .Cin(Cin), .Gg(g0), .Pg(p0), .s(s[3:0]), .Cout(dummy_carry));
//Lookahead logic for c4
wire and0;
and2$ g_and0(.in0(p0), .in1(Cin), .out(and0));
or2$ g_c4(.in0(g0), .in1(and0), .out(c4));

CLA4 cla1(.a(a[7:4]), .b(b[7:4]), .Cin(c4), .Gg(g4), .Pg(p4), .s(s[7:4]), .Cout(dummy_carry));
//Lookahead logic for c8
wire and1, and2;
and2$ g_and1(.in0(p4), .in1(g0), .out(and1));
and3$ g_and2(.in0(p4), .in1(p0), .in2(Cin), .out(and2));
or3$ g_c2(.in0(g4), .in1(and1), .in2(and2), .out(c8));

CLA4 cla2(.a(a[11:8]), .b(b[11:8]), .Cin(c8), .Gg(g8), .Pg(p8), .s(s[11:8]), .Cout(dummy_carry));
//Lookahead logic for c12
wire and3, and4, and5;
and2$ g_and3(.in0(p8), .in1(g4), .out(and3));
and3$ g_and4(.in0(p8), .in1(p4), .in2(g0), .out(and4));
and4$ g_and5(.in0(p8), .in1(p4), .in2(p0), .in3(Cin), .out(and5));
or4$ g_c3(.in0(g8), .in1(and3), .in2(and4), .in3(and5), .out(c12));

CLA4 cla3(.a(a[15:12]), .b(b[15:12]), .Cin(c12), .Gg(g12), .Pg(p12), .s(s[15:12]),  .Cout(dummy_carry));
//Lookahead logic for c16
wire and6, and7, and8, and9;
and2$ g_and6(.in0(p12), .in1(g8), .out(and6));
and3$ g_and7(.in0(p12), .in1(p8), .in2(g4), .out(and7));
and4$ g_and8(.in0(p12), .in1(p8), .in2(p4), .in3(g0), .out(and8));
and5$ g_and9(.in0(p12), .in1(p8), .in2(p4), .in3(p0), .in4(Cin), .out(and9));
or5$ g_Cout(.in0(g12), .in1(and6), .in2(and7), .in3(and8), .in4(and9), .out(Cout));

//Logic for Gg and Pg
and4$ g_pg(.in0(p12), .in1(p8), .in2(p4), .in3(p0), .out(Pg)); //group propogate logic
or4$ g_gg(.in0(g12), .in1(and6), .in2(and7), .in3(and8), .out(Gg)); //group generate logic

wire input_signs, output_sign_not, in_out_signs;
xnor2$ signs_xnor(.out(input_signs), .in0(a[15]), .in1(b[15]));
inv1$ output_sign_inv(.out(output_sign_not), .in(s[15]));
xnor2$ in_out_signs_xnor(.out(in_out_signs), .in0(output_sign_not), .in1(b[15]));
and2$ overflow_and(.out(overflow), .in0(in_out_signs), .in1(input_signs));
endmodule

`timescale 1ns/1ps
module CLA32(
    input [31:0] a, 
    input [31:0] b, 
    input Cin, 
    output [31:0] s, 
    output Cout,
    output overflow 
);
    wire dummy_carry, g0, p0;
    CLA16 cla0(.a(a[15:0]), .b(b[15:0]), .Cin(Cin), .Gg(g0), .Pg(p0), .s(s[15:0]), .Cout(dummy_carry));
    //Lookahead logic for c16
    wire and0, c16;
    and2$ g_and0(.in0(p0), .in1(Cin), .out(and0));
    or2$ g_c4(.in0(g0), .in1(and0), .out(c16));

    wire g16, p16;
    CLA16 cla16(.a(a[31:16]), .b(b[31:16]), .Cin(c16), .Gg(g16), .Pg(p16), .s(s[31:16]), .Cout(dummy_carry));
    //Lookahead logic for Cout
    wire and1, and2;
    and2$ g_and1(.in0(p16), .in1(g0), .out(and1));
    and3$ g_and2(.in0(p16), .in1(p0), .in2(Cin), .out(and2));
    or3$ g_c2(.in0(g16), .in1(and1), .in2(and2), .out(Cout));

    wire input_signs, output_sign_not, in_out_signs;
    xnor2$ signs_xnor(.out(input_signs), .in0(a[31]), .in1(b[31]));
    inv1$ output_sign_inv(.out(output_sign_not), .in(s[31]));
    xnor2$ in_out_signs_xnor(.out(in_out_signs), .in0(output_sign_not), .in1(b[31]));
    and2$ overflow_and(.out(overflow), .in0(in_out_signs), .in1(input_signs));
endmodule