module opcode_rom_control_cloud (
     input  sizeop,
     input  op15,
     input  op14,
     input  op13,
     input  op12,
     input  op11,
     input  op10,
     input  op9,
     input  op8,
     input  op7,
     input  op6,
     input  op5,
     input  op4,
     input  op3,
     input  op2,
     input  op1,
     input  op0,
     output rom_control_3, 
     output rom_control_2,
     output rom_control_1,
     output rom_control_0,
     output rom_in_control
);				    


wire op12_not;
wire op10_not;
wire op9_not;
wire op8_not;
wire and0;
wire and1;
wire or0;
wire sizeop_not;
wire op13_not;
wire and2;
wire op14_not;
wire and3;
wire sizeop_not;
wire and4;
wire and5;
wire or1;
wire and6;
wire and7;
wire op14_not;
wire and8;
wire op12_not;
wire and9;
wire or2;
wire and10;
wire and11;
wire op13_not;
wire and12;
wire and13;
wire and14;
wire or3;

inv1$ op12_inv (.out(op12_not), .in(op12));
inv1$ op10_inv (.out(op10_not), .in(op10));
inv1$ op9_inv (.out(op9_not), .in(op9));
inv1$ op8_inv (.out(op8_not), .in(op8));
inv1$ sizeop_inv (.out(sizeop_not), .in(sizeop));
inv1$ op13_inv (.out(op13_not), .in(op13));
inv1$ op14_inv (.out(op14_not), .in(op14));

and8$ and_gate0(.out(and0), .in0(op15), .in1(op14), .in2(op13), .in3(op12_not), .in4(op11), .in5(op10_not), .in6(op9_not), .in7(op8_not));
and8$ and_gate1(.out(and1), .in0(op15), .in1(op14
), .in2(op13), .in3(op12), .in4(op11), .in5(op10), .in6(op9), .in7(op8));
and7$ and_gate2(.out(and2), .in0(sizeop_not), .in1(op15), .in2(op14), .in3(op13_not), .in4(op12_not), .in5(op10_not), .in6(op9));
and9$ and_gate3(.out(and3), .in0(sizeop_not), .in1(op15), .in2(op14_not), .in3(op13_not), .in4(op12), .in5(op11), .in6(op10_not), .in7(op9), .in8(op8_not));
and9$ and_gate4(.out(and4), .in0(sizeop_not), .in1(op15), .in2(op14), .in3(op13_not), .in4(op12_not), .in5(op11), .in6(op10), .in7(op9), .in8(op8));
and8$ and_gate5(.out(and5), .in0(op15), .in1(op14), .in2(op13
), .in3(op12), .in4(op11), .in5(op10), .in6(op9), .in7(op8));
and9$ and_gate6(.out(and6), .in0(sizeop_not), .in1(op15), .in2(op14), .in3(op13), .in4(op12_not), .in5(op11), .in6(op10_not), .in7(op9_not), .in8(op8_not));
and9$ and_gate7(.out(and7), .in0(sizeop_not), .in1(op15), .in2(op14), .in3(op13), .in4(op12), .in5(op11), .in6(op10), .in7(op9), .in8(op8));
and9$ and_gate8(.out(and8), .in0(sizeop_not), .in1(op15), .in2(op14_not), .in3(op13_not), .in4(op12), .in5(op11), .in6(op10_not), .in7(op9), .in8(op8_not));
and8$ and_gate9(.out(and9), .in0(sizeop_not), .in1(op15), .in2(op14), .in3(op13_not), .in4(op12_not), .in5(op11), .in6(op10_not), .in7(op9));
and9$ and_gate10(.out(and10), .in0(sizeop_not), .in1(op15), .in2(op14_not), .in3(op13_not), .in4(op12), .in5(op11), .in6(op10_not), .in7(op9), .in8(op8_not));
and8$ and_gate11(.out(and11), .in0(
op15), .in1(op14), .in2(op13), .in3(op12_not), .in4(op11), .in5(op10_not), .in6(op9_not), .in7(op8_not));
and9$ and_gate12(.out(and12), .in0(sizeop_not), .in1(op15), .in2(op14), .in3(op13_not), .in4(op12_not), .in5(op11), .in6(op10), .in7(op9), .in8(op8));
and8$ and_gate13(.out(and13), .in0(op15), .in1(op14), .in2(op13), .in3(op12), .in4(op11), .in5(op10), .in6(op9), .in7(op8));
and7$ and_gate14(.out(and14), .in0(sizeop_not), .in1(op15), .in2(op14), .in3(op13_not), .in4(op12_not), .in5(op10_not), .in6(op9));

or2$ or_gate0(.out(or0), .in0(and0), .in1(and1));
or3$ or_gate1(.out(or1), .in0(and3), .in1(and4), .in2(and5));
or4$ or_gate2(.out(or2), .in0(and6), .in1(and7), .in2(and8), .in3(and9));
or5$ or_gate3(.out(or3), .in0(and10), .in1(and11), .in2(and12), .in3(and13), .in4(and14));

assign rom_control_3 = or0;
assign rom_control_2 = and2;
assign rom_control_1 = or1;
assign rom_control_0 = or2;
assign rom_in_control = or3;

endmodule
