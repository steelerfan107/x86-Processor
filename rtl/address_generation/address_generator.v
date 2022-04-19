
//////////////////////////////////////
//
//  Address Generator Module
//
//  Holds components for address generator

// no longer used. Address generation logic now contained in address_generation_top module
module address_generator (
    address_1,
    address_1_valid,
    address_2,
    address_2_valid,

    op1_mode,
    op2_mode,

    mod_rm_byte,

    sib_byte,

    op1_reg,
    op2_reg,

    immediate,

    displacement,

    eax,
    ecx,
    edx,
    ebx,
    esp,
    ebp,
    esi,
    edi
);

    output [31:0] address_1;
    output address_1_valid;
    output [31:0] address_2;
    output address_2_valid;

    input [2:0] op1_mode;
    input [2:0] op2_mode;

    input [7:0] mod_rm_byte;

    input [7:0] sib_byte;

    input [7:0] op1_reg;
    input [7:0] op2_reg;

    input [7:0] immediate;

    input [31:0] displacement;

    input [31:0] eax;
    input [31:0] ecx;
    input [31:0] edx;
    input [31:0] ebx;
    input [31:0] esp;
    input [31:0] ebp;
    input [31:0] esi;
    input [31:0] edi;

    

endmodule


// ------ //
// Mod RM //
// ------ //

// Generates effective address based on modrm
module mod_rm (
    value,

    is_address,
    
    mod_rm_byte,
    sib_byte,

    eax,
    ecx,
    edx,
    ebx,
    esp,
    ebp,
    esi,
    edi,

    reg_0,
    reg_1,
    reg_2,
    reg_3,
    reg_4,
    reg_5,
    reg_6,
    reg_7,

    displacement,

    seg_sel,
    seg_override_valid,

    es,
    cs,
    ss,
    ds,
    fs,
    gs
);

    output [63:0] value;

    output is_address;  // 1 if an address and needs mem read, 0 if its a reg value
    
    input [7:0] mod_rm_byte;
    input [7:0] sib_byte;

    input [31:0] eax;
    input [31:0] ecx;
    input [31:0] edx;
    input [31:0] ebx;
    input [31:0] esp;
    input [31:0] ebp;
    input [31:0] esi;
    input [31:0] edi;

    input [63:0] reg_0;
    input [63:0] reg_1;
    input [63:0] reg_2;
    input [63:0] reg_3;
    input [63:0] reg_4;
    input [63:0] reg_5;
    input [63:0] reg_6;
    input [63:0] reg_7;

    input [31:0] displacement;

    input [2:0] seg_sel;
    input seg_override_valid;

    input [15:0] es;
    input [15:0] cs;
    input [15:0] ss;
    input [15:0] ds;
    input [15:0] fs;
    input [15:0] gs;

    wire [1:0] mod = mod_rm_byte[7:6];
    wire [2:0] reg_opcode = mod_rm_byte[5:3];
    wire [2:0] rm = mod_rm_byte[2:0];


    wire [31:0] sib_out;

    // sib value
    sib sib_block (
        sib_out,

        sib_byte,

        eax,
        ecx,
        edx,
        ebx,
        esp,
        ebp,
        esi,
        edi,

        seg_sel,
        seg_override_valid,

        es,
        cs,
        ss,
        ds,
        fs,
        gs
    );

    // displacements
    wire [31:0] eax_disp;
    wire [31:0] ecx_disp;
    wire [31:0] edx_disp;
    wire [31:0] ebx_disp;
    // wire [31:0] esp_disp;
    wire [31:0] ebp_disp;
    wire [31:0] esi_disp;
    wire [31:0] edi_disp;
    wire [31:0] sib_disp;

    // Assume displacement is passed in as either 8 bit or 32 bit correctly
    address_generation_32_bit_adder 
    eax_disp_adder (eax_disp, eax, displacement),
    ecx_disp_adder (ecx_disp, ecx, displacement),
    edx_disp_adder (edx_disp, edx, displacement),
    ebx_disp_adder (ebx_disp, ebx, displacement),
    // esp_disp_adder (esp_disp, esp, displacement),
    ebp_disp_adder (ebp_disp, ebp, displacement),
    esi_disp_adder (esi_disp, esi, displacement),
    edi_disp_adder (edi_disp, edi, displacement),
    sib_disp_adder (sib_disp, sib_out, displacement);
    

    // mod 00
    wire [31:0] mod_00_out;

    mux #(.WIDTH(32), .INPUTS(8)) mod_00_mux (
        {edi, esi, displacement, sib_out, ebx, edx, ecx, eax},
        mod_00_out,
        rm
    );

    // mod 01 and 10
    wire [31:0] mod_disp_out;

    mux #(.WIDTH(32), .INPUTS(8)) mod_01_mux (
        {edi_disp, esi_disp, ebp_disp, sib_disp, ebx_disp, edx_disp, ecx_disp, eax_disp},
        mod_disp_out,
        rm
    );

    // mod 11
    // can be 32 bit register, 16 bit regiter, 8 bit register, or 64 bit register
    
    wire [63:0] mod_11_out;
    mux #(.WIDTH(64), .INPUTS(8)) mod_11_mux (
        {reg_7, reg_6, reg_5, reg_4, reg_3, reg_2, reg_1, reg_0},
        mod_11_out,
        rm
    );

    // select output
    wire [63:0] mod_mux_out;

    mux #(.WIDTH(64), .INPUTS(4)) mod_mux (
        {mod_11_out, {32'h0000_0000, mod_disp_out}, {32'h0000_0000, mod_disp_out}, {32'h0000_0000, mod_00_out}},
        mod_mux_out,
        mod
    );
    // add segment register but only if its mod 00, 01, 10 and its not rm 100
    // needs_seg = (!mod0&!rm2) | (!mod1&!rm2) | (!mod0&rm1) | (!mod1&rm1) | (
    // !mod0&rm0) | (!mod1&rm0);

    wire need_seg;  // 1 if needs segment register; 0 if does not need segment register

    wire mod0_not;
    wire rm2_not;
    wire and0;
    wire mod1_not;
    wire and1;
    wire and2;
    wire and3;
    wire and4;
    wire and5;
    // wire or0;

    // wire mod0 = mod[0];
    // wire mod1 = mod[1];

    inv1$ mod0_inv (.out(mod0_not), .in(mod[0]));
    inv1$ rm2_inv (.out(rm2_not), .in(rm[2]));
    inv1$ mod1_inv (.out(mod1_not), .in(mod[1]));

    and2$ and_gate0(.out(and0), .in0(mod0_not), .in1(rm2_not));
    and2$ and_gate1(.out(and1), .in0(mod1_not), .in1(rm2_not));
    and2$ and_gate2(.out(and2), .in0(mod0_not), .in1(rm[1]));
    and2$ and_gate3(.out(and3), .in0(mod1_not), .in1(rm[1]));
    and2$ and_gate4(.out(and4), .in0(mod0_not), .in1(rm[0]));
    and2$ and_gate5(.out(and5), .in0(mod1_not), .in1(rm[0]));

    wire or_out_0, or_out_1;

    or3$ 
    or_gate0(.out(or_out_0), .in0(and0), .in1(and1), .in2(and2)),
    or_gate1(.out(or_out_1), .in0(and3), .in1(and4), .in2(and5));

    or2$ or_gate2(needs_seg, or_out_0, or_out_1);


    // assign needs_seg = or0;

    // mux that if 1, adds segment register to output

    // have mux selecting desired segment
    

    // mux #(.WIDTH(16), .INPUTS(8)) seg_select_mux (
    //     {16'h0, 16'h0, gs, fs, ds, ss, cs, es},
    //     seg_select_out,
    //     seg_sel
    // );

    // // shift
    // wire [31:0] seg_shift;

    // segment_shifter shifter (
    //     seg_shift,
    //     seg_select_out
    // );

    // If r/m is ebp, use ss. else use ds
    wire [2:0] rm_not;
    genvar i;
    generate
        for (i = 0; i < 3; i = i + 1) begin
            inv1$ rm_inv (rm_not[i], rm[i]);
        end
    endgenerate

    // it is ebp if rm is 101 and mod is not 00
    wire rm_is_ebp;
    and3$ and_rm_is_ebp (rm_is_ebp, rm[2], rm_not[1], rm[0]);

    wire [1:0] mod_not;
    inv1$ 
    inv_mod0 (mod_not[0], mod[0]),
    inv_mod1 (mod_not[1], mod[1]);
    
    // is mod not 00
    wire mod_not_00;
    or2$ or_mod_not_00 (mod_not_00, mod[0], mod[1]);

    // is mod not 00 and is rm 101
    wire is_accessing_stack;
    and2$ and_is_accessing_stack (is_accessing_stack, rm_is_ebp, mod_not_00);

    // select segment
    wire [2:0] normal_segment;
    mux #(.WIDTH(3), .INPUTS(2)) normal_segment_mux (
        {3'b010, 3'b011},
        normal_segment,
        is_accessing_stack
    );

    // pick what to use based on seg override
    wire [2:0] selected_seg_id;

    mux #(.WIDTH(3), .INPUTS(2)) seg_override_mux (
        {seg_sel, normal_segment},
        selected_seg_id,
        seg_override_valid
    );

    // get segment value from reg
    wire [15:0] seg_select_out;

    mux #(.WIDTH(16), .INPUTS(8)) seg_select_mux (
        {16'h0, 16'h0, gs, fs, ds, ss, cs, es},
        seg_select_out,
        selected_seg_id
    );

    // shift
    wire [31:0] seg_shift;

    segment_shifter shifter (
        seg_shift,
        seg_select_out
    );

    // add it to value
    wire [31:0] address_plus_segment;
    address_generation_32_bit_adder seg_adder (
        address_plus_segment[31:0],
        mod_mux_out[31:0],
        seg_shift
    );

    // use mux to select the addition, or the regular value, 
    mux #(.WIDTH(64), .INPUTS(2)) seg_or_no_seg (
        {{32'h0000_0000, address_plus_segment}, mod_mux_out},
        value,
        needs_seg
    );

    // set is_address if its 00, 01, or 10
    // wire mod[0]_not;
    // wire mod[1]_not;
    // wire [1:0] mod_not;
    // wire or3;

    // inv1$ mod2_inv (.out(mod_not[0]), .in(mod[0]));
    // inv1$ mod3_inv (.out(mod_not[1]), .in(mod[1]));


    or2$ or_gate3(.out(or3), .in0(mod_not[0]), .in1(mod_not[1]));

    assign is_address = or3;

endmodule

// --- //
// SIB //
// --- //



module sib (
    sib_out,

    sib_byte,

    // no esp
    eax,
    ecx,
    edx,
    ebx,
    esp,
    ebp,
    esi,
    edi,

    seg_sel,
    seg_override_valid,

    es,
    cs,
    ss,
    ds,
    fs,
    gs

);

    output [31:0] sib_out;

    input [7:0] sib_byte;

    // no esp
    input [31:0] eax;
    input [31:0] ecx;
    input [31:0] edx;
    input [31:0] ebx;
    input [31:0] esp;
    input [31:0] ebp;
    input [31:0] esi;
    input [31:0] edi;

    input [2:0] seg_sel;
    input seg_override_valid;

    input [15:0] es;
    input [15:0] cs;
    input [15:0] ss;
    input [15:0] ds;
    input [15:0] fs;
    input [15:0] gs;

    wire [2:0] base = sib_byte[2:0];
    wire [1:0] segment_scale = sib_byte[7:6];
    wire [2:0] index = sib_byte[5:3];

    wire [31:0] none = 0;

    // SS = 00
    wire [255:0] index_00_mux_in;
    assign index_00_mux_in[31:0] = eax;
    assign index_00_mux_in[63:32] = ecx;
    assign index_00_mux_in[95:64] = edx;
    assign index_00_mux_in[127:96] = ebx;
    assign index_00_mux_in[159:128] = none;
    assign index_00_mux_in[191:160] = ebp;
    assign index_00_mux_in[223:192] = esi;
    assign index_00_mux_in[255:224] = edi;

    wire [31:0] index_00_mux_out;

    address_generator_mux_8_32 index_00_mux (
        index_00_mux_out, 
        eax, ecx, edx, ebx, none, ebp, esi, edi, 
        index
    );

    // SS = 01

    wire [31:0] eax_2;
    wire [31:0] ecx_2;
    wire [31:0] edx_2;
    wire [31:0] ebx_2;
    wire [31:0] ebp_2;
    wire [31:0] esi_2;
    wire [31:0] edi_2;

    sib_shifter_2 
    eax_shift_2 (eax_2, eax),
    ecx_shift_2 (ecx_2, ecx),
    edx_shift_2 (edx_2, edx),
    ebx_shift_2 (ebx_2, ebx),
    ebp_shift_2 (ebp_2, ebp),
    esi_shift_2 (esi_2, esi),
    edi_shift_2 (edi_2, edi);

    wire [255:0] index_01_mux_in;
    assign index_01_mux_in[31:0] = eax_2;
    assign index_01_mux_in[63:32] = ecx_2;
    assign index_01_mux_in[95:64] = edx_2;
    assign index_01_mux_in[127:96] = ebx_2;
    assign index_01_mux_in[159:128] = none;
    assign index_01_mux_in[191:160] = ebp_2;
    assign index_01_mux_in[223:192] = esi_2;
    assign index_01_mux_in[255:224] = edi_2;

    wire [31:0] index_01_mux_out;

    address_generator_mux_8_32 index_01_mux (
        index_01_mux_out, 
        eax_2, ecx_2, edx_2, ebx_2, none, ebp_2, esi_2, edi_2, 
        index
    );

    // SS = 10

    wire [31:0] eax_4;
    wire [31:0] ecx_4;
    wire [31:0] edx_4;
    wire [31:0] ebx_4;
    wire [31:0] ebp_4;
    wire [31:0] esi_4;
    wire [31:0] edi_4;

    sib_shifter_4 
    eax_shift_4 (eax_4, eax),
    ecx_shift_4 (ecx_4, ecx),
    edx_shift_4 (edx_4, edx),
    ebx_shift_4 (ebx_4, ebx),
    ebp_shift_4 (ebp_4, ebp),
    esi_shift_4 (esi_4, esi),
    edi_shift_4 (edi_4, edi);

    wire [255:0] index_10_mux_in;
    assign index_10_mux_in[31:0] = eax_4;
    assign index_10_mux_in[63:32] = ecx_4;
    assign index_10_mux_in[95:64] = edx_4;
    assign index_10_mux_in[127:96] = ebx_4;
    assign index_10_mux_in[159:128] = none;
    assign index_10_mux_in[191:160] = ebp_4;
    assign index_10_mux_in[223:192] = esi_4;
    assign index_10_mux_in[255:224] = edi_4;

    wire [31:0] index_10_mux_out;

    address_generator_mux_8_32 index_10_mux (
        index_10_mux_out, 
        eax_4, ecx_4, edx_4, ebx_4, none, ebp_4, esi_4, edi_4, 
        index
    );


    // SS = 11

    wire [31:0] eax_8;
    wire [31:0] ecx_8;
    wire [31:0] edx_8;
    wire [31:0] ebx_8;
    wire [31:0] ebp_8;
    wire [31:0] esi_8;
    wire [31:0] edi_8;

    sib_shifter_8 
    eax_shift_8 (eax_8, eax),
    ecx_shift_8 (ecx_8, ecx),
    edx_shift_8 (edx_8, edx),
    ebx_shift_8 (ebx_8, ebx),
    ebp_shift_8 (ebp_8, ebp),
    esi_shift_8 (esi_8, esi),
    edi_shift_8 (edi_8, edi);

    wire [255:0] index_11_mux_in;
    assign index_11_mux_in[31:0] = eax_8;
    assign index_11_mux_in[63:32] = ecx_8;
    assign index_11_mux_in[95:64] = edx_8;
    assign index_11_mux_in[127:96] = ebx_8;
    assign index_11_mux_in[159:128] = none;
    assign index_11_mux_in[191:160] = ebp_8;
    assign index_11_mux_in[223:192] = esi_8;
    assign index_11_mux_in[255:224] = edi_8;

    wire [31:0] index_11_mux_out;

    address_generator_mux_8_32 index_11_mux (
        index_11_mux_out, 
        eax_8, ecx_8, edx_8, ebx_8, none, ebp_8, esi_8, edi_8, 
        index
    );

    // mux controlled by ss signal
    wire [127:0] ss_mux_in;
    wire [31:0] ss_mux_out;

    assign ss_mux_in[31:0] = index_00_mux_out;
    assign ss_mux_in[63:32] = index_01_mux_out;
    assign ss_mux_in[95:64] = index_10_mux_out;
    assign ss_mux_in[127:96] = index_11_mux_out;

    
    mux #(.WIDTH(32), .INPUTS(4)) segment_scale_mux (
        ss_mux_in,
        ss_mux_out,
        segment_scale
    );

    // determine base
    wire [255:0] base_mux_in;
    wire [31:0] base_mux_out;

    assign base_mux_in[31:0] = eax;
    assign base_mux_in[63:32] = ecx;
    assign base_mux_in[95:64] = edx;
    assign base_mux_in[127:96] = ebx;
    assign base_mux_in[159:128] = esp;
    assign base_mux_in[191:160] = none;     // TODO: Verify that this is correct. Should it be none with this selection?
    assign base_mux_in[223:192] = esi;
    assign base_mux_in[255:224] = edi;


    address_generator_mux_8_32 base_mux (
        base_mux_out,
        eax, ecx, edx, ebx, esp, none, esi, edi,
        base
    );

    wire [31:0] base_scaled_index;

    // add base to scaled index
    address_generation_32_bit_adder base_index_adder (
        base_scaled_index,

        base_mux_out,
        ss_mux_out
    );

    // add value in segment register
    // if base is ESP then Segment is SS
    // Else use the segment register value

    // AND gate toggling a mux that selects segment as being either SS or the segment register
    // Output of this mux goes to another mux selecting the segment register value
    // Adder adding the shifted segment register value to the output of the previous adder

    // wire [2:0] base_not;

    // inv1$ 
    // base_inv0 (base_not[0], base[0]),
    // base_inv1 (base_not[1], base[1]),
    // base_inv2 (base_not[2], base[2]);

    // wire is_ss; // toggled when base is esp, 100
    // and3$ ss_seg_sel (is_ss, base[2], base_not[1], base_not[0]);

    // // 3 bit mux selecting if it is ss or seg_sel value
    // wire [5:0] seg_sel_mux_in;
    // wire [2:0] seg_sel_mux_out;

    // assign seg_sel_mux_in[2:0] = seg_sel;
    // assign seg_sel_mux_in[5:3] = 3'b010;

    // mux #(.WIDTH(3), .INPUTS(2)) seg_sel_mux (
    //     seg_sel_mux_in,
    //     seg_sel_mux_out,
    //     is_ss
    // );

    // // Use output of this mux to select the segment register

    // wire [95:0] seg_select_in;
    // wire [15:0] seg_select_out;

    // add value in segment register
    // if base is esp then segment is ss
    // is base is any other register, it is ds
    // if segment override is 1, then base is value in segment select

    // mux selecting value based on segment select value
    // wire [15:0] segment_override_mux_out;

    // mux #(.WIDTH(16), .INPUTS(8)) segment_override_mux (
    //     {16'd0, 16'd0, gs, fs, ds, ss, cs, es},
    //     segment_override_mux_out,
    //     seg_sel
    // );

    // check if base is esp and assign to wire
    wire [2:0] base_not;
    genvar i;
    generate
        for (i = 0; i < 3; i = i+1) begin
            inv1$ base_inv (base_not[i], base[i]);
        end
    endgenerate

    wire base_is_esp;
    and3$ and_is_base_esp (base_is_esp, base[2], base_not[1], base_not[0]);

    wire base_not_esp;
    inv1$ is_base_esp_inv (base_not_esp, base_is_esp);
    
    // one hot mux with input selection being based on segment override, if base is esp, and if base is not esp
    // wire [2:0] the_seg_with_the_value;
    // ao_mux #(.WIDTH(3), .NINPUTS(3)) segment_select_mux (
    //     {seg_sel, 3'b010, 3'b011},     // 010 is ss, 011 is ds
    //     the_seg_with_the_value,
    //     {seg_override_valid, base_is_esp, base_not_esp}
    // );

    // select the normal segment
    wire [2:0] normal_segment;
    ao_mux #(.WIDTH(3), .NINPUTS(2)) normal_segment_mux (
        {3'b010, 3'b011},
        normal_segment,
        {base_is_esp, base_not_esp}
    );

    // is there a segment override?
    wire [2:0] the_seg_with_the_value;
    mux #(.WIDTH(3), .INPUTS(2)) another_segment_mux (
        {seg_sel, normal_segment},
        the_seg_with_the_value,
        seg_override_valid
    );

    

    // get value of the segment selection
    // wire [15:0] seg_sel_mux_out;
    // mux #(.WIDTH(16), .INPUTS(8)) segment_value_mux (
    //     {16'd0, 16'd0, gs, fs, ds, ss, cs, es},
    //     seg_sel_mux_out,
    //     the_seg_with_the_value
    // );

    wire [15:0] seg_select_out;
    mux #(.WIDTH(16), .INPUTS(8)) seg_select (
        {16'h0, 16'h0, gs, fs, ds, ss, cs, es},
        seg_select_out,
        the_seg_with_the_value
    );

    // shift output of segment select mux
    wire [31:0] shifted_seg_value;
    segment_shifter seg_shift (
        shifted_seg_value,
        seg_select_out
    );

    // add segment register to base_scaled_index and output that value
    address_generation_32_bit_adder seg_adder (
        sib_out,

        shifted_seg_value,
        base_scaled_index
    );


endmodule


// ----------- //
// SIB Shifter //
// ----------- //

module sib_shifter_2 (
    out,
    in
);
    output [31:0] out;
    input [31:0] in;

    assign out[31:1] = in[30:0];
    assign out[0] = 0;

endmodule

module sib_shifter_4 (
    out,
    in
);
    output [31:0] out;
    input [31:0] in;

    assign out[31:2] = in[29:0];
    assign out[1:0] = 0;
    
endmodule

module sib_shifter_8 (
    out,
    in
);
    output [31:0] out;
    input [31:0] in;

    assign out[31:3] = in[28:0];
    assign out[2:0] = 0;
    
endmodule

// --------------- //
// Segment Shifter //
// --------------- //

// Shifts Segment Register by 16 bits
module segment_shifter (
    out,
    in
);
    output [31:0] out;
    input [15:0] in;

    assign out[31:16] = in;
    assign out[15:0] = 0;

endmodule

// -------------- //
// 32 bit 8-1 mux //
// -------------- //
module address_generator_mux_8_32 (
    out,
    a, b, c, d, e, f, g, h,
    s
);
    output [31:0] out;
    input [31:0] a, b, c, d, e, f, g, h;
    input [2:0] s;

    // abcd
    wire [31:0] abcd_out, efgh_out;

    mux #(.WIDTH(32), .INPUTS(4)) 
    mux_abcd ({d, c, b, a}, abcd_out, s[1:0]),
    mux_efgh ({h, g, f, e}, efgh_out, s[1:0]);

    mux #(.WIDTH(32), .INPUTS(2)) 
    mux_output ({efgh_out, abcd_out}, out, s[2]);


endmodule



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

// module address_generator_old (
//     mode,

//     op_1,
//     op_2,
//     op_size,
    

//     sib_enable,
//     sib_scale,
//     sib_base,
//     sib_index,

//     address_displacement,

//     segment_register_value,

//     op_1_out,
//     op_1_read_enable,

//     op_2_out,
//     op_2_read_enable

// );

//     input [2:0] mode;

//     input [31:0] op_1;
//     input [31:0] op_2;
//     input [1:0] op_size;
    

//     input sib_enable;
//     input [1:0] sib_scale;
//     input [31:0] sib_base;
//     input [31:0] sib_index;

//     input [31:0] address_displacement;

//     input [15:0] segment_register_value;

//     output [31:0] op_1_out;
//     output op_1_read_enable;

//     output [31:0] op_2_out;
//     output op_2_read_enable;

//     // outputs will have mux with selection done by the mode input
//     // read enable controlled by digital logic block with output determined by mode input

//     // any address will need segment address added to it
//     wire [31:0] op_1_seg, op_2_seg;
//     wire [31:0] shifted_seg;

//     assign shifted_seg[31:16] = segment_register_value[15:0];
//     assign shifted_seg[15:0] = 0;

//     address_generation_32_bit_adder 
//     op_1_seg_adder (op_1_seg, op_1, shifted_seg),
//     op_2_seg_adder (op_2_seg, op_2, shifted_seg);


//     // op1 is an effective address plus displacement
//     wire [31:0] op1_addr_disp;
//     modrm_addr_disp modrm_1 (op1_addr_disp, op_1_seg, address_displacement);

//     // op2 is an effective address plus displacement
//     wire [31:0] op2_addr_disp;
//     modrm_addr_disp modrm_2 (op2_addr_disp, op_2_seg, address_displacement);

//     // next, instantiate the SIB block
//     wire [31:0] sib_out;

//     sib_calculation sib_calculation (sib_out, sib_base, sib_index, sib_scale, address_displacement);

//     // create mux selecting proper output
//     // TODO: Condense this mux down to 3 inputs lol
//     wire [255:0] op1_mux_in;
//     assign [31:0] op1_mux_in = op_1;            // no generation needed
//     assign [63:32] op1_mux_in = op1_addr_disp;  // ModR/M
//     assign [95:64] op1_mux_in = op_1;           // no generation needed
//     assign [127:96] op1_mux_in = sib_out;       // sib
//     assign [159:128] op1_mux_in = op_1;         // no generation needed
//     assign [191:160] op1_mux_in = op_1;         // no generation needed

//     mux #(.WIDTH(32), .INPUTS(8)) op1_mux (op1_mux_in, op_1_out, mode);

//     wire [255:0] op2_mux_in;

//     wire [255:0] op2_mux_in;
//     assign [31:0] op2_mux_in = op_2;            // no generation needed
//     assign [63:32] op2_mux_in = op_2;  // ModR/M
//     assign [95:64] op2_mux_in = op2_addr_disp;           // no generation needed
//     assign [127:96] op2_mux_in = op_2;       // sib
//     assign [159:128] op2_mux_in = sib_out;         // no generation needed
//     assign [191:160] op2_mux_in = op_2;         // no generation needed

//     mux #(.WIDTH(32), .INPUTS(8)) op2_mux (op2_mux_in, op_2_out, mode);

//     // TODO: create digital logic block for read enable


    


// endmodule


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
    mux #(.WIDTH(32), .INPUTS(4)) scale_select (
        scale_select_in, 
        scale_select_out, 
        scale
    );

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
    displacement

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
