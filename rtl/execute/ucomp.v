`timescale 1ns/1ps
module comp1(a, b, agb, eq, bga);
input a, b;
output agb, eq, bga;

wire a_not, b_not;
inv1$ ga_not(.in(a), .out(a_not));
inv1$ gb_not(.in(b), .out(b_not));

and2$ g_agb(.out(agb), .in0(a), .in1(b_not));
and2$ g_bga(.out(bga), .in0(b), .in1(a_not));
xnor2$ g_eq(.out(eq), .in0(a), .in1(b));

endmodule

`timescale 1ns/1ps
module ucomp4(a, b, agb_in, eq_in, bga_in, agb_out, eq_out, bga_out);
input [3:0] a;
input [3:0] b;
input agb_in, eq_in, bga_in;
output agb_out, eq_out, bga_out;

wire agb0, agb1, agb2, agb3;
wire eq0, eq1, eq2, eq3;
wire bga0, bga1, bga2, bga3;

comp1 c0(.a(a[0]), .b(b[0]), .agb(agb0), .eq(eq0), .bga(bga0));
comp1 c1(.a(a[1]), .b(b[1]), .agb(agb1), .eq(eq1), .bga(bga1));
comp1 c2(.a(a[2]), .b(b[2]), .agb(agb2), .eq(eq2), .bga(bga2));
comp1 c3(.a(a[3]), .b(b[3]), .agb(agb3), .eq(eq3), .bga(bga3));

wire and0, and1, and2, and3, and4, and5, and6, and7;
wire eq_all;
and2$ g_and0(.out(and0), .in0(eq3), .in1(bga2)); //eq3 & bga2
and3$ g_and1(.out(and1), .in0(eq3), .in1(eq2), .in2(bga1)); //eq3 & eq2 & bga1
and4$ g_and2(.out(and2), .in0(eq3), .in1(eq2), .in2(eq1), .in3(bga0)); //eq3 & eq2 & eq0 & bga0

and2$ g_and3(.out(and3), .in0(eq3), .in1(agb2)); //eq3 & agb2
and3$ g_and4(.out(and4), .in0(eq3), .in1(eq2), .in2(agb1)); //eq3 & eq2 & agb1
and4$ g_and5(.out(and5), .in0(eq3), .in1(eq2), .in2(eq1), .in3(agb0)); //eq3 & eq2 & eq1 & agb0
and4$ g_eqall(.out(eq_all), .in0(eq3), .in1(eq2), .in2(eq1), .in3(eq0)); //eq3 & eq2 & eq1 & eq0

and2$ g_eqout(.out(eq_out), .in0(eq_all), .in1(eq_in));
and2$ g_and6(.out(and6), .in0(eq_all), .in1(agb_in));
and2$ g_and7(.out(and7), .in0(eq_all), .in1(bga_in));
or5$ g_agbout(.out(agb_out), .in0(agb3), .in1(and3), .in2(and4), .in3(and5), .in4(and6));
or5$ g_bgaout(.out(bga_out), .in0(bga3), .in1(and0), .in2(and1), .in3(and2), .in4(and7));


endmodule

`timescale 1ns/1ps
module ucomp8(a, b, agb, eq, bga);
input [7:0] a;
input [7:0] b;
output agb, eq, bga;

wire agb4;
wire eq4;
wire bga4;

ucomp4 c4(.a(a[3:0]), .b(b[3:0]), .agb_in(1'b0), .eq_in(1'b1), .bga_in(1'b0), .agb_out(agb4), .eq_out(eq4), .bga_out(bga4));
ucomp4 c8(.a(a[7:4]), .b(b[7:4]), .agb_in(agb4), .eq_in(eq4), .bga_in(bga4), .agb_out(agb), .eq_out(eq), .bga_out(bga));

endmodule

`timescale 1ns/1ps
module ucomp12(a, b, agb, eq, bga);
input [11:0] a;
input [11:0] b;
output agb, eq, bga;

wire agb4, agb8;
wire eq4, eq8;
wire bga4, bga8;

ucomp4 c4(.a(a[3:0]), .b(b[3:0]), .agb_in(1'b0), .eq_in(1'b1), .bga_in(1'b0), .agb_out(agb4), .eq_out(eq4), .bga_out(bga4));
ucomp4 c8(.a(a[7:4]), .b(b[7:4]), .agb_in(agb4), .eq_in(eq4), .bga_in(bga4), .agb_out(agb8), .eq_out(eq8), .bga_out(bga8));
ucomp4 c12(.a(a[11:8]), .b(b[11:8]), .agb_in(agb8), .eq_in(eq8), .bga_in(bga8), .agb_out(agb), .eq_out(eq), .bga_out(bga));

endmodule

`timescale 1ns/1ps
module ucomp16(a, b, agb, eq, bga);
input [15:0] a;
input [15:0] b;
output agb, eq, bga;

wire agb4, agb8, agb12;
wire eq4, eq8, eq12;
wire bga4, bga8, bga12;


ucomp4 c4(.a(a[3:0]), .b(b[3:0]), .agb_in(1'b0), .eq_in(1'b1), .bga_in(1'b0), .agb_out(agb4), .eq_out(eq4), .bga_out(bga4));
ucomp4 c8(.a(a[7:4]), .b(b[7:4]), .agb_in(agb4), .eq_in(eq4), .bga_in(bga4), .agb_out(agb8), .eq_out(eq8), .bga_out(bga8));
ucomp4 c12(.a(a[11:8]), .b(b[11:8]), .agb_in(agb8), .eq_in(eq8), .bga_in(bga8), .agb_out(agb12), .eq_out(eq12), .bga_out(bga12));
ucomp4 c16(.a(a[15:12]), .b(b[15:12]), .agb_in(agb12), .eq_in(eq12), .bga_in(bga12), .agb_out(agb), .eq_out(eq), .bga_out(bga));

endmodule

`timescale 1ns/1ps
module ucomp32(a, b, agb, eq, bga);
input [31:0] a;
input [31:0] b;
output agb, eq, bga;

wire agb4, agb8, agb12, agb16, agb20, agb24, agb28;
wire eq4, eq8, eq12, eq16, eq20, eq24, eq28;
wire bga4, bga8, bga12, bga16, bga20, bga24, bga28;

ucomp4 c4(.a(a[3:0]), .b(b[3:0]), .agb_in(1'b0), .eq_in(1'b1), .bga_in(1'b0), .agb_out(agb4), .eq_out(eq4), .bga_out(bga4));
ucomp4 c8(.a(a[7:4]), .b(b[7:4]), .agb_in(agb4), .eq_in(eq4), .bga_in(bga4), .agb_out(agb8), .eq_out(eq8), .bga_out(bga8));
ucomp4 c12(.a(a[11:8]), .b(b[11:8]), .agb_in(agb8), .eq_in(eq8), .bga_in(bga8), .agb_out(agb12), .eq_out(eq12), .bga_out(bga12));
ucomp4 c16(.a(a[15:12]), .b(b[15:12]), .agb_in(agb12), .eq_in(eq12), .bga_in(bga12), .agb_out(agb16), .eq_out(eq16), .bga_out(bga16));
ucomp4 c20(.a(a[19:16]), .b(b[19:16]), .agb_in(agb16), .eq_in(eq16), .bga_in(bga16), .agb_out(agb20), .eq_out(eq20), .bga_out(bga20));
ucomp4 c24(.a(a[23:20]), .b(b[23:20]), .agb_in(agb20), .eq_in(eq20), .bga_in(bga20), .agb_out(agb24), .eq_out(eq24), .bga_out(bga24));
ucomp4 c28(.a(a[27:24]), .b(b[27:24]), .agb_in(agb24), .eq_in(eq24), .bga_in(bga24), .agb_out(agb28), .eq_out(eq28), .bga_out(bga28));
ucomp4 c32(.a(a[31:28]), .b(b[31:28]), .agb_in(agb28), .eq_in(eq28), .bga_in(bga28), .agb_out(agb), .eq_out(eq), .bga_out(bga));


endmodule
