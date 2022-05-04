module simple_read_master(
    clk,
    reset,
    
    req_valid,
    req_ready,
    req_address,
    dp_valid,
    dp_ready,
    dp_read_data,

    mem_addr,
    mem_req,
    mem_data_valid,
    mem_data,
    mem_rd_wr,
    mem_en,

    grant_in,
    grant_out,
    
    bus_busy_out,
    bus_busy_in
);

    input clk;
    input reset;

    input req_valid;
    output req_ready;
    input [31:0] req_address;
    output dp_valid;
    input dp_ready;
    output [31:0] dp_read_data;

    output [31:0] mem_addr;
    output mem_req;
    input mem_data_valid;
    input [31:0] mem_data;
    output mem_rd_wr;
    output mem_en;

    input grant_in;
    output grant_out;

    output bus_busy_out;
    input bus_busy_in;
    
    wire grant_pass;
    wire mem_ready;

    
    assign mem_ready = mem_data_valid;

    wire new_state1;
    wire new_state0;
    wire state0;
    wire state1;

    wire reset_n;

    inv1$ reset_inv(reset_n, reset);

    dff$ 
        fsm0(clk, new_state0, state0, , reset_n, 1'b1),
        fsm1(clk, new_state1, state1, , reset_n, 1'b1);

    // pass along grant signal?
    mux2$ grant_mux(grant_out, 1'b0, grant_in, grant_pass);


    wire state1_not;
    wire state0_not;
    wire req_valid_not;
    wire and0;
    wire and1;
    wire or0;
    wire bus_busy_in_not;
    wire and2;
    wire and3;
    wire or1;
    wire and4;
    wire and5;
    wire and6;
    wire or2;
    wire and7;
    wire dp_ready_not;
    wire and8;
    wire mem_ready_not;
    wire and9;
    wire or3;
    wire and10;
    wire grant_in_not;
    wire and11;
    wire and12;
    wire or4;

    inv1$ state1_inv (.out(state1_not), .in(state1));
    inv1$ state0_inv (.out(state0_not), .in(state0));
    inv1$ req_valid_inv (.out(req_valid_not), .in(req_valid));
    inv1$ bus_busy_in_inv (.out(bus_busy_in_not), .in(bus_busy_in));
    inv1$ dp_ready_inv (.out(dp_ready_not), .in(dp_ready));
    inv1$ mem_ready_inv (.out(mem_ready_not), .in(mem_ready));
    inv1$ grant_in_inv (.out(grant_in_not), .in(grant_in));

    and3$ and_gate0(.out(and0), .in0(state1_not), .in1(state0_not), .in2(req_valid_not));
    and3$ and_gate1(.out(and1), .in0(state1_not), .in1(state0_not), .in2(req_valid));
    and4$ and_gate2(.out(and2), .in0(state1_not), .in1(state0), .in2(grant_in), .in3(bus_busy_in_not));
    and2$ and_gate3(.out(and3), .in0(state1), .in1(state0_not));
    and3$ and_gate4(.out(and4), .in0(state1_not), .in1(state0_not), .in2(req_valid_not));
    and4$ and_gate5(.out(and5), .in0(state1_not), .in1(state0), .in2(grant_in), .in3(bus_busy_in_not));
    and2$ and_gate6(.out(and6), .in0(state1), .in1(state0_not));
    and4$ and_gate7(.out(and7), .in0(state1_not), .in1(state0), .in2(grant_in), .in3(bus_busy_in_not));
    and3$ and_gate8(.out(and8), .in0(state1), .in1(state0_not), .in2(dp_ready_not));
    and3$ and_gate9(.out(and9), .in0(state1), .in1(state0_not), .in2(mem_ready_not));
    and3$ and_gate10(.out(and10), .in0(state1_not), .in1(state0), .in2(bus_busy_in));
    and3$ and_gate11(.out(and11), .in0(state1_not), .in1(state0), .in2(grant_in_not));
    and3$ and_gate12(.out(and12), .in0(state1_not), .in1(state0_not), .in2(req_valid));

    or2$ or_gate0(.out(or0), .in0(and0), .in1(and1));
    or2$ or_gate1(.out(or1), .in0(and2), .in1(and3));
    or2$ or_gate2(.out(or2), .in0(and5), .in1(and6));
    or3$ or_gate3(.out(or3), .in0(and7), .in1(and8), .in2(and9));
    or3$ or_gate4(.out(or4), .in0(and10), .in1(and11), .in2(and12));

    assign req_ready = or0;
    assign mem_req = or1;
    assign grant_pass = and4;
    assign mem_en = or2;
    assign new_state1 = or3;
    assign new_state0 = or4;

        

endmodule
