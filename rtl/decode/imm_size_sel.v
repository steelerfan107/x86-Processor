module imm_size_sel (
  input f16,
  input size,
  input imm1,
  input imm0,
  output sel1, 
  output sel0		     
);

wire f16_not;
wire size_not;
wire and0;
wire and1;
wire or0;
wire and2;
wire and3;
wire and4;
wire or1;

inv1$ f16_inv (.out(f16_not), .in(f16));
inv1$ size_inv (.out(size_not), .in(size));

and3$ and_gate0(.out(and0), .in0(f16_not), .in1(size_not), .in2(imm1));
and2$ and_gate1(.out(and1), .in0(imm1), .in1(imm0));
and2$ and_gate2(.out(and2), .in0(size), .in1(imm1));
and2$ and_gate3(.out(and3), .in0(f16), .in1(imm1));
and2$ and_gate4(.out(and4), .in0(imm1), .in1(imm0));

or2$ or_gate0(.out(or0), .in0(and0), .in1(and1));
or3$ or_gate1(.out(or1), .in0(and2), .in1(and3), .in2(and4));

assign sel1 = or0;
assign sel0 = or1;
   
endmodule
   
