module icache_combinational_logic(
state1,  state0,  write_num,   write_num0,  read_valid,  dp_ready,    TLB_hit, cache_hit,   mem_ready,   bus_grant,   bus_busy,
busy_out,    write,   write_num_src,   mem_req, read_ready,  dp_valid,    grant_pass,  pa_src,  pa_wr_en,    new_state1,  new_state0
);

input state1;
input state0;
input write_num;
input write_num0;
input read_valid;
input dp_ready;
input TLB_hit;
input cache_hit;
input mem_ready ;
input bus_grant;
input bus_busy;

output busy_out;
output write;
output write_num_src;
output mem_req;
output read_ready;
output dp_valid;
output grant_pass;
output pa_src;
output pa_wr_en;
output new_state1;
output new_state0;

wire and0;
wire mem_ready_not;
wire and1;
wire write_num0_not;
wire and2;
wire write_num_not;
wire and3;
wire or0;
wire and4;
wire and5;
wire and6;
wire and7;
wire or1;
wire state0_not;
wire and8;
wire state1_not;
wire and9;
wire and10;
wire and11;
wire and12;
wire or2;
wire and13;
wire and14;
wire or3;
wire and15;
wire and16;
wire and17;
wire and18;
wire or4;
wire cache_hit_not;
wire and19;
wire and20;
wire and21;
wire and22;
wire and23;
wire or5;
wire dp_ready_not;
wire and24;
wire bus_busy_not;
wire and25;
wire and26;
wire and27;
wire and28;
wire and29;
wire and30;
wire or6;

inv1$ mem_ready_inv (.out(mem_ready_not), .in(mem_ready));
inv1$ write_num0_inv (.out(write_num0_not), .in(write_num0));
inv1$ write_num_inv (.out(write_num_not), .in(write_num));
inv1$ state0_inv (.out(state0_not), .in(state0));
inv1$ state1_inv (.out(state1_not), .in(state1));
inv1$ cache_hit_inv (.out(cache_hit_not), .in(cache_hit));
inv1$ dp_ready_inv (.out(dp_ready_not), .in(dp_ready));
inv1$ bus_busy_inv (.out(bus_busy_not), .in(bus_busy));

and5$ and_gate0(.out(and0), .in0(state1), .in1(state0), .in2(write_num), .in3(write_num0), .in4(mem_ready));
and3$ and_gate1(.out(and1), .in0(state1), .in1(state0), .in2(mem_ready_not));
and3$ and_gate2(.out(and2), .in0(state1), .in1(state0), .in2(write_num0_not));
and3$ and_gate3(.out(and3), .in0(state1), .in1(state0), .in2(write_num_not));
and5$ and_gate4(.out(and4), .in0(state1), .in1(state0), .in2(write_num), .in3(write_num0), .in4(mem_ready));
and5$ and_gate5(.out(and5), .in0(state1), .in1(state0), .in2(write_num0_not), .in3(mem_ready), .in4(bus_grant));
and5$ and_gate6(.out(and6), .in0(state1), .in1(state0), .in2(write_num_not), .in3(mem_ready), .in4(bus_grant));
and5$ and_gate7(.out(and7), .in0(state1), .in1(state0), .in2(write_num), .in3(write_num0), .in4(mem_ready));
and2$ and_gate8(.out(and8), .in0(state1), .in1(state0_not));
and2$ and_gate9(.out(and9), .in0(state1_not), .in1(state0_not));
and2$ and_gate10(.out(and10), .in0(state1_not), .in1(state0_not));
and2$ and_gate11(.out(and11), .in0(state1_not), .in1(TLB_hit));
and2$ and_gate12(.out(and12), .in0(state1_not), .in1(state0_not));
and5$ and_gate13(.out(and13), .in0(state1), .in1(state0), .in2(write_num0_not), .in3(mem_ready), .in4(bus_grant));
and5$ and_gate14(.out(and14), .in0(state1), .in1(state0), .in2(write_num_not), .in3(mem_ready), .in4(bus_grant));
and5$ and_gate15(.out(and15), .in0(state1), .in1(state0), .in2(write_num0_not), .in3(mem_ready), .in4(bus_grant));
and5$ and_gate16(.out(and16), .in0(state1), .in1(state0), .in2(write_num_not), .in3(mem_ready), .in4(bus_grant));
and2$ and_gate17(.out(and17), .in0(state1_not), .in1(TLB_hit));
and2$ and_gate18(.out(and18), .in0(state1_not), .in1(state0_not));
and4$ and_gate19(.out(and19), .in0(state1_not), .in1(state0), .in2(TLB_hit), .in3(cache_hit_not));
and2$ and_gate20(.out(and20), .in0(state1), .in1(state0_not));
and3$ and_gate21(.out(and21), .in0(state1), .in1(state0), .in2(mem_ready_not));
and3$ and_gate22(.out(and22), .in0(state1), .in1(state0), .in2(write_num0_not));
and3$ and_gate23(.out(and23), .in0(state1), .in1(state0), .in2(write_num_not));
and4$ and_gate24(.out(and24), .in0(state0), .in1(dp_ready_not), .in2(TLB_hit), .in3(cache_hit));
and3$ and_gate25(.out(and25), .in0(state1), .in1(bus_grant), .in2(bus_busy_not));
and5$ and_gate26(.out(and26), .in0(state1), .in1(state0), .in2(write_num), .in3(write_num0), .in4(mem_ready));
and3$ and_gate27(.out(and27), .in0(state1_not), .in1(state0_not), .in2(read_valid));
and3$ and_gate28(.out(and28), .in0(state1), .in1(state0), .in2(mem_ready_not));
and3$ and_gate29(.out(and29), .in0(state1), .in1(state0), .in2(write_num0_not));
and3$ and_gate30(.out(and30), .in0(state1), .in1(state0), .in2(write_num_not));

or4$ or_gate0(.out(or0), .in0(and0), .in1(and1), .in2(and2), .in3(and3));
or3$ or_gate1(.out(or1), .in0(and5), .in1(and6), .in2(and7));
or2$ or_gate2(.out(or2), .in0(and11), .in1(and12));
or2$ or_gate3(.out(or3), .in0(and13), .in1(and14));
or4$ or_gate4(.out(or4), .in0(and15), .in1(and16), .in2(and17), .in3(and18));
or5$ or_gate5(.out(or5), .in0(and19), .in1(and20), .in2(and21), .in3(and22), .in4(and23));
or7$ or_gate6(.out(or6), .in0(and24), .in1(and25), .in2(and26), .in3(and27), .in4(and28), .in5(and29), .in6(and30));

assign busy_out = or0;
assign write = and4;
assign write_num_src = or1;
assign mem_req = and8;
assign read_ready = and9;
assign dp_valid = and10;
assign grant_pass = or2;
assign pa_src = or3;
assign pa_wr_en = or4;
assign new_state1 = or5;
assign new_state0 = or6;


endmodule
