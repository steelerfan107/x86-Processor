module dcache_combinational_logic(
    state2, 
    state1,
    state0,
    rd_valid,
    wr_valid,
    dp_ready,
    write_num, 
    read_num,
    read2, 
    TLB_hit,
    cache_hit, 
    mem_ready, 
    bus_grant, 
    bus_busy,
    page_fault,
    rd_ready,
    wr_ready,
    rd_wr_addr,
    req_addr_en,
    read_num_sel,
    read_num_wr_en,
    dp_valid,
    busy_out,
    write, 
    write_num_data,
    write_num_wr_en, 
    mem_req, 
    grant_pass,
    pa_wr_en,
    new_state2,
    new_state1,
    new_state0
);

    input state2; 
    input state1;
    input state0;
    input rd_valid;
    input wr_valid;
    input dp_ready;
    input write_num; 
    input read_num;
    input read2; 
    input TLB_hit;
    input cache_hit; 
    input mem_ready; 
    input bus_grant; 
    input bus_busy;

    output page_fault;
    output rd_ready;
    output wr_ready;
    output rd_wr_addr;
    output req_addr_en;
    output read_num_sel;
    output read_num_wr_en;
    output dp_valid;
    output busy_out;
    output write; 
    output write_num_data;
    output write_num_wr_en; 
    output mem_req; 
    output grant_pass;
    output pa_wr_en;
    output new_state2;
    output new_state1;
    output new_state0

    wire and0;
    wire state2_not;
    wire state1_not;
    wire state0_not;
    wire rd_valid_not;
    wire wr_valid_not;
    wire and1;
    wire and2;
    wire or0;
    wire and3;
    wire and4;
    wire or1;
    wire and5;
    wire and6;
    wire and7;
    wire or2;
    wire read_num_not;
    wire and8;
    wire write_num_not;
    wire and9;
    wire or3;
    wire and10;
    wire and11;
    wire and12;
    wire or4;
    wire read2_not;
    wire and13;
    wire and14;
    wire or5;
    wire and15;
    wire and16;
    wire mem_ready_not;
    wire and17;
    wire or6;
    wire and18;
    wire cache_hit_not;
    wire and19;
    wire and20;
    wire and21;
    wire or7;
    wire and22;
    wire and23;
    wire bus_grant_not;
    wire and24;
    wire or8;
    wire and25;
    wire and26;
    wire and27;
    wire and28;
    wire dp_ready_not;
    wire and29;
    wire and30;
    wire and31;
    wire and32;
    wire and33;
    wire TLB_hit_not;
    wire and34;
    wire or9;
    wire and35;
    wire and36;
    wire and37;
    wire or10;
    wire bus_busy_not;
    wire and38;
    wire and39;
    wire and40;
    wire and41;
    wire and42;
    wire and43;
    wire and44;
    wire or11;
    wire and45;
    wire and46;
    wire and47;
    wire and48;
    wire and49;
    wire and50;
    wire and51;
    wire and52;
    wire and53;
    wire or12;

    inv1$ state2_inv (.out(state2_not), .in(state2));
    inv1$ state1_inv (.out(state1_not), .in(state1));
    inv1$ state0_inv (.out(state0_not), .in(state0));
    inv1$ rd_valid_inv (.out(rd_valid_not), .in(rd_valid));
    inv1$ wr_valid_inv (.out(wr_valid_not), .in(wr_valid));
    inv1$ read_num_inv (.out(read_num_not), .in(read_num));
    inv1$ write_num_inv (.out(write_num_not), .in(write_num));
    inv1$ read2_inv (.out(read2_not), .in(read2));
    inv1$ mem_ready_inv (.out(mem_ready_not), .in(mem_ready));
    inv1$ cache_hit_inv (.out(cache_hit_not), .in(cache_hit));
    inv1$ bus_grant_inv (.out(bus_grant_not), .in(bus_grant));
    inv1$ dp_ready_inv (.out(dp_ready_not), .in(dp_ready));
    inv1$ TLB_hit_inv (.out(TLB_hit_not), .in(TLB_hit));
    inv1$ bus_busy_inv (.out(bus_busy_not), .in(bus_busy));

    and3$ and_gate0(.out(and0), .in0(state2), .in1(state1), .in2(state0));
    and5$ and_gate1(.out(and1), .in0(state2_not), .in1(state1_not), .in2(state0_not), .in3(rd_valid_not), .in4(wr_valid_not));
    and5$ and_gate2(.out(and2), .in0(state2_not), .in1(state1_not), .in2(state0_not), .in3(rd_valid), .in4(wr_valid_not));
    and5$ and_gate3(.out(and3), .in0(state2_not), .in1(state1_not), .in2(state0_not), .in3(rd_valid_not), .in4(wr_valid_not));
    and4$ and_gate4(.out(and4), .in0(state2_not), .in1(state1_not), .in2(state0_not), .in3(wr_valid));
    and4$ and_gate5(.out(and5), .in0(state2_not), .in1(state1_not), .in2(state0_not), .in3(wr_valid));
    and5$ and_gate6(.out(and6), .in0(state2_not), .in1(state1_not), .in2(state0_not), .in3(rd_valid), .in4(wr_valid_not));
    and4$ and_gate7(.out(and7), .in0(state2_not), .in1(state1_not), .in2(state0_not), .in3(wr_valid));
    and7$ and_gate8(.out(and8), .in0(state2_not), .in1(state1_not), .in2(state0), .in3(read_num_not), .in4(read2), .in5(TLB_hit), .in6(cache_hit));
    and5$ and_gate9(.out(and9), .in0(state2_not), .in1(state1), .in2(state0), .in3(write_num_not), .in4(mem_ready));
    and7$ and_gate10(.out(and10), .in0(state2_not), .in1(state1_not), .in2(state0), .in3(read_num_not), .in4(read2), .in5(TLB_hit), .in6(cache_hit));
    and5$ and_gate11(.out(and11), .in0(state2_not), .in1(state1), .in2(state0), .in3(write_num_not), .in4(mem_ready));
    and5$ and_gate12(.out(and12), .in0(state2_not), .in1(state1_not), .in2(state0_not), .in3(rd_valid), .in4(wr_valid_not));
    and8$ and_gate13(.out(and13), .in0(state2_not), .in1(state1_not), .in2(state0), .in3(dp_ready), .in4(read_num_not), .in5(read2_not), .in6(TLB_hit), .in7(cache_hit));
    and8$ and_gate14(.out(and14), .in0(state2_not), .in1(state1_not), .in2(state0), .in3(dp_ready), .in4(read_num), .in5(read2), .in6(TLB_hit), .in7(cache_hit));
    and5$ and_gate15(.out(and15), .in0(state2_not), .in1(state1), .in2(state0), .in3(write_num), .in4(mem_ready));
    and5$ and_gate16(.out(and16), .in0(state2_not), .in1(state1), .in2(state0), .in3(write_num_not), .in4(mem_ready));
    and4$ and_gate17(.out(and17), .in0(state2_not), .in1(state1), .in2(state0), .in3(mem_ready_not));
    and5$ and_gate18(.out(and18), .in0(state2_not), .in1(state1), .in2(state0), .in3(write_num_not), .in4(mem_ready));
    and5$ and_gate19(.out(and19), .in0(state2_not), .in1(state1_not), .in2(state0), .in3(TLB_hit), .in4(cache_hit_not));
    and5$ and_gate20(.out(and20), .in0(state2_not), .in1(state1), .in2(state0), .in3(write_num), .in4(mem_ready));
    and5$ and_gate21(.out(and21), .in0(state2_not), .in1(state1_not), .in2(state0), .in3(TLB_hit), .in4(cache_hit_not));
    and5$ and_gate22(.out(and22), .in0(state2_not), .in1(state1_not), .in2(state0), .in3(TLB_hit), .in4(cache_hit_not));
    and4$ and_gate23(.out(and23), .in0(state2_not), .in1(state1), .in2(state0_not), .in3(bus_busy));
    and4$ and_gate24(.out(and24), .in0(state2_not), .in1(state1), .in2(state0_not), .in3(bus_grant_not));
    and8$ and_gate25(.out(and25), .in0(state2_not), .in1(state1_not), .in2(state0), .in3(dp_ready), .in4(read_num_not), .in5(read2_not), .in6(TLB_hit), .in7(cache_hit));
    and8$ and_gate26(.out(and26), .in0(state2_not), .in1(state1_not), .in2(state0), .in3(dp_ready), .in4(read_num), .in5(read2), .in6(TLB_hit), .in7(cache_hit));
    and7$ and_gate27(.out(and27), .in0(state2_not), .in1(state1_not), .in2(state0), .in3(read_num_not), .in4(read2), .in5(TLB_hit), .in6(cache_hit));
    and5$ and_gate28(.out(and28), .in0(state2_not), .in1(state1_not), .in2(state0_not), .in3(rd_valid_not), .in4(wr_valid_not));
    and6$ and_gate29(.out(and29), .in0(state2_not), .in1(state1_not), .in2(state0), .in3(dp_ready_not), .in4(read2), .in5(cache_hit));
    and6$ and_gate30(.out(and30), .in0(state2_not), .in1(state1_not), .in2(state0), .in3(dp_ready_not), .in4(read_num_not), .in5(cache_hit));
    and5$ and_gate31(.out(and31), .in0(state2_not), .in1(state1_not), .in2(state0_not), .in3(rd_valid), .in4(wr_valid_not));
    and3$ and_gate32(.out(and32), .in0(state2), .in1(state1), .in2(state0));
    and4$ and_gate33(.out(and33), .in0(state2_not), .in1(state1_not), .in2(state0_not), .in3(wr_valid));
    and4$ and_gate34(.out(and34), .in0(state2_not), .in1(state1_not), .in2(state0), .in3(TLB_hit_not));
    and5$ and_gate35(.out(and35), .in0(state2_not), .in1(state1_not), .in2(state0), .in3(TLB_hit), .in4(cache_hit_not));
    and4$ and_gate36(.out(and36), .in0(state2_not), .in1(state1_not), .in2(state0_not), .in3(wr_valid));
    and4$ and_gate37(.out(and37), .in0(state2_not), .in1(state1_not), .in2(state0), .in3(TLB_hit_not));
    and5$ and_gate38(.out(and38), .in0(state2_not), .in1(state1), .in2(state0_not), .in3(bus_grant), .in4(bus_busy_not));
    and5$ and_gate39(.out(and39), .in0(state2_not), .in1(state1), .in2(state0), .in3(write_num), .in4(mem_ready));
    and5$ and_gate40(.out(and40), .in0(state2_not), .in1(state1_not), .in2(state0), .in3(TLB_hit), .in4(cache_hit_not));
    and4$ and_gate41(.out(and41), .in0(state2_not), .in1(state1), .in2(state0_not), .in3(bus_busy));
    and4$ and_gate42(.out(and42), .in0(state2_not), .in1(state1), .in2(state0_not), .in3(bus_grant_not));
    and4$ and_gate43(.out(and43), .in0(state2_not), .in1(state1), .in2(state0), .in3(mem_ready_not));
    and4$ and_gate44(.out(and44), .in0(state2_not), .in1(state1_not), .in2(state0), .in3(TLB_hit_not));
    and4$ and_gate45(.out(and45), .in0(state2_not), .in1(state1), .in2(state0), .in3(bus_grant));
    and7$ and_gate46(.out(and46), .in0(state2_not), .in1(state1_not), .in2(state0), .in3(read_num_not), .in4(read2), .in5(TLB_hit), .in6(cache_hit));
    and6$ and_gate47(.out(and47), .in0(state2_not), .in1(state1_not), .in2(state0), .in3(dp_ready_not), .in4(read2), .in5(cache_hit));
    and6$ and_gate48(.out(and48), .in0(state2_not), .in1(state1_not), .in2(state0), .in3(dp_ready_not), .in4(read_num_not), .in5(cache_hit));
    and5$ and_gate49(.out(and49), .in0(state2_not), .in1(state1), .in2(state0_not), .in3(bus_grant), .in4(bus_busy_not));
    and5$ and_gate50(.out(and50), .in0(state2_not), .in1(state1), .in2(state0), .in3(write_num_not), .in4(mem_ready));
    and5$ and_gate51(.out(and51), .in0(state2_not), .in1(state1_not), .in2(state0_not), .in3(rd_valid), .in4(wr_valid_not));
    and4$ and_gate52(.out(and52), .in0(state2_not), .in1(state1), .in2(state0), .in3(mem_ready_not));
    and4$ and_gate53(.out(and53), .in0(state2_not), .in1(state1_not), .in2(state0), .in3(TLB_hit_not));

    or2$ or_gate0(.out(or0), .in0(and1), .in1(and2));
    or2$ or_gate1(.out(or1), .in0(and3), .in1(and4));
    or2$ or_gate2(.out(or2), .in0(and6), .in1(and7));
    or2$ or_gate3(.out(or3), .in0(and8), .in1(and9));
    or3$ or_gate4(.out(or4), .in0(and10), .in1(and11), .in2(and12));
    or2$ or_gate5(.out(or5), .in0(and13), .in1(and14));
    or3$ or_gate6(.out(or6), .in0(and15), .in1(and16), .in2(and17));
    or2$ or_gate7(.out(or7), .in0(and20), .in1(and21));
    or3$ or_gate8(.out(or8), .in0(and22), .in1(and23), .in2(and24));
    or10$ or_gate9(.out(or9), .in0(and25), .in1(and26), .in2(and27), .in3(and28), .in4(and29), .in5(and30), .in6(and31), .in7(and32), .in8(and33), .in9(and34));
    or2$ or_gate10(.out(or10), .in0(and36), .in1(and37));
    or7$ or_gate11(.out(or11), .in0(and38), .in1(and39), .in2(and40), .in3(and41), .in4(and42), .in5(and43), .in6(and44));
    or9$ or_gate12(.out(or12), .in0(and45), .in1(and46), .in2(and47), .in3(and48), .in4(and49), .in5(and50), .in6(and51), .in7(and52), .in8(and53));

    assign page_fault = and0;
    assign rd_ready = or0;
    assign wr_ready = or1;
    assign rd_wr_addr = and5;
    assign req_addr_en = or2;
    assign read_num_sel = or3;
    assign read_num_wr_en = or4;
    assign dp_valid = or5;
    assign busy_out = or6;
    assign write = and18;
    assign write_num_data = and19;
    assign write_num_wr_en = or7;
    assign mem_req = or8;
    assign grant_pass = or9;
    assign pa_wr_en = and35;
    assign new_state2 = or10;
    assign new_state1 = or11;
    assign new_state0 = or12;
endmodule
