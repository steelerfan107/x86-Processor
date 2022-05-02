`timescale 1 ns / 1 ps
module fifo
   (clk,
    reset,
    flush,
    wr_en,
    wr_data,
    rd_en,
    rd_data,
    empty,
    nearly_full,
    full);
  input clk;
  input reset;
  input flush;
  input wr_en;
  input [31:0] wr_data;
  input rd_en;
  output [31:0] rd_data;
  output empty;
  output nearly_full;
  output full;

  wire and2_out;
  wire and3_out;
  wire and4_out;
  wire and5_out;
  wire and6_out;
  wire [31:0] mux1;
  wire [31:0] mux2;
  wire [31:0] mux3;
  wire [31:0] mux4;
  wire [31:0] mux5;
  wire wr_ptr_select_1;
  wire wr_ptr_select_2;
  wire wr_ptr_select_3;
  wire wr_ptr_select_4;
  wire wr_ptr_select_5;
  wire [3:0] count;
  wire [3:0] count0;
  wire [3:0] count0_i;
  wire count1;
  wire count2;
  wire [3:0] count_0;
  wire count_i_1;
  wire count_i_2;
  wire count_i_3;
  wire [3:0] count_i_n;
  wire [31:0] data0;
  wire [31:0] data1;
  wire [31:0] data2;
  wire [31:0] data3;
  wire [31:0] data4;
  wire [31:0] data5;
  wire mem;
  wire p_0_in;
  wire p_0_in1_in;
  wire [31:0] p_0_out;
  wire p_1_out;
  wire p_2_out;
  wire [2:0] rd_ptr;
  wire rd_ptr0;
  wire [2:0] rd_ptr0_i;
  wire [2:0] rd_ptr0_out;
  wire rd_ptr1;
  wire rd_ptr_i_1;
  wire [2:0] sel0;
  wire [2:0] wr_ptr;
  wire wr_ptr0;
  wire [2:0] wr_ptr0_i_n;
  wire [2:0] wr_ptr0_out;
  wire wr_ptr1;
  wire [2:0] wr_ptr_0;
  wire wr_ptr_i_1;

  and2$ and0(.in0(p_0_in), .in1(mem), .out(p_1_out));
  and2$ and1(.in0(p_0_in1_in), .in1(p_1_out), .out(p_2_out));
  and2$ and2(.in0(wr_ptr_select_1), .in1(p_1_out), .out(and2_out));
  and2$ and3(.in0(wr_ptr_select_2), .in1(p_1_out), .out(and3_out));
  and2$ and4(.in0(wr_ptr_select_3), .in1(p_1_out), .out(and4_out));
  and2$ and5(.in0(wr_ptr_select_4), .in1(p_1_out), .out(and5_out));
  and2$ and6(.in0(wr_ptr_select_5), .in1(p_1_out), .out(and6_out));

  mux #(.WIDTH(1), .INPUTS(2)) mux_p_0_flush(.in({1'b0, wr_ptr0}), .out(p_0_in), .select(flush));
  mux #(.WIDTH(32), .INPUTS(6)) mux_p_0_out(.in({32'hz, 32'hz, 32'hz, 32'hz, 32'hz, wr_data}), .out(p_0_out), .select(wr_ptr));
  mux #(.WIDTH(32), .INPUTS(6)) mux_1(.in({32'hz, 32'hz, 32'hz, 32'hz, wr_data, 32'hz}), .out(mux1), .select(wr_ptr));
  mux #(.WIDTH(32), .INPUTS(6)) mux_2(.in({32'hz, 32'hz, 32'hz, wr_data, 32'hz, 32'hz}), .out(mux2), .select(wr_ptr));
  mux #(.WIDTH(32), .INPUTS(6)) mux_3(.in({32'hz, 32'hz, wr_data, 32'hz, 32'hz, 32'hz}), .out(mux3), .select(wr_ptr));
  mux #(.WIDTH(32), .INPUTS(6)) mux_4(.in({32'hz, wr_data, 32'hz, 32'hz, 32'hz, 32'hz}), .out(mux4), .select(wr_ptr));
  mux #(.WIDTH(32), .INPUTS(6)) mux_5(.in({wr_data, 32'hz, 32'hz, 32'hz, 32'hz, 32'hz}), .out(mux5), .select(wr_ptr));
  mux #(.WIDTH(32), .INPUTS(6)) mux_rd_data(.in({data5, data4, data3, data2, data1, data0}), .out(rd_data), .select(sel0));
  mux #(.WIDTH(1), .INPUTS(6)) mux_p_0_in1_in(.in({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1}), .out(p_0_in1_in), .select(wr_ptr));
  mux #(.WIDTH(1), .INPUTS(6)) mux_wr_ptr_select_1(.in({1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0}), .out(wr_ptr_select_1), .select(wr_ptr));
  mux #(.WIDTH(1), .INPUTS(6)) mux_wr_ptr_select_2(.in({1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0}), .out(wr_ptr_select_2), .select(wr_ptr));
  mux #(.WIDTH(1), .INPUTS(6)) mux_wr_ptr_select_3(.in({1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0}), .out(wr_ptr_select_3), .select(wr_ptr));
  mux #(.WIDTH(1), .INPUTS(6)) mux_wr_ptr_select_4(.in({1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0}), .out(wr_ptr_select_4), .select(wr_ptr));
  mux #(.WIDTH(1), .INPUTS(6)) mux_wr_ptr_select_5(.in({1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), .out(wr_ptr_select_5), .select(wr_ptr));

  CLA4 add_count0_i(.a(count), .b(4'b0001), .Cin(1'b0), .s(count0));
  CLA4 sub1_count0_i(.a(count), .b(4'b1111), .Cin(1'b0), .s(count0_i)); //subtract 1

  and2$ and_count1_i(.in0(count2), .in1(rd_ptr1), .out(count1));
  and2$ and_count2_i(.in0(wr_ptr0), .in1(rd_en), .out(count2));

  mux #(.WIDTH(4), .INPUTS(2)) mux_count_i(.in({count0, count0_i}), .out(count_i_n), .select(wr_ptr0));
  mux #(.WIDTH(4), .INPUTS(2)) mux_count_i__0(.in({4'b0000, count_i_n}), .out(count_0), .select(flush));
  mux #(.WIDTH(1), .INPUTS(2)) mux_count_i_1(.in({1'b1, rd_ptr0}), .out(count_i_1), .select(wr_ptr0));
  mux #(.WIDTH(1), .INPUTS(2)) mux_count_i__2(.in({1'b0, count_i_1}), .out(count_i_2), .select(count1));
  mux #(.WIDTH(1), .INPUTS(2)) mux_count_i__3(.in({1'b1, count_i_2}), .out(count_i_3), .select(flush));

  register #(.WIDTH(4)) count_reg(.clk(clk), .en(count_i_3), .din(count_0), .q(count));

  ucomp4 comp_empty_i(.a(count), .b(4'b0000), .agb_in(1'b0), .eq_in(1'b1), .bga_in(1'b0), .eq_out(empty));
  ucomp4 comp_full_i(.a(count), .b(4'b0110), .agb_in(1'b0), .eq_in(1'b1), .bga_in(1'b0), .eq_out(full));

  mux #(.WIDTH(1), .INPUTS(2)) mux_mem_i(.in({1'b0, 1'b1}), .out(mem), .select(reset));

  register #(.WIDTH(32)) data0_reg(.clk(clk), .en(p_2_out), .din(p_0_out), .q(data0));
  register #(.WIDTH(32)) data1_reg(.clk(clk), .en(and2_out), .din(mux1), .q(data1));
  register #(.WIDTH(32)) data2_reg(.clk(clk), .en(and3_out), .din(mux2), .q(data2));
  register #(.WIDTH(32)) data3_reg(.clk(clk), .en(and4_out), .din(mux3), .q(data3));
  register #(.WIDTH(32)) data4_reg(.clk(clk), .en(and5_out), .din(mux4), .q(data4));
  register #(.WIDTH(32)) data5_reg(.clk(clk), .en(and6_out), .din(mux5), .q(data5));
  
  ucomp4 comp_nearly_full_i(.a(count), .b(4'b0100), .agb_in(1'b0), .eq_in(1'b1), .bga_in(1'b0), .eq_out(nearly_full), .agb_out(nearly_full));

  and2$ and_rd_ptr0_i(.in0(rd_en), .in1(rd_ptr1), .out(rd_ptr0));

  CLA3 add_rd_ptr0_i(.a(sel0), .b(3'b001), .Cin(1'b0), .s(rd_ptr0_i));

  inv1$ inv_rd_ptr1_i(.in(empty), .out(rd_ptr1));

  mux #(.WIDTH(3), .INPUTS(6)) mux_rd_ptr_i(.in({3'b000, rd_ptr0_i, rd_ptr0_i, rd_ptr0_i, rd_ptr0_i, rd_ptr0_i}), .out(rd_ptr), .select(sel0));
  mux #(.WIDTH(3), .INPUTS(2)) mux_rd_ptr_i__0(.in({3'b000, rd_ptr}), .out(rd_ptr0_out), .select(flush));  
  mux #(.WIDTH(1), .INPUTS(2)) mux_rd_ptr_i__1(.in({1'b1, rd_ptr0}), .out(rd_ptr_i_1), .select(flush));  

  register #(.WIDTH(1)) rd_ptr_reg0(.clk(clk), .reset(reset), .en(rd_ptr_i_1), .din(rd_ptr0_out[0]), .q(sel0[0]));
  register #(.WIDTH(1)) rd_ptr_reg1(.clk(clk), .reset(reset), .en(rd_ptr_i_1), .din(rd_ptr0_out[1]), .q(sel0[1]));
  register #(.WIDTH(1)) rd_ptr_reg2(.clk(clk), .reset(reset), .en(rd_ptr_i_1), .din(rd_ptr0_out[2]), .q(sel0[2]));

  CLA3 add_wr_ptr0_i(.a(wr_ptr), .b(3'b001), .Cin(1'b0), .s(wr_ptr0_i_n));

  and2$ and_wr_ptr0_i__0(.in0(wr_en), .in1(wr_ptr1), .out(wr_ptr0));
  inv1$ inv_wr_ptr1_i(.in(full), .out(wr_ptr1));

  mux #(.WIDTH(3), .INPUTS(6)) mux_wr_ptr_i(.in({3'b000, wr_ptr0_i_n, wr_ptr0_i_n, wr_ptr0_i_n, wr_ptr0_i_n, wr_ptr0_i_n}), .out(wr_ptr_0), .select(wr_ptr));
  mux #(.WIDTH(3), .INPUTS(2)) mux_wr_ptr_i__0(.in({3'b000, wr_ptr_0}), .out(wr_ptr0_out), .select(flush));
  mux #(.WIDTH(1), .INPUTS(2)) mux_wr_ptr_i__1(.in({1'b1, wr_ptr0}), .out(wr_ptr_i_1), .select(flush));

  register #(.WIDTH(1)) wr_ptr_reg0(.clk(clk), .reset(reset), .en(wr_ptr_i_1), .din(wr_ptr0_out[0]), .q(wr_ptr[0]));
  register #(.WIDTH(1)) wr_ptr_reg1(.clk(clk), .reset(reset), .en(wr_ptr_i_1), .din(wr_ptr0_out[1]), .q(wr_ptr[1]));
  register #(.WIDTH(1)) wr_ptr_reg2(.clk(clk), .reset(reset), .en(wr_ptr_i_1), .din(wr_ptr0_out[2]), .q(wr_ptr[2]));
endmodule




