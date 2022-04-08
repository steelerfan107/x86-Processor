module modrm_size_map (
   input mod1,
   input mod0,
   input rm2, 
   input rm1,
   input rm0,
   output sib,
   output disp1,
   output disp0		       
);   

wire rm1_not;
wire rm0_not;
wire and0;
wire mod1_not;
wire and1;
wire or0;
wire mod0_not;
wire and2;
wire and3;
wire or1;
wire and4;

inv1$ rm1_inv (.out(rm1_not), .in(rm1));
inv1$ rm0_inv (.out(rm0_not), .in(rm0));
inv1$ mod1_inv (.out(mod1_not), .in(mod1));
inv1$ mod0_inv (.out(mod0_not), .in(mod0));

and4$ and_gate0(.out(and0), .in0(mod0), .in1(rm2), .in2(rm1_not), .in3(rm0_not));
and4$ and_gate1(.out(and1), .in0(mod1_not), .in1(rm2), .in2(rm1_not), .in3(rm0_not));
and5$ and_gate2(.out(and2), .in0(mod1_not), .in1(mod0_not), .in2(rm2), .in3(rm1_not), .in4(rm0));
and2$ and_gate3(.out(and3), .in0(mod1), .in1(mod0));
and2$ and_gate4(.out(and4), .in0(mod1_not), .in1(mod0));

or2$ or_gate0(.out(or0), .in0(and0), .in1(and1));
or2$ or_gate1(.out(or1), .in0(and2), .in1(and3));

assign sib = or0;
assign disp1 = or1;
assign disp0 = and4;

endmodule
