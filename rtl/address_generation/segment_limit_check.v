
//////////////////////////////////////
//
//  makes sure address is within the segment limit
//

module segment_limit_check (
    cause_exception,

    address,
    address_is_valid,

    segment,

    size
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
    // slow_addr #(.WIDTH(32)) size_adder (address, num_bytes, added_address, c_out);
    // from rtl/execute/CLA.v
    CLA32 size_adder (address, num_bytes, 1'b0, added_address, , c_out);

    wire [31:0] largest_address;
    mux #(.WIDTH(32), .INPUTS(2)) sat_mux (
        {32'hFFFFFFFF, added_address},
        largest_address,
        c_out
    );

    // compare it to the current segment that is being used
    wire [31:0] seg_max;
    mux #(.WIDTH(32), .INPUTS(8)) seg_limit_mux (
        {
            32'h0,
            32'h0,
            gs_limit,
            fs_limit,
            es_limit,
            ss_limit,
            ds_limit,
            cs_limit
        },
        seg_max,
        segment
    );

    // from rtl/execute/ucomp.v
    // safe if largest_address < seg_max, so fault on inverse of this
    wire safe;
    ucomp32 seg_compare (largest_address, seg_max, , , safe);

    wire unsafe;
    inv1$ safe_inv (unsafe, safe);

    // only cause exception if this address is valid
    and2$ out_and (cause_exception, unsafe, address_is_valid);

endmodule