
//////////////////////////////////////
//
//  DCache Interface
//



module dcache_interface (


);
    output [63:0] op0_data;
    output [63:0] op1_data;

    input [31:0] op0_address;
    input op0_address_is_valid;
    input [31:0] op1_address;
    input op1_address_is_valid;

    input [2:0] size;

    // interface to dcache
    output rd_req_valid;
    input rd_req_ready;
    output [31:0] rd_req_address;
    input rd_dp_valid;
    output rd_dp_ready;
    input [63:0] rd_dp_read_data;


    // Three possible situations:
        // op0 is valid
        // op1 is valid
        // op0 and op1 is valid

    // if only one is valid read from memory directly
    // if both are active, read op0 then op1

    // use mux to select the input to rd_req_address with its value coming from {op1_addr_is_valid, op0_addr_is_valid}
        // 00: Do nothing
        // 01: rd_req_address = op0_address and rd_req_valid = 1
        // 10: rd_req_address = op1_address and rd_req_valid = 1
        // 11: first read op0_address then read op1_address

    // actually, this doesn't actually happen. only need to read one memory location at a time
    // reading both:
        // set address to op0 address
        // wait for rd_dp_valid to be 1
        // set this value to a register and set address to op1 address
        // wait for rd_dp_valid to be 1
        // set this value to another register and finish



endmodule