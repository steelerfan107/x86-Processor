module dcache_combinational_logic(
    state2, 
    state1,
    state0,
    rd_valid,
    wr_valid,
    wr_done,
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
    addr2_mux,
    wr_cnt_z,
    wr_cnt_en,
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
    input wr_done;
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
    output addr2_mux;
    output wr_cnt_z;
    output wr_cnt_en;
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
    wire and5;
    wire wr_done_not;
    wire and6;
    wire bus_busy_not;
    wire and7;
    wire and8;
    wire mem_ready_not;
    wire and9;
    wire and10;
    wire bus_grant_not;
    wire and11;
    wire TLB_rd_wr_not;
    wire and12;
    wire TLB_hit_not;
    wire and13;
    wire and14;
    wire or2;
    wire and15;
    wire and16;
    wire and17;
    wire or3;
    wire and18;
    wire and19;
    wire and20;
    wire or4;
    wire and21;
    wire and22;
    wire and23;
    wire or5;
    wire read_num_not;
    wire and24;
    wire write_num_not;
    wire and25;
    wire or6;
    wire and26;
    wire and27;
    wire and28;
    wire or7;
    wire read2_not;
    wire and29;
    wire and30;
    wire or8;
    wire and31;
    wire and32;
    wire and33;
    wire and34;
    wire and35;
    wire and36;
    wire or9;
    wire TLB_pcd_not;
    wire and37;
    wire and38;
    wire or10;
    wire and39;
    wire cache_hit_not;
    wire and40;
    wire and41;
    wire and42;
    wire or11;
    wire and43;
    wire and44;
    wire and45;
    wire and46;
    wire or12;
    wire and47;
    wire and48;
    wire and49;
    wire or13;
    wire and50;
    wire and51;
    wire and52;
    wire and53;
    wire and54;
    wire or14;
    wire and55;
    wire and56;
    wire and57;
    wire dp_ready_not;
    wire and58;
    wire and59;
    wire and60;
    wire and61;
    wire and62;
    wire and63;
    wire and64;
    wire or15;
    wire and65;
    wire and66;
    wire or16;
    wire and67;
    wire and68;
    wire and69;
    wire and70;
    wire and71;
    wire and72;
    wire and73;
    wire and74;
    wire and75;
    wire and76;
    wire or17;
    wire and77;
    wire and78;
    wire and79;
    wire and80;
    wire and81;
    wire and82;
    wire and83;
    wire and84;
    wire and85;
    wire or18;
    wire and86;
    wire and87;
    wire and88;
    wire and89;
    wire and90;
    wire and91;
    wire and92;
    wire and93;
    wire and94;
    wire and95;
    wire and96;
    wire and97;
    wire and98;
    wire and99;
    wire or19;

    inv1$ state2_inv (.out(state2_not), .in(state2));
    inv1$ state1_inv (.out(state1_not), .in(state1));
    inv1$ state0_inv (.out(state0_not), .in(state0));
    inv1$ rd_valid_inv (.out(rd_valid_not), .in(rd_valid));
    inv1$ wr_valid_inv (.out(wr_valid_not), .in(wr_valid));
    inv1$ wr_done_inv (.out(wr_done_not), .in(wr_done));
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
    and5$ and_gate5(.out(and5), .in0(state2), .in1(state1), .in2(state0_not), .in3(wr_done), .in4(mem_ready));
    and5$ and_gate6(.out(and6), .in0(state2), .in1(state1), .in2(state0_not), .in3(wr_done_not), .in4(mem_ready));
    and5$ and_gate7(.out(and7), .in0(state2), .in1(state1_not), .in2(state0), .in3(bus_grant), .in4(bus_busy_not));
    and5$ and_gate8(.out(and8), .in0(state2), .in1(state1_not), .in2(state0_not), .in3(TLB_hit), .in4(TLB_rd_wr));
    and4$ and_gate9(.out(and9), .in0(state2), .in1(state1), .in2(state0_not), .in3(mem_ready_not));
    and4$ and_gate10(.out(and10), .in0(state2), .in1(state1_not), .in2(state0), .in3(bus_busy));
    and4$ and_gate11(.out(and11), .in0(state2), .in1(state1_not), .in2(state0), .in3(bus_grant_not));
    and4$ and_gate12(.out(and12), .in0(state2), .in1(state1_not), .in2(state0_not), .in3(TLB_rd_wr_not));
    and4$ and_gate13(.out(and13), .in0(state2), .in1(state1_not), .in2(state0_not), .in3(TLB_hit_not));
    and4$ and_gate14(.out(and14), .in0(state2_not), .in1(state1_not), .in2(state0_not), .in3(wr_valid));
    and5$ and_gate15(.out(and15), .in0(state2), .in1(state1), .in2(state0_not), .in3(wr_done_not), .in4(mem_ready));
    and5$ and_gate16(.out(and16), .in0(state2_not), .in1(state1_not), .in2(state0_not), .in3(rd_valid), .in4(wr_valid_not));
    and4$ and_gate17(.out(and17), .in0(state2_not), .in1(state1_not), .in2(state0_not), .in3(wr_valid));
    and5$ and_gate18(.out(and18), .in0(state2), .in1(state1), .in2(state0_not), .in3(wr_done_not), .in4(mem_ready));
    and5$ and_gate19(.out(and19), .in0(state2), .in1(state1), .in2(state0_not), .in3(wr_done), .in4(mem_ready));
    and4$ and_gate20(.out(and20), .in0(state2_not), .in1(state1_not), .in2(state0_not), .in3(wr_valid));
    and5$ and_gate21(.out(and21), .in0(state2), .in1(state1), .in2(state0_not), .in3(wr_done), .in4(mem_ready));
    and5$ and_gate22(.out(and22), .in0(state2), .in1(state1), .in2(state0_not), .in3(wr_done_not), .in4(mem_ready));
    and4$ and_gate23(.out(and23), .in0(state2_not), .in1(state1_not), .in2(state0_not), .in3(wr_valid));
    and7$ and_gate24(.out(and24), .in0(state2_not), .in1(state1_not), .in2(state0), .in3(read_num_not), .in4(read2), .in5(TLB_hit), .in6(cache_hit));
    and5$ and_gate25(.out(and25), .in0(state2_not), .in1(state1), .in2(state0), .in3(write_num_not), .in4(mem_ready));
    and7$ and_gate26(.out(and26), .in0(state2_not), .in1(state1_not), .in2(state0), .in3(read_num_not), .in4(read2), .in5(TLB_hit), .in6(cache_hit));
    and5$ and_gate27(.out(and27), .in0(state2_not), .in1(state1), .in2(state0), .in3(write_num_not), .in4(mem_ready));
    and5$ and_gate28(.out(and28), .in0(state2_not), .in1(state1_not), .in2(state0_not), .in3(rd_valid), .in4(wr_valid_not));
    and8$ and_gate29(.out(and29), .in0(state2_not), .in1(state1_not), .in2(state0), .in3(dp_ready), .in4(read_num_not), .in5(read2_not), .in6(TLB_hit), .in7(cache_hit));
    and8$ and_gate30(.out(and30), .in0(state2_not), .in1(state1_not), .in2(state0), .in3(dp_ready), .in4(read_num), .in5(read2), .in6(TLB_hit), .in7(cache_hit));
    and5$ and_gate31(.out(and31), .in0(state2), .in1(state1), .in2(state0_not), .in3(wr_done), .in4(mem_ready));
    and5$ and_gate32(.out(and32), .in0(state2_not), .in1(state1), .in2(state0), .in3(write_num), .in4(mem_ready));
    and5$ and_gate33(.out(and33), .in0(state2), .in1(state1), .in2(state0_not), .in3(wr_done_not), .in4(mem_ready));
    and5$ and_gate34(.out(and34), .in0(state2_not), .in1(state1), .in2(state0), .in3(write_num_not), .in4(mem_ready));
    and4$ and_gate35(.out(and35), .in0(state2_not), .in1(state1), .in2(state0), .in3(mem_ready_not));
    and4$ and_gate36(.out(and36), .in0(state2), .in1(state1), .in2(state0_not), .in3(mem_ready_not));
    and7$ and_gate37(.out(and37), .in0(state2), .in1(state1_not), .in2(state0_not), .in3(TLB_hit), .in4(TLB_rd_wr), .in5(TLB_pcd_not), .in6(cache_hit));
    and5$ and_gate38(.out(and38), .in0(state2_not), .in1(state1), .in2(state0), .in3(write_num_not), .in4(mem_ready));
    and5$ and_gate39(.out(and39), .in0(state2_not), .in1(state1), .in2(state0), .in3(write_num_not), .in4(mem_ready));
    and5$ and_gate40(.out(and40), .in0(state2_not), .in1(state1_not), .in2(state0), .in3(TLB_hit), .in4(cache_hit_not));
    and5$ and_gate41(.out(and41), .in0(state2), .in1(state1_not), .in2(state0_not), .in3(TLB_hit), .in4(TLB_rd_wr));
    and4$ and_gate42(.out(and42), .in0(state2_not), .in1(state1_not), .in2(state0_not), .in3(wr_valid));
    and5$ and_gate43(.out(and43), .in0(state2_not), .in1(state1), .in2(state0), .in3(write_num), .in4(mem_ready));
    and5$ and_gate44(.out(and44), .in0(state2_not), .in1(state1_not), .in2(state0), .in3(TLB_hit), .in4(cache_hit_not));
    and5$ and_gate45(.out(and45), .in0(state2), .in1(state1_not), .in2(state0_not), .in3(TLB_hit), .in4(TLB_rd_wr));
    and4$ and_gate46(.out(and46), .in0(state2_not), .in1(state1_not), .in2(state0_not), .in3(wr_valid));
    and5$ and_gate47(.out(and47), .in0(state2), .in1(state1), .in2(state0_not), .in3(wr_done), .in4(mem_ready));
    and5$ and_gate48(.out(and48), .in0(state2), .in1(state1), .in2(state0_not), .in3(wr_done_not), .in4(mem_ready));
    and4$ and_gate49(.out(and49), .in0(state2), .in1(state1), .in2(state0_not), .in3(mem_ready_not));
    and5$ and_gate50(.out(and50), .in0(state2_not), .in1(state1_not), .in2(state0), .in3(TLB_hit), .in4(cache_hit_not));
    and5$ and_gate51(.out(and51), .in0(state2), .in1(state1_not), .in2(state0), .in3(bus_grant), .in4(bus_busy_not));
    and3$ and_gate52(.out(and52), .in0(state2_not), .in1(state1), .in2(state0_not));
    and4$ and_gate53(.out(and53), .in0(state2), .in1(state1_not), .in2(state0), .in3(bus_busy));
    and4$ and_gate54(.out(and54), .in0(state2), .in1(state1_not), .in2(state0), .in3(bus_grant_not));
    and8$ and_gate55(.out(and55), .in0(state2_not), .in1(state1_not), .in2(state0), .in3(dp_ready), .in4(read_num_not), .in5(read2_not), .in6(TLB_hit), .in7(cache_hit));
    and8$ and_gate56(.out(and56), .in0(state2_not), .in1(state1_not), .in2(state0), .in3(dp_ready), .in4(read_num), .in5(read2), .in6(TLB_hit), .in7(cache_hit));
    and7$ and_gate57(.out(and57), .in0(state2_not), .in1(state1_not), .in2(state0), .in3(read_num_not), .in4(read2), .in5(TLB_hit), .in6(cache_hit));
    and6$ and_gate58(.out(and58), .in0(state2_not), .in1(state1_not), .in2(state0), .in3(dp_ready_not), .in4(read2), .in5(cache_hit));
    and6$ and_gate59(.out(and59), .in0(state2_not), .in1(state1_not), .in2(state0), .in3(dp_ready_not), .in4(read_num_not), .in5(cache_hit));
    and5$ and_gate60(.out(and60), .in0(state2_not), .in1(state1_not), .in2(state0_not), .in3(rd_valid_not), .in4(wr_valid_not));
    and5$ and_gate61(.out(and61), .in0(state2_not), .in1(state1_not), .in2(state0_not), .in3(rd_valid), .in4(wr_valid_not));
    and3$ and_gate62(.out(and62), .in0(state2), .in1(state1), .in2(state0));
    and4$ and_gate63(.out(and63), .in0(state2_not), .in1(state1_not), .in2(state0_not), .in3(wr_valid));
    and4$ and_gate64(.out(and64), .in0(state2_not), .in1(state1_not), .in2(state0), .in3(TLB_hit_not));
    and5$ and_gate65(.out(and65), .in0(state2_not), .in1(state1_not), .in2(state0), .in3(TLB_hit), .in4(cache_hit_not));
    and5$ and_gate66(.out(and66), .in0(state2), .in1(state1_not), .in2(state0_not), .in3(TLB_hit), .in4(TLB_rd_wr));
    and5$ and_gate67(.out(and67), .in0(state2), .in1(state1), .in2(state0_not), .in3(wr_done_not), .in4(mem_ready));
    and5$ and_gate68(.out(and68), .in0(state2), .in1(state1_not), .in2(state0), .in3(bus_grant), .in4(bus_busy_not));
    and5$ and_gate69(.out(and69), .in0(state2), .in1(state1_not), .in2(state0_not), .in3(TLB_hit), .in4(TLB_rd_wr));
    and4$ and_gate70(.out(and70), .in0(state2), .in1(state1), .in2(state0_not), .in3(mem_ready_not));
    and4$ and_gate71(.out(and71), .in0(state2), .in1(state1_not), .in2(state0), .in3(bus_busy));
    and4$ and_gate72(.out(and72), .in0(state2), .in1(state1_not), .in2(state0), .in3(bus_grant_not));
    and4$ and_gate73(.out(and73), .in0(state2), .in1(state1_not), .in2(state0_not), .in3(TLB_rd_wr_not));
    and4$ and_gate74(.out(and74), .in0(state2), .in1(state1_not), .in2(state0_not), .in3(TLB_hit_not));
    and4$ and_gate75(.out(and75), .in0(state2_not), .in1(state1_not), .in2(state0_not), .in3(wr_valid));
    and4$ and_gate76(.out(and76), .in0(state2_not), .in1(state1_not), .in2(state0), .in3(TLB_hit_not));
    and5$ and_gate77(.out(and77), .in0(state2_not), .in1(state1), .in2(state0), .in3(write_num), .in4(mem_ready));
    and5$ and_gate78(.out(and78), .in0(state2_not), .in1(state1_not), .in2(state0), .in3(TLB_hit), .in4(cache_hit_not));
    and5$ and_gate79(.out(and79), .in0(state2), .in1(state1_not), .in2(state0), .in3(bus_grant), .in4(bus_busy_not));
    and4$ and_gate80(.out(and80), .in0(state2_not), .in1(state1), .in2(state0), .in3(mem_ready_not));
    and4$ and_gate81(.out(and81), .in0(state2), .in1(state1), .in2(state0_not), .in3(mem_ready_not));
    and3$ and_gate82(.out(and82), .in0(state2_not), .in1(state1), .in2(state0_not));
    and4$ and_gate83(.out(and83), .in0(state2), .in1(state1_not), .in2(state0_not), .in3(TLB_rd_wr_not));
    and4$ and_gate84(.out(and84), .in0(state2), .in1(state1_not), .in2(state0_not), .in3(TLB_hit_not));
    and4$ and_gate85(.out(and85), .in0(state2_not), .in1(state1_not), .in2(state0), .in3(TLB_hit_not));
    and4$ and_gate86(.out(and86), .in0(state2_not), .in1(state1), .in2(state0), .in3(bus_grant));
    and7$ and_gate87(.out(and87), .in0(state2_not), .in1(state1_not), .in2(state0), .in3(read_num_not), .in4(read2), .in5(TLB_hit), .in6(cache_hit));
    and6$ and_gate88(.out(and88), .in0(state2_not), .in1(state1_not), .in2(state0), .in3(dp_ready_not), .in4(read2), .in5(cache_hit));
    and6$ and_gate89(.out(and89), .in0(state2_not), .in1(state1_not), .in2(state0), .in3(dp_ready_not), .in4(read_num_not), .in5(cache_hit));
    and4$ and_gate90(.out(and90), .in0(state2_not), .in1(state1), .in2(bus_grant), .in3(bus_busy_not));
    and5$ and_gate91(.out(and91), .in0(state2_not), .in1(state1), .in2(state0), .in3(write_num_not), .in4(mem_ready));
    and5$ and_gate92(.out(and92), .in0(state2_not), .in1(state1_not), .in2(state0_not), .in3(rd_valid), .in4(wr_valid_not));
    and5$ and_gate93(.out(and93), .in0(state2), .in1(state1_not), .in2(state0_not), .in3(TLB_hit), .in4(TLB_rd_wr));
    and4$ and_gate94(.out(and94), .in0(state2_not), .in1(state1), .in2(state0), .in3(mem_ready_not));
    and4$ and_gate95(.out(and95), .in0(state2), .in1(state1_not), .in2(state0), .in3(bus_busy));
    and4$ and_gate96(.out(and96), .in0(state2), .in1(state1_not), .in2(state0), .in3(bus_grant_not));
    and4$ and_gate97(.out(and97), .in0(state2), .in1(state1_not), .in2(state0_not), .in3(TLB_rd_wr_not));
    and4$ and_gate98(.out(and98), .in0(state2), .in1(state1_not), .in2(state0_not), .in3(TLB_hit_not));
    and4$ and_gate99(.out(and99), .in0(state2_not), .in1(state1_not), .in2(state0), .in3(TLB_hit_not));

    or2$ or_gate0(.out(or0), .in0(and1), .in1(and2));
    or2$ or_gate1(.out(or1), .in0(and3), .in1(and4));
    or10$ or_gate2(.out(or2), .in0(and5), .in1(and6), .in2(and7), .in3(and8), .in4(and9), .in5(and10), .in6(and11), .in7(and12), .in8(and13), .in9(and14));
    or3$ or_gate3(.out(or3), .in0(and15), .in1(and16), .in2(and17));
    or2$ or_gate4(.out(or4), .in0(and19), .in1(and20));
    or3$ or_gate5(.out(or5), .in0(and21), .in1(and22), .in2(and23));
    or2$ or_gate6(.out(or6), .in0(and24), .in1(and25));
    or3$ or_gate7(.out(or7), .in0(and26), .in1(and27), .in2(and28));
    or2$ or_gate8(.out(or8), .in0(and29), .in1(and30));
    or6$ or_gate9(.out(or9), .in0(and31), .in1(and32), .in2(and33), .in3(and34), .in4(and35), .in5(and36));
    or2$ or_gate10(.out(or10), .in0(and37), .in1(and38));
    or3$ or_gate11(.out(or11), .in0(and40), .in1(and41), .in2(and42));
    or4$ or_gate12(.out(or12), .in0(and43), .in1(and44), .in2(and45), .in3(and46));
    or3$ or_gate13(.out(or13), .in0(and47), .in1(and48), .in2(and49));
    or5$ or_gate14(.out(or14), .in0(and50), .in1(and51), .in2(and52), .in3(and53), .in4(and54));
    or10$ or_gate15(.out(or15), .in0(and55), .in1(and56), .in2(and57), .in3(and58), .in4(and59), .in5(and60), .in6(and61), .in7(and62), .in8(and63), .in9(and64));
    or2$ or_gate16(.out(or16), .in0(and65), .in1(and66));
    or10$ or_gate17(.out(or17), .in0(and67), .in1(and68), .in2(and69), .in3(and70), .in4(and71), .in5(and72), .in6(and73), .in7(and74), .in8(and75), .in9(and76));
    or9$ or_gate18(.out(or18), .in0(and77), .in1(and78), .in2(and79), .in3(and80), .in4(and81), .in5(and82), .in6(and83), .in7(and84), .in8(and85));
    or14$ or_gate19(.out(or19), .in0(and86), .in1(and87), .in2(and88), .in3(and89), .in4(and90), .in5(and91), .in6(and92), .in7(and93), .in8(and94), .in9(and95), .in10(and96), .in11(and97), .in12(and98), .in13(and99));

    assign page_fault = and0;
    assign rd_ready = or0;
    assign wr_ready = or1;
    assign rd_wr_addr = or2;
    assign req_addr_en = or3;
    assign addr2_mux = and18;
    assign wr_cnt_z = or4;
    assign wr_cnt_en = or5;
    assign read_num_sel = or6;
    assign read_num_wr_en = or7;
    assign dp_valid = or8;
    assign busy_out = or9;
    assign write = or10;
    assign valid_src = and39;
    assign write_num_data = or11;
    assign write_num_wr_en = or12;
    assign mem_rd_wr = or13;
    assign mem_req = or14;
    assign grant_pass = or15;
    assign pa_wr_en = or16;
    assign new_state2 = or17;
    assign new_state1 = or18;
    assign new_state0 = or19;
endmodule
