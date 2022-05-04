module memory_subsystem_top (
    clk,
    reset,

    // Instruction Memory Interface
    imem_valid,
    imem_ready,
    imem_address,
    imem_wr_en,    // unused
    imem_wr_data,  // unused
    imem_wr_size,  // unused
    imem_dp_valid,
    imem_dp_ready,
    imem_dp_read_data,

    // Data Memory Read Interface
    dmem_r_valid,
    dmem_r_ready,
    dmem_r_address,
    dmem_r_wr_en,    // unused
    dmem_r_wr_data,  // unused
    dmem_r_wr_size,  // unused
    dmem_r_dp_valid,
    dmem_r_dp_ready,
    dmem_r_dp_read_data,

    // Data Memory Write Interface
    dmem_w_valid,
    dmem_w_ready,
    dmem_w_address,
    dmem_w_wr_en,    
    dmem_w_wr_data,  
    dmem_w_wr_size,  
    dmem_w_dp_valid,      // unused
    dmem_w_dp_ready,      // unused
    dmem_w_dp_read_data,   // unused

    tlb_contents,
);

    // Instruction Memory Interface Parameters
    parameter IDATAW = 128;
    parameter ISIZEW = 8;
    parameter IADDRW = 32;

    // Data Memory Interface Parameters
    parameter DDATAW = 64;
    parameter DSIZEW = 4;
    parameter DADDRW = 32;

    // Bus Parameters   
    parameter BUSDATAW = 32;
    parameter BUSADDRW = 32; 

    input clk;
    input reset;
 
    // Instruction Memory Interface
    input 	            imem_valid;
    output 	            imem_ready;
    input [IADDRW-1:0]  imem_address;
    input               imem_wr_en;   // unused 
    input [IDATAW-1:0]	imem_wr_data; // unused
    input [ISIZEW-1:0] 	imem_wr_size; // unused
    output              imem_dp_valid;
    input               imem_dp_ready;
    output [IDATAW-1:0] imem_dp_read_data;

    // Data Memory Read Interface
    input 	            dmem_r_valid;
    output 	            dmem_r_ready;
    input [DADDRW-1:0]  dmem_r_address;
    input               dmem_r_wr_en;   // unused 
    input [DDATAW-1:0]	dmem_r_wr_data; // unused
    input [DSIZEW-1:0] 	dmem_r_wr_size; // unused
    output              dmem_r_dp_valid;
    input               dmem_r_dp_ready;
    output [DDATAW-1:0] dmem_r_dp_read_data;

    // Data Memory Write Interface
    input 	            dmem_w_valid;
    output 	            dmem_w_ready;
    input [IADDRW-1:0]  dmem_w_address;
    input               dmem_w_wr_en;
    input [IDATAW-1:0]	dmem_w_wr_data;
    input [ISIZEW-1:0] 	dmem_w_wr_size;
    output              dmem_w_dp_valid;     // unused 
    input               dmem_w_dp_ready;     // unused
    output [IDATAW-1:0] dmem_w_dp_read_data; // unused

    input [351:0] tlb_contents;

    // Interconnect - Busses
    wire [BUSDATAW-1:0] bus_data;
    wire [BUSADDRW-1:0] bus_addr;

    wire bus_req_icache;
    wire bus_req;

    //wire bus_done_icache;
    //wire bus_done;

    wire bus_data_valid;

    wire bus_rd_wr;
    wire bus_en;

    wire bus_busy_icache;
    wire bus_busy_dcache;
    wire bus_busy_sys_controller;
    wire bus_busy_dma;
    wire bus_busy;

    or4$ _or_busy(bus_busy, bus_busy_icache, bus_busy_dcache, bus_busy_sys_controller, bus_busy_dma);


    //or3$(bus_req, bus_req_icache, 1'b0, 1'b0);
    //or3$(bus_done, bus_done_icache, 1'b0, 1'b0);
    //or3$(bus_busy, bus_busy_icache, 1'b0, 1'b0);


    wire arb_grant;
    arbiter arb(
        .clk(clk),
        .reset(reset),
        .req(bus_req),
        //.done(bus_done),
        .grant(arb_grant),
        .busy(bus_busy)
    );

   
    wire dec_rd_wr; 
    wire dec_dma_en;
    wire dec_mem_en;
    wire dec_io_en;
    arb_decoder dec(
        .clk(clk),
        .reset(reset),
        .bus_addr(bus_addr),
        .rd_wr_in(bus_rd_wr),
        .rd_wr_out(dec_rd_wr),
        .en(bus_en),
        .dma_en(dec_dma_en),
        .mem_en(dec_mem_en),
        .io_en(dec_io_en)
    );

    wire tlb_i_hit;
    wire tlb_i_rd_wr;
    wire [31:0] tlb_i_pa;
    wire tlb_i_pcd;

    wire tlb_d_hit;
    wire tlb_d_rd_wr;
    wire [31:0] tlb_d_pa;
    wire tlb_d_pcd;

    wire d_virt_addr;

    TLB tlb(
        .contents(tlb_contents),
        .i_addr_in(imem_address),
        .i_hit(tlb_i_hit),
        .i_rd_wr_out(tlb_i_rd_wr),
        .i_pa_out(tlb_i_pa),
        .i_PCD_out(tlb_i_pcd),
        .d_addr_in(d_virt_addr),
        .d_hit(tlb_d_hit),
        .d_rd_wr_out(tlb_d_rd_wr),
        .d_pa_out(tlb_d_pa),
        .d_PCD_out(tlb_d_pcd)
    );
    //dcache dcache();

    wire icache_grant;
    icache icache(
        .clk(clk),
        .reset(reset),
        .req_valid(imem_valid),
        .req_ready(imem_ready),
        .req_address(imem_address),
        .dp_valid(imem_dp_valid),
        .dp_ready(imem_dp_ready),
        .dp_read_data(imem_dp_read_data),
        .phys_addr(tlb_i_pa),   // from TLB
        .tlb_hit(tlb_i_hit),     // from TLB
        .mem_addr(bus_addr),
        .mem_req(bus_req_icache),
        .mem_data_valid(bus_data_valid),
        .mem_data(bus_data),
        .mem_rd_wr(bus_rd_wr),
        .mem_en(bus_en),
        .grant_in(arb_grant),
        .grant_out(icache_grant),
        .bus_busy_out(bus_busy_icache_out),
        .bus_busy_in(bus_busy)
    );

    //dma_top dma();
    
    main_memory_top main_memory_top(
        .clk(clk),
        .reset(reset),
        .en(dec_mem_en),
        .rd_wr(dec_rd_wr),
        .addr(bus_addr),
        .data(bus_data),
        .valid(bus_data_valid)
    );

    //io_device_top io_device();

endmodule
