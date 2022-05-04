`timescale 1ns/1ps
module halfadder(in0, in1, Cin, g, p, s);
input in0, in1, Cin;
output g, p, s; //generate, propogate, sum

//generate - ab
and2$ g_and(.out(g), .in0(in0), .in1(in1));

//progate - a xor b
xor2$ p_out(.out(p), .in0(in0), .in1(in1));

//sum - p xor cin
xor2$ s_out(.out(s), .in0(p), .in1(Cin));

endmodule