module int_next_state_cloud (
       input  curr_state2,
       input  curr_state1,
       input  curr_state0,
       input  or_int_vec,
       input  dec_end_int,
       input  mem_ready,
       input  mem_dp_valid,	     
       output next_state2,
       output next_state1,
       output next_state0			     
);
   
wire curr_state2_not;
wire and0;
wire curr_state1_not;
wire curr_state0_not;
wire and1;
wire or0;
wire mem_ready_not;
wire and2;
wire curr_state2_not;
wire and3;
wire and4;
wire or1;
wire and5;
wire and6;
wire curr_state2_not;
wire and7;
wire and8;
wire or2;

inv1$ curr_state2_inv (.out(curr_state2_not), .in(curr_state2));
inv1$ curr_state1_inv (.out(curr_state1_not), .in(curr_state1));
inv1$ curr_state0_inv (.out(curr_state0_not), .in(curr_state0));
inv1$ mem_ready_inv (.out(mem_ready_not), .in(mem_ready));

and4$ and_gate0(.out(and0), .in0(curr_state2_not), .in1(curr_state1), .in2(curr_state0), .in3(mem_ready));
and3$ and_gate1(.out(and1), .in0(
curr_state2), .in1(curr_state1_not), .in2(curr_state0_not));
and4$ and_gate2(.out(and2), .in0(curr_state2_not), .in1(curr_state1), .in2(curr_state0), .in3(mem_ready_not));
and3$ and_gate3(.out(and3), .in0(curr_state2_not), .in1(curr_state1_not), .in2(curr_state0));
and3$ and_gate4(.out(and4), .in0(curr_state2_not), .in1(curr_state1
), .in2(curr_state0_not));
and4$ and_gate5(.out(and5), .in0(curr_state2), .in1(curr_state1_not), .in2(curr_state0_not), .in3(mem_dp_valid));
and4$ and_gate6(.out(and6), .in0(curr_state2_not), .in1(curr_state1), .in2(curr_state0_not), .in3(dec_end_int));
and4$ and_gate7(.out(and7), .in0(curr_state2_not), .in1(curr_state1_not), .in2(curr_state0_not), .in3(or_int_vec));
and4$ and_gate8(.out(and8), .in0(curr_state2_not), .in1(curr_state1
), .in2(curr_state0), .in3(mem_ready_not));

or2$ or_gate0(.out(or0), .in0(and0), .in1(and1));
or3$ or_gate1(.out(or1), .in0(and2), .in1(and3), .in2(and4));
or4$ or_gate2(.out(or2), .in0(and5), .in1(and6), .in2(and7), .in3(and8));

assign next_state2 = or0;
assign next_state1 = or1;
assign next_state0 = or2;

   
endmodule   
