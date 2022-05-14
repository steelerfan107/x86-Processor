
//////////////////////////////////////
//
//  makes sure address is within the segment limit
//

module segment_limit_check (
    cause_exception,

    address,
    address_is_valid,

    segment,

    cs,
    ds,
    ss,
    es,
    fs,
    gs,

    size
);
    output cause_exception;

    input [31:0] address;
    input address_is_valid;

    input [2:0] segment;

    input [15:0] cs;
    input [15:0] ds;
    input [15:0] ss;
    input [15:0] es;
    input [15:0] fs;
    input [15:0] gs;

    input [2:0] size;

    // segment limits
    wire [31:0] cs_limit_offset = 32'h04fff000;
    wire [31:0] ds_limit_offset = 32'h011ff000;
    wire [31:0] ss_limit_offset = 32'h04000000;
    wire [31:0] es_limit_offset = 32'h003ff000;
    wire [31:0] fs_limit_offset = 32'h003ff000;
    wire [31:0] gs_limit_offset = 32'h007ff000;

    wire [31:0] cs_limit;
    wire [31:0] ds_limit;
    wire [31:0] ss_limit;
    wire [31:0] es_limit;
    wire [31:0] fs_limit;
    wire [31:0] gs_limit;

    wire [31:0] cs_shifted = {cs[15:0], 16'h0};
    wire [31:0] ds_shifted = {ds[15:0], 16'h0};
    wire [31:0] ss_shifted = {ss[15:0], 16'h0};
    wire [31:0] es_shifted = {es[15:0], 16'h0};
    wire [31:0] fs_shifted = {fs[15:0], 16'h0};
    wire [31:0] gs_shifted = {gs[15:0], 16'h0};

    slow_addr #(.WIDTH(32)) 
    cs_limit_add (cs_shifted, cs_limit_offset, cs_limit),
    ds_limit_add (ds_shifted, ds_limit_offset, ds_limit),
    ss_limit_add (ss_shifted, ss_limit_offset, ss_limit),
    es_limit_add (es_shifted, es_limit_offset, es_limit),
    fs_limit_add (fs_shifted, fs_limit_offset, fs_limit),
    gs_limit_add (gs_shifted, gs_limit_offset, gs_limit);

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
            ds_limit,
            ss_limit,
            cs_limit,
            es_limit
        },
        seg_max,
        segment
    );

    // from rtl/execute/ucomp.v
    // fault if largest_address > seg_max
    wire unsafe;
    ucomp32 seg_compare (largest_address, seg_max, unsafe, , 0);

    // only cause exception if this address is valid
    and2$ out_and (cause_exception, unsafe, address_is_valid);

endmodule