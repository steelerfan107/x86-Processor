module dcache_controller(
    input clk,
    input reset,
    
    // read interface 
    input rd_valid,
    output rd_ready,
    input dp_ready,
    output dp_valid,

    // write interface
    input wr_valid,
    output wr_ready,
    input wr_done,

    // DCache Internal
    input write_num,
    input read_num,
    input cache_hit,
    input tlb_rd_wr,
    output write,
    output write_num_data,
    output write_num_wr_en,
    output read_num_sel,
    output read_num_wr_en,
    input read2,
    output pa_wr_en,
    output rd_wr_addr,
    output req_addr_en,
    output valid_src,

    output addr2_mux,
    output wr_cnt_z,
    output wr_cnt_en,

    // TLB
    input TLB_hit,
    input TLB_rd_wr,
    input TLB_pcd,

    // Memory interface
    input mem_ready,
    output mem_req,
    output mem_rd_wr,

    // Bus
    input bus_grant,
    output grant_pass,
    input bus_busy,
    output busy_out,

    output page_fault
    
);
    
    wire [2:0] state;
    wire [2:0] new_state;

    wire reset_n;
    inv1$ reset_inv(reset_n, reset);

    wire write_num_n;
    inv1$ write_num_inv(write_num_n, write_num);
    assign pa_src = write_num_n;


    // TODO add wr_size
    dcache_combinational_logic dcl(
        .state2             (state[2]), 
        .state1             (state[1]),
        .state0             (state[0]),
        .rd_valid           (rd_valid),
        .wr_valid           (wr_valid),
        .wr_done            (wr_done),
        .dp_ready           (dp_ready),
        .write_num          (write_num), 
        .read_num           (read_num),
        .read2              (read2), 
        .TLB_hit            (TLB_hit),
        .TLB_rd_wr          (tlb_rd_wr),
        .TLB_pcd            (TLB_pcd),
        .cache_hit          (cache_hit), 
        .mem_ready          (mem_ready), 
        .bus_grant          (bus_grant), 
        .bus_busy           (bus_busy),
        .page_fault         (page_fault),
        .rd_ready           (rd_ready),
        .wr_ready           (wr_ready),
        .rd_wr_addr         (rd_wr_addr),
        .req_addr_en        (req_addr_en),
        .addr2_mux          (addr2_mux),
        .wr_cnt_z           (wr_cnt_z),
        .wr_cnt_en          (wr_cnt_en),
        .read_num_sel       (read_num_sel),
        .read_num_wr_en     (read_num_wr_en),
        .dp_valid           (dp_valid),
        .busy_out           (busy_out),
        .write              (write), 
        .valid_src          (valid_src),
        .write_num_data     (write_num_data),
        .write_num_wr_en    (write_num_wr_en), 
        .mem_req            (mem_req), 
        .mem_rd_wr          (mem_rd_wr),
        .grant_pass         (grant_pass),
        .pa_wr_en           (pa_wr_en),
        .new_state2         (new_state[2]),
        .new_state1         (new_state[1]),
        .new_state0         (new_state[0])
    );

    dff$ 
        fsm0(clk, new_state[0], state[0], , reset_n, 1'b1),
        fsm1(clk, new_state[1], state[1], , reset_n, 1'b1),
        fsm2(clk, new_state[2], state[2], , reset_n, 1'b1);
endmodule
