module prefix_map_cloud (
			 input i23,
			 input i22,
			 input i21,
			 input i20,
			 input i19,
			 input i18,
			 input i17,
			 input i16,
			 input i15,
			 input i14,
			 input i13,
			 input i12,
			 input i11,
			 input i10,
			 input i9,
			 input i8,
			 input i7,
			 input i6,
			 input i5,
			 input i4,
			 input i3,
			 input i2,
			 input i1,
			 input i0,
			 output s1,
			 output s0,
                         output size_prefix			 
);

wire i23_not;
wire i20_not;
wire i19_not;
wire i16_not;
wire i10_not;
wire i7_not;
wire i4_not;
wire i3_not;
wire i1_not;
wire and0;
wire i18_not;
wire i15_not;
wire i12_not;
wire i8_not;
wire and1;
wire i6_not;
wire i0_not;
wire and2;
wire and3;
wire i17_not;
wire and4;
wire i22_not;
wire and5;
wire i9_not;
wire and6;
wire i14_not;
wire and7;
wire and8;
wire and9;
wire and10;
wire and11;
wire or0;
wire and12;
wire and13;
wire and14;
wire and15;
wire or1;
wire i11_not;
wire i2_not;
wire and16;
wire and17;
wire and18;
wire and19;
wire and20;
wire and21;
wire and22;
wire and23;
wire and24;
wire and25;
wire and26;
wire or2;

inv1$ i23_inv (.out(i23_not), .in(i23));
inv1$ i20_inv (.out(i20_not), .in(i20));
inv1$ i19_inv (.out(i19_not), .in(i19));
inv1$ i16_inv (.out(i16_not), .in(i16));
inv1$ i10_inv (.out(i10_not), .in(i10));
inv1$ i7_inv (.out(i7_not), .in(i7));
inv1$ i4_inv (.out(i4_not), .in(i4));
inv1$ i3_inv (.out(i3_not), .in(i3));
inv1$ i1_inv (.out(i1_not), .in(i1));
inv1$ i18_inv (.out(i18_not), .in(i18));
inv1$ i15_inv (.out(i15_not), .in(i15));
inv1$ i12_inv (.out(i12_not), .in(i12));
inv1$ i8_inv (.out(i8_not), .in(i8));
inv1$ i6_inv (.out(i6_not), .in(i6));
inv1$ i0_inv (.out(i0_not), .in(i0));
inv1$ i17_inv (.out(i17_not), .in(i17));
inv1$ i22_inv (.out(i22_not), .in(i22));
inv1$ i9_inv (.out(i9_not), .in(i9));
inv1$ i14_inv (.out(i14_not), .in(i14));
inv1$ i11_inv (.out(i11_not), .in(i11));
inv1$ i2_inv (.out(i2_not), .in(i2));

and22$ and_gate0(.out(and0), .in0(i23_not), .in1(i21), .in2(i20_not), .in3(i19_not), .in4(i18), .in5(i17), .in6(i16_not), .in7(i15), .in8(i14), .in9(i13), .in10(i12), .in11(i11_not), .in12(i10_not), .in13(i9), .in14(i8), .in15(i7_not), .in16(i6), .in17(i5), .in18(i4_not), .in19(i3_not), .in20(i2), .in21(i1_not));
and23$ and_gate1(.out(and1), .in0(i23), .in1(i22), .in2(i21), .in3(i20), .in4(i19_not), .in5(i18_not), .in6(i17), .in7(i16), .in8(i15_not), .in9(i14), .in10(i13), .in11(i12_not), .in12(i11_not), .in13(i10), .in14(i9), .in15(i8_not), .in16(i7_not), .in17(i6), .in18(i5), .in19(i4_not), .in20(i3_not), .in21(i2), .in22(i1_not));
and21$ and_gate2(.out(and2), .in0(i23_not), .in1(i21), .in2(i20_not), .in3(i19_not), .in4(i18), .in5(i17), .in6(i16_not), .in7(i15), .in8(i14), .in9(i13), .in10(i12), .in11(i11_not), .in12(i10_not), .in13(i9), .in14(i8), .in15(i7_not), .in16(i6_not), .in17(i5), .in18(i2), .in19(i1), .in20(i0_not));
and22$ and_gate3(.out(and3), .in0(i23), .in1(i22), .in2(i21), .in3(i20), .in4(i19_not), .in5(i18_not), .in6(i17), .in7(i16), .in8(i15_not), .in9(i14), .in10(i13), .in11(i12_not), .in12(i11_not), .in13(i10), .in14(i9), .in15(i8_not), .in16(i7_not), .in17(i6_not), .in18(i5), .in19(i2), .in20(i1), .in21(i0_not));
and15$ and_gate4(.out(and4), .in0(i23_not), .in1(i22), .in2(i21), .in3(i20_not), .in4(i19_not), .in5(i18), .in6(i17_not), .in7(i15), .in8(i14), .in9(i13), .in10(i12), .in11(i11_not), .in12(i10_not), .in13(i9), .in14(i8));
and14$ and_gate5(.out(and5), .in0(i23_not), .in1(i22_not), .in2(i21), .in3(i18), .in4(i17), .in5(i16_not), .in6(i15), .in7(i14), .in8(i13), .in9(i12), .in10(i11_not), .in11(i10_not), .in12(i9), .in13(i8));
and15$ and_gate6(.out(and6), .in0(i23), .in1(i22), .in2(i21), .in3(i20), .in4(i19_not), .in5(i18_not), .in6(i17), .in7(i16), .in8(i15_not), .in9(i14), .in10(i13), .in11(i12_not), .in12(i11_not), .in13(i10), .in14(i9_not));
and14$ and_gate7(.out(and7), .in0(i23), .in1(i22), .in2(i21), .in3(i20), .in4(i19_not), .in5(i18_not), .in6(i17), .in7(i16), .in8(i15_not), .in9(i14_not), .in10(i13), .in11(i10), .in12(i9), .in13(i8_not));
and15$ and_gate8(.out(and8), .in0(i23_not), .in1(i22), .in2(i21), .in3(i20_not), .in4(i19_not), .in5(i18), .in6(i17), .in7(i16_not), .in8(i15_not), .in9(i14), .in10(i13), .in11(i12_not), .in12(i11_not), .in13(i10), .in14(i9_not));
and15$ and_gate9(.out(and9), .in0(i23_not), .in1(i22), .in2(i21), .in3(i20_not), .in4(i19_not), .in5(i18), .in6(i17_not), .in7(i15_not), .in8(i14), .in9(i13), .in10(i12_not), .in11(i11_not), .in12(i10), .in13(i9), .in14(i8_not));
and14$ and_gate10(.out(and10), .in0(i23_not), .in1(i22), .in2(i21), .in3(i20_not), .in4(i19_not), .in5(i18), .in6(i17), .in7(i16_not), .in8(i15_not), .in9(i14_not), .in10(i13), .in11(i10), .in12(i9), .in13(i8_not));
and14$ and_gate11(.out(and11), .in0(i23_not), .in1(i22_not), .in2(i21), .in3(i18), .in4(i17), .in5(i16_not), .in6(i15_not), .in7(i14), .in8(i13), .in9(i12_not), .in10(i11_not), .in11(i10), .in12(i9), .in13(i8_not));
and8$ and_gate12(.out(and12), .in0(i23), .in1(i22), .in2(i21), .in3(i20), .in4(i19_not), .in5(i18_not), .in6(i17), .in7(i16));
and7$ and_gate13(.out(and13), .in0(i23_not), .in1(i22), .in2(i21), .in3(i20_not), .in4(i19_not), .in5(i18), .in6(i17_not));
and6$ and_gate14(.out(and14), .in0(i23_not), .in1(i22_not), .in2(i21), .in3(i18), .in4(i17), .in5(i16_not));
and8$ and_gate15(.out(and15), .in0(i23_not), .in1(i22), .in2(i21), .in3(i20_not), .in4(i19_not), .in5(i18), .in6(i17), .in7(i16_not));
and23$ and_gate16(.out(and16), .in0(i23), .in1(i22), .in2(i21), .in3(i20), .in4(i19_not), .in5(i18_not), .in6(i17), .in7(i16), .in8(i15_not), .in9(i14), .in10(i13), .in11(i12_not), .in12(i11_not), .in13(i10), .in14(i9_not), .in15(i7), .in16(i6), .in17(i5), .in18(i4), .in19(i3_not), .in20(i2_not), .in21(i1), .in22(i0));
and23$ and_gate17(.out(and17), .in0(i23_not), .in1(i22), .in2(i21), .in3(i20_not), .in4(i19_not), .in5(i18), .in6(i17_not), .in7(i15), .in8(i14), .in9(i13), .in10(i12), .in11(i11_not), .in12(i10_not), .in13(i9), .in14(i8), .in15(i7_not), .in16(i6), .in17(i5), .in18(i4_not), .in19(i3_not), .in20(i2), .in21(i1), .in22(i0_not));
and22$ and_gate18(.out(and18), .in0(i23), .in1(i22), .in2(i21), .in3(i20), .in4(i19_not), .in5(i18_not), .in6(i17), .in7(i16), .in8(i15_not), .in9(i14_not), .in10(i13), .in11(i10), .in12(i9), .in13(i8_not), .in14(i7), .in15(i6), .in16(i5), .in17(i4), .in18(i3_not), .in19(i2_not), .in20(i1), .in21(i0));
and22$ and_gate19(.out(and19), .in0(i23_not), .in1(i22_not), .in2(i21), .in3(i18), .in4(i17), .in5(i16_not), .in6(i15), .in7(i14), .in8(i13), .in9(i12), .in10(i11_not), .in11(i10_not), .in12(i9), .in13(i8), .in14(i7_not), .in15(i6), .in16(i5), .in17(i4_not), .in18(i3_not), .in19(i2), .in20(i1), .in21(i0_not));
and23$ and_gate20(.out(and20), .in0(i23), .in1(i22), .in2(i21), .in3(i20), .in4(i19_not), .in5(i18_not), .in6(i17), .in7(i16), .in8(i15_not), .in9(i14), .in10(i13), .in11(i12_not), .in12(i11_not), .in13(i10), .in14(i9_not), .in15(i7_not), .in16(i6), .in17(i5), .in18(i4_not), .in19(i3_not), .in20(i2), .in21(i1), .in22(i0_not));
and22$ and_gate21(.out(and21), .in0(i23), .in1(i22), .in2(i21), .in3(i20), .in4(i19_not), .in5(i18_not), .in6(i17), .in7(i16), .in8(i15_not), .in9(i14_not), .in10(i13), .in11(i10), .in12(i9), .in13(i8_not), .in14(i7_not), .in15(i6), .in16(i5), .in17(i4_not), .in18(i3_not), .in19(i2), .in20(i1), .in21(i0_not));
and23$ and_gate22(.out(and22), .in0(i23), .in1(i22), .in2(i21), .in3(i20), .in4(i19_not), .in5(i18_not), .in6(i17), .in7(i16), .in8(i15_not), .in9(i14), .in10(i13), .in11(i12_not), .in12(i11_not), .in13(i10), .in14(i9), .in15(i8_not), .in16(i7_not), .in17(i6), .in18(i5), .in19(i4_not), .in20(i3_not), .in21(i2), .in22(i1_not));
and22$ and_gate23(.out(and23), .in0(i23), .in1(i22), .in2(i21), .in3(i20), .in4(i19_not), .in5(i18_not), .in6(i17), .in7(i16), .in8(i15_not), .in9(i14), .in10(i13), .in11(i12_not), .in12(i11_not), .in13(i10), .in14(i9), .in15(i8_not), .in16(i7_not), .in17(i6_not), .in18(i5), .in19(i2), .in20(i1), .in21(i0_not));
and15$ and_gate24(.out(and24), .in0(i23_not), .in1(i22), .in2(i21), .in3(i20_not), .in4(i19_not), .in5(i18), .in6(i17_not), .in7(i15_not), .in8(i14), .in9(i13), .in10(i12_not), .in11(i11_not), .in12(i10), .in13(i9), .in14(i8_not));
and14$ and_gate25(.out(and25), .in0(i23_not), .in1(i22_not), .in2(i21), .in3(i18), .in4(i17), .in5(i16_not), .in6(i15_not), .in7(i14), .in8(i13), .in9(i12_not), .in10(i11_not), .in11(i10), .in12(i9), .in13(i8_not));
and8$ and_gate26(.out(and26), .in0(i23_not), .in1(i22), .in2(i21), .in3(i20_not), .in4(i19_not), .in5(i18), .in6(i17), .in7(i16_not));

or12$ or_gate0(.out(or0), .in0(and0), .in1(and1), .in2(and2), .in3(and3), .in4(and4), .in5(and5), .in6(and6), .in7(and7), .in8(and8), .in9(and9), .in10(and10), .in11(and11));
or4$ or_gate1(.out(or1), .in0(and12), .in1(and13), .in2(and14), .in3(and15));
or11$ or_gate2(.out(or2), .in0(and16), .in1(and17), .in2(and18), .in3(and19), .in4(and20), .in5(and21), .in6(and22), .in7(and23), .in8(and24), .in9(and25), .in10(and26));

assign s1 = or0;
assign s0 = or1;
assign size_prefix = or2;
   

endmodule
