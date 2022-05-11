module int_comb_output_cloud (
			      input  not_used, 
			      input  curr_state2,
			      input  curr_state1,
			      input  curr_state0, 
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
			      output int_clear,
			      output capture_bottom_eip,
			      output addrp1		      
);

wire not_used_not;
wire curr_state2_not;
wire curr_state0_not;
wire and0;
wire and1;
wire curr_state1_not;
wire and2;
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
wire or2;
wire and14;
wire and15;
wire and16;
wire and17;
wire and18;
wire and19;
wire or3;

inv1$ not_used_inv (.out(not_used_not), .in(not_used));
inv1$ curr_state2_inv (.out(curr_state2_not), .in(curr_state2));
inv1$ curr_state0_inv (.out(curr_state0_not), .in(curr_state0));
inv1$ curr_state1_inv (.out(curr_state1_not), .in(curr_state1));

and4$ and_gate0(.out(and0), .in0(not_used_not), .in1(curr_state2_not), .in2(curr_state1), .in3(curr_state0_not));
and4$ and_gate1(.out(and1), .in0(not_used_not), .in1(curr_state2_not), .in2(curr_state1), .in3(curr_state0));
and4$ and_gate2(.out(and2), .in0(not_used_not), .in1(curr_state2_not), .in2(curr_state1_not), .in3(curr_state0));
and2$ and_gate3(.out(and3), .in0(not_used_not), .in1(curr_state2));
and4$ and_gate4(.out(and4), .in0(not_used_not), .in1(curr_state2_not), .in2(curr_state1), .in3(curr_state0_not));
and4$ and_gate5(.out(and5), .in0(not_used_not), .in1(curr_state2_not), .in2(curr_state1_not), .in3(curr_state0));
and4$ and_gate6(.out(and6), .in0(not_used_not), .in1(curr_state2_not), .in2(curr_state1_not), .in3(curr_state0));
and4$ and_gate7(.out(and7), .in0(not_used_not), .in1(curr_state2_not), .in2(curr_state1_not), .in3(curr_state0));
and4$ and_gate8(.out(and8), .in0(not_used_not), .in1(curr_state2_not), .in2(curr_state1_not), .in3(curr_state0));
and4$ and_gate9(.out(and9), .in0(not_used_not), .in1(curr_state2_not), .in2(curr_state1_not), .in3(curr_state0));
and4$ and_gate10(.out(and10), .in0(not_used_not), .in1(curr_state2_not), .in2(curr_state1_not), .in3(curr_state0));
and4$ and_gate11(.out(and11), .in0(not_used_not), .in1(curr_state2_not), .in2(curr_state1), .in3(curr_state0_not));
and4$ and_gate12(.out(and12), .in0(not_used_not), .in1(curr_state2), .in2(curr_state1_not), .in3(curr_state0));
and4$ and_gate13(.out(and13), .in0(not_used_not), .in1(curr_state2_not), .in2(curr_state1), .in3(curr_state0));
and4$ and_gate14(.out(and14), .in0(not_used_not), .in1(curr_state2), .in2(curr_state1), .in3(curr_state0));
and4$ and_gate15(.out(and15), .in0(not_used_not), .in1(curr_state2), .in2(curr_state1_not), .in3(curr_state0));
and4$ and_gate16(.out(and16), .in0(not_used_not), .in1(curr_state2), .in2(curr_state1), .in3(curr_state0));
and4$ and_gate17(.out(and17), .in0(not_used_not), .in1(curr_state2), .in2(curr_state1_not), .in3(curr_state0));
and4$ and_gate18(.out(and18), .in0(not_used_not), .in1(curr_state2), .in2(curr_state1_not), .in3(curr_state0));
and3$ and_gate19(.out(and19), .in0(not_used_not), .in1(curr_state2), .in2(curr_state1));

or4$ or_gate0(.out(or0), .in0(and0), .in1(and1), .in2(and2), .in3(and3));
or2$ or_gate1(.out(or1), .in0(and4), .in1(and5));
or2$ or_gate2(.out(or2), .in0(and12), .in1(and13));
or2$ or_gate3(.out(or3), .in0(and18), .in1(and19));

assign flush_fetch = or0;
assign flush_dec_0 = or1;
assign flush_dec_1 = and6;
assign flush_reg = and7;
assign flush_addr = and8;
assign flush_ex = and9;
assign flush_wb = and10;
assign dec_start_int = and11;
assign mem_valid = or2;
assign fetch_load = and14;
assign reg_load_cs = and15;
assign int_clear = and16;
assign capture_bottom_eip = and17;
assign addrp1 = or3;

endmodule
