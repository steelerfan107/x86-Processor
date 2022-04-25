`timescale 1ns/1ps
//or$ modules larger than 4 inputs
module or5$(output out,
input in0, 
input in1, 
input in2, 
input in3, 
input in4 
);


wire OR0, OR1, OR_OUT;

or3$ g_or0(.in0(in0), .in1(in1), .in2(in2), .out(OR0));
or2$ g_or1(.in0(in3), .in1(in4), .out(OR1));
or2$ g_or_out(.in0(OR0), .in1(OR1), .out(out));

endmodule

`timescale 1ns/1ps
module or6$(output out,
input in0, 
input in1, 
input in2, 
input in3, 
input in4,
input in5 
);


wire OR0, OR1, OR_OUT;

or3$ g_or0(.in0(in0), .in1(in1), .in2(in2), .out(OR0));
or3$ g_or1(.in0(in3), .in1(in4), .in2(in5), .out(OR1));
or2$ g_or_out(.in0(OR0), .in1(OR1), .out(out));

endmodule

`timescale 1ns/1ps
module or7$(output out,
input in0, 
input in1, 
input in2, 
input in3, 
input in4,
input in5,
input in6 
);


wire OR0, OR1, OR_OUT;

or3$ g_or0(.in0(in0), .in1(in1), .in2(in2), .out(OR0));
or4$ g_or1(.in0(in3), .in1(in4), .in2(in5), .in3(in6), .out(OR1));
or2$ g_or_out(.in0(OR0), .in1(OR1), .out(out));

endmodule

`timescale 1ns/1ps
module or8$(output out,
input in0, 
input in1, 
input in2, 
input in3, 
input in4,
input in5,
input in6,
input in7 
);


wire OR0, OR1, OR_OUT;

or4$ g_or0(.in0(in0), .in1(in1), .in2(in2), .in3(in7), .out(OR0));
or4$ g_or1(.in0(in3), .in1(in4), .in2(in5), .in3(in6), .out(OR1));
or2$ g_or_out(.in0(OR0), .in1(OR1), .out(out));

endmodule

`timescale 1ns/1ps
module or9$(output out,
input in0, 
input in1, 
input in2, 
input in3, 
input in4,
input in5,
input in6,
input in7,
input in8 
);


wire OR0, OR1, OR_OUT;

or4$ g_or0(.in0(in0), .in1(in1), .in2(in2), .in3(in7), .out(OR0));
or5$ g_or1(.in0(in3), .in1(in4), .in2(in5), .in3(in6), .in4(in8), .out(OR1));
or2$ g_or_out(.in0(OR0), .in1(OR1), .out(out));

endmodule

`timescale 1ns/1ps
module or10$(output out,
input in0, 
input in1, 
input in2, 
input in3, 
input in4,
input in5,
input in6,
input in7,
input in8,
input in9 
);


wire OR0, OR1, OR_OUT;

or5$ g_or0(.in0(in0), .in1(in1), .in2(in2), .in3(in7), .in4(in9), .out(OR0));
or5$ g_or1(.in0(in3), .in1(in4), .in2(in5), .in3(in6), .in4(in8), .out(OR1));
or2$ g_or_out(.in0(OR0), .in1(OR1), .out(out));

endmodule

`timescale 1ns/1ps
module or11$(output out,
input in0, 
input in1, 
input in2, 
input in3, 
input in4,
input in5,
input in6,
input in7,
input in8,
input in9,
input in10
);


wire OR0, OR1, OR_OUT;

or5$ g_or0(.in0(in0), .in1(in1), .in2(in2), .in3(in7), .in4(in9), .out(OR0));
or6$ g_or1(.in0(in3), .in1(in4), .in2(in5), .in3(in6), .in4(in8), .in5(in10), .out(OR1));
or2$ g_or_out(.in0(OR0), .in1(OR1), .out(out));

endmodule

`timescale 1ns/1ps
module or12$(output out,
input in0, 
input in1, 
input in2, 
input in3, 
input in4,
input in5,
input in6,
input in7,
input in8,
input in9,
input in10,
input in11
);


wire OR0, OR1, OR_OUT;

or6$ g_or0(.in0(in0), .in1(in1), .in2(in2), .in3(in7), .in4(in9), .in5(in11), .out(OR0));
or6$ g_or1(.in0(in3), .in1(in4), .in2(in5), .in3(in6), .in4(in8), .in5(in10), .out(OR1));
or2$ g_or_out(.in0(OR0), .in1(OR1), .out(out));

endmodule

`timescale 1ns/1ps
module or13$(output out,
input in0, 
input in1, 
input in2, 
input in3, 
input in4,
input in5,
input in6,
input in7,
input in8,
input in9,
input in10,
input in11,
input in12
);


wire OR0, OR1, OR_OUT;

or6$ g_or0(.in0(in0), .in1(in1), .in2(in2), .in3(in7), .in4(in9), .in5(in11), .out(OR0));
or7$ g_or1(.in0(in3), .in1(in4), .in2(in5), .in3(in6), .in4(in8), .in5(in10), .in6(in12), .out(OR1));
or2$ g_or_out(.in0(OR0), .in1(OR1), .out(out));

endmodule

`timescale 1ns/1ps
module or14$(output out,
input in0, 
input in1, 
input in2, 
input in3, 
input in4,
input in5,
input in6,
input in7,
input in8,
input in9,
input in10,
input in11,
input in12,
input in13
);


wire OR0, OR1, OR_OUT;

or7$ g_or0(.in0(in0), .in1(in1), .in2(in2), .in3(in7), .in4(in9), .in5(in11), .in6(in13), .out(OR0));
or7$ g_or1(.in0(in3), .in1(in4), .in2(in5), .in3(in6), .in4(in8), .in5(in10), .in6(in12), .out(OR1));
or2$ g_or_out(.in0(OR0), .in1(OR1), .out(out));

endmodule

`timescale 1ns/1ps
module or15$(output out,
input in0, 
input in1, 
input in2, 
input in3, 
input in4,
input in5,
input in6,
input in7,
input in8,
input in9,
input in10,
input in11,
input in12,
input in13,
input in14
);


wire OR0, OR1, OR_OUT;

or7$ g_or0(.in0(in0), .in1(in1), .in2(in2), .in3(in7), .in4(in9), .in5(in11), .in6(in13), .out(OR0));
or8$ g_or1(.in0(in3), .in1(in4), .in2(in5), .in3(in6), .in4(in8), .in5(in10), .in6(in12), .in7(in14), .out(OR1));
or2$ g_or_out(.in0(OR0), .in1(OR1), .out(out));

endmodule

`timescale 1ns/1ps
module or16$(output out,
input in0, 
input in1, 
input in2, 
input in3, 
input in4,
input in5,
input in6,
input in7,
input in8,
input in9,
input in10,
input in11,
input in12,
input in13,
input in14,
input in15
);


wire OR0, OR1, OR_OUT;

or8$ g_or0(.in0(in0), .in1(in1), .in2(in2), .in3(in7), .in4(in9), .in5(in11), .in6(in13), .in7(in15), .out(OR0));
or8$ g_or1(.in0(in3), .in1(in4), .in2(in5), .in3(in6), .in4(in8), .in5(in10), .in6(in12), .in7(in14), .out(OR1));
or2$ g_or_out(.in0(OR0), .in1(OR1), .out(out));

endmodule

`timescale 1ns/1ps
module or17$(output out,
input in0, 
input in1, 
input in2, 
input in3, 
input in4,
input in5,
input in6,
input in7,
input in8,
input in9,
input in10,
input in11,
input in12,
input in13,
input in14,
input in15,
input in16
);


wire OR0, OR1, OR_OUT;

or8$ g_or0(.in0(in0), .in1(in1), .in2(in2), .in3(in7), .in4(in9), .in5(in11), .in6(in13), .in7(in15), .out(OR0));
or9$ g_or1(.in0(in3), .in1(in4), .in2(in5), .in3(in6), .in4(in8), .in5(in10), .in6(in12), .in7(in14), .in8(in16), .out(OR1));
or2$ g_or_out(.in0(OR0), .in1(OR1), .out(out));

endmodule

`timescale 1ns/1ps
module or18$(output out,
input in0, 
input in1, 
input in2, 
input in3, 
input in4,
input in5,
input in6,
input in7,
input in8,
input in9,
input in10,
input in11,
input in12,
input in13,
input in14,
input in15,
input in16,
input in17
);


wire OR0, OR1, OR_OUT;

or9$ g_or0(.in0(in0), .in1(in1), .in2(in2), .in3(in7), .in4(in9), .in5(in11), .in6(in13), .in7(in15), .in8(in17), .out(OR0));
or9$ g_or1(.in0(in3), .in1(in4), .in2(in5), .in3(in6), .in4(in8), .in5(in10), .in6(in12), .in7(in14), .in8(in16), .out(OR1));
or2$ g_or_out(.in0(OR0), .in1(OR1), .out(out));

endmodule

`timescale 1ns/1ps
module or19$(output out,
input in0, 
input in1, 
input in2, 
input in3, 
input in4,
input in5,
input in6,
input in7,
input in8,
input in9,
input in10,
input in11,
input in12,
input in13,
input in14,
input in15,
input in16,
input in17,
input in18
);


wire OR0, OR1, OR_OUT;

or9$ g_or0(.in0(in0), .in1(in1), .in2(in2), .in3(in7), .in4(in9), .in5(in11), .in6(in13), .in7(in15), .in8(in17), .out(OR0));
or10$ g_or1(.in0(in3), .in1(in4), .in2(in5), .in3(in6), .in4(in8), .in5(in10), .in6(in12), .in7(in14), .in8(in16), .in9(in18), .out(OR1));
or2$ g_or_out(.in0(OR0), .in1(OR1), .out(out));

endmodule

`timescale 1ns/1ps
module or20$(output out,
input in0, 
input in1, 
input in2, 
input in3, 
input in4,
input in5,
input in6,
input in7,
input in8,
input in9,
input in10,
input in11,
input in12,
input in13,
input in14,
input in15,
input in16,
input in17,
input in18,
input in19
);


wire OR0, OR1, OR_OUT;

or10$ g_or0(.in0(in0), .in1(in1), .in2(in2), .in3(in7), .in4(in9), .in5(in11), .in6(in13), .in7(in15), .in8(in17), .in9(in19), .out(OR0));
or10$ g_or1(.in0(in3), .in1(in4), .in2(in5), .in3(in6), .in4(in8), .in5(in10), .in6(in12), .in7(in14), .in8(in16), .in9(in18), .out(OR1));
or2$ g_or_out(.in0(OR0), .in1(OR1), .out(out));

endmodule

`timescale 1ns/1ps
module or21$(output out,
input in0, 
input in1, 
input in2, 
input in3, 
input in4,
input in5,
input in6,
input in7,
input in8,
input in9,
input in10,
input in11,
input in12,
input in13,
input in14,
input in15,
input in16,
input in17,
input in18,
input in19,
input in20
);


wire OR0, OR1, OR_OUT;

or10$ g_or0(.in0(in0), .in1(in1), .in2(in2), .in3(in7), .in4(in9), .in5(in11), .in6(in13), .in7(in15), .in8(in17), .in9(in19), .out(OR0));
or11$ g_or1(.in0(in3), .in1(in4), .in2(in5), .in3(in6), .in4(in8), .in5(in10), .in6(in12), .in7(in14), .in8(in16), .in9(in18), .in10(in20), .out(OR1));
or2$ g_or_out(.in0(OR0), .in1(OR1), .out(out));

endmodule

`timescale 1ns/1ps
module or22$(output out,
input in0, 
input in1, 
input in2, 
input in3, 
input in4,
input in5,
input in6,
input in7,
input in8,
input in9,
input in10,
input in11,
input in12,
input in13,
input in14,
input in15,
input in16,
input in17,
input in18,
input in19,
input in20,
input in21
);


wire OR0, OR1, OR_OUT;

or11$ g_or0(.in0(in0), .in1(in1), .in2(in2), .in3(in7), .in4(in9), .in5(in11), .in6(in13), .in7(in15), .in8(in17), .in9(in19), .in10(in21), .out(OR0));
or11$ g_or1(.in0(in3), .in1(in4), .in2(in5), .in3(in6), .in4(in8), .in5(in10), .in6(in12), .in7(in14), .in8(in16), .in9(in18), .in10(in20), .out(OR1));
or2$ g_or_out(.in0(OR0), .in1(OR1), .out(out));

endmodule

`timescale 1ns/1ps
module or23$(output out,
input in0, 
input in1, 
input in2, 
input in3, 
input in4,
input in5,
input in6,
input in7,
input in8,
input in9,
input in10,
input in11,
input in12,
input in13,
input in14,
input in15,
input in16,
input in17,
input in18,
input in19,
input in20,
input in21,
input in22
);


wire OR0, OR1, OR_OUT;

or11$ g_or0(.in0(in0), .in1(in1), .in2(in2), .in3(in7), .in4(in9), .in5(in11), .in6(in13), .in7(in15), .in8(in17), .in9(in19), .in10(in21), .out(OR0));
or12$ g_or1(.in0(in3), .in1(in4), .in2(in5), .in3(in6), .in4(in8), .in5(in10), .in6(in12), .in7(in14), .in8(in16), .in9(in18), .in10(in20), .in11(in22), .out(OR1));
or2$ g_or_out(.in0(OR0), .in1(OR1), .out(out));

endmodule

`timescale 1ns/1ps
module or24$(output out,
input in0, 
input in1, 
input in2, 
input in3, 
input in4,
input in5,
input in6,
input in7,
input in8,
input in9,
input in10,
input in11,
input in12,
input in13,
input in14,
input in15,
input in16,
input in17,
input in18,
input in19,
input in20,
input in21,
input in22,
input in23
);


wire OR0, OR1, OR_OUT;

or12$ g_or0(.in0(in0), .in1(in1), .in2(in2), .in3(in7), .in4(in9), .in5(in11), .in6(in13), .in7(in15), .in8(in17), .in9(in19), .in10(in21), .in11(in23), .out(OR0));
or12$ g_or1(.in0(in3), .in1(in4), .in2(in5), .in3(in6), .in4(in8), .in5(in10), .in6(in12), .in7(in14), .in8(in16), .in9(in18), .in10(in20), .in11(in22), .out(OR1));
or2$ g_or_out(.in0(OR0), .in1(OR1), .out(out));

endmodule

`timescale 1ns/1ps
module or25$(output out,
input in0, 
input in1, 
input in2, 
input in3, 
input in4,
input in5,
input in6,
input in7,
input in8,
input in9,
input in10,
input in11,
input in12,
input in13,
input in14,
input in15,
input in16,
input in17,
input in18,
input in19,
input in20,
input in21,
input in22,
input in23,
input in24
);


wire OR0, OR1, OR_OUT;

or12$ g_or0(.in0(in0), .in1(in1), .in2(in2), .in3(in7), .in4(in9), .in5(in11), .in6(in13), .in7(in15), .in8(in17), .in9(in19), .in10(in21), .in11(in23), .out(OR0));
or13$ g_or1(.in0(in3), .in1(in4), .in2(in5), .in3(in6), .in4(in8), .in5(in10), .in6(in12), .in7(in14), .in8(in16), .in9(in18), .in10(in20), .in11(in22), .in12(in24), .out(OR1));
or2$ g_or_out(.in0(OR0), .in1(OR1), .out(out));

endmodule

`timescale 1ns/1ps
module or26$(output out,
input in0, 
input in1, 
input in2, 
input in3, 
input in4,
input in5,
input in6,
input in7,
input in8,
input in9,
input in10,
input in11,
input in12,
input in13,
input in14,
input in15,
input in16,
input in17,
input in18,
input in19,
input in20,
input in21,
input in22,
input in23,
input in24,
input in25
);


wire OR0, OR1, OR_OUT;

or13$ g_or0(.in0(in0), .in1(in1), .in2(in2), .in3(in7), .in4(in9), .in5(in11), .in6(in13), .in7(in15), .in8(in17), .in9(in19), .in10(in21), .in11(in23), .in12(in25), .out(OR0));
or13$ g_or1(.in0(in3), .in1(in4), .in2(in5), .in3(in6), .in4(in8), .in5(in10), .in6(in12), .in7(in14), .in8(in16), .in9(in18), .in10(in20), .in11(in22), .in12(in24), .out(OR1));
or2$ g_or_out(.in0(OR0), .in1(OR1), .out(out));

endmodule

`timescale 1ns/1ps
module or27$(output out,
input in0, 
input in1, 
input in2, 
input in3, 
input in4,
input in5,
input in6,
input in7,
input in8,
input in9,
input in10,
input in11,
input in12,
input in13,
input in14,
input in15,
input in16,
input in17,
input in18,
input in19,
input in20,
input in21,
input in22,
input in23,
input in24,
input in25,
input in26
);


wire OR0, OR1, OR_OUT;

or13$ g_or0(.in0(in0), .in1(in1), .in2(in2), .in3(in7), .in4(in9), .in5(in11), .in6(in13), .in7(in15), .in8(in17), .in9(in19), .in10(in21), .in11(in23), .in12(in25), .out(OR0));
or14$ g_or1(.in0(in3), .in1(in4), .in2(in5), .in3(in6), .in4(in8), .in5(in10), .in6(in12), .in7(in14), .in8(in16), .in9(in18), .in10(in20), .in11(in22), .in12(in24), .in13(in26), .out(OR1));
or2$ g_or_out(.in0(OR0), .in1(OR1), .out(out));

endmodule

`timescale 1ns/1ps
module or28$(output out,
input in0, 
input in1, 
input in2, 
input in3, 
input in4,
input in5,
input in6,
input in7,
input in8,
input in9,
input in10,
input in11,
input in12,
input in13,
input in14,
input in15,
input in16,
input in17,
input in18,
input in19,
input in20,
input in21,
input in22,
input in23,
input in24,
input in25,
input in26,
input in27
);


wire OR0, OR1, OR_OUT;

or14$ g_or0(.in0(in0), .in1(in1), .in2(in2), .in3(in7), .in4(in9), .in5(in11), .in6(in13), .in7(in15), .in8(in17), .in9(in19), .in10(in21), .in11(in23), .in12(in25), .in13(in27), .out(OR0));
or14$ g_or1(.in0(in3), .in1(in4), .in2(in5), .in3(in6), .in4(in8), .in5(in10), .in6(in12), .in7(in14), .in8(in16), .in9(in18), .in10(in20), .in11(in22), .in12(in24), .in13(in26), .out(OR1));
or2$ g_or_out(.in0(OR0), .in1(OR1), .out(out));

endmodule

`timescale 1ns/1ps
module or29$(output out,
input in0, 
input in1, 
input in2, 
input in3, 
input in4,
input in5,
input in6,
input in7,
input in8,
input in9,
input in10,
input in11,
input in12,
input in13,
input in14,
input in15,
input in16,
input in17,
input in18,
input in19,
input in20,
input in21,
input in22,
input in23,
input in24,
input in25,
input in26,
input in27,
input in28
);


wire OR0, OR1, OR_OUT;

or14$ g_or0(.in0(in0), .in1(in1), .in2(in2), .in3(in7), .in4(in9), .in5(in11), .in6(in13), .in7(in15), .in8(in17), .in9(in19), .in10(in21), .in11(in23), .in12(in25), .in13(in27), .out(OR0));
or15$ g_or1(.in0(in3), .in1(in4), .in2(in5), .in3(in6), .in4(in8), .in5(in10), .in6(in12), .in7(in14), .in8(in16), .in9(in18), .in10(in20), .in11(in22), .in12(in24), .in13(in26), .in14(in28), .out(OR1));
or2$ g_or_out(.in0(OR0), .in1(OR1), .out(out));

endmodule

`timescale 1ns/1ps
module or30$(output out,
input in0, 
input in1, 
input in2, 
input in3, 
input in4,
input in5,
input in6,
input in7,
input in8,
input in9,
input in10,
input in11,
input in12,
input in13,
input in14,
input in15,
input in16,
input in17,
input in18,
input in19,
input in20,
input in21,
input in22,
input in23,
input in24,
input in25,
input in26,
input in27,
input in28,
input in29
);


wire OR0, OR1, OR_OUT;

or15$ g_or0(.in0(in0), .in1(in1), .in2(in2), .in3(in7), .in4(in9), .in5(in11), .in6(in13), .in7(in15), .in8(in17), .in9(in19), .in10(in21), .in11(in23), .in12(in25), .in13(in27), .in14(in29), .out(OR0));
or15$ g_or1(.in0(in3), .in1(in4), .in2(in5), .in3(in6), .in4(in8), .in5(in10), .in6(in12), .in7(in14), .in8(in16), .in9(in18), .in10(in20), .in11(in22), .in12(in24), .in13(in26), .in14(in28), .out(OR1));
or2$ g_or_out(.in0(OR0), .in1(OR1), .out(out));

endmodule

`timescale 1ns/1ps
module or31$(output out,
input in0, 
input in1, 
input in2, 
input in3, 
input in4,
input in5,
input in6,
input in7,
input in8,
input in9,
input in10,
input in11,
input in12,
input in13,
input in14,
input in15,
input in16,
input in17,
input in18,
input in19,
input in20,
input in21,
input in22,
input in23,
input in24,
input in25,
input in26,
input in27,
input in28,
input in29,
input in30
);


wire OR0, OR1, OR_OUT;

or15$ g_or0(.in0(in0), .in1(in1), .in2(in2), .in3(in7), .in4(in9), .in5(in11), .in6(in13), .in7(in15), .in8(in17), .in9(in19), .in10(in21), .in11(in23), .in12(in25), .in13(in27), .in14(in29), .out(OR0));
or16$ g_or1(.in0(in3), .in1(in4), .in2(in5), .in3(in6), .in4(in8), .in5(in10), .in6(in12), .in7(in14), .in8(in16), .in9(in18), .in10(in20), .in11(in22), .in12(in24), .in13(in26), .in14(in28), .in15(in30), .out(OR1));
or2$ g_or_out(.in0(OR0), .in1(OR1), .out(out));

endmodule

`timescale 1ns/1ps
module or32$(output out,
input in0, 
input in1, 
input in2, 
input in3, 
input in4,
input in5,
input in6,
input in7,
input in8,
input in9,
input in10,
input in11,
input in12,
input in13,
input in14,
input in15,
input in16,
input in17,
input in18,
input in19,
input in20,
input in21,
input in22,
input in23,
input in24,
input in25,
input in26,
input in27,
input in28,
input in29,
input in30,
input in31
);


wire OR0, OR1, OR_OUT;

or16$ g_or0(.in0(in0), .in1(in1), .in2(in2), .in3(in7), .in4(in9), .in5(in11), .in6(in13), .in7(in15), .in8(in17), .in9(in19), .in10(in21), .in11(in23), .in12(in25), .in13(in27), .in14(in29), .in15(in31), .out(OR0));
or16$ g_or1(.in0(in3), .in1(in4), .in2(in5), .in3(in6), .in4(in8), .in5(in10), .in6(in12), .in7(in14), .in8(in16), .in9(in18), .in10(in20), .in11(in22), .in12(in24), .in13(in26), .in14(in28), .in15(in30), .out(OR1));
or2$ g_or_out(.in0(OR0), .in1(OR1), .out(out));

endmodule

`timescale 1ns/1ps
module or128$(output out,
input in0,
input in1,
input in2,
input in3,
input in4,
input in5,
input in6,
input in7,
input in8,
input in9,
input in10,
input in11,
input in12,
input in13,
input in14,
input in15,
input in16,
input in17,
input in18,
input in19,
input in20,
input in21,
input in22,
input in23,
input in24,
input in25,
input in26,
input in27,
input in28,
input in29,
input in30,
input in31,
input in32,
input in33,
input in34,
input in35,
input in36,
input in37,
input in38,
input in39,
input in40,
input in41,
input in42,
input in43,
input in44,
input in45,
input in46,
input in47,
input in48,
input in49,
input in50,
input in51,
input in52,
input in53,
input in54,
input in55,
input in56,
input in57,
input in58,
input in59,
input in60,
input in61,
input in62,
input in63,
input in64,
input in65,
input in66,
input in67,
input in68,
input in69,
input in70,
input in71,
input in72,
input in73,
input in74,
input in75,
input in76,
input in77,
input in78,
input in79,
input in80,
input in81,
input in82,
input in83,
input in84,
input in85,
input in86,
input in87,
input in88,
input in89,
input in90,
input in91,
input in92,
input in93,
input in94,
input in95,
input in96,
input in97,
input in98,
input in99,
input in100,
input in101,
input in102,
input in103,
input in104,
input in105,
input in106,
input in107,
input in108,
input in109,
input in110,
input in111,
input in112,
input in113,
input in114,
input in115,
input in116,
input in117,
input in118,
input in119,
input in120,
input in121,
input in122,
input in123,
input in124,
input in125,
input in126,
input in127);

wire or0, or1, or2, or3;

or32$ or_gate0(.out(or0), .in0(in0), .in1(in1), .in2(in2), .in3(in3), .in4(in4), .in5(in5), .in6(in6), .in7(in7), 
.in8(in8), .in9(in9), .in10(in10), .in11(in11), .in12(in12), .in13(in13), .in14(in14), .in15(in15), 
.in16(in16), .in17(in17), .in18(in18), .in19(in19), .in20(in20), .in21(in21), .in22(in22), .in23(in23), 
.in24(in24), .in25(in25), .in26(in26), .in27(in27), .in28(in28), .in29(in29), .in30(in30), .in31(in31));

or32$ or_gate1(.out(or1), .in0(in32), .in1(in33), .in2(in34), .in3(in35), .in4(in36), .in5(in37), .in6(in38), .in7(in39), 
.in8(in40), .in9(in41), .in10(in42), .in11(in43), .in12(in44), .in13(in45), .in14(in46), .in15(in47), 
.in16(in48), .in17(in49), .in18(in50), .in19(in51), .in20(in52), .in21(in53), .in22(in54), .in23(in55), 
.in24(in56), .in25(in57), .in26(in58), .in27(in59), .in28(in60), .in29(in61), .in30(in62), .in31(in63));

or32$ or_gate2(.out(or2), .in0(in64), .in1(in65), .in2(in66), .in3(in67), .in4(in68), .in5(in69), .in6(in70), .in7(in71), 
.in8(in72), .in9(in73), .in10(in74), .in11(in75), .in12(in76), .in13(in77), .in14(in78), .in15(in79), 
.in16(in80), .in17(in81), .in18(in82), .in19(in83), .in20(in84), .in21(in85), .in22(in86), .in23(in87), 
.in24(in88), .in25(in89), .in26(in90), .in27(in91), .in28(in92), .in29(in93), .in30(in94), .in31(in95));

or32$ or_gate3(.out(or3), .in0(in96), .in1(in97), .in2(in98), .in3(in99), .in4(in100), .in5(in101), .in6(in102), .in7(in103), 
.in8(in104), .in9(in105), .in10(in106), .in11(in107), .in12(in108), .in13(in109), .in14(in110), .in15(in111), 
.in16(in112), .in17(in113), .in18(in114), .in19(in115), .in20(in116), .in21(in117), .in22(in118), .in23(in119), 
.in24(in120), .in25(in121), .in26(in122), .in27(in123), .in28(in124), .in29(in125), .in30(in126), .in31(in127));

or4$ or128_out(.out(out), .in0(or0), .in1(or1), .in2(or2), .in3(or3));

endmodule