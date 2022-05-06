module dcache(
    clk,
    reset,
   
    // read interface 
    rd_req_valid,
    rd_req_ready,
    rd_req_address,
    rd_dp_valid,
    rd_dp_ready,
    rd_dp_read_data,

    //  TLB
    virt_addr,
    phys_addr,
    tlb_hit,
    tlb_pcd,

    // write interface
    // TODO ...
    wr_req_valid,
    wr_req_ready,
    wr_req_address,
    wr_req_data,
    wr_size,

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
    input clk;
    input reset;
   
    // read interface 
    input rd_req_valid;
    output rd_req_ready;
    input [31:0] rd_req_address;
    output rd_dp_valid;
    input rd_dp_ready;
    output [63:0] rd_dp_read_data;

    //  TLB
    output [31:0] virt_addr;
    input [31:0] phys_addr;
    input tlb_hit;
    input tlb_pcd;

    // write interface
    // TODO ...
    input wr_req_valid;
    output wr_req_ready;
    input [31:0] wr_req_address;
    input [63:0] wr_req_data;
    input wr_size;

    // interrupt
    input page_fault;

    // interface to interconnect
    output [31:0] mem_addr;
    output mem_req;
    output mem_data_valid;
    output [31:0] mem_data;
    output mem_rd_wr;
    output mem_en;

    // Arbiter Interface
    input grant_in;
    output grant_out;

    output bus_busy_out;
    input bus_busy_in;

    wire ctrl_write;
    wire ctrl_rd_wr_addr;

    wire [31:0] addr_mux_out;
    mux #(.WIDTH(32), .INPUTS(2)) rd_wr_mux({rd_req_address, wr_req_address},  addr_mux_out, ctrl_rd_wr_addr);

    wire [31:0] req_pending_addr;
    wire ctrl_req_addr_en;
    
    register #(.WIDTH(32)) req_addr_reg(clk, reset, addr_mux_out, req_pending_addr, , ctrl_req_addr_en);

    wire virt_addr_mux_sel;
    wire [31:0] req_pending_addr_p8;
    slow_addr #(.WIDTH(32)) block_sel_adder(req_pending_addr, 32'd8, req_pending_addr_p8,);
    mux #(.WIDTH(32), .INPUTS(2)) virt_addr_mux({req_pending_addr, req_pending_addr_p8},  virt_addr, virt_addr_mux_sel);

    wire [5:0] index = virt_addr[8:3];
    wire [22:0] phys_tag = phys_addr[31:9];
    wire [2:0] byte_offset = virt_addr[2:0];

    wire [22:0] tag_out;
    wire valid_out;

    wire valid_in;

    wire [31:0] pa_out;
    wire [31:0] pa_p4;
    wire [31:0] pa_reg_out;

    wire ctrl_pa_src;
    wire ctrl_pa_wr_en;

    mux2_16$ 
        pa_mux0(pa_out[15:0], pa_reg_out[15:0], pa_p4[15:0], ctrl_pa_src),
        pa_mux1(pa_out[31:16], pa_reg_out[31:16], pa_p4[31:16], ctrl_pa_src);
    register #(.WIDTH(32)) phys_addr_reg(clk, reset, phys_addr, pa_reg_out, , ctrl_pa_wr_en);
    slow_addr  #(.WIDTH(32)) phys_addr_adder(pa_reg_out, 32'd4, pa_p4, );

    dtagRAM tagram(clk, reset, index, ctrl_write, phys_tag, tag_out);
    dvalidRAM validram(clk, reset, index, ctrl_write, valid_in, valid_out);

    // 23-bit compare
    wire tag_hit;
    compare #(.WIDTH(23)) comp(tag_out, phys_tag, tag_hit);

    wire cache_hit;
    and2$ hit_and(cache_hit, tag_hit, valid_out);

    wire ctrl_write_num_wr_en;
    wire ctrl_write_num_data;
    wire ctrl_read_num_sel;
    wire ctrl_read_num_wr_en;
    wire ctrl_staging_wr_en;
    wire ctrl_wr_data_reg_wr_en;
    wire ctrl_drive_bus;
    wire ctrl_read2;

    dcache_controller control();

    wire read_num;

    assign virt_addr_mux_sel = read_num;
    
    wire read_num_n;
    inv1$ read_num_inv(read_num_n, read_num);
    and2$ staging_and(staging_wr_en, read_num_n, ctrl_write)

    wire is_aligned;
    assign ctrl_read2 = is_aligned;
    or3$ alignment_or(is_aligned, virt_addr[2], virt_addr[1], virt_addr[0]);
    wire read_num_mux_out;
    mux2$ read_num_mux(read_num_mux_out, 1'b0, is_aligned, ctrl_read_num_sel);
    register #(.WIDTH(1)) read_num_reg(clk, reset, read_num_mux_out, read_num, , ctrl_read_num_wr_en);

    // pass along grant signal?
    mux2$ grant_mux(grant_out, 1'b0, grant_in, ctrl_grant_pass);

  
    wire write_num; 
    // write_num reg and hardware here
    register #(.WIDTH(1)) write_num_reg(clk, reset, ctrl_write_num_data, write_num, , ctrl_write_num_wr_en);
  
    // FIXME enable should be write_num && rd -- nevermind its fine
    wire [31:0] accum_reg_out;
    register #(.WIDTH(32)) accum_reg(clk, reset, mem_data, accum_reg_out, , write_num);

    wire [63:0] dataram_in;
    assign dataram_in = {mem_data, accum_reg_out};

    wire [63:0] dataram_out;
    ddataRAM dataram(clk, reset, index, ctrl_write, dataram_in, dataram_out); 

    wire [63:0] staging_reg_out;
    register #(.WIDTH(64)) staging_reg(clk, reset, dataram_in, staging_reg_out, , ctrl_staging_wr_en);

    d_align align_result(
        .in_high(dataram_out),
        .in_low(staging_reg_out),
        .offset(byte_offset),
        .out(dp_read_data)
    );

    wire [63:0] wr_data_reg_out;
    register #(.WIDTH(64)) wr_data_reg(clk, reset, wr_data, wr_data_reg_out, , ctrl_wr_data_reg_wr_en);
 
    wire [31:0] mem_data_driver; 
    mux #(.WIDTH(32), .INPUTS(2)) mem_data_mux(wr_data_reg_out, mem_data_driver, write_num);
     
    wire n_drive_bus; 
    inv1$ drive_bus_inv(n_drive_bus, ctrl_drive_bus);

    tristate_bus_driver16$ data_bus_driver1(n_drive_bus, mem_data_driver[15:0], mem_data[15:0]);
    tristate_bus_driver16$ data_bus_driver2(n_drive_bus, mem_data_driver[31:16], mem_data[31:16]);

endmodule
