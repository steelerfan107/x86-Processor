
//////////////////////////////////////
//
//  Address Generator Module
//
//  Holds components for address generator

// possible addresses needed:
    // op1 and op2 are both immediates and do not need address generation
        // pass op1 and op2 with no modification
    // op1 needs modr/m and op2 is an immediate
        // pass op1 with its modr/m stuff and op2 with no modification
    // op1 is an immediate and op2 needs modr/m
        // pass op1 and op2 with its modr/m stuff
    // op1 needs modr/m plus sib and op2 is immediate
        // pass op1 with its modr/m and displacement stuff and op2 with no modification
        // don't actually use op1 for input but use it for output
    // op1 is immediate and op2 needs modr/m plus sib
        // pass op1 with no modification and op2 with its modr/m stuff and sib
        // dont actually use op2 for input but use it for output
    // op1 and op2 are addresses but need no modification (like for MOVS)
        // add segment register value to op1 and op2 (with shift) and mark them as addresses

module address_generator (
    mode,

    op_1,
    op_2,
    op_size,
    

    sib_enable,
    sib_scale,
    sib_base,
    sib_index,

    address_displacement,

    segment_register_value,

    op_1_out,
    op_1_read_enable,

    op_2_out,
    op_2_read_enable

);

    input [2:0] mode;

    input [31:0] op_1;
    input [31:0] op_2;
    input [1:0] op_size;
    

    input sib_enable;
    input [1:0] sib_scale;
    input [31:0] sib_base;
    input [31:0] sib_index;

    input [31:0] address_displacement;

    input [15:0] segment_register_value;

    output [31:0] op_1_out;
    output op_1_read_enable;

    output [31:0] op_2_out;
    output op_2_read_enable;

    // outputs will have mux with selection done by the mode input
    // read enable controlled by digital logic block with output determined by mode input

    // any address will need segment address added to it
    wire [31:0] op_1_seg, op_2_seg;
    wire [31:0] shifted_seg;

    assign shifted_seg[31:16] = segment_register_value[15:0];
    assign shifted_seg[15:0] = 0;

    address_generation_32_bit_adder 
    op_1_seg_adder (op_1_seg, op_1, shifted_seg),
    op_2_seg_adder (op_2_seg, op_2, shifted_seg);


    // op1 is an effective address plus displacement
    wire [31:0] op1_addr_disp;
    modrm_addr_disp modrm_1 (op1_addr_disp, op_1_seg, address_displacement);

    // op2 is an effective address plus displacement
    wire [31:0] op2_addr_disp;
    modrm_addr_disp modrm_2 (op2_addr_disp, op_2_seg, address_displacement);

    // next, instantiate the SIB block
    wire [31:0] sib_out;

    sib_calculation sib_calculation (sib_out, sib_base, sib_index, sib_scale, address_displacement);

    // create mux selecting proper output
    // TODO: Condense this mux down to 3 inputs lol
    wire [255:0] op1_mux_in;
    assign [31:0] op1_mux_in = op_1;            // no generation needed
    assign [63:32] op1_mux_in = op1_addr_disp;  // ModR/M
    assign [95:64] op1_mux_in = op_1;           // no generation needed
    assign [127:96] op1_mux_in = sib_out;       // sib
    assign [159:128] op1_mux_in = op_1;         // no generation needed
    assign [191:160] op1_mux_in = op_1;         // no generation needed

    mux_8_32 op1_mux (op1_mux_in, op_1_out, mode);

    wire [255:0] op2_mux_in;

    wire [255:0] op2_mux_in;
    assign [31:0] op2_mux_in = op_2;            // no generation needed
    assign [63:32] op2_mux_in = op_2;  // ModR/M
    assign [95:64] op2_mux_in = op2_addr_disp;           // no generation needed
    assign [127:96] op2_mux_in = op_2;       // sib
    assign [159:128] op2_mux_in = sib_out;         // no generation needed
    assign [191:160] op2_mux_in = op_2;         // no generation needed

    mux_8_32 op2_mux (op2_mux_in, op_2_out, mode);

    // TODO: create digital logic block for read enable


    


endmodule


// --------------- //
// SIB Calculation //
// --------------- //
module sib_calculation (
    out,

    base,
    index,
    scale,
    displacement
);
    output [31:0] out;

    input [31:0] base;
    input [31:0] index;
    input [1:0] scale;
    input [31:0] displacement;

    wire [31:0] scale_2;
    assign scale_2[31:1] = index[30:0];
    assign scale_2[0] = 0;

    wire [31:0] scale_4;
    assign scale_4[31:2] = index[29:0];
    assign scale_4[1:0] = 0;

    wire [31:0] scale_8;
    assign scale_8[31:3] = index[28:0];
    assign scale_8[2:0] = 0;

    wire [127:0] scale_select_in;
    wire [31:0] scale_select_out;
    assign scale_select_in[31:0] = index;
    assign scale_select_in[63:32] = scale_2;
    assign scale_select_in[95:64] = scale_4;
    assign scale_select_in[127:96] = scale_8;
    mux_4_32 scale_select (scale_select_in, scale_select_out, scale);

    // add base, scale out, and displacement
    wire [31:0] base_index;
    address_generation_32_bit_adder 
    add0 (base_index, base, scale_select_out),
    add1 (out, base_index, displacement);


endmodule


// -------------------------------- //
// ModR/M Address plus Displacement //
// -------------------------------- //

// Expect displacement to already be correctly sized so the add is always 32 bit
module modrm_addr_disp (
    effective_address,

    op_value,
    displacement,

);

    output [31:0] effective_address;

    input [31:0] op_value;
    input [31:0] displacement;

    address_generation_32_bit_adder modrm_add (effective_address, op_value, displacement);

endmodule

// ------------ //
// 32 Bit adder //
// ------------ //

// Bad adder lol. Replace it when Anthony makes a better one
// TODO: CHANGE TO BETTER ADDER
module address_generation_32_bit_adder (
    out,

    a,
    b
);
    output [31:0] out;
    input [31:0] a, b;
    

    wire [32:0] c;

    assign c[0] = 0;

    address_generator_rca 
    rca0 (out[0], c[1], a[0], b[0], c[0]),
    rca1 (out[1], c[2], a[1], b[1], c[1]),
    rca2 (out[2], c[3], a[2], b[2], c[2]),
    rca3 (out[3], c[4], a[3], b[3], c[3]),
    rca4 (out[4], c[5], a[4], b[4], c[4]),
    rca5 (out[5], c[6], a[5], b[5], c[5]),
    rca6 (out[6], c[7], a[6], b[6], c[6]),
    rca7 (out[7], c[8], a[7], b[7], c[7]),
    rca8 (out[8], c[9], a[8], b[8], c[8]),
    rca9 (out[9], c[10], a[9], b[9], c[9]),
    rca10 (out[10], c[11], a[10], b[10], c[10]),
    rca11 (out[11], c[12], a[11], b[11], c[11]),
    rca12 (out[12], c[13], a[12], b[12], c[12]),
    rca13 (out[13], c[14], a[13], b[13], c[13]),
    rca14 (out[14], c[15], a[14], b[14], c[14]),
    rca15 (out[15], c[16], a[15], b[15], c[15]),
    rca16 (out[16], c[17], a[16], b[16], c[16]),
    rca17 (out[17], c[18], a[17], b[17], c[17]),
    rca18 (out[18], c[19], a[18], b[18], c[18]),
    rca19 (out[19], c[20], a[19], b[19], c[19]),
    rca20 (out[20], c[21], a[20], b[20], c[20]),
    rca21 (out[21], c[22], a[21], b[21], c[21]),
    rca22 (out[22], c[23], a[22], b[22], c[22]),
    rca23 (out[23], c[24], a[23], b[23], c[23]),
    rca24 (out[24], c[25], a[24], b[24], c[24]),
    rca25 (out[25], c[26], a[25], b[25], c[25]),
    rca26 (out[26], c[27], a[26], b[26], c[26]),
    rca27 (out[27], c[28], a[27], b[27], c[27]),
    rca28 (out[28], c[29], a[28], b[28], c[28]),
    rca29 (out[29], c[30], a[29], b[29], c[29]),
    rca30 (out[30], c[31], a[30], b[30], c[30]),
    rca31 (out[31], c[32], a[31], b[31], c[31]);
        

endmodule

//----------

// RCA

//----------
// Ripple carry adder block
module address_generator_rca (out, c_out, a, b, c);
    input a, b, c;
    output out, c_out;

    wire ab_not, bc_not, ac_not;

    wire a_not, b_not, c_not;
    wire an_b_not, a_bn_not, an_bn_not;
    wire an_b, a_bn, an_bn, ab;
    wire an_b_cn_not, a_bn_cn_not, an_bn_c_not, a_b_c_not;
    wire spongebob_not, patrick_not; // bad names but they are the gates before the end product and naming based on their value would be nasty
    wire spongebob, patrick;

    nand2$ c_nand_ab (ab_not, a, b);
    nand2$ c_nand_bc (bc_not, b, c);
    nand2$ c_nand_ac (ac_not, a, c);

    nand3$ c_nand_cout (c_out, ab_not, bc_not, ac_not);

    // result logic
    nand2$ q_nand0 (a_not, a, a),
           q_nand1 (b_not, b, b),
           q_nand2 (c_not, c, c),
           q_nand3 (an_b_not, a_not, b),
           q_nand4 (a_bn_not, a, b_not),
           q_nand5 (an_bn_not, a_not, b_not),
           // ab_not already generated by carry logic
           q_nand6 (an_b, an_b_not, an_b_not),
           q_nand7 (a_bn, a_bn_not, a_bn_not),
           q_nand8 (an_bn, an_bn_not, an_bn_not),
           q_nand9 (ab, ab_not, ab_not),
           q_nand10 (an_b_cn_not, an_b, c_not),
           q_nand11 (a_bn_cn_not, a_bn, c_not),
           q_nand12 (an_bn_c_not, an_bn, c),
           q_nand13 (a_b_c_not, ab, c),
           q_nand14 (spongebob_not, an_b_cn_not, a_bn_cn_not),
           q_nand15 (patrick_not, an_bn_c_not, a_b_c_not),
           q_nand16 (spongebob, spongebob_not, spongebob_not),
           q_nand17 (patrick, patrick_not, patrick_not),
           q_nand18 (out, spongebob, patrick);

endmodule
