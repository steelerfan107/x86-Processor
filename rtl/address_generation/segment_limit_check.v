
//////////////////////////////////////
//
//  makes sure address is within the segment limit
//

module segment_limit_check (
    
);
    output cause_exception;

    input [31:0] address;
    input address_is_valid;

    input [2:0] segment;


    input [2:0] size;

    // segment limits
    wire [31:0] cs_limit = 32'h04fff000;
    wire [31:0] ds_limit = 32'h011ff000;
    wire [31:0] ss_limit = 32'h04000000;
    wire [31:0] es_limit = 32'h003ff000;
    wire [31:0] fs_limit = 32'h003ff000;
    wire [31:0] gs_limit = 32'h007ff000;

    // have 3 of these blocks, 2 for operands and one for stack address


    // Add the number of bytes that are being read to the address
    wire [31:0] num_bytes;

    mux #(.WIDTH(32), .INPUTS(8)) size_mux (
        {
            32'h0,  // not used
            32'h0,  // not used
            32'h7,  // 64
            32'h0,  // not used
            32'h3,  // 32
            32'h1,  // 16
            32'h0,  // 1
            32'h0   // 0
        },
        num_bytes,
        size
    );

    wire [31:0] added_address;
    wire c_out;
    // this should be a saturating adder tbh. bc it will loop back to 0 and not cause exception 
    slow_addr #(.WIDTH(32)) size_adder (address, num_bytes, added_address, c_out);

    wire [31:0] largest_address;
    mux #(.WIDTH(32), .INPUTS(2)) sat_mux (
        {32'hFFFFFFFF, added_address},
        largest_address,
        c_out
    );

    // compare it to the current segment that is being used
    

    // if the address is less than the limit, do not cause exception




    // create a segment select parameter passed into the stage for the checking




endmodule