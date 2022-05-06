module icache(
    clk,
    reset,
    
    req_valid,
    req_ready,
    req_address,
    dp_valid,
    dp_ready,
    dp_read_data,

    //  TLB
    virt_addr,
    phys_addr,
    tlb_hit,
    tlb_pcd,

    // interrupt
    page_fault,
    
    // interface to interconnect
    mem_addr,
    mem_req,
    mem_data_valid,
    mem_data,
    mem_rd_wr,
    mem_en,

    // Arbiter Interface
    grant_in,
    grant_out,

    bus_busy_out,
    bus_busy_in
    
);

    // Instruction Memory Interface Parameters
    parameter IDATAW = 128;
    parameter ISIZEW = 8;
    parameter IADDRW = 32;

    parameter BUSDATAW = 32;
    parameter BUSADDRW = 32; 

    input clk;
    input reset;
  
    // Fetch Stage Interface  
    input               req_valid;
    output              req_ready;
    input  [IADDRW-1:0] req_address;
    output              dp_valid;
    input               dp_ready;
    output [IDATAW-1:0] dp_read_data;

    //  TLB
    input [31:0] phys_addr;
    output [31:0] virt_addr;
    input tlb_hit;
    input tlb_pcd;
    output page_fault;
    
    // Interface to Interconnect
    output [BUSADDRW-1:0]  mem_addr;
    output                 mem_req;
    input                  mem_data_valid;
    input  [BUSDATAW-1:0]  mem_data;
    output                 mem_rd_wr;
    output                 mem_en;

    // Arbitration Signals
    input  grant_in;
    output grant_out;

    output bus_busy_out;
    input bus_busy_in;

    assign mem_rd_wr = 1'b0;

    wire [31:0] req_pending_addr;
    wire req_addr_en;

    register #(.WIDTH(32)) req_addr_reg(clk, reset, req_address, req_pending_addr, , req_addr_en);

    assign virt_addr = req_pending_addr;

    wire [4:0] index = req_pending_addr[8:4];
    wire [22:0] phys_tag = phys_addr[31:9];

    // this should always be 0 for 16B-aligned requests
    wire [3:0] byte_offset = req_pending_addr[3:0];

    wire ctrl_write;

    wire [22:0] tag_out;
    wire valid_out;

    itagRAM tagram(clk, reset, index, ctrl_write, phys_tag, tag_out);
    ivalidRAM validram(clk,reset, index, ctrl_write, 1'b1, valid_out);

    // 23-bit compare
    wire tag_hit;
    compare #(.WIDTH(23)) comp(tag_out, phys_tag, tag_hit);

    wire cache_hit;
    and2$ hit_and(cache_hit, tag_hit, valid_out);

    wire ctrl_pa_src;
    wire ctrl_pa_wr_en;
    wire ctrl_grant_pass;
    wire ctrl_write_num_sel;

    wire [1:0] write_num;

    icache_controller control(
        .clk             (clk),
        .reset           (reset),
        .read_valid      (req_valid),
        .read_ready      (req_ready),
        .dp_ready        (dp_ready),
        .dp_valid        (dp_valid),
        .write_num       (write_num),
        .cache_hit       (cache_hit),
        .write           (ctrl_write),
        .write_num_src   (ctrl_write_num_sel),
        .pa_src          (ctrl_pa_src),
        .pa_wr_en        (ctrl_pa_wr_en),
        .TLB_hit         (tlb_hit),
        .mem_ready       (mem_data_valid),
        .mem_req         (mem_req),
        .bus_grant       (grant_in),
        .grant_pass      (ctrl_grant_pass),
        .bus_busy        (bus_busy_in),
        .busy_out        (bus_busy_out),
        .req_addr_en     (req_addr_en),
        .page_fault      (page_fault)
    );

    // pass along grant signal?
    mux2$ grant_mux(grant_out, 1'b0, grant_in, ctrl_grant_pass);

    wire [1:0] write_num_p1;
    wire [1:0] write_num_mux_out; 
    mux2$ 
        mux20(write_num_mux_out[0], write_num[0], write_num_p1[0], ctrl_write_num_sel),
        mux21(write_num_mux_out[1], write_num[1], write_num_p1[1], ctrl_write_num_sel);
    register #(.WIDTH(2)) write_num_reg(clk, reset, write_num_mux_out, write_num, , 1'b1);
    slow_addr #(.WIDTH(2)) write_num_adder(write_num, 2'b01, write_num_p1, );

    wire [3:0] accum_we;
    decoder2_4$ accum_decoder(write_num, accum_we, );
    // 16B accumulation register
    wire [127:0] accum_out;
    //register #(.WIDTH(32)) accum_reg1(clk, reset, mem_data, accum_out[127:96], , accum_we[3]);
    register #(.WIDTH(32)) accum_reg2(clk, reset, mem_data, accum_out[95:64] , , accum_we[2]);
    register #(.WIDTH(32)) accum_reg3(clk, reset, mem_data, accum_out[63:32] , , accum_we[1]);
    register #(.WIDTH(32)) accum_reg4(clk, reset, mem_data, accum_out[31:0]  , , accum_we[0]);

    assign accum_out[127:96] = mem_data;

    // PA adder and mux (can make this faster with smaller adder (only add last
    // few bits since addresses are 16B-aligned)
    wire [BUSADDRW-1:0] pa_out;
    wire [BUSADDRW-1:0] pa_p4;
    wire [BUSADDRW-1:0] phys_addr_mux_out;
    mux2_16$ 
        pa_mux0(phys_addr_mux_out[15:0], phys_addr[15:0], pa_p4[15:0], ctrl_pa_src),
        pa_mux1(phys_addr_mux_out[31:16], phys_addr[31:16], pa_p4[31:16], ctrl_pa_src);
    register #(.WIDTH(32)) phys_addr_reg(clk, reset, phys_addr_mux_out, pa_out, , ctrl_pa_wr_en);
    slow_addr  #(.WIDTH(32)) phys_addr_adder(pa_out, 32'd4, pa_p4, );

    idataRAM dataram(clk, reset, index, ctrl_write, accum_out, dp_read_data);

    assign mem_en = bus_busy_out;
    assign mem_addr = pa_out;

endmodule
