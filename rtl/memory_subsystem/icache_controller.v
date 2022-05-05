module icache_controller(
    clk,
    reset,
    
    // Fetch Interface 
    read_valid,
    read_ready,
    dp_ready,
    dp_valid,
    
    // ICache Internal
    write_num,
    cache_hit,
    write,
    write_num_src,
    pa_src,
    pa_wr_en,
    
    // TLB
    TLB_hit,
    
    // Memory interface
    mem_ready,
    mem_req,

    // Bus
    bus_grant,
    grant_pass,
    bus_busy,
    busy_out,

    req_addr_en,
    page_fault

    
);

    input clk;
    input reset;
    
    // Fetch Interface 
    input read_valid;
    output read_ready;
    input dp_ready;
    output dp_valid;

    // ICache Internal
    input [1:0] write_num;
    input cache_hit;
    output write;
    output write_num_src;
    output pa_src;
    output pa_wr_en;

    // TLB
    input TLB_hit;

    // Memory interface
    input mem_ready;
    output mem_req;

    // Bus
    input bus_grant;
    output grant_pass;
    input bus_busy;
    output busy_out;

    output req_addr_en;
    output page_fault;

    wire [2:0] state;
    wire [2:0] new_state;
  
    icache_combinational_logic icl(
        .state2         (state[2]),
        .state1         (state[1]),
        .state0         (state[0]),
        .write_num      (write_num[1]),
        .write_num0     (write_num[0]),
        .read_valid     (read_valid),
        .dp_ready       (dp_ready),
        .TLB_hit        (TLB_hit),
        .cache_hit      (cache_hit),
        .mem_ready      (mem_ready),
        .bus_grant      (bus_grant),
        .bus_busy       (bus_busy),

        .page_fault     (page_fault),
        .req_addr_en    (req_addr_en),
        .busy_out       (busy_out),
        .write          (write),
        .write_num_src  (write_num_src),
        .mem_req        (mem_req),
        .read_ready     (read_ready),
        .dp_valid       (dp_valid),
        .grant_pass     (grant_pass),
        .pa_src         (pa_src),
        .pa_wr_en       (pa_wr_en),
        .new_state2     (new_state[2]),
        .new_state1     (new_state[1]),
        .new_state0     (new_state[0])
    );

    wire reset_n;
    inv1$ reset_inv(reset_n, reset);

    dff$ 
        fsm0(clk, new_state[0], state[0], , reset_n, 1'b1),
        fsm1(clk, new_state[1], state[1], , reset_n, 1'b1),
        fsm2(clk, new_state[2], state[2], , reset_n, 1'b1);

endmodule
