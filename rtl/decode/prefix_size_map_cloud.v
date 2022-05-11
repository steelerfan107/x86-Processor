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

   wire 			det0, det1, det2;
   wire 			size0, size1, size2;
   wire [1:0] 			sum0;
   
pre_detect (
	     		  i23,
              		  i22,
			  i21,
			  i20,
			  i19,
			  i18,
			  i17,
			  i16,
	                  det0,
	                  size0
	    );

pre_detect (
	     		  i15,
              		  i14,
			  i13,
			  i12,
			  i11,
			  i10,
			  i9,
			  i8,
	                  det1,
	                  size1
	    );

pre_detect (
	     		  i7,
              		  i6,
			  i5,
			  i4,
			  i3,
			  i2,
			  i1,
			  i0,
	                  det2,
	                  size2
	    );   
	    
   or3$ ( size_prefix, size0, size1, size2);
   slow_addr #(.WIDTH(2)) ({1'b0,det0}, {1'b0,det1}, sum0, );
   slow_addr #(.WIDTH(2)) (sum0       , {1'b0,det2}, {s1, s0}, );
   
 
endmodule

module pre_detect (
			 
			 input i7,
			 input i6,
			 input i5,
			 input i4,
			 input i3,
			 input i2,
			 input i1,
			 input i0,
			 output s0,
                         output size_prefix			 
);

wire i3_not;
wire i2_not;
wire and0;
wire i7_not;
wire i4_not;
wire i1_not;
wire and1;
wire i6_not;
wire i0_not;
wire and2;
wire and3;
wire or0;
wire and4;

inv1$ i3_inv (.out(i3_not), .in(i3));
inv1$ i2_inv (.out(i2_not), .in(i2));
inv1$ i7_inv (.out(i7_not), .in(i7));
inv1$ i4_inv (.out(i4_not), .in(i4));
inv1$ i1_inv (.out(i1_not), .in(i1));
inv1$ i6_inv (.out(i6_not), .in(i6));
inv1$ i0_inv (.out(i0_not), .in(i0));

and8$ and_gate0(.out(and0), .in0(i7), .in1(i6), .in2(i5), .in3(i4), .in4(i3_not), .in5(i2_not), .in6(i1), .in7(i0));
and7$ and_gate1(.out(and1), .in0(i7_not), .in1(i6), .in2(i5), .in3(i4_not), .in4(i3_not), .in5(i2), .in6(i1_not));
and6$ and_gate2(.out(and2), .in0(i7_not), .in1(i6_not), .in2(i5), .in3(i2), .in4(i1), .in5(i0_not));
and8$ and_gate3(.out(and3), .in0(i7_not), .in1(i6), .in2(i5), .in3(i4_not), .in4(i3_not), .in5(i2), .in6(i1), .in7(i0_not));
and8$ and_gate4(.out(and4), .in0(i7_not), .in1(i6), .in2(i5), .in3(i4_not), .in4(i3_not), .in5(i2), .in6(i1), .in7(i0_not));

or4$ or_gate0(.out(or0), .in0(and0), .in1(and1), .in2(and2), .in3(and3));

assign s0 = or0;
assign size_prefix = and4;

endmodule
