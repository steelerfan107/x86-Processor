`timescale 1 ns / 1 ps
module two_level_adapative_predictor(clk, reset, en, actual, prediction);
  input clk;
  input reset;
  input en;
  input actual;
  output prediction;

  wire [2:0] br_hist;
  br_hist_buffer hist_buffer(.clk(clk), .reset(reset), .en(en), .actual(actual), .br_hist(br_hist));
  pht pattern_history_table(.clk(clk), .reset(reset), .en(en), .index(br_hist), .actual(actual), .prediction(prediction));
endmodule

//branch target buffer
module btb(clk, reset, en, instr_addr, new_iaddr, actual_target, target_addr);
  input clk;
  input reset;
  input en;
  input [31:0] instr_addr;
  input [31:0] new_iaddr; //used to change btb index's address or add new btb entry
  input [31:0] actual_target;
  output [31:0] target_addr;

  wire comp_instr_addr_out;
  wire new_iaddr_v_mux_out;
  wire select_target_addr;
  wire [7:0] new_iaddr_index;
  wire [7:0] new_iaddr_index0;
  wire [7:0] new_iaddr_index1;
  wire [7:0] new_iaddr_v;
  wire [7:0] new_iaddr_v0;
  wire [7:0] new_iaddr_v1;
  wire [7:0] target_addr_index;
  wire [7:0] target_addr_index0;
  wire [7:0] target_addr_index1;
  wire [31:0] instr_addr_mux_out;
  wire [31:0] target_addr_mux_out;
  wire [31:0] p_in [7:0];
  wire [31:0] target_addr_reg_out [7:0];

  /*Functionality:
  Reset invalidates all BTB entries
  Enable puts the new_iaddr at the appropiate index (tag is bits [4:2] on the iaddr), changes target if necessary, and validates entry
  The target addr is entries[instr_addr[4:2]].valid & ( instr_addr == entries[instr_addr[4:2]].instr_addr ) ) ? entries[instr_addr[4:2]].target_addr : instr_addr
  */

  //Level 1
  decoder3_8$ select_new_iaddr0(.SEL(instr_addr[4:2]), .Y(new_iaddr_index));

  //Level 2
  mux #(.WIDTH(8), .INPUTS(2)) mux_new_iaddr_index0(.in({new_iaddr_index, 8'h00}), .out(new_iaddr_index0), .select(en));
  
  //Level 3
  decoder3_8$ select_target_addr_index(.SEL(instr_addr[4:2]), .Y(target_addr_index));
  mux #(.WIDTH(8), .INPUTS(2)) mux_new_iaddr_index1(.in({8'h00, new_iaddr_index0}), .out(new_iaddr_index1), .select(reset));
  decoder3_8$ select_new_iaddr_v(.SEL(instr_addr[4:2]), .Y(new_iaddr_v));

  //Level 4
  mux #(.WIDTH(8), .INPUTS(2)) mux_target_addr_index0(.in({target_addr_index, 8'h00}), .out(target_addr_index0), .select(en));
  genvar i;
  generate
  for(i = 0; i < 8; i = i+1) begin : new_iaddr_reg_block
      register #(.WIDTH(32)) instance(.clk(clk), .reset(reset), .din(new_iaddr), .q(p_in[i]), .en(new_iaddr_index1[i]));
  end
  endgenerate
  mux #(.WIDTH(8), .INPUTS(2)) mux_new_iaddr_v0(.in({new_iaddr_v, 8'h00}), .out(new_iaddr_v0), .select(en));

  //Level 5
  mux #(.WIDTH(8), .INPUTS(2)) mux_target_addr_index1(.in({8'h00, target_addr_index0}), .out(target_addr_index1), .select(reset));
  generate
  for(i = 0; i < 8; i = i+1) begin : new_iaddr_v_dff_block
      dff$ instance(.clk(clk), .d(1'b0), .q(new_iaddr_v1[i]), .r(reset), .s(new_iaddr_v0[i]));
  end
  endgenerate
  mux #(.WIDTH(32), .INPUTS(8)) mux_instr_addr(.in({p_in[7], p_in[6], p_in[5], p_in[4], p_in[3], p_in[2], p_in[1], p_in[0]}), .out(instr_addr_mux_out), .select(instr_addr[4:2]));

  //Level 6
  generate
  for(i = 0; i < 8; i = i+1) begin : target_addr_index_reg_block
      register #(.WIDTH(32)) instance(.clk(clk), .din(actual_target), .q(target_addr_reg_out[i]), .en(target_addr_index1[i]));
  end
  endgenerate
  mux #(.WIDTH(1), .INPUTS(8)) mux_new_iaddr_v(.in(new_iaddr_v1), .out(new_iaddr_v_mux_out), .select(instr_addr[4:2]));
  ucomp32 comp_instr_addr(.a(instr_addr), .b(instr_addr_mux_out), .eq(comp_instr_addr_out));

  //Level 7
  mux #(.WIDTH(32), .INPUTS(8)) mux_target_addr(.in({target_addr_reg_out[7], target_addr_reg_out[6], target_addr_reg_out[5], target_addr_reg_out[4], target_addr_reg_out[3], target_addr_reg_out[2], target_addr_reg_out[1], target_addr_reg_out[0]}), .out(target_addr_mux_out), .select(instr_addr[4:2]));
  and2$ and_select_target_addr(.out(select_target_addr), .in0(comp_instr_addr_out), .in1(new_iaddr_v_mux_out));

  //Level 8
  mux #(.WIDTH(32), .INPUTS(2)) mux_target_addr_out(.in({target_addr_mux_out, instr_addr}), .out(target_addr), .select(select_target_addr));
endmodule

//branch history buffer
module br_hist_buffer(clk, reset, en, actual, br_hist);
  input clk;
  input reset;
  input en;
  input actual;
  output [2:0] br_hist;

  wire br_hist0;
  wire [2:0] br_hist0_i;
  wire [2:0] br_hist1_i;
  wire [2:0] br_hist_i_0;
  wire br_hist_i_1;
  wire [2:0] br_hist_i_2;
  wire [2:0] br_hist_i_n;
  
  mux #(.WIDTH(1), .INPUTS(2)) mux_br_hist0(.in({br_hist_i_1, 1'b1}), .out(br_hist0), .select(reset));
  mux #(.WIDTH(3), .INPUTS(2)) mux_br_hist0_i(.in({br_hist1_i, 3'b111}), .out(br_hist0_i), .select(reset));
  
  genvar i;
  generate
  for(i = 0; i < 2; i = i+1) begin : br_hist1_i_inv_block
      inv1$ instance(.out(br_hist_i_n[i]), .in(br_hist_i_2[i]));
  end
  endgenerate
  
  mux #(.WIDTH(3), .INPUTS(2)) mux_br_hist_i(.in({3'b000, 3'bzzz}), .out(br_hist_i_n), .select(reset));
  mux #(.WIDTH(3), .INPUTS(2)) mux_br_hist_i_0(.in({{br_hist[1:0],actual}, br_hist_i_n}), .out(br_hist_i_0), .select(en));
  mux #(.WIDTH(1), .INPUTS(2)) mux_br_hist_i_1(.in({1'b0, 1'b1}), .out(br_hist_i_1), .select(reset));
  mux #(.WIDTH(3), .INPUTS(2)) mux_br_hist_i_2(.in({3'b000, 3'b000}), .out(br_hist_i_2), .select(reset));
  reg32e$ br_hist_reg(.CLK(clk), .Din({br_hist_i_0[0], br_hist_i_0[1], br_hist_i_0[2]}), .Q(br_hist), .en(en), .CLR(br_hist0));

  assign br_hist[31:3] = 28'h000000;
endmodule

//pattern history table with 8 indexes
module pht(clk, reset, en, index, actual, prediction);
  input clk;
  input reset;
  input en;
  input [2:0] index;
  input actual;
  output prediction;

  wire [7:0] index_prediction;
  wire [7:0] counter_index;
  wire [7:0] counter_en;
  decoder3_8$ counter_decoder(.SEL(index), .Y(counter_index));
  ANDN #(.WIDTH(8)) and_en(.in0({en, en, en, en, en, en, en, en}), .in1(counter_index), .out(counter_en));

  genvar i;
  generate
  for(i = 0; i < 8; i = i+1) begin : pht_2b_saturating_counter_block
      twob_saturating_counter instance(.clk(clk), .reset(reset), .en(counter_en[i]), .actual(actual), .prediction(index_prediction[i]));
  end
  endgenerate

  mux #(.WIDTH(1), .INPUTS(8)) mux_prediction_out(.in(index_prediction), .out(prediction), .select(index));
endmodule

//2-bit Saturating Counter
//Actual: Not taken (0), Taken (1)
//State: Strongly Not Taken (00), Weakly Not Taken (01), Weakly Taken (10), Strongly Taken (11)
module twob_saturating_counter(clk, reset, en, actual, prediction);
  input clk, reset, en, actual;
  output prediction;

  wire [1:0] next_state0_i_0;
  wire [1:0] next_state0_i_1;
  wire [1:0] next_state0_i_2;
  wire [1:0] next_state0_i_n;
  wire [1:0] next_state_i_0;
  wire [1:0] next_state_i_1;
  wire [1:0] next_state_i_2;
  wire [1:0] next_state;
  wire [1:0] state;

  assign prediction = state[1];

  mux #(.WIDTH(2), .INPUTS(2)) mux_next_state0_i(.in({2'b01, 2'b00}), .out(next_state0_i_n), .select(actual));
  mux #(.WIDTH(2), .INPUTS(2)) mux_next_state0_i_0(.in({2'b10, 2'b00}), .out(next_state0_i_0), .select(actual));
  mux #(.WIDTH(2), .INPUTS(2)) mux_next_state0_i_1(.in({2'b11, 2'b01}), .out(next_state0_i_1), .select(actual));
  mux #(.WIDTH(2), .INPUTS(2)) mux_next_state0_i_2(.in({2'b11, 2'b10}), .out(next_state0_i_2), .select(actual));
  mux #(.WIDTH(2), .INPUTS(2)) mux_next_state_i(.in({next_state0_i_n, 2'b00}), .out(next_state_i_n), .select(en));
  mux #(.WIDTH(2), .INPUTS(2)) mux_next_state_i_0(.in({next_state0_i_0, 2'b01}), .out(next_state_i_0), .select(en));
  mux #(.WIDTH(2), .INPUTS(2)) mux_next_state_i_1(.in({next_state0_i_1, 2'b10}), .out(next_state_i_1), .select(en));
  mux #(.WIDTH(2), .INPUTS(2)) mux_next_state_i_2(.in({next_state0_i_2, 2'b11}), .out(next_state_i_2), .select(en));
  mux #(.WIDTH(2), .INPUTS(4)) mux_next_state_out(.in({next_state_i_2, next_state_i_1, next_state_i_0, next_state_i_n}), .out(next_state), .select(state));
  register #(.WIDTH(2)) reg_state(.clk(clk), .din(next_state), .q(state), .en(en), .reset(reset));

  
endmodule
