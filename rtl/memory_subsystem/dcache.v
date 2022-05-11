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
    tlb_rd_wr,

    // write interface
    // TODO ...
    wr_req_valid,
    wr_req_ready,
    wr_req_address,
    wr_req_data,
    wr_size_in,

    // interrupt
    page_fault,
    
    // interface to interconnect
    mem_addr,
    mem_req,
    mem_data_valid,
    mem_data,
    mem_rd_wr,
    mem_en,
    mem_wr_size,


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
    input tlb_rd_wr;

    // write interface
    // TODO ...
    input wr_req_valid;
    output wr_req_ready;
    input [31:0] wr_req_address;
    input [63:0] wr_req_data;
    input wr_size_in;

    // interrupt
    output page_fault;

    // interface to interconnect
    output [31:0] mem_addr;
    output mem_req;
    input  mem_data_valid;
    output [31:0] mem_data;
    output mem_rd_wr;
    output mem_en;
    output [1:0] mem_wr_size;

    // Arbiter Interface
    input grant_in;
    output grant_out;

    output bus_busy_out;
    input bus_busy_in;

    wire ctrl_write;
    wire ctrl_rd_wr_addr;

    //tristate_bus_driver1$(~bus_busy_out, bus_busy_out, mem_en);
    assign mem_en = bus_busy_out;
   
    wire ctrl_write_cnt_z;
    wire ctrl_write_cnt_en;

    wire [5:0] index = virt_addr[8:3];
    wire [22:0] phys_tag = phys_addr[31:9];

    wire [1:0] byte_offset;

    wire [1:0] write_cnt;
    wire [1:0] write_cnt_mux_out;
    wire [1:0] write_cnt_p1;
    assign write_cnt_p1 = write_cnt + 1;
    mux #(.WIDTH(2), .INPUTS(2)) write_cnt_mux({2'b0, write_cnt_p1}, write_cnt_mux_out, ctrl_write_cnt_z);
    register #(.WIDTH(2)) write_cnt_reg(clk, reset, write_cnt_mux_out, write_cnt, , ctrl_write_cnt_en );

    wire [31:0] addr_mux_out;
    mux #(.WIDTH(32), .INPUTS(2)) rd_wr_mux({wr_req_address, rd_req_address},  addr_mux_out, ctrl_rd_wr_addr);

    wire [31:0] req_pending_addr;
    wire ctrl_req_addr_en;

    // TODO behavioral
    wire [2:0] offset_mux_out;
    mux #(.WIDTH(3), .INPUTS(2)) offset_mux({3'd4, 3'd4 - byte_offset}, offset_mux_out, write_cnt[0]);

    wire [31:0] addr2_adder_out;
    slow_addr #(.WIDTH(32)) addr2_adder({29'h0, offset_mux_out}, req_pending_addr, addr2_adder_out,  );

    wire [31:0] addr_mux2_out;
    mux #(.WIDTH(32), .INPUTS(2)) addr_mux2({addr2_adder_out, addr_mux_out},  addr_mux2_out, ctrl_addr2_mux);

    wire [1:0] byte_offset_in = addr_mux2_out[1:0];
   
 
    register #(.WIDTH(32)) req_addr_reg(clk, reset, addr_mux2_out, req_pending_addr, , ctrl_req_addr_en);

    wire virt_addr_mux_sel;
    wire [31:0] req_pending_addr_p8;
    slow_addr #(.WIDTH(32)) block_sel_adder(req_pending_addr, 32'd8, req_pending_addr_p8,);
    mux #(.WIDTH(32), .INPUTS(2)) virt_addr_mux({ req_pending_addr_p8, req_pending_addr},  virt_addr, virt_addr_mux_sel);


    wire [22:0] tag_out;
    wire valid_out;

    wire valid_in;

    wire [31:0] pa_out;
    wire [31:0] pa_p4;
    wire [31:0] pa_reg_out;

    wire ctrl_pa_src;
    wire ctrl_pa_wr_en;
    wire wr_size;
    wire write_num; 

    wire write_num_n;
    inv1$ write_num_inv(write_num_n, write_num);

    assign ctrl_pa_src = write_num_n;

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
    wire ctrl_read2;
    wire ctrl_grant_pass;
    wire wr_done;

    wire read_num;
    wire  mem_rd_wr_comb;
   
   
    dcache_controller control(
        .clk(clk),
        .reset(reset),
        .rd_valid(rd_req_valid),
        .rd_ready(rd_req_ready),
        .dp_ready(rd_dp_ready),
        .dp_valid(rd_dp_valid),
        .wr_valid(wr_req_valid),
        .wr_ready(wr_req_ready),
        .wr_done(wr_done),
        .write_num(write_num),
        .read_num(read_num),
        .cache_hit(cache_hit),
        .tlb_rd_wr(tlb_rd_wr),
        .write(ctrl_write),
        .write_num_data(ctrl_write_num_data),
        .write_num_wr_en(ctrl_write_num_wr_en),
        .read_num_sel(ctrl_read_num_sel),
        .read_num_wr_en(ctrl_read_num_wr_en),
        .read2(ctrl_read2),
        .pa_wr_en(ctrl_pa_wr_en),
        .rd_wr_addr(ctrl_rd_wr_addr),
        .req_addr_en(ctrl_req_addr_en),
        .addr2_mux(ctrl_addr2_mux),
        .wr_cnt_z(ctrl_write_cnt_z),
        .wr_cnt_en(ctrl_write_cnt_en),
        .valid_src(valid_in),
        .TLB_hit(tlb_hit),
        .TLB_rd_wr(tlb_rd_wr),
        .TLB_pcd(tlb_pcd),
        .mem_ready(mem_data_valid),
        .mem_rd_wr(mem_rd_wr_comb),
        .mem_req(mem_req),
        .bus_grant(grant_in),
        .grant_pass(ctrl_grant_pass),
        .bus_busy(bus_busy_in),
        .busy_out(bus_busy_out),
        .page_fault(page_fault)
    );

   
    //assign mem_rd_wr = 1'b0;
    tristate_bus_driver1$(n_drive_addr, mem_rd_wr_comb, mem_rd_wr);

    assign ctrl_staging_wr_en = ctrl_write & ~read_num;

    assign virt_addr_mux_sel = read_num;
    
    wire read_num_n;
    inv1$ read_num_inv(read_num_n, read_num);
    and2$ staging_and(staging_wr_en, read_num_n, ctrl_write);

    wire is_aligned;
    assign ctrl_read2 = is_aligned;
    or3$ alignment_or(is_aligned, virt_addr[2], virt_addr[1], virt_addr[0]);
    wire read_num_mux_out;
    mux2$ read_num_mux(read_num_mux_out, 1'b0, is_aligned, ctrl_read_num_sel);
    register #(.WIDTH(1)) read_num_reg(clk, reset, read_num_mux_out, read_num, , ctrl_read_num_wr_en);

    // pass along grant signal?
    mux2$ grant_mux(grant_out, 1'b0, grant_in, ctrl_grant_pass);

  
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
        .out(rd_dp_read_data)
    );

    wire [63:0] wr_data_reg_out;
    wire wr_req_en;
    wire a2m_n;
    inv1$ a2m_inv(a2m_n, ctrl_addr2_mux);
    and2$ wr_req_and(wr_req_en, ctrl_req_addr_en, a2m_n);
    register #(.WIDTH(64)) wr_data_reg(clk, reset, wr_req_data, wr_data_reg_out, , wr_req_en);
    register #(.WIDTH(1)) wr_size_reg(clk, reset, wr_size_in, wr_size, , wr_req_en);
 
    register #(.WIDTH(2)) byte_offset_reg(clk, reset, byte_offset_in, byte_offset,, wr_req_en);

    wire [31:0] mem_data_driver; 
    wr_data_select wds(wr_data_reg_out, write_cnt, byte_offset, mem_data_driver);
    //mux #(.WIDTH(32), .INPUTS(2)) mem_data_mux(wr_data_reg_out, mem_data_driver, write_num_n);
     
    wire n_drive_data; 
    wire ctrl_drive_bus;
    and2$ drive_bus_and(ctrl_drive_bus, mem_en, ctrl_rd_wr_addr);
    inv1$ drive_bus_inv(n_drive_data, ctrl_drive_bus);

    wire n_drive_addr;
    inv1$ drive_bus_addr_inv(n_drive_addr, bus_busy_out);

    tristate_bus_driver16$ data_bus_driver1(n_drive_data, mem_data_driver[15:0], mem_data[15:0]);
    tristate_bus_driver16$ data_bus_driver2(n_drive_data, mem_data_driver[31:16], mem_data[31:16]);

    tristate_bus_driver16$(n_drive_addr, pa_out[15:0],  mem_addr[15:0]);
    tristate_bus_driver16$(n_drive_addr, pa_out[31:16], mem_addr[31:16]);
   
 
    eval_wr_done ewd(wr_done, write_cnt, byte_offset, wr_size);
    
    wr_size_select wss(write_cnt, byte_offset, wr_size, mem_wr_size);     

endmodule

module eval_wr_done(
    output wr_done,
    input [1:0] write_cnt,
    input [1:0] off,
    input wr_size
);
    wire off0;
    wire aob;
    or2$ or33(aob, off[0], off[1]);
    inv1$ invee(off0, aob);

    wire wr_size_n;
    inv1$ wsn(wr_size_n, wr_size);
   
    wire write_cnt_1_n;
    inv1$ wc1inv(write_cnt_1_n, write_cnt[1]);
    
    wire write_cnt_0_n;
    inv1$ wc0inv(write_cnt_0_n, write_cnt[0]);

    wire wr_cnt_eq_1;
    and2$ wc1a(wr_cnt_eq_1, write_cnt[0], write_cnt_1_n);

    wire wr_cnt_eq_2;
    and2$ wc2a(wr_cnt_eq_2, write_cnt[1], write_cnt_0_n);

    wire wr_cnt_eq_0;
    and2$ wc0a(wr_cnt_eq_0, write_cnt_1_n, write_cnt_0_n);

    wire wrsnandoffn;
    or2$ wsnao(wrsnandoffn, wr_size_n, off0);

    wire term1;
    and2$ t1a(term1, wr_cnt_eq_1, wrsnandoffn);

    wire term2;
    and2$ t2a(term2, wr_cnt_eq_2, wr_size);

    wire term3;
    and3$ t3a(term3, wr_cnt_eq_0, wr_size_n, off0);

    or3$ wr_done_or(wr_done, term1, term2, term3);

endmodule

module wr_data_select(
    input [63:0] wr_data_in,
    input [1:0] wr_cnt,
    input [1:0] off,
    output reg [31:0] out
);

   // TODO behavioral
   always @(*) begin
    case({off, wr_cnt})
        4'b0000: out <= wr_data_in[31:0];
        4'b0001: out <= wr_data_in[63:32];
        4'b0100: out <= wr_data_in[31:0];
        4'b0101: out <= wr_data_in[55:24];
        4'b0110: out <= {24'b0 , wr_data_in[63:56]};

        4'b1000: out <= wr_data_in[31:0];
        4'b1001: out <= wr_data_in[47:16];
        4'b1010: out <= {16'b0, wr_data_in[63: 48]};

        4'b1100: out <= wr_data_in[31:0];
        4'b1101: out <= wr_data_in[39:8];
        4'b1110: out <= {8'b0, wr_data_in[63:40]};
        default: out <= 32'b0;
    endcase   
   end

endmodule

module wr_size_select(
    input [1:0] wr_cnt,
    input [1:0] off,
    input size_in,
    output [1:0] size_out
);

wire wr_cnt1_not;
wire size_in_not;
wire and0;
wire wr_cnt0_not;
wire and1;
wire off0_not;
wire and2;
wire off1_not;
wire and3;
wire or0;
wire and4;
wire and5;
wire or1;

inv1$ wr_cnt1_inv (.out(wr_cnt1_not), .in(wr_cnt[1]));
inv1$ size_in_inv (.out(size_in_not), .in(size_in));
inv1$ wr_cnt0_inv (.out(wr_cnt0_not), .in(wr_cnt[0]));
inv1$ off0_inv (.out(off0_not), .in(off[0]));
inv1$ off1_inv (.out(off1_not), .in(off[1]));

and4$ and_gate0(.out(and0), .in0(wr_cnt1_not), .in1(wr_cnt[0]), .in2(off[1]), .in3(size_in_not));
and4$ and_gate1(.out(and1), .in0(wr_cnt[1]), .in1(wr_cnt0_not), .in2(off[1]), .in3(size_in));
and4$ and_gate2(.out(and2), .in0(wr_cnt1_not), .in1(wr_cnt0_not), .in2(off[1]), .in3(off0_not));
and4$ and_gate3(.out(and3), .in0(wr_cnt1_not), .in1(wr_cnt0_not), .in2(off1_not), .in3(off[0]));
and3$ and_gate4(.out(and4), .in0(wr_cnt1_not), .in1(off[0]), .in2(size_in_not));
and3$ and_gate5(.out(and5), .in0(wr_cnt0_not), .in1(off[0]), .in2(size_in));

or4$ or_gate0(.out(or0), .in0(and0), .in1(and1), .in2(and2), .in3(and3));
or2$ or_gate1(.out(or1), .in0(and4), .in1(and5));

assign size_out[1] = or0;
assign size_out[0] = or1;

endmodule
