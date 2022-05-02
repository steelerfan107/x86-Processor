module opcode_size_map_cloud (
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
        output opsize,
        output modrm, 
        output imm1,
        output imm0,
        output f16		      
);

wire i0_not;
wire i1_not;
wire i2_not;
wire i3_not;
wire i8_not;
wire i10_not;
wire i11_not;
wire i12_not;
wire i13_not;
wire i15_not;
wire and0;
wire i0_not;
wire i9_not;
wire i14_not;
wire and1;
wire i0_not;
wire and2;
wire i1_not;
wire and3;
wire i3_not;
wire and4;
wire and5;
wire and6;
wire and7;
wire i13_not;
wire and8;
wire or0;
wire and9;
wire and10;
wire and11;
wire and12;
wire and13;
wire and14;
wire and15;
wire i4_not;
wire and16;
wire and17;
wire i5_not;
wire i6_not;
wire and18;
wire i7_not;
wire and19;
wire and20;
wire and21;
wire and22;
wire and23;
wire i2_not;
wire and24;
wire and25;
wire and26;
wire and27;
wire and28;
wire and29;
wire or1;
wire and30;
wire and31;
wire and32;
wire and33;
wire and34;
wire i5_not;
wire and35;
wire and36;
wire i6_not;
wire and37;
wire and38;
wire and39;
wire and40;
wire and41;
wire or2;
wire and42;
wire and43;
wire and44;
wire and45;
wire and46;
wire and47;
wire and48;
wire and49;
wire and50;
wire and51;
wire and52;
wire or3;
wire and53;

inv1$ i0_inv (.out(i0_not), .in(i0));
inv1$ i1_inv (.out(i1_not), .in(i1));
inv1$ i2_inv (.out(i2_not), .in(i2));
inv1$ i3_inv (.out(i3_not), .in(i3));
inv1$ i8_inv (.out(i8_not), .in(i8));
inv1$ i10_inv (.out(i10_not), .in(i10));
inv1$ i11_inv (.out(i11_not), .in(i11));
inv1$ i12_inv (.out(i12_not), .in(i12));
inv1$ i13_inv (.out(i13_not), .in(i13));
inv1$ i15_inv (.out(i15_not), .in(i15));
inv1$ i9_inv (.out(i9_not), .in(i9));
inv1$ i14_inv (.out(i14_not), .in(i14));
inv1$ i4_inv (.out(i4_not), .in(i4));
inv1$ i5_inv (.out(i5_not), .in(i5));
inv1$ i6_inv (.out(i6_not), .in(i6));
inv1$ i7_inv (.out(i7_not), .in(i7));

and16$ and_gate0(.out(and0), .in0(i0_not), .in1(i1_not), .in2(i2_not), .in3(i3_not), .in4(i4), .in5(i5), .in6(i6), .in7(i7), .in8(i8_not), .in9(i9), .in10(i10_not), .in11(i11_not), .in12(i12_not), .in13(i13_not), .in14(i14), .in15(i15_not));
and16$ and_gate1(.out(and1), .in0(i0_not), .in1(i1_not), .in2(i2_not), .in3(i3_not), .in4(i4), .in5(i5), .in6(i6), .in7(i7), .in8(i8), .in9(i9_not), .in10(i10), .in11(i11), .in12(i12), .in13(i13), .in14(i14_not), .in15(i15_not));
and16$ and_gate2(.out(and2), .in0(i0_not), .in1(i1_not), .in2(i2_not), .in3(i3_not), .in4(i4), .in5(i5), .in6(i6), .in7(i7), .in8(i8), .in9(i9), .in10(i10), .in11(i11), .in12(i12), .in13(i13), .in14(i14_not), .in15(i15));
and15$ and_gate3(.out(and3), .in0(i0_not), .in1(i1_not), .in2(i2_not), .in3(i3_not), .in4(i4), .in5(i5), .in6(i6), .in7(i7), .in8(i8), .in9(i9_not), .in10(i10_not), .in11(i11_not), .in12(i12_not), .in13(i13), .in14(i15));
and15$ and_gate4(.out(and4), .in0(i0_not), .in1(i1_not), .in2(i2_not), .in3(i3_not), .in4(i4), .in5(i5), .in6(i6), .in7(i7), .in8(i8_not), .in9(i9), .in10(i10), .in11(i12), .in12(i13), .in13(i14), .in14(i15));
and15$ and_gate5(.out(and5), .in0(i0_not), .in1(i1_not), .in2(i2_not), .in3(i3_not), .in4(i4), .in5(i5), .in6(i6
), .in7(i7), .in8(i8), .in9(i9_not), .in10(i10), .in11(i11), .in12(i12_not), .in13(i13_not), .in14(i14_not));
and15$ and_gate6(.out(and6), .in0(i0_not), .in1(i1_not), .in2(i2_not), .in3(i3_not), .in4(i4), .in5(i5), .in6(i6), .in7(i7), .in8(i8
), .in9(i9), .in10(i10), .in11(i11_not), .in12(i12), .in13(i14), .in14(i15_not));
and15$ and_gate7(.out(and7), .in0(i0_not), .in1(i1_not), .in2(i2_not), .in3(i3_not), .in4(i4), .in5(i5), .in6(i6), .in7(i7), .in8(i8), .in9(i9), .in10(i10
), .in11(i12), .in12(i13), .in13(i14), .in14(i15_not));
and14$ and_gate8(.out(and8), .in0(i0_not), .in1(i1_not), .in2(i2_not), .in3(i3_not), .in4(i4), .in5(i5), .in6(i6), .in7(i7), .in8(i8), .in9(i9_not), .in10(i10), .in11(i11_not), .in12(i13_not), .in13(i14_not));
and16$ and_gate9(.out(and9), .in0(i0_not), .in1(i1_not), .in2(i2_not), .in3(i3_not), .in4(i4), .in5(i5), .in6(i6), .in7(i7), .in8(i8_not), .in9(i9), .in10(i10_not), .in11(i11_not), .in12(i12_not), .in13(i13_not), .in14(i14), .in15(i15_not));
and16$ and_gate10(.out(and10), .in0(i0_not), .in1(i1_not), .in2(i2_not), .in3(i3_not), .in4(i4), .in5(i5), .in6(i6), .in7(i7), .in8(i8), .in9(i9_not), .in10(i10), .in11(i11), .in12(i12), .in13(i13), .in14(i14_not), .in15(i15_not));
and16$ and_gate11(.out(and11), .in0(i0_not), .in1(i1_not), .in2(i2_not), .in3(i3_not), .in4(i4), .in5(i5), .in6(i6), .in7(i7), .in8(i8), .in9(i9), .in10(i10), .in11(i11), .in12(i12), .in13(i13), .in14(i14_not), .in15(i15));
and15$ and_gate12(.out(and12), .in0(i0_not), .in1(i1_not), .in2(i2_not), .in3(i3_not), .in4(i4), .in5(i5), .in6(i6), .in7(i7), .in8(i8_not), .in9(i9), .in10(i10), .in11(i12), .in12(i13), .in13(i14), .in14(i15));
and15$ and_gate13(.out(and13), .in0(i0_not), .in1(i1_not), .in2(i2_not), .in3(i3_not), .in4(i4), .in5(i5), .in6(i6), .in7(i7), .in8(i8), .in9(i9_not), .in10(i10), .in11(i11), .in12(i12_not), .in13(i13_not), .in14(i14_not));
and15$ and_gate14(.out(and14), .in0(i0_not), .in1(i1_not), .in2(i2_not), .in3(i3_not), .in4(i4), .in5(i5
), .in6(i6), .in7(i7), .in8(i8), .in9(i9), .in10(i10), .in11(i11_not), .in12(i12), .in13(i14), .in14(i15_not));
and15$ and_gate15(.out(and15), .in0(i0_not), .in1(i1_not), .in2(i2_not), .in3(i3_not), .in4(i4), .in5(i5), .in6(i6), .in7(i7), .in8(i8
), .in9(i9), .in10(i10), .in11(i12), .in12(i13), .in13(i14), .in14(i15_not));
and7$ and_gate16(.out(and16), .in0(i0), .in1(i1), .in2(i2), .in3(i3), .in4(i4_not), .in5(i5), .in6(i6));
and7$ and_gate17(.out(and17), .in0(i0), .in1(i1), .in2(i2), .in3(i3), .in4(i4
), .in5(i5), .in6(i7));
and8$ and_gate18(.out(and18), .in0(i0), .in1(i1_not), .in2(i2_not), .in3(i3_not), .in4(i4_not), .in5(i5_not), .in6(i6_not), .in7(i7));
and8$ and_gate19(.out(and19), .in0(i0), .in1(i1), .in2(i2_not), .in3(i3_not), .in4(i4_not), .in5(i5), .in6(i6
), .in7(i7_not));
and7$ and_gate20(.out(and20), .in0(i0), .in1(i2_not), .in2(i3_not), .in3(i4_not), .in4(i5_not), .in5(i6_not), .in6(i7_not));
and8$ and_gate21(.out(and21), .in0(i0), .in1(i1), .in2(i2_not), .in3(i3_not), .in4(i4_not), .in5(i5), .in6(i6), .in7(i7));
and8$ and_gate22(.out(and22), .in0(
i0), .in1(i1_not), .in2(i2_not), .in3(i3_not), .in4(i4_not), .in5(i5_not), .in6(i6), .in7(i7));
and7$ and_gate23(.out(and23), .in0(i0), .in1(i1), .in2(i2_not), .in3(i3_not), .in4(i4_not), .in5(i5_not), .in6(i6_not));
and5$ and_gate24(.out(and24), .in0(i1), .in1(i2_not), .in2(i3), .in3(i4_not), .in4(i5_not));
and5$ and_gate25(.out(and25), .in0(i0_not), .in1(i1), .in2(i2_not), .in3(i3), .in4(i4_not));
and6$ and_gate26(.out(and26), .in0(i0), .in1(i1_not), .in2(i2_not), .in3(i3_not), .in4(i4), .in5(i7_not));
and6$ and_gate27(.out(and27), .in0(i0), .in1(i1_not), .in2(i2_not), .in3(i3_not), .in4(i5), .in5(i6));
and5$ and_gate28(.out(and28), .in0(i0_not), .in1(i1_not), .in2(i3_not), .in3(i4_not), .in4(i5_not));
and5$ and_gate29(.out(and29), .in0(i1_not), .in1(i2_not), .in2(i3_not), .in3(i4), .in4(i5_not));
and15$ and_gate30(.out(and30), .in0(i0_not), .in1(i1_not), .in2(i2_not), .in3(i3_not), .in4(i4), .in5(i5), .in6(i6), .in7(i7), .in8(i8), .in9(i9_not), .in10(i10_not), .in11(i11_not), .in12(i12_not), .in13(i13), .in14(i15));
and8$ and_gate31(.out(and31), .in0(i0_not), .in1(i1), .in2(i2), .in3(i3_not), .in4(i4), .in5(i5_not), .in6(i6_not), .in7(i7_not));
and7$ and_gate32(.out(and32), .in0(i0), .in1(i2), .in2(i3), .in3(i4), .in4(i5), .in5(i6), .in6(i7));
and8$ and_gate33(.out(and33), .in0(i0), .in1(i1), .in2(i2), .in3(i3_not), .in4(i4), .in5(i5_not), .in6(i6_not), .in7(i7));
and7$ and_gate34(.out(and34), .in0(i0), .in1(i1), .in2(i3_not), .in3(i4), .in4(i5_not), .in5(i6), .in6(i7_not));
and8$ and_gate35(.out(and35), .in0(i0), .in1(i1_not), .in2(i2_not), .in3(i3), .in4(i4), .in5(i5_not), .in6(i6), .in7(i7_not));
and7$ and_gate36(.out(and36), .in0(i0_not), .in1(i1_not), .in2(i3_not), .in3(i4_not), .in4(i5), .in5(i6_not), .in6(i7));
and8$ and_gate37(.out(and37), .in0(i0), .in1(i1_not), .in2(i2_not), .in3(i3_not), .in4(i4_not), .in5(i5_not), .in6(i6_not), .in7(i7));
and7$ and_gate38(.out(and38), .in0(i0), .in1(i1), .in2(i2_not), .in3(i3_not), .in4(i5_not), .in5(i6), .in6(i7_not));
and7$ and_gate39(.out(and39), .in0(i0_not), .in1(i1_not), .in2(i2_not), .in3(i3_not), .in4(i5), .in5(i6_not), .in6(i7));
and8$ and_gate40(.out(and40), .in0(
i0), .in1(i1), .in2(i2_not), .in3(i3_not), .in4(i4_not), .in5(i5), .in6(i6), .in7(i7));
and5$ and_gate41(.out(and41), .in0(i0), .in1(i1_not), .in2(i2), .in3(i3), .in4(i4));
and7$ and_gate42(.out(and42), .in0(i0_not), .in1(i1), .in2(i2), .in3(i3), .in4(i4_not), .in5(i5), .in6(i7));
and8$ and_gate43(.out(and43), .in0(i0), .in1(i1_not), .in2(i2_not), .in3(i3), .in4(i4), .in5(i5_not), .in6(i6), .in7(i7_not));
and7$ and_gate44(.out(and44), .in0(i1), .in1(i2
), .in2(i3_not), .in3(i4), .in4(i5_not), .in5(i6), .in6(i7_not));
and7$ and_gate45(.out(and45), .in0(i0_not), .in1(i1_not), .in2(i3_not), .in3(i4_not), .in4(i5), .in5(i6_not), .in6(i7_not));
and7$ and_gate46(.out(and46), .in0(i0), .in1(i1), .in2(i2), .in3(i3_not), .in4(i4
), .in5(i5_not), .in6(i6));
and7$ and_gate47(.out(and47), .in0(i0_not), .in1(i1_not), .in2(i2_not), .in3(i3_not), .in4(i5), .in5(i6_not), .in6(i7_not));
and8$ and_gate48(.out(and48), .in0(i0), .in1(i1), .in2(i2_not), .in3(i3_not), .in4(i4_not), .in5(i5), .in6(i6), .in7(i7_not));
and7$ and_gate49(.out(and49), .in0(
i0), .in1(i2_not), .in2(i3_not), .in3(i4_not), .in4(i5_not), .in5(i6_not), .in6(i7_not));
and8$ and_gate50(.out(and50), .in0(i0), .in1(i1_not), .in2(i2_not), .in3(i3_not), .in4(i4_not), .in5(i5_not), .in6(i6), .in7(i7));
and7$ and_gate51(.out(and51), .in0(i0), .in1(i1
), .in2(i2_not), .in3(i3_not), .in4(i4_not), .in5(i5_not), .in6(i6_not));
and5$ and_gate52(.out(and52), .in0(i0), .in1(i1_not), .in2(i2), .in3(i3), .in4(i4_not));
and7$ and_gate53(.out(and53), .in0(i0), .in1(i1), .in2(i2_not), .in3(i3_not), .in4(i5_not), .in5(i6), .in6(i7_not));

or9$ or_gate0(.out(or0), .in0(and0), .in1(and1), .in2(and2), .in3(and3), .in4(and4), .in5(and5), .in6(and6), .in7(and7), .in8(and8));
or21$ or_gate1(.out(or1), .in0(and9), .in1(and10), .in2(and11), .in3(and12), .in4(and13), .in5(and14), .in6(and15), .in7(and16), .in8(and17), .in9(and18), .in10(and19), .in11(and20), .in12(and21), .in13(and22), .in14(and23), .in15(and24), .in16(and25), .in17(and26), .in18(and27), .in19(and28), .in20(and29));
or12$ or_gate2(.out(or2), .in0(and30), .in1(and31), .in2(and32), .in3(and33), .in4(and34), .in5(and35), .in6(and36), .in7(and37), .in8(and38), .in9(and39), .in10(and40), .in11(and41));
or11$ or_gate3(.out(or3), .in0(and42), .in1(and43), .in2(and44), .in3(and45), .in4(and46), .in5(and47), .in6(and48), .in7(and49), .in8(and50), .in9(and51), .in10(and52));

assign opsize = or0;
assign modrm = or1;
assign imm1 = or2;
assign imm0 = or3;
assign f16 = and53;

  
endmodule 
   
