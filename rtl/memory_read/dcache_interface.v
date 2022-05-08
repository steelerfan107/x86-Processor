
//////////////////////////////////////
//
//  DCache Interface
//



module dcache_interface (
    clk,
    reset,

    data_out,

    a_valid,
    e_ready,

    a_ready,
    e_valid,

    op0_address,
    op0_address_is_valid,
    op1_address,
    op1_address_is_valid,

    rd_req_valid,
    rd_req_ready,
    rd_req_address,
    rd_dp_valid,
    rd_dp_ready,
    rd_dp_read_data

);
    input clk;
    input reset;

    output [63:0] data_out;

    input a_valid;
    input e_ready;

    output a_ready;
    output e_valid;

    input [31:0] op0_address;
    input op0_address_is_valid;
    input [31:0] op1_address;
    input op1_address_is_valid;

    // interface to dcache
    output rd_req_valid;
    input rd_req_ready;
    output [31:0] rd_req_address;
    input rd_dp_valid;
    output rd_dp_ready;
    input [63:0] rd_dp_read_data;

    // read in rom
    // initial $readmemb("dcache_interface_rom.bit", rom.mem);

    // two possible situations:
        // op0 is valid
        // op1 is valid

    // if only one is valid read from memory directly
    // if both are active, read op0 then op1

    // use mux to select the input to rd_req_address with its value coming from {op1_addr_is_valid, op0_addr_is_valid}
        // 00: Do nothing
        // 01: rd_req_address = op0_address and rd_req_valid = 1
        // 10: rd_req_address = op1_address and rd_req_valid = 1

    wire start;
    wire [2:0] next_state;

    wire [31:0] rom_out;

    wire [1:0] cond = rom_out[7:6];
    wire [2:0] j = rom_out[5:3];
    assign rd_req_valid = rom_out[2];
    assign rd_dp_ready = rom_out[1];
    assign a_ready = rom_out[8];
    assign e_valid = rom_out[9];
    wire ld_mdr = rom_out[0];

    rom32b32w$ rom ({2'b0, next_state}, 1'b1, rom_out);

    dcache_interface_microsequencer dcache_interface_microsequencer0 (
        clk,
        reset,

        next_state,

        j,
        cond,
        rd_req_ready,
        start,
        rd_dp_valid
    );

    ao_mux #(.WIDTH(32), .NINPUTS(2)) rd_req_mux (
        {op1_address, op0_address},
        rd_req_address,
        {op1_address_is_valid, op0_address_is_valid}
    );


    register #(.WIDTH(64)) mdr (
        clk,
        reset,
        rd_dp_read_data,
        data_out,
        ,
        ld_mdr
    );


    dcache_interface_start_fsm dcache_interface_start_fsm0 (
        start,

        a_valid,
        e_ready,
        op0_address_is_valid,
        op1_address_is_valid
    );





endmodule

// determines of fsm should start running
module dcache_interface_start_fsm (
    out,

    a_valid,
    e_ready,
    op0_valid,
    op1_valid
);
    output out;

    input a_valid;
    input e_ready;
    input op0_valid;
    input op1_valid;

    wire op0_a_valid;
    and3$ op0_and (op0_a_valid, a_valid, op0_valid, e_ready);

    wire op1_a_valid;
    and3$ op1_and (op1_a_valid, a_valid, op1_valid, e_ready);

    or2$ out_or (out, op0_a_valid, op1_a_valid);
endmodule

// determines next state for rom
module dcache_interface_microsequencer (
    clk,
    reset,

    next_state,

    j,
    cond,
    rd_req_ready,
    start,
    rd_dp_valid
);
    input clk;
    input reset;

    output [2:0] next_state;

    input [2:0] j;
    input [1:0] cond;
    input rd_req_ready;
    input start;
    input rd_dp_valid;

    wire [1:0] cond_not;
    inv1$ 
    inv0 (cond_not[0], cond[0]),
    inv1 (cond_not[1], cond[1]);

    wire [2:0] next_state_reg_in;
    

    wire j0_cond;
    and3$ j0_and (j0_cond, cond[1], cond[0], rd_dp_valid);
    or2$ j0_or (next_state_reg_in[0], j[0], j0_cond);

    wire j1_cond;
    and3$ j1_and (j1_cond, cond_not[1], cond[0], start);
    or2$ j1_or (next_state_reg_in[1], j[1], j1_cond);

    wire j2_cond;
    and3$ j2_and (j2_cond, cond[1], cond_not[0], rd_req_ready);
    or2$ j2_or (next_state_reg_in[2], j[2], j2_cond);

    // from register_file
    wire [31:0] next_state_out;
    assign next_state = next_state_out[2:0];
    register_32_reset next_state_reg (
        next_state_out,     // d
        {29'h0, next_state_reg_in},  // q
        32'h0,              // reset value
        1'b1,               // always enable
        clk,                // clk
        reset               // reset
    );



endmodule