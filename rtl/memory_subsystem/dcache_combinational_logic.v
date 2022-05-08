module dcache_combinational_logic(
    state2, 
    state1,
    state0,
    rd_valid,
    wr_valid,
    wr_size,
    dp_ready,
    write_num, 
    read_num,
    read2, 
    TLB_hit,
    TLB_rd_wr,
    TLB_pcd,
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
    valid_src,
    write_num_data,
    write_num_wr_en, 
    mem_rd_wr,
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
    input wr_size;
    input dp_ready;
    input write_num; 
    input read_num;
    input read2; 
    input TLB_hit;
    input TLB_rd_wr;
    input TLB_pcd;
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
    output valid_src;
    output write_num_data;
    output write_num_wr_en; 
    output mem_rd_wr;
    output mem_req; 
    output grant_pass;
    output pa_wr_en;
    output new_state2;
    output new_state1;
    output new_state0;

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
    wire bus_busy_not;
    wire and5;
    wire and6;
    wire and7;
    wire mem_ready_not;
    wire and8;
    wire and9;
    wire and10;
    wire bus_grant_not;
    wire and11;
    wire TLB_rd_wr_not;
    wire and12;
    wire TLB_hit_not;
    wire and13;
    wire or2;
    wire and14;
    wire and15;
    wire or3;
    wire read_num_not;
    wire and16;
    wire write_num_not;
    wire and17;
    wire or4;
    wire and18;
    wire and19;
    wire and20;
    wire or5;
    wire read2_not;
    wire and21;
    wire and22;
    wire or6;
    wire and23;
    wire and24;
    wire and25;
    wire and26;
    wire and27;
    wire or7;
    wire TLB_pcd_not;
    wire and28;
    wire and29;
    wire or8;
    wire and30;
    wire cache_hit_not;
    wire and31;
    wire and32;
    wire or9;
    wire and33;
    wire and34;
    wire and35;
    wire and36;
    wire or10;
    wire and37;
    wire and38;
    wire or11;
    wire and39;
    wire and40;
    wire and41;
    wire and42;
    wire and43;
    wire or12;
    wire and44;
    wire and45;
    wire and46;
    wire dp_ready_not;
    wire and47;
    wire and48;
    wire and49;
    wire and50;
    wire and51;
    wire and52;
    wire and53;
    wire and54;
    wire and55;
    wire and56;
    wire or13;
    wire and57;
    wire and58;
    wire or14;
    wire and59;
    wire and60;
    wire and61;
    wire and62;
    wire and63;
    wire and64;
    wire and65;
    wire and66;
    wire and67;
    wire and68;
    wire and69;
    wire or15;
    wire and70;
    wire and71;
    wire and72;
    wire and73;
    wire and74;
    wire and75;
    wire and76;
    wire and77;
    wire and78;
    wire and79;
    wire or16;
    wire and80;
    wire and81;
    wire and82;
    wire and83;
    wire and84;
    wire and85;
    wire and86;
    wire and87;
    wire and88;
    wire and89;
    wire and90;
    wire and91;
    wire and92;
    wire and93;
    wire and94;
    wire or17;

    inv1$ state2_inv (.out(state2_not), .in(state2));
    inv1$ state1_inv (.out(state1_not), .in(state1));
    inv1$ state0_inv (.out(state0_not), .in(state0));
    inv1$ rd_valid_inv (.out(rd_valid_not), .in(rd_valid));
    inv1$ wr_valid_inv (.out(wr_valid_not), .in(wr_valid));
    inv1$ bus_busy_inv (.out(bus_busy_not), .in(bus_busy));
    inv1$ mem_ready_inv (.out(mem_ready_not), .in(mem_ready));
    inv1$ bus_grant_inv (.out(bus_grant_not), .in(bus_grant));
    inv1$ TLB_rd_wr_inv (.out(TLB_rd_wr_not), .in(TLB_rd_wr));
    inv1$ TLB_hit_inv (.out(TLB_hit_not), .in(TLB_hit));
    inv1$ read_num_inv (.out(read_num_not), .in(read_num));
    inv1$ write_num_inv (.out(write_num_not), .in(write_num));
    inv1$ read2_inv (.out(read2_not), .in(read2));
    inv1$ TLB_pcd_inv (.out(TLB_pcd_not), .in(TLB_pcd));
    inv1$ cache_hit_inv (.out(cache_hit_not), .in(cache_hit));
    inv1$ dp_ready_inv (.out(dp_ready_not), .in(dp_ready));

    and3$ and_gate0(.out(and0), .in0(state2), .in1(state1), .in2(state0));
    and5$ and_gate1(.out(and1), .in0(state2_not), .in1(state1_not), .in2(state0_not), .in3(rd_valid_not), .in4(wr_valid_not));
    and5$ and_gate2(.out(and2), .in0(state2_not), .in1(state1_not), .in2(state0_not), .in3(rd_valid), .in4(wr_valid_not));
    and5$ and_gate3(.out(and3), .in0(state2_not), .in1(state1_not), .in2(state0_not), .in3(rd_valid_not), .in4(wr_valid_not));
    and4$ and_gate4(.out(and4), .in0(state2_not), .in1(state1_not), .in2(state0_not), .in3(wr_valid));
    and5$ and_gate5(.out(and5), .in0(state2), .in1(state1_not), .in2(state0), .in3(bus_grant), .in4(bus_busy_not));
    and6$ and_gate6(.out(and6), .in0(state2), .in1(state1_not), .in2(state0_not), .in3(TLB_hit), .in4(TLB_rd_wr), .in5(cache_hit));
    and4$ and_gate7(.out(and7), .in0(state2), .in1(state1), .in2(state0_not), .in3(mem_ready));
    and4$ and_gate8(.out(and8), .in0(state2), .in1(state1), .in2(state0_not), .in3(mem_ready_not));
    and4$ and_gate9(.out(and9), .in0(state2_not), .in1(state1_not), .in2(state0_not), .in3(wr_valid));
    and4$ and_gate10(.out(and10), .in0(state2), .in1(state1_not), .in2(state0), .in3(bus_busy));
    and4$ and_gate11(.out(and11), .in0(state2), .in1(state1_not), .in2(state0), .in3(bus_grant_not));
    and4$ and_gate12(.out(and12), .in0(state2), .in1(state1_not), .in2(state0_not), .in3(TLB_rd_wr_not));
    and4$ and_gate13(.out(and13), .in0(state2), .in1(state1_not), .in2(state0_not), .in3(TLB_hit_not));
    and5$ and_gate14(.out(and14), .in0(state2_not), .in1(state1_not), .in2(state0_not), .in3(rd_valid), .in4(wr_valid_not));
    and4$ and_gate15(.out(and15), .in0(state2_not), .in1(state1_not), .in2(state0_not), .in3(wr_valid));
    and7$ and_gate16(.out(and16), .in0(state2_not), .in1(state1_not), .in2(state0), .in3(read_num_not), .in4(read2), .in5(TLB_hit), .in6(cache_hit));
    and5$ and_gate17(.out(and17), .in0(state2_not), .in1(state1), .in2(state0), .in3(write_num_not), .in4(mem_ready));
    and7$ and_gate18(.out(and18), .in0(state2_not), .in1(state1_not), .in2(state0), .in3(read_num_not), .in4(read2), .in5(TLB_hit), .in6(cache_hit));
    and5$ and_gate19(.out(and19), .in0(state2_not), .in1(state1), .in2(state0), .in3(write_num_not), .in4(mem_ready));
    and5$ and_gate20(.out(and20), .in0(state2_not), .in1(state1_not), .in2(state0_not), .in3(rd_valid), .in4(wr_valid_not));
    and8$ and_gate21(.out(and21), .in0(state2_not), .in1(state1_not), .in2(state0), .in3(dp_ready), .in4(read_num_not), .in5(read2_not), .in6(TLB_hit), .in7(cache_hit));
    and8$ and_gate22(.out(and22), .in0(state2_not), .in1(state1_not), .in2(state0), .in3(dp_ready), .in4(read_num), .in5(read2), .in6(TLB_hit), .in7(cache_hit));
    and5$ and_gate23(.out(and23), .in0(state2_not), .in1(state1), .in2(state0), .in3(write_num), .in4(mem_ready));
    and5$ and_gate24(.out(and24), .in0(state2_not), .in1(state1), .in2(state0), .in3(write_num_not), .in4(mem_ready));
    and4$ and_gate25(.out(and25), .in0(state2), .in1(state1), .in2(state0_not), .in3(mem_ready));
    and4$ and_gate26(.out(and26), .in0(state2_not), .in1(state1), .in2(state0), .in3(mem_ready_not));
    and4$ and_gate27(.out(and27), .in0(state2), .in1(state1), .in2(state0_not), .in3(mem_ready_not));
    and7$ and_gate28(.out(and28), .in0(state2), .in1(state1_not), .in2(state0_not), .in3(TLB_hit), .in4(TLB_rd_wr), .in5(TLB_pcd_not), .in6(cache_hit));
    and5$ and_gate29(.out(and29), .in0(state2_not), .in1(state1), .in2(state0), .in3(write_num_not), .in4(mem_ready));
    and5$ and_gate30(.out(and30), .in0(state2_not), .in1(state1), .in2(state0), .in3(write_num_not), .in4(mem_ready));
    and5$ and_gate31(.out(and31), .in0(state2_not), .in1(state1_not), .in2(state0), .in3(TLB_hit), .in4(cache_hit_not));
    and6$ and_gate32(.out(and32), .in0(state2), .in1(state1_not), .in2(state0_not), .in3(TLB_hit), .in4(TLB_rd_wr), .in5(cache_hit));
    and5$ and_gate33(.out(and33), .in0(state2_not), .in1(state1), .in2(state0), .in3(write_num), .in4(mem_ready));
    and5$ and_gate34(.out(and34), .in0(state2_not), .in1(state1_not), .in2(state0), .in3(TLB_hit), .in4(cache_hit_not));
    and6$ and_gate35(.out(and35), .in0(state2), .in1(state1_not), .in2(state0_not), .in3(TLB_hit), .in4(TLB_rd_wr), .in5(cache_hit));
    and4$ and_gate36(.out(and36), .in0(state2), .in1(state1), .in2(state0_not), .in3(mem_ready));
    and4$ and_gate37(.out(and37), .in0(state2), .in1(state1), .in2(state0_not), .in3(mem_ready));
    and4$ and_gate38(.out(and38), .in0(state2), .in1(state1), .in2(state0_not), .in3(mem_ready_not));
    and5$ and_gate39(.out(and39), .in0(state2_not), .in1(state1_not), .in2(state0), .in3(TLB_hit), .in4(cache_hit_not));
    and5$ and_gate40(.out(and40), .in0(state2), .in1(state1_not), .in2(state0), .in3(bus_grant), .in4(bus_busy_not));
    and3$ and_gate41(.out(and41), .in0(state2_not), .in1(state1), .in2(state0_not));
    and4$ and_gate42(.out(and42), .in0(state2), .in1(state1_not), .in2(state0), .in3(bus_busy));
    and4$ and_gate43(.out(and43), .in0(state2), .in1(state1_not), .in2(state0), .in3(bus_grant_not));
    and8$ and_gate44(.out(and44), .in0(state2_not), .in1(state1_not), .in2(state0), .in3(dp_ready), .in4(read_num_not), .in5(read2_not), .in6(TLB_hit), .in7(cache_hit));
    and8$ and_gate45(.out(and45), .in0(state2_not), .in1(state1_not), .in2(state0), .in3(dp_ready), .in4(read_num), .in5(read2), .in6(TLB_hit), .in7(cache_hit));
    and7$ and_gate46(.out(and46), .in0(state2_not), .in1(state1_not), .in2(state0), .in3(read_num_not), .in4(read2), .in5(TLB_hit), .in6(cache_hit));
    and6$ and_gate47(.out(and47), .in0(state2_not), .in1(state1_not), .in2(state0), .in3(dp_ready_not), .in4(read2), .in5(cache_hit));
    and6$ and_gate48(.out(and48), .in0(state2_not), .in1(state1_not), .in2(state0), .in3(dp_ready_not), .in4(read_num_not), .in5(cache_hit));
    and5$ and_gate49(.out(and49), .in0(state2_not), .in1(state1_not), .in2(state0_not), .in3(rd_valid_not), .in4(wr_valid_not));
    and5$ and_gate50(.out(and50), .in0(state2_not), .in1(state1_not), .in2(state0_not), .in3(rd_valid), .in4(wr_valid_not));
    and6$ and_gate51(.out(and51), .in0(state2), .in1(state1_not), .in2(state0_not), .in3(TLB_hit), .in4(TLB_rd_wr), .in5(cache_hit));
    and3$ and_gate52(.out(and52), .in0(state2), .in1(state1), .in2(state0));
    and4$ and_gate53(.out(and53), .in0(state2_not), .in1(state1_not), .in2(state0_not), .in3(wr_valid));
    and4$ and_gate54(.out(and54), .in0(state2_not), .in1(state1_not), .in2(state0), .in3(TLB_hit_not));
    and4$ and_gate55(.out(and55), .in0(state2), .in1(state1_not), .in2(state0_not), .in3(TLB_rd_wr_not));
    and4$ and_gate56(.out(and56), .in0(state2), .in1(state1_not), .in2(state0_not), .in3(TLB_hit_not));
    and5$ and_gate57(.out(and57), .in0(state2_not), .in1(state1_not), .in2(state0), .in3(TLB_hit), .in4(cache_hit_not));
    and6$ and_gate58(.out(and58), .in0(state2), .in1(state1_not), .in2(state0_not), .in3(TLB_hit), .in4(TLB_rd_wr), .in5(cache_hit));
    and6$ and_gate59(.out(and59), .in0(state2), .in1(state1), .in2(state0_not), .in3(wr_size), .in4(write_num), .in5(bus_grant));
    and7$ and_gate60(.out(and60), .in0(state2), .in1(state1), .in2(state0_not), .in3(wr_size), .in4(write_num), .in5(mem_ready), .in6(bus_grant_not));
    and5$ and_gate61(.out(and61), .in0(state2), .in1(state1_not), .in2(state0), .in3(bus_grant), .in4(bus_busy_not));
    and6$ and_gate62(.out(and62), .in0(state2), .in1(state1_not), .in2(state0_not), .in3(TLB_hit), .in4(TLB_rd_wr), .in5(cache_hit));
    and4$ and_gate63(.out(and63), .in0(state2), .in1(state1), .in2(state0_not), .in3(mem_ready_not));
    and4$ and_gate64(.out(and64), .in0(state2_not), .in1(state1_not), .in2(state0_not), .in3(wr_valid));
    and4$ and_gate65(.out(and65), .in0(state2), .in1(state1_not), .in2(state0), .in3(bus_busy));
    and4$ and_gate66(.out(and66), .in0(state2), .in1(state1_not), .in2(state0), .in3(bus_grant_not));
    and4$ and_gate67(.out(and67), .in0(state2_not), .in1(state1_not), .in2(state0), .in3(TLB_hit_not));
    and4$ and_gate68(.out(and68), .in0(state2), .in1(state1_not), .in2(state0_not), .in3(TLB_rd_wr_not));
    and4$ and_gate69(.out(and69), .in0(state2), .in1(state1_not), .in2(state0_not), .in3(TLB_hit_not));
    and6$ and_gate70(.out(and70), .in0(state2), .in1(state1), .in2(state0_not), .in3(wr_size), .in4(write_num), .in5(bus_grant));
    and5$ and_gate71(.out(and71), .in0(state2_not), .in1(state1), .in2(state0), .in3(write_num), .in4(mem_ready));
    and5$ and_gate72(.out(and72), .in0(state2_not), .in1(state1_not), .in2(state0), .in3(TLB_hit), .in4(cache_hit_not));
    and5$ and_gate73(.out(and73), .in0(state2), .in1(state1_not), .in2(state0), .in3(bus_grant), .in4(bus_busy_not));
    and4$ and_gate74(.out(and74), .in0(state2_not), .in1(state1), .in2(state0), .in3(mem_ready_not));
    and4$ and_gate75(.out(and75), .in0(state2), .in1(state1), .in2(state0_not), .in3(mem_ready_not));
    and3$ and_gate76(.out(and76), .in0(state2_not), .in1(state1), .in2(state0_not));
    and4$ and_gate77(.out(and77), .in0(state2_not), .in1(state1_not), .in2(state0), .in3(TLB_hit_not));
    and4$ and_gate78(.out(and78), .in0(state2), .in1(state1_not), .in2(state0_not), .in3(TLB_rd_wr_not));
    and4$ and_gate79(.out(and79), .in0(state2), .in1(state1_not), .in2(state0_not), .in3(TLB_hit_not));
    and7$ and_gate80(.out(and80), .in0(state2), .in1(state1), .in2(state0_not), .in3(wr_size), .in4(write_num), .in5(mem_ready), .in6(bus_grant_not));
    and4$ and_gate81(.out(and81), .in0(state2_not), .in1(state1), .in2(state0), .in3(bus_grant));
    and7$ and_gate82(.out(and82), .in0(state2_not), .in1(state1_not), .in2(state0), .in3(read_num_not), .in4(read2), .in5(TLB_hit), .in6(cache_hit));
    and6$ and_gate83(.out(and83), .in0(state2_not), .in1(state1_not), .in2(state0), .in3(dp_ready_not), .in4(read2), .in5(cache_hit));
    and6$ and_gate84(.out(and84), .in0(state2_not), .in1(state1_not), .in2(state0), .in3(dp_ready_not), .in4(read_num_not), .in5(cache_hit));
    and4$ and_gate85(.out(and85), .in0(state2_not), .in1(state1), .in2(bus_grant), .in3(bus_busy_not));
    and5$ and_gate86(.out(and86), .in0(state2_not), .in1(state1), .in2(state0), .in3(write_num_not), .in4(mem_ready));
    and5$ and_gate87(.out(and87), .in0(state2_not), .in1(state1_not), .in2(state0_not), .in3(rd_valid), .in4(wr_valid_not));
    and6$ and_gate88(.out(and88), .in0(state2), .in1(state1_not), .in2(state0_not), .in3(TLB_hit), .in4(TLB_rd_wr), .in5(cache_hit));
    and4$ and_gate89(.out(and89), .in0(state2_not), .in1(state1), .in2(state0), .in3(mem_ready_not));
    and4$ and_gate90(.out(and90), .in0(state2), .in1(state1_not), .in2(state0), .in3(bus_busy));
    and4$ and_gate91(.out(and91), .in0(state2), .in1(state1_not), .in2(state0), .in3(bus_grant_not));
    and4$ and_gate92(.out(and92), .in0(state2_not), .in1(state1_not), .in2(state0), .in3(TLB_hit_not));
    and4$ and_gate93(.out(and93), .in0(state2), .in1(state1_not), .in2(state0_not), .in3(TLB_rd_wr_not));
    and4$ and_gate94(.out(and94), .in0(state2), .in1(state1_not), .in2(state0_not), .in3(TLB_hit_not));

    or2$ or_gate0(.out(or0), .in0(and1), .in1(and2));
    or2$ or_gate1(.out(or1), .in0(and3), .in1(and4));
    or9$ or_gate2(.out(or2), .in0(and5), .in1(and6), .in2(and7), .in3(and8), .in4(and9), .in5(and10), .in6(and11), .in7(and12), .in8(and13));
    or2$ or_gate3(.out(or3), .in0(and14), .in1(and15));
    or2$ or_gate4(.out(or4), .in0(and16), .in1(and17));
    or3$ or_gate5(.out(or5), .in0(and18), .in1(and19), .in2(and20));
    or2$ or_gate6(.out(or6), .in0(and21), .in1(and22));
    or5$ or_gate7(.out(or7), .in0(and23), .in1(and24), .in2(and25), .in3(and26), .in4(and27));
    or2$ or_gate8(.out(or8), .in0(and28), .in1(and29));
    or2$ or_gate9(.out(or9), .in0(and31), .in1(and32));
    or4$ or_gate10(.out(or10), .in0(and33), .in1(and34), .in2(and35), .in3(and36));
    or2$ or_gate11(.out(or11), .in0(and37), .in1(and38));
    or5$ or_gate12(.out(or12), .in0(and39), .in1(and40), .in2(and41), .in3(and42), .in4(and43));
    or13$ or_gate13(.out(or13), .in0(and44), .in1(and45), .in2(and46), .in3(and47), .in4(and48), .in5(and49), .in6(and50), .in7(and51), .in8(and52), .in9(and53), .in10(and54), .in11(and55), .in12(and56));
    or2$ or_gate14(.out(or14), .in0(and57), .in1(and58));
    or11$ or_gate15(.out(or15), .in0(and59), .in1(and60), .in2(and61), .in3(and62), .in4(and63), .in5(and64), .in6(and65), .in7(and66), .in8(and67), .in9(and68), .in10(and69));
    or10$ or_gate16(.out(or16), .in0(and70), .in1(and71), .in2(and72), .in3(and73), .in4(and74), .in5(and75), .in6(and76), .in7(and77), .in8(and78), .in9(and79));
    or15$ or_gate17(.out(or17), .in0(and80), .in1(and81), .in2(and82), .in3(and83), .in4(and84), .in5(and85), .in6(and86), .in7(and87), .in8(and88), .in9(and89), .in10(and90), .in11(and91), .in12(and92), .in13(and93), .in14(and94));

    assign page_fault = and0;
    assign rd_ready = or0;
    assign wr_ready = or1;
    assign rd_wr_addr = or2;
    assign req_addr_en = or3;
    assign read_num_sel = or4;
    assign read_num_wr_en = or5;
    assign dp_valid = or6;
    assign busy_out = or7;
    assign write = or8;
    assign valid_src = and30;
    assign write_num_data = or9;
    assign write_num_wr_en = or10;
    assign mem_rd_wr = or11;
    assign mem_req = or12;
    assign grant_pass = or13;
    assign pa_wr_en = or14;
    assign new_state2 = or15;
    assign new_state1 = or16;
    assign new_state0 = or17;

endmodule
