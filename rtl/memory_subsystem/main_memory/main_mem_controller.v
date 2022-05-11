module main_mem_controller(
    input clk,
    input reset,

    input en,
    input rd_wr,
    input sram_done,
    input direct,

    output valid,
    output sram_rd,
    output sram_wr,
    output reg_wr,
    output drive_rd_tri
);


    wire [2:0] state;
    wire [2:0] new_state;

    wire state0 = state[0];
    wire state1 = state[1];
    wire state2 = state[2];

    wire new_state0;
    wire new_state1;
    wire new_state2;

    assign new_state[0] = new_state0;
    assign new_state[1] = new_state1;
    assign new_state[2] = new_state2;

    wire reset_n;
    inv1$ reset_inv(reset_n, reset);

    dff$ 
        fsm0(clk, new_state[0], state[0], , reset_n, 1'b1),
        fsm1(clk, new_state[1], state[1], , reset_n, 1'b1),
        fsm2(clk, new_state[2], state[2], , reset_n, 1'b1);

    assign drive_rd_tri = sram_rd & (state != 3);

   
    wire state1_not;
    wire state0_not;
    wire and0;
    wire state2_not;
    wire and1;
    wire and2;
    wire or0;
    wire and3;
    wire and4;
    wire and5;
    wire sram_done_not;
    wire and6;
    wire or1;
    wire and7;
    wire and8;
    wire and9;
    wire or2;
    wire and10;
    wire and11;
    wire or3;
    wire and12;
    wire and13;
    wire or4;
    wire and14;
    wire and15;
    wire or5;

    inv1$ state1_inv (.out(state1_not), .in(state1));
    inv1$ state0_inv (.out(state0_not), .in(state0));
    inv1$ state2_inv (.out(state2_not), .in(state2));
    inv1$ sram_done_inv (.out(sram_done_not), .in(sram_done));

    and4$ and_gate0(.out(and0), .in0(state2), .in1(state1_not), .in2(state0_not), .in3(sram_done));
    and4$ and_gate1(.out(and1), .in0(state2_not), .in1(state1), .in2(state0_not), .in3(sram_done));
    and4$ and_gate2(.out(and2), .in0(state2_not), .in1(state1_not), .in2(state0), .in3(sram_done));
    and4$ and_gate3(.out(and3), .in0(state2_not), .in1(state1), .in2(state0), .in3(sram_done));
    and4$ and_gate4(.out(and4), .in0(state2_not), .in1(state1), .in2(state0), .in3(sram_done));
    and4$ and_gate5(.out(and5), .in0(state2_not), .in1(state1_not), .in2(state0), .in3(sram_done));
    and3$ and_gate6(.out(and6), .in0(state2_not), .in1(state0), .in2(sram_done_not));
    and4$ and_gate7(.out(and7), .in0(state2), .in1(state1_not), .in2(state0_not), .in3(sram_done_not));
    and4$ and_gate8(.out(and8), .in0(state2), .in1(state1_not), .in2(state0_not), .in3(sram_done));
    and3$ and_gate9(.out(and9), .in0(state2_not), .in1(state1), .in2(state0_not));
    and4$ and_gate10(.out(and10), .in0(state2), .in1(state1_not), .in2(state0_not), .in3(sram_done_not));
    and4$ and_gate11(.out(and11), .in0(state2_not), .in1(state1), .in2(state0), .in3(sram_done));
    and5$ and_gate12(.out(and12), .in0(state2_not), .in1(state1_not), .in2(state0_not), .in3(rd_wr), .in4(en));
    and3$ and_gate13(.out(and13), .in0(state2_not), .in1(state1), .in2(sram_done_not));
    and4$ and_gate14(.out(and14), .in0(state2_not), .in1(state1_not), .in2(state0_not), .in3(en));
    and3$ and_gate15(.out(and15), .in0(state2_not), .in1(state0), .in2(sram_done_not));

    or3$ or_gate0(.out(or0), .in0(and0), .in1(and1), .in2(and2));
    or3$ or_gate1(.out(or1), .in0(and4), .in1(and5), .in2(and6));
    or3$ or_gate2(.out(or2), .in0(and7), .in1(and8), .in2(and9));
    or2$ or_gate3(.out(or3), .in0(and10), .in1(and11));
    or2$ or_gate4(.out(or4), .in0(and12), .in1(and13));
    or2$ or_gate5(.out(or5), .in0(and14), .in1(and15));

    assign valid = or0;
    assign reg_wr = and3;
    assign sram_rd = or1;
    assign sram_wr = or2;
    assign new_state2 = or3;
    assign new_state1 = or4;
    assign new_state0 = or5;
    
endmodule
