module sram_controller(
    input clk,
    input reset,

    input read,
    input write,

    output ce,
    output wr,
    output oe,
   
    output done
);
    parameter RD_CYCLES = 10;
    parameter WR_CYCLES = 10;

    parameter WR_WAIT = 10;
    parameter RD_WAIT = 10;

    parameter WR_BUSY = 10;
    parameter RD_BUSY = 10;

    parameter CNT_REG_WIDTH = 5;

    wire [CNT_REG_WIDTH-1:0] wr_wait = WR_WAIT;
    wire [CNT_REG_WIDTH-1:0] rd_wait = RD_WAIT;

    wire [CNT_REG_WIDTH-1:0] wr_busy = WR_BUSY;
    wire [CNT_REG_WIDTH-1:0] rd_busy = RD_BUSY;


    wire cnt_en;
    wire cnt_src;
    wire cnt_eqz;
    wire cnt_stage;

    wire [1:0] state;
    wire [1:0] new_state;

    wire state0 = state[0];
    wire state1 = state[1];
    //wire state2 = state[2];
//    wire state3 = state[3];

    wire new_state0;
    wire new_state1;

    assign  new_state[0] = new_state0;
    assign  new_state[1] = new_state1;
    //wire new_state2 = new_state[2];
 //   wire new_state3 = new_state[3];

    wire reset_n;
    inv1$ reset_inv(reset_n, reset);

    dff$ 
        fsm0(clk, new_state[0], state[0], , reset_n, 1'b1),
        fsm1(clk, new_state[1], state[1], , reset_n, 1'b1);
   //     fsm2(clk, new_state[2], state[2], , reset_n, 1'b1);
  //      fsm2(clk, new_state[3], state[3], , reset_n, 1'b1);


    // FIXME can make faster by just adding states instead of counting?
    wire [CNT_REG_WIDTH-1:0] cnt;
    wire [CNT_REG_WIDTH-1:0] cnt_in;
  
    // TODO behavioral 
    wire [CNT_REG_WIDTH-1:0] cntmm = cnt - 1;
    wire [CNT_REG_WIDTH-1:0] cycles;

    wire [CNT_REG_WIDTH-1:0] rd_cycles = RD_CYCLES;
    wire [CNT_REG_WIDTH-1:0] wr_cycles = WR_CYCLES;

    //mux #(.WIDTH(CNT_REG_WIDTH), .INPUTS(2)) rd_stage_mux({rd_wait, rd_busy}, rd_cycles, cnt_stage);
    //mux #(.WIDTH(CNT_REG_WIDTH), .INPUTS(2)) wr_stage_mux({wr_wait, wr_busy}, wr_cycles, cnt_stage);

    mux #(.WIDTH(CNT_REG_WIDTH), .INPUTS(2)) cycles_mux({rd_cycles, wr_cycles}, cycles, read);
    mux #(.WIDTH(CNT_REG_WIDTH), .INPUTS(2)) cnt_mux({cntmm, cycles}, cnt_in, cnt_src);

    register #(.WIDTH(CNT_REG_WIDTH)) cnt_reg(clk, reset, cnt_in, cnt,, cnt_en);

    compare #(.WIDTH(CNT_REG_WIDTH)) comp(cnt, zero);
    
    // TODO behavioral
    assign cnt_eqz = cnt == 0;

    wire state0_not;
    wire and0;
    wire state1_not;
    wire and1;
    wire or0;
    wire write_not;
    wire and2;
    wire read_not;
    wire and3;
    wire or1;
    wire and4;
    wire and5;
    wire and6;
    wire cnt_eqz_not;
    wire and7;
    wire or2;
    wire and8;
    wire and9;
    wire and10;
    wire and11;
    wire or3;
    wire and12;
    wire and13;
    wire and14;
    wire and15;
    wire and16;
    wire and17;
    wire or4;
    wire and18;
    wire and19;
    wire or5;
    wire and20;
    wire and21;
    wire or6;
    wire and22;
    wire and23;
    wire or7;

    inv1$ state0_inv (.out(state0_not), .in(state0));
    inv1$ state1_inv (.out(state1_not), .in(state1));
    inv1$ write_inv (.out(write_not), .in(write));
    inv1$ read_inv (.out(read_not), .in(read));
    inv1$ cnt_eqz_inv (.out(cnt_eqz_not), .in(cnt_eqz));

    and3$ and_gate0(.out(and0), .in0(state1), .in1(state0_not), .in2(cnt_eqz));
    and3$ and_gate1(.out(and1), .in0(state1_not), .in1(state0), .in2(cnt_eqz));
    and3$ and_gate2(.out(and2), .in0(state1_not), .in1(state0_not), .in2(write_not));
    and4$ and_gate3(.out(and3), .in0(state1_not), .in1(state0_not), .in2(read_not), .in3(write));
    and3$ and_gate4(.out(and4), .in0(state1), .in1(state0_not), .in2(cnt_eqz));
    and3$ and_gate5(.out(and5), .in0(state1_not), .in1(state0_not), .in2(write_not));
    and4$ and_gate6(.out(and6), .in0(state1_not), .in1(state0_not), .in2(read_not), .in3(write));
    and3$ and_gate7(.out(and7), .in0(state1), .in1(state0_not), .in2(cnt_eqz_not));
    and3$ and_gate8(.out(and8), .in0(state1_not), .in1(state0), .in2(cnt_eqz));
    and3$ and_gate9(.out(and9), .in0(state1_not), .in1(state0_not), .in2(write_not));
    and4$ and_gate10(.out(and10), .in0(state1_not), .in1(state0_not), .in2(read_not), .in3(write));
    and3$ and_gate11(.out(and11), .in0(state1_not), .in1(state0), .in2(cnt_eqz_not));
    and4$ and_gate12(.out(and12), .in0(state1_not), .in1(state0_not), .in2(read), .in3(write_not));
    and3$ and_gate13(.out(and13), .in0(state1), .in1(state0_not), .in2(cnt_eqz));
    and3$ and_gate14(.out(and14), .in0(state1_not), .in1(state0), .in2(cnt_eqz));
    and4$ and_gate15(.out(and15), .in0(state1_not), .in1(state0_not), .in2(read_not), .in3(write));
    and3$ and_gate16(.out(and16), .in0(state1), .in1(state0_not), .in2(cnt_eqz_not));
    and3$ and_gate17(.out(and17), .in0(state1_not), .in1(state0), .in2(cnt_eqz_not));
    and3$ and_gate18(.out(and18), .in0(state1), .in1(state0_not), .in2(cnt_eqz_not));
    and3$ and_gate19(.out(and19), .in0(state1_not), .in1(state0), .in2(cnt_eqz_not));
    and4$ and_gate20(.out(and20), .in0(state1_not), .in1(state0_not), .in2(read_not), .in3(write));
    and3$ and_gate21(.out(and21), .in0(state1), .in1(state0_not), .in2(cnt_eqz_not));
    and4$ and_gate22(.out(and22), .in0(state1_not), .in1(state0_not), .in2(read), .in3(write_not));
    and3$ and_gate23(.out(and23), .in0(state1_not), .in1(state0), .in2(cnt_eqz_not));

    or2$ or_gate0(.out(or0), .in0(and0), .in1(and1));
    or2$ or_gate1(.out(or1), .in0(and2), .in1(and3));
    or4$ or_gate2(.out(or2), .in0(and4), .in1(and5), .in2(and6), .in3(and7));
    or4$ or_gate3(.out(or3), .in0(and8), .in1(and9), .in2(and10), .in3(and11));
    or6$ or_gate4(.out(or4), .in0(and12), .in1(and13), .in2(and14), .in3(and15), .in4(and16), .in5(and17));
    or2$ or_gate5(.out(or5), .in0(and18), .in1(and19));
    or2$ or_gate6(.out(or6), .in0(and20), .in1(and21));
    or2$ or_gate7(.out(or7), .in0(and22), .in1(and23));

    assign done = or0;
    assign ce = or1;
    assign oe = or2;
    assign wr = or3;
    assign cnt_en = or4;
    assign cnt_src = or5;
    assign new_state1 = or6;
    assign new_state0 = or7;

endmodule



