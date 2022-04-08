module prefix_map_cloud (
			 input i0,
			 input i1,
			 input i2,
			 input i3,
			 input i4,
			 input i5,
			 input i6,
			 input i7,
			 input i8,
			 input i9,
			 input i10,
			 input i11,
			 input i12,
			 input i13,
			 input i14,
			 input i15,
			 input i16,
			 input i17,
			 input i18,
			 input i19,
			 input i20,
			 input i21,
			 input i22,
			 input i23,
			 output s0,
			 output s1			 
);
   

wire i4_not;
wire i5_not;
wire i8_not;
wire i11_not;
wire i12_not;
wire i15_not;
wire i16_not;
wire i19_not;
wire i20_not;
wire i22_not;
wire and0;
wire i0_not;
wire i3_not;
wire i7_not;
wire i13_not;
wire and1;
wire i4_not;
wire i17_not;
wire i23_not;
wire and2;
wire i0_not;
wire i17_not;
wire and3;
wire i12_not;
wire i14_not;
wire and4;
wire i6_not;
wire and5;
wire i9_not;
wire and6;
wire i0_not;
wire i1_not;
wire and7;
wire i3_not;
wire and8;
wire and9;
wire i8_not;
wire and10;
wire i9_not;
wire and11;
wire or0;
wire and12;
wire and13;
wire i1_not;
wire and14;
wire and15;
wire or1;

inv1$ i4_inv (.out(i4_not), .in(i4));
inv1$ i5_inv (.out(i5_not), .in(i5));
inv1$ i8_inv (.out(i8_not), .in(i8));
inv1$ i11_inv (.out(i11_not), .in(i11));
inv1$ i12_inv (.out(i12_not), .in(i12));
inv1$ i15_inv (.out(i15_not), .in(i15));
inv1$ i16_inv (.out(i16_not), .in(i16));
inv1$ i19_inv (.out(i19_not), .in(i19));
inv1$ i20_inv (.out(i20_not), .in(i20));
inv1$ i22_inv (.out(i22_not), .in(i22));
inv1$ i0_inv (.out(i0_not), .in(i0));
inv1$ i3_inv (.out(i3_not), .in(i3));
inv1$ i7_inv (.out(i7_not), .in(i7));
inv1$ i13_inv (.out(i13_not), .in(i13));
inv1$ i4_inv (.out(i4_not), .in(i4));
inv1$ i17_inv (.out(i17_not), .in(i17));
inv1$ i23_inv (.out(i23_not), .in(i23));
inv1$i0_inv (.out(i0_not), .in(i0));
inv1$ i17_inv (.out(i17_not), .in(i17));
inv1$ i12_inv (.out(i12_not), .in(i12));
inv1$ i14_inv (.out(i14_not), .in(i14));
inv1$ i6_inv (.out(i6_not), .in(i6));
inv1$ i9_inv (.out(i9_not), .in(i9));
inv1$ i0_inv (.out(i0_not), .in(i0));
inv1$ i1_inv (.out(i1_not), .in(i1));
inv1$ i3_inv (.out(i3_not), .in(i3));
inv1$ i8_inv (.out(i8_not), .in(i8));
inv1$ i9_inv (.out(i9_not), .in(i9));
inv1$ i1_inv (.out(i1_not), .in(i1));

and22$ and_gate0(.out(and0), .in0(i0), .in1(i1), .in2(i2), .in3(i3), .in4(i4_not), .in5(i5_not), .in6(i6), .in7(i7), .in8(i8_not), .in9(i10), .in10(i11_not), .in11(i12_not), .in12(i13), .in13(i14), .in14(i15_not), .in15(i16_not), .in16(i17), .in17(i18), .in18(i19_not), .in19(i20_not), .in20(i21), .in21(i22_not));
and22$ and_gate1(.out(and1), .in0(i0_not), .in1(i2), .in2(i3_not), .in3(i4_not), .in4(i5), .in5(i6), .in6(i7_not), .in7(i8), .in8(i9), .in9(i10), .in10(i11), .in11(i12_not), .in12(i13_not), .in13(i14), .in14(i15), .in15(i16_not), .in16(i17), .in17(i18), .in18(i19_not), .in19(i20_not), .in20(i21), .in21(i22_not));
and21$ and_gate2(.out(and2), .in0(i0), .in1(i1), .in2(i2), .in3(i3), .in4(i4_not), .in5(i5_not), .in6(i6), .in7(i7), .in8(i8_not), .in9(i10), .in10(i11_not), .in11(i12_not), .in12(i13), .in13(i14), .in14(i15_not), .in15(i16_not), .in16(i17_not), .in17(i18), .in18(i21), .in19(i22), .in20(i23_not));
and21$ and_gate3(.out(and3), .in0(i0_not), .in1(i2), .in2(i3_not), .in3(i4_not), .in4(i5), .in5(i6), .in6(i7_not), .in7(i8), .in8(i9), .in9(i10), .in10(i11), .in11(i12_not), .in12(i13_not), .in13(i14), .in14(i15), .in15(i16_not), .in16(i17
_not), .in17(i18), .in18(i21), .in19(i22), .in20(i23_not));
and15$ and_gate4(.out(and4), .in0(i0), .in1(i1), .in2(i2), .in3(i3), .in4(i4_not), .in5(i5_not), .in6(i6), .in7(i7), .in8(i8_not), .in9(i9), .in10(i10), .in11(i11_not), .in12(i12_not), .in13(i13), .in14(i14_not));
and15$ and_gate5(.out(and5), .in0(i0_not), .in1(i1), .in2(i2), .in3(i3_not), .in4(i4_not), .in5(i5), .in6(i6_not), .in7(i8), .in8(i9), .in9(i10), .in10(i11), .in11(i12_not), .in12(i13_not), .in13(i14), .in14(i15));
and14$ and_gate6(.out(and6), .in0(i0), .in1(i1), .in2(i2), .in3(i3), .in4(i4_not), .in5(i5_not), .in6(i6), .in7(i7), .in8(i8_not), .in9(i9_not), .in10(i10), .in11(i13), .in12(i14), .in13(i15_not));
and14$ and_gate7(.out(and7), .in0(i0_not), .in1(i1_not), .in2(i2), .in3(i5), .in4(i6), .in5(i7_not), .in6(i8), .in7(i9), .in8(i10), .in9(i11), .in10(i12_not), .in11(i13_not), .in12(i14), .in13(i15));
and15$ and_gate8(.out(and8), .in0(i0_not), .in1(i1), .in2(i2), .in3(i3_not), .in4(i4_not), .in5(i5), .in6(i6_not), .in7(i8_not), .in8(i9), .in9(i10), .in10(i11_not), .in11(i12_not), .in12(i13), .in13(i14), .in14(i15_not));
and15$ and_gate9(.out(and9), .in0(i0_not), .in1(i1), .in2(i2), .in3(i3_not), .in4(i4_not), .in5(i5), .in6(i6), .in7(i7_not), .in8(i8_not), .in9(i9), .in10(i10), .in11(i11_not), .in12(i12_not), .in13(i13), .in14(i14_not));
and14$ and_gate10(.out(and10), .in0(i0_not), .in1(i1_not), .in2(i2), .in3(i5), .in4(i6), .in5(i7_not), .in6(i8_not), .in7(i9), .in8(i10), .in9(i11_not), .in10(i12_not), .in11(i13), .in12(i14), .in13(i15_not));
and14$ and_gate11(.out(and11), .in0(i0_not), .in1(i1), .in2(i2), .in3(i3_not), .in4(i4_not), .in5(i5), .in6(i6), .in7(i7_not), .in8(i8_not), .in9(i9_not), .in10(i10), .in11(i13), .in12(i14), .in13(i15_not));
and8$ and_gate12(.out(and12), .in0(i0), .in1(i1), .in2(i2), .in3(i3), .in4(i4_not), .in5(i5_not), .in6(i6), .in7(i7));
and7$ and_gate13(.out(and13), .in0(i0_not), .in1(i1), .in2(i2), .in3(i3_not), .in4(i4_not), .in5(i5), .in6(i6_not));
and6$ and_gate14(.out(and14), .in0(i0_not), .in1(i1_not), .in2(i2), .in3(i5), .in4(i6), .in5(i7_not));
and7$ and_gate15(.out(and15), .in0(i0_not), .in1(i2), .in2(i3_not), .in3(i4_not), .in4(i5), .in5(i6), .in6(i7_not));

or12$ or_gate0(.out(or0), .in0(and0), .in1(and1), .in2(and2), .in3(and3), .in4(and4), .in5(and5), .in6(and6), .in7(and7), .in8(and8), .in9(and9), .in10(and10), .in11(and11));
or4$ or_gate1(.out(or1), .in0(and12), .in1(and13), .in2(and14), .in3(and15));

assign  s0 = or0;
assign s1 = or1;

endmodule
