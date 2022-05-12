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
    input [1:0] wr_size_in;

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

    assign mem_en = bus_busy_out;
    //tristate_bus_driver1$(~bus_busy_out, bus_busy_out, mem_en);
    //assign mem_en = bus_busy_out;
   
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

    //wire 4_or_more = ~wr_size[1];
    //wire upper 

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
    wire [1:0] wr_size;
    wire write_num; 

    wire write_num_n;
    inv1$ write_num_inv(write_num_n, write_num);

    assign ctrl_pa_src = write_num_n;

    wire ctrl_wr;
    wire [31:0] final_addr;
    wire [2:0] byte_offset_out;
    mux #(.WIDTH(3), .INPUTS(2)) remove_off({phys_addr[2:0], 3'h0}, byte_offset_out, ctrl_wr);

    assign final_addr = {phys_addr[31:3], byte_offset_out};

    mux2_16$ 
        pa_mux0(pa_out[15:0], pa_reg_out[15:0], pa_p4[15:0], ctrl_pa_src),
        pa_mux1(pa_out[31:16], pa_reg_out[31:16], pa_p4[31:16], ctrl_pa_src);
    register #(.WIDTH(32)) phys_addr_reg(clk, reset, final_addr, pa_reg_out, , ctrl_pa_wr_en);
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
    wire ctrl_stage; 
   
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
        .wr(ctrl_wr),
        .TLB_hit(tlb_hit),
        .TLB_rd_wr(tlb_rd_wr),
        .TLB_pcd(tlb_pcd),
        .mem_ready(mem_data_valid),
        .mem_rd_wr(mem_rd_wr),
        .mem_req(mem_req),
        .bus_grant(grant_in),
        .grant_pass(ctrl_grant_pass),
        .bus_busy(bus_busy_in),
        .busy_out(bus_busy_out),
        .page_fault(page_fault),
        .stage(ctrl_stage)
    );

   
    //assign mem_rd_wr = 1'b0;
    //tristate_bus_driver1$(n_drive_addr, mem_rd_wr_comb, mem_rd_wr);

    // TODO behavioral
    assign ctrl_staging_wr_en = (ctrl_write & ~read_num) | ctrl_stage;

    assign virt_addr_mux_sel = read_num;
    
    wire read_num_n;
    inv1$ read_num_inv(read_num_n, read_num);
    and2$ staging_and(staging_wr_en, read_num_n, ctrl_write);

    wire is_not_aligned;
    assign ctrl_read2 = is_not_aligned;
    or3$ alignment_or(is_not_aligned, virt_addr[2], virt_addr[1], virt_addr[0]);
    wire read_num_mux_out;
    mux2$ read_num_mux(read_num_mux_out, 1'b0, is_not_aligned, ctrl_read_num_sel);
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
    register #(.WIDTH(64)) staging_reg(clk, reset, dataram_out, staging_reg_out, , ctrl_staging_wr_en);

    d_align align_result(
        .in_high(dataram_out),
        .in_low(staging_reg_out),
        .offset(virt_addr[2:0]),
        .out(rd_dp_read_data)
    );

    wire [63:0] wr_data_reg_out;
    wire wr_req_en;
    wire a2m_n;
    inv1$ a2m_inv(a2m_n, ctrl_addr2_mux);
    and2$ wr_req_and(wr_req_en, ctrl_req_addr_en, a2m_n);
    register #(.WIDTH(64)) wr_data_reg(clk, reset, wr_req_data, wr_data_reg_out, , wr_req_en);

    register #(.WIDTH(2)) wr_size_reg(clk, reset, wr_size_in, wr_size, , wr_req_en);
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
    input [1:0] wr_size
);
    wire wr_cnt0 = write_cnt[0];
    wire wr_cnt1 = write_cnt[1];

    wire off0 = off[0]; 
    wire off1 = off[1];

    wire wr_size0 = wr_size[0];
    wire wr_size1 = wr_size[1];


wire wr_cnt0_not;
wire off1_not;
wire off0_not;
wire wr_size0_not;
wire and0;
wire wr_cnt1_not;
wire and1;
wire wr_size1_not;
wire and2;
wire and3;
wire and4;
wire and5;
wire and6;
wire or0;

inv1$ wr_cnt0_inv (.out(wr_cnt0_not), .in(wr_cnt0));
inv1$ off1_inv (.out(off1_not), .in(off1));
inv1$ off0_inv (.out(off0_not), .in(off0));
inv1$ wr_size0_inv (.out(wr_size0_not), .in(wr_size0));
inv1$ wr_cnt1_inv (.out(wr_cnt1_not), .in(wr_cnt1));
inv1$ wr_size1_inv (.out(wr_size1_not), .in(wr_size1));

and4$ and_gate0(.out(and0), .in0(wr_cnt0_not), .in1(off1_not), .in2(off0_not), .in3(wr_size0_not));
and5$ and_gate1(.out(and1), .in0(wr_cnt1_not), .in1(wr_cnt0), .in2(off1), .in3(off0), .in4(wr_size1));
and5$ and_gate2(.out(and2), .in0(wr_cnt1_not), .in1(wr_cnt0), .in2(off1_not), .in3(off0_not), .in4(wr_size1_not));
and3$ and_gate3(.out(and3), .in0(wr_cnt0_not), .in1(off1_not), .in2(wr_size1));
and3$ and_gate4(.out(and4), .in0(wr_cnt1_not), .in1(wr_cnt0), .in2(wr_size0_not));
and2$ and_gate5(.out(and5), .in0(wr_cnt1), .in1(wr_cnt0_not));
and2$ and_gate6(.out(and6), .in0(wr_size1), .in1(wr_size0_not));

or7$ or_gate0(.out(or0), .in0(and0), .in1(and1), .in2(and2), .in3(and3), .in4(and4), .in5(and5), .in6(and6));

assign wr_done = or0;
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
    input [1:0] size_in,
    output [1:0] size_out
);
wire wr_cnt0 = wr_cnt[0];
wire wr_cnt1 = wr_cnt[1];

wire off0 = off[0];
wire off1 = off[1];

wire size_in0 = size_in[0];
wire size_in1 = size_in[1];

wire wr_cnt1_not;
wire size_in0_not;
wire and0;
wire wr_cnt0_not;
wire and1;
wire off0_not;
wire and2;
wire off1_not;
wire and3;
wire and4;
wire and5;
wire or0;
wire and6;
wire and7;
wire and8;
wire and9;
wire or1;

wire wr_cnt1_not;
wire size_in1_not;
wire size_in0_not;
wire and0;
wire wr_cnt0_not;
wire and1;
wire off0_not;
wire and2;
wire off1_not;
wire and3;
wire and4;
wire and5;
wire or0;
wire and6;
wire and7;
wire and8;
wire and9;
wire or1;

inv1$ wr_cnt1_inv (.out(wr_cnt1_not), .in(wr_cnt1));
inv1$ size_in1_inv (.out(size_in1_not), .in(size_in1));
inv1$ size_in0_inv (.out(size_in0_not), .in(size_in0));
inv1$ wr_cnt0_inv (.out(wr_cnt0_not), .in(wr_cnt0));
inv1$ off0_inv (.out(off0_not), .in(off0));
inv1$ off1_inv (.out(off1_not), .in(off1));

and5$ and_gate0(.out(and0), .in0(wr_cnt1_not), .in1(wr_cnt0), .in2(off1), .in3(size_in1_not), .in4(size_in0_not));
and5$ and_gate1(.out(and1), .in0(wr_cnt1), .in1(wr_cnt0_not), .in2(off1), .in3(size_in1_not), .in4(size_in0));
and5$ and_gate2(.out(and2), .in0(wr_cnt1_not), .in1(wr_cnt0_not), .in2(off0_not), .in3(size_in1), .in4(size_in0));
and5$ and_gate3(.out(and3), .in0(wr_cnt1_not), .in1(wr_cnt0_not), .in2(off1_not), .in3(size_in1), .in4(size_in0));
and5$ and_gate4(.out(and4), .in0(wr_cnt1_not), .in1(wr_cnt0_not), .in2(off1), .in3(off0_not), .in4(size_in1_not));
and5$ and_gate5(.out(and5), .in0(wr_cnt1_not), .in1(wr_cnt0_not), .in2(off1_not), .in3(off0), .in4(size_in1_not));
and5$ and_gate6(.out(and6), .in0(wr_cnt1_not), .in1(off1), .in2(off0), .in3(size_in1), .in4(size_in0));
and4$ and_gate7(.out(and7), .in0(wr_cnt1_not), .in1(off0), .in2(size_in1_not), .in3(size_in0_not));
and4$ and_gate8(.out(and8), .in0(wr_cnt1_not), .in1(wr_cnt0_not), .in2(size_in1), .in3(size_in0_not));
and4$ and_gate9(.out(and9), .in0(wr_cnt0_not), .in1(off0), .in2(size_in1_not), .in3(size_in0));

or6$ or_gate0(.out(or0), .in0(and0), .in1(and1), .in2(and2), .in3(and3), .in4(and4), .in5(and5));
or4$ or_gate1(.out(or1), .in0(and6), .in1(and7), .in2(and8), .in3(and9));

assign size_out[1] = or0;
assign size_out[0] = or1;

endmodule
