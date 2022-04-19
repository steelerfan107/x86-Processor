module int_comb_output_cloud (
       input curr_state_2,
       input curr_state_1,
       input curr_state_0,			      
       output flush_fetch,
       output flush_dec_0,
       output flush_dec_1,
       output flush_reg,
       output flush_addr,
       output flush_ex,
       output flush_wb,
       output dec_start_int,
       output mem_valid,
       output fetch_load,
       output reg_load_cs,
       output int_clear
);

wire curr_state2_not;
wire curr_state0_not;
wire and0;
wire curr_state2_not;
wire and1;
wire curr_state1_not;
wire and2;
wire curr_state2_not;
wire and3;
wire or0;
wire and4;
wire and5;
wire or1;
wire and6;
wire and7;
wire and8;
wire and9;
wire and10;
wire and11;
wire and12;
wire and13;
wire and14;
wire and15;

inv1$ curr_state2_inv (.out(curr_state2_not), .in(curr_state2));
inv1$ curr_state0_inv (.out(curr_state0_not), .in(curr_state0));
inv1$ curr_state1_inv (.out(curr_state1_not), .in(curr_state1));

and3$ and_gate0(.out(and0), .in0(curr_state2_not), .in1(curr_state1), .in2(curr_state0_not));
and3$ and_gate1(.out(and1), .in0(curr_state2_not), .in1(curr_state1), .in2(curr_state0));
and2$ and_gate2(.out(and2), .in0(curr_state2), .in1(curr_state1_not));
and3$ and_gate3(.out(and3), .in0(curr_state2_not), .in1(curr_state1_not), .in2(curr_state0));
and3$ and_gate4(.out(and4), .in0(curr_state2_not), .in1(curr_state1), .in2(curr_state0_not));
and3$ and_gate5(.out(and5), .in0(curr_state2_not), .in1(curr_state1_not), .in2(curr_state0));
and3$ and_gate6(.out(and6), .in0(curr_state2_not), .in1(curr_state1_not), .in2(curr_state0));
and3$ and_gate7(.out(and7), .in0(curr_state2_not), .in1(curr_state1_not), .in2(curr_state0));
and3$ and_gate8(.out(and8), .in0(curr_state2_not), .in1(curr_state1_not), .in2(curr_state0));
and3$ and_gate9(.out(and9), .in0(curr_state2_not), .in1(curr_state1_not), .in2(curr_state0));
and3$ and_gate10(.out(and10), .in0(curr_state2_not), .in1(curr_state1_not), .in2(curr_state0));
and3$ and_gate11(.out(and11), .in0(curr_state2_not), .in1(curr_state1), .in2(curr_state0_not));
and3$ and_gate12(.out(and12), .in0(curr_state2_not), .in1(curr_state1), .in2(curr_state0));
and3$ and_gate13(.out(and13), .in0(curr_state2), .in1(curr_state1_not), .in2(curr_state0));
and3$ and_gate14(.out(and14), .in0(curr_state2), .in1(curr_state1_not), .in2(curr_state0));
and3$ and_gate15(.out(and15), .in0(curr_state2), .in1(curr_state1_not), .in2(curr_state0));

or4$ or_gate0(.out(or0), .in0(and0), .in1(and1), .in2(and2), .in3(and3));
or2$ or_gate1(.out(or1), .in0(and4), .in1(and5));

assign flush_fetch = or0;
assign flush_dec_0 = or1;
assign flush_dec_1 = and6;
assign flush_reg = and7;
assign flush_addr = and8;
assign flush_ex = and9;
assign flush_wb = and10;
assign dec_start_int = and11;
assign mem_valid = and12;
assign fetch_load = and13;
assign reg_load_cs = and14;
assign int_clear = and15;

endmodule
