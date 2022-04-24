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

wire op13_not;
wire op12_not;
wire op10_not;
wire and0;
wire and1;
wire op14_not;
wire op11_not;
wire op9_not;
wire and2;
wire or0;
wire op8_not;
wire and3;
wire and4;
wire op14_not;
wire and5;
wire or1;
wire and6;
wire and7;
wire and8;
wire and9;
wire or2;

inv1$ op13_inv (.out(op13_not), .in(op13));
inv1$ op12_inv (.out(op12_not), .in(op12));
inv1$ op10_inv (.out(op10_not), .in(op10));
inv1$ op14_inv (.out(op14_not), .in(op14));
inv1$ op11_inv (.out(op11_not), .in(op11));
inv1$ op9_inv (.out(op9_not), .in(op9));
inv1$ op8_inv (.out(op8_not), .in(op8));

and6$ and_gate0(.out(and0), .in0(op15), .in1(op14), .in2(op13_not), .in3(op12_not), .in4(op10_not), .in5(op9));
and8$ and_gate1(.out(and1), .in0(op15), .in1(op14), .in2(op13_not), .in3(op12_not), .in4(op11), .in5(op10), .in6(op9), .in7(op8));
and7$ and_gate2(.out(and2), .in0(op15), .in1(op14_not), .in2(op13), .in3(op12_not), .in4(op11_not), .in5(op10), .in6(op9_not));
and8$ and_gate3(.out(and3), .in0(op15), .in1(op14), .in2(op13), .in3(op12), .in4(op11_not), .in5(op10), .in6(op9_not), .in7(op8_not));
and7$ and_gate4(.out(and4), .in0(op15), .in1(op14
), .in2(op13_not), .in3(op12_not), .in4(op10_not), .in5(op9), .in6(op8_not));
and7$ and_gate5(.out(and5), .in0(op15), .in1(op14_not), .in2(op13), .in3(op12_not), .in4(op11_not), .in5(op10), .in6(op9_not));
and8$ and_gate6(.out(and6), .in0(op15), .in1(op14), .in2(op13), .in3(op12), .in4(op11_not), .in5(op10), .in6(op9_not), .in7(op8_not));
and8$ and_gate7(.out(and7), .in0(op15), .in1(op14
), .in2(op13_not), .in3(op12_not), .in4(op11), .in5(op10), .in6(op9), .in7(op8));
and7$ and_gate8(.out(and8), .in0(op15), .in1(op14_not), .in2(op13), .in3(op12_not), .in4(op11_not), .in5(op10
), .in6(op9_not));
and6$ and_gate9(.out(and9), .in0(op15), .in1(op14), .in2(op13_not), .in3(op12_not), .in4(op10_not), .in5(op9));

or2$ or_gate0(.out(or0), .in0(and1), .in1(and2));
or3$ or_gate1(.out(or1), .in0(and3), .in1(and4), .in2(and5));
or4$ or_gate2(.out(or2), .in0(and6), .in1(and7), .in2(and8), .in3(and9));

assign rom_control_2 = and0;
assign rom_control_1 = or0;
assign rom_control_0 = or1;
assign rom_in_control = or2;

endmodule
