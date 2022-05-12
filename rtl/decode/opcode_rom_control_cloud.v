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
     input  modrm5,
     input  modrm4,
     input  modrm3,				 
     output rom_control_3, 
     output rom_control_2,
     output rom_control_1,
     output rom_control_0,
     output rom_in_control
);				    

wire modrm5_not;
wire modrm3_not;
wire and0;
wire sizeop_not;
wire op13_not;
wire op12_not;
wire op11_not;
wire op10_not;
wire and1;
wire op9_not;
wire op8_not;
wire and2;
wire or0;
wire and3;
wire and4;
wire op14_not;
wire and5;
wire sizeop_not;
wire and6;
wire or1;
wire and7;
wire and8;
wire and9;
wire and10;
wire or2;
wire and11;
wire and12;
wire and13;
wire op13_not;
wire and14;
wire and15;
wire or3;

inv1$ modrm5_inv (.out(modrm5_not), .in(modrm5));
inv1$ modrm3_inv (.out(modrm3_not), .in(modrm3));
inv1$ sizeop_inv (.out(sizeop_not), .in(sizeop));
inv1$ op13_inv (.out(op13_not), .in(op13));
inv1$ op12_inv (.out(op12_not), .in(op12));
inv1$ op11_inv (.out(op11_not), .in(op11));
inv1$ op10_inv (.out(op10_not), .in(op10));
inv1$ op9_inv (.out(op9_not), .in(op9));
inv1$ op8_inv (.out(op8_not), .in(op8));
inv1$ op14_inv (.out(op14_not), .in(op14));

and11$ and_gate0(.out(and0), .in0(modrm5_not), .in1(modrm4), .in2(modrm3_not), .in3(op15), .in4(op14), .in5(op13), .in6(op12), .in7(op11), .in8(op10), .in9(op9
), .in10(op8));
and9$ and_gate1(.out(and1), .in0(sizeop_not), .in1(op15), .in2(op14), .in3(op13_not), .in4(op12_not), .in5(op11_not), .in6(op10_not), .in7(op9), .in8(op8));
and8$ and_gate2(.out(and2), .in0(op15
), .in1(op14), .in2(op13), .in3(op12_not), .in4(op11), .in5(op10_not), .in6(op9_not), .in7(op8_not));
and7$ and_gate3(.out(and3), .in0(sizeop_not), .in1(op15), .in2(op14), .in3(op13_not), .in4(op12_not), .in5(op10_not), .in6(op9));
and11$ and_gate4(.out(and4), .in0(modrm5_not), .in1(modrm4), .in2(modrm3_not), .in3(op15), .in4(op14), .in5(op13), .in6(op12), .in7(op11), .in8(op10), .in9(op9
), .in10(op8));
and9$ and_gate5(.out(and5), .in0(sizeop_not), .in1(op15), .in2(op14_not), .in3(op13_not), .in4(op12), .in5(op11), .in6(op10_not), .in7(op9), .in8(op8_not));
and9$ and_gate6(.out(and6), .in0(sizeop_not), .in1(op15), .in2(op14), .in3(op13_not), .in4(op12_not), .in5(op11), .in6(op10), .in7(op9), .in8(op8));
and12$ and_gate7(.out(and7), .in0(sizeop_not), .in1(modrm5_not), .in2(modrm4), .in3(modrm3_not), .in4(op15), .in5(op14), .in6(op13), .in7(op12), .in8(op11
), .in9(op10), .in10(op9), .in11(op8));
and9$ and_gate8(.out(and8), .in0(sizeop_not), .in1(op15), .in2(op14), .in3(op13), .in4(op12_not), .in5(op11), .in6(op10_not), .in7(op9_not), .in8(op8_not));
and9$ and_gate9(.out(and9), .in0(sizeop_not), .in1(op15), .in2(op14_not), .in3(op13_not), .in4(op12), .in5(op11), .in6(op10_not), .in7(op9), .in8(op8_not));
and8$ and_gate10(.out(and10), .in0(sizeop_not), .in1(op15
), .in2(op14), .in3(op13_not), .in4(op12_not), .in5(op11), .in6(op10_not), .in7(op9));
and11$ and_gate11(.out(and11), .in0(modrm5_not), .in1(modrm4), .in2(modrm3_not), .in3(op15), .in4(op14), .in5(op13), .in6(op12), .in7(op11), .in8(op10
), .in9(op9), .in10(op8));
and9$ and_gate12(.out(and12), .in0(sizeop_not), .in1(op15), .in2(op14_not), .in3(op13_not), .in4(op12), .in5(op11), .in6(op10_not), .in7(op9), .in8(op8_not));
and8$ and_gate13(.out(and13), .in0(
op15), .in1(op14), .in2(op13), .in3(op12_not), .in4(op11), .in5(op10_not), .in6(op9_not), .in7(op8_not));
and9$ and_gate14(.out(and14), .in0(sizeop_not), .in1(op15), .in2(op14), .in3(op13_not), .in4(op12_not), .in5(op11), .in6(op10), .in7(op9), .in8(op8));
and7$ and_gate15(.out(and15), .in0(sizeop_not), .in1(op15), .in2(op14), .in3(op13_not), .in4(op12_not), .in5(op10_not), .in6(op9));

or3$ or_gate0(.out(or0), .in0(and0), .in1(and1), .in2(and2));
or3$ or_gate1(.out(or1), .in0(and4), .in1(and5), .in2(and6));
or4$ or_gate2(.out(or2), .in0(and7), .in1(and8), .in2(and9), .in3(and10));
or5$ or_gate3(.out(or3), .in0(and11), .in1(and12), .in2(and13), .in3(and14), .in4(and15));

assign rom_control_3 = or0;
assign rom_control_2 = and3;
assign rom_control_1 = or1;
assign rom_control_0 = or2;
assign rom_in_control = or3;


   
endmodule
