module opcode_rom_control_cloud (
     input op15,
     input op14,
     input op13,
     input op12,
     input op11,
     input op10,
     input op9,
     input op8,
     input op7,
     input op6,
     input op5,
     input op4,
     input op3,
     input op2,
     input op1,
     input op0,
     output rom_control_2,
     output rom_control_1,
     output rom_control_0,
     output rom_in_control
);				    

wire op14_not;
wire op12_not;
wire op11_not;
wire op9_not;
wire and0;
wire op13_not;
wire op10_not;
wire op8_not;
wire and1;
wire and2;
wire or0;
wire op15_not;
wire op6_not;
wire op4_not;
wire op2_not;
wire op1_not;
wire op0_not;
wire and3;
wire and4;
wire and5;
wire or1;
wire and6;
wire and7;
wire op15_not;
wire and8;
wire op12_not;
wire and9;
wire and10;
wire or2;
wire and11;
wire and12;
wire and13;
wire and14;
wire and15;
wire and16;
wire or3;

inv1$ op14_inv (.out(op14_not), .in(op14));
inv1$ op12_inv (.out(op12_not), .in(op12));
inv1$ op11_inv (.out(op11_not), .in(op11));
inv1$ op9_inv (.out(op9_not), .in(op9));
inv1$ op13_inv (.out(op13_not), .in(op13));
inv1$ op10_inv (.out(op10_not), .in(op10));
inv1$ op8_inv (.out(op8_not), .in(op8));
inv1$ op6_inv (.out(op6_not), .in(op6));
inv1$ op4_inv (.out(op4_not), .in(op4));
inv1$ op2_inv (.out(op2_not), .in(op2));
inv1$ op1_inv (.out(op1_not), .in(op1));
inv1$ op0_inv (.out(op0_not), .in(op0));
inv1$ op15_inv (.out(op15_not), .in(op15));

and8$ and_gate0(.out(and0), .in0(op15), .in1(op14_not), .in2(op13), .in3(op12_not), .in4(op11_not), .in5(op10), .in6(op9_not), .in7(op8));
and8$ and_gate1(.out(and1), .in0(op15), .in1(op14
), .in2(op13_not), .in3(op12_not), .in4(op11_not), .in5(op10_not), .in6(op9), .in7(op8_not));
and7$ and_gate2(.out(and2), .in0(op15), .in1(op14), .in2(op13_not), .in3(op12_not), .in4(op10_not), .in5(op9
), .in6(op8));
and16$ and_gate3(.out(and3), .in0(op15_not), .in1(op14_not), .in2(op13_not), .in3(op12_not), .in4(op11), .in5(op10), .in6(op9), .in7(op8), .in8(op7), .in9(op6_not), .in10(op5
), .in11(op4_not), .in12(op3), .in13(op2_not), .in14(op1_not), .in15(op0_not));
and8$ and_gate4(.out(and4), .in0(op15), .in1(op14), .in2(op13), .in3(op12), .in4(op11_not), .in5(op10), .in6(op9_not), .in7(op8_not));
and7$ and_gate5(.out(and5), .in0(
op15), .in1(op14_not), .in2(op13), .in3(op12_not), .in4(op11_not), .in5(op10), .in6(op9_not));
and16$ and_gate6(.out(and6), .in0(op15_not), .in1(op14_not), .in2(op13_not), .in3(op12_not), .in4(op11), .in5(op10), .in6(op9), .in7(op8), .in8(op7), .in9(op6_not), .in10(op5
), .in11(op4_not), .in12(op3), .in13(op2_not), .in14(op1_not), .in15(op0_not));
and8$ and_gate7(.out(and7), .in0(op15), .in1(op14), .in2(op13_not), .in3(op12_not), .in4(op11), .in5(op10_not), .in6(op9), .in7(op8));
and8$ and_gate8(.out(and8), .in0(op15_not), .in1(op14_not), .in2(op13), .in3(op12_not), .in4(op11_not), .in5(op10), .in6(op9), .in7(op8));
and8$ and_gate9(.out(and9), .in0(op15), .in1(op14), .in2(op13_not), .in3(op12_not), .in4(op11_not), .in5(op10_not), .in6(op9), .in7(op8_not));
and7$ and_gate10(.out(and10), .in0(op15), .in1(op14_not), .in2(op13), .in3(op12_not), .in4(op11_not), .in5(op10), .in6(op9_not));
and16$ and_gate11(.out(and11), .in0(op15_not), .in1(op14_not), .in2(op13_not), .in3(op12_not), .in4(op11), .in5(op10), .in6(op9), .in7(op8), .in8(op7), .in9(op6_not), .in10(op5
), .in11(op4_not), .in12(op3), .in13(op2_not), .in14(op1_not), .in15(op0_not));
and8$ and_gate12(.out(and12), .in0(op15), .in1(op14), .in2(op13), .in3(op12), .in4(op11_not), .in5(op10), .in6(op9_not), .in7(op8_not));
and8$ and_gate13(.out(and13), .in0(op15_not), .in1(op14_not), .in2(op13), .in3(op12_not), .in4(op11_not), .in5(op10), .in6(op9), .in7(op8));
and8$ and_gate14(.out(and14), .in0(op15), .in1(op14), .in2(op13_not), .in3(op12_not), .in4(op11_not), .in5(op10_not), .in6(op9), .in7(op8_not));
and7$ and_gate15(.out(and15), .in0(op15), .in1(op14), .in2(op13_not), .in3(op12_not), .in4(op10_not), .in5(op9), .in6(op8));
and7$ and_gate16(.out(and16), .in0(
op15), .in1(op14_not), .in2(op13), .in3(op12_not), .in4(op11_not), .in5(op10), .in6(op9_not));

or3$ or_gate0(.out(or0), .in0(and0), .in1(and1), .in2(and2));
or3$ or_gate1(.out(or1), .in0(and3), .in1(and4), .in2(and5));
or5$ or_gate2(.out(or2), .in0(and6), .in1(and7), .in2(and8), .in3(and9), .in4(and10));
or6$ or_gate3(.out(or3), .in0(and11), .in1(and12), .in2(and13), .in3(and14), .in4(and15), .in5(and16));

assign rom_control_2 = or0;
assign rom_control_1 = or1;
assign rom_control_0 = or2;
assign rom_in_control = or3;

endmodule
