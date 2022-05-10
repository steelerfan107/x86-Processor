
//////////////////////////////////////
//
//  Register File Module
//
//  Holds components for register file

module register_file (
    clk,
    reset,

    register_size,

    op_1,
    op_1_value,

    op_2,
    op_2_value,

    sib_base_reg,
    sib_base_value,
    sib_index_reg,
    sib_index_value,
    
    writeback_reg,
    writeback_en,
    writeback_size,
    writeback_data,

    esi_data,
    esi_en,
    edi_data,
    edi_en,
    write_esp,
    write_esp_enable,

    eax_out,
    ecx_out,
    edx_out,
    ebx_out,
    esp_out,
    ebp_out,
    esi_out,
    edi_out

);

    input clk;
    input reset;

    input [1:0] register_size;

    input [2:0] op_1;
    output [31:0] op_1_value;

    input [2:0] op_2;
    output [31:0] op_2_value;

    input [2:0] sib_base_reg;
    output [31:0] sib_base_value;
    input [2:0] sib_index_reg;
    output [31:0] sib_index_value;

    input [2:0] writeback_reg;     // number of writeback register
    input writeback_en;
    input [1:0] writeback_size;
    input [31:0] writeback_data;

    // for movs
    input [31:0] esi_data;
    input esi_en;
    input [31:0] edi_data;
    input edi_en;

    input [31:0]  write_esp;
    input 	  write_esp_enable;
  
    output [31:0] eax_out;
    output [31:0] ecx_out;
    output [31:0] edx_out;
    output [31:0] ebx_out;
    output [31:0] esp_out;
    output [31:0] ebp_out;
    output [31:0] esi_out;
    output [31:0] edi_out;

    

    // each register gets a 32 bit reg
    // wires for registers
    // these are disconnected since registers start unitinialized
    wire [31:0] eax_reset_in;
    wire [31:0] ecx_reset_in;
    wire [31:0] edx_reset_in;
    wire [31:0] ebx_reset_in;
    wire [31:0] esp_reset_in;
    wire [31:0] ebp_reset_in;
    wire [31:0] esi_reset_in;
    wire [31:0] edi_reset_in;



    wire eax_en;
    wire ecx_en;
    wire edx_en;
    wire ebx_en;
    wire esp_en;
    wire ebp_en;
    wire esi_en;
    wire edi_en;

    // register size and output selectors for operands
    register_output_size_selector 
    op1_out_select(
        op_1_value, 
        op_1, 
        register_size,

        eax_out,
        ecx_out,
        edx_out,
        ebx_out,
        esp_out,
        ebp_out,
        esi_out,
        edi_out
    ),
    op2_out_select(
        op_2_value, 
        op_2, 
        register_size,

        eax_out,
        ecx_out,
        edx_out,
        ebx_out,
        esp_out,
        ebp_out,
        esi_out,
        edi_out
    );

    // muxes for sib output
    reg_mux8_32 
    sib_base_reg_mux (sib_base_value, eax_out, ecx_out, edx_out, ebx_out, esp_out, ebp_out, esi_out, edi_out, sib_base_reg),
    sib_index_reg_mux (sib_index_value, eax_out, ecx_out, edx_out, ebx_out, esp_out, ebp_out, esi_out, edi_out, sib_index_reg);

    // Set register inputs
    wire [31:0] reg_inputs;
    register_input_size_selector reg_size_sel (
        reg_inputs,

        writeback_reg, 
        writeback_size,
        writeback_data,

        eax_out,
        ecx_out,
        edx_out,
        ebx_out,
        esp_out,
        ebp_out,
        esi_out,
        edi_out
    );

    // set writeback for reg

    // i made the writeback en logic block work by outputting a reg number rather than being one hot
    // now gotta decode the reg number to one hot...
    // also add an AND gate so it only writes to reg if writeback_en is 1

    wire [2:0] selected_reg;
    register_writeback_select wb_sel (selected_reg, writeback_reg, writeback_size);

    // decode the selected reg signal into something useful
    wire [7:0] wb_en;

    wire ld_eax;
    wire ld_ecx;
    wire ld_edx;
    wire ld_ebx;
    wire ld_esp;
    wire ld_ebp;
    wire ld_esi;
    wire ld_edi;

    decoder3_8$ wb_decoder (selected_reg, wb_en, );

    // and gate to enable load only when we actually want to load
    and2$ 
    and_ld_eax (ld_eax, wb_en[0], writeback_en),
    and_ld_ecx (ld_ecx, wb_en[1], writeback_en),
    and_ld_edx (ld_edx, wb_en[2], writeback_en),
    and_ld_ebx (ld_ebx, wb_en[3], writeback_en),
    and_ld_esp (ld_esp, wb_en[4], writeback_en),
    and_ld_ebp (ld_ebp, wb_en[5], writeback_en),
    and_ld_esi (ld_esi, wb_en[6], writeback_en),
    and_ld_edi (ld_edi, wb_en[7], writeback_en);

    // direct esi and edi loads
    // if directly load, set ld to 1 and data to esi/edi data
    wire esi_mux_ld_out, edi_mux_ld_out;

    wire [31:0] esi_mux_data_out, edi_mux_data_out;

    mux #(.WIDTH(32), .INPUTS(2)) esi_mux_data (
        {esi_data, reg_inputs},
        esi_mux_data_out,
        esi_en
    );

    mux #(.WIDTH(32), .INPUTS(2)) edi_mux_data (
        {edi_data, reg_inputs},
        edi_mux_data_out,
        edi_en
    );

    mux #(.WIDTH(1), .INPUTS(2)) esi_mux_ld (
        {1'b1, ld_esi},
        esi_mux_ld_out,
        esi_en
    );

    mux #(.WIDTH(1), .INPUTS(2)) edi_mux_ld (
        {1'b1, ld_edi},
        esi_mux_ld_out,
        edi_en
    );

    wire 	  ld_esp_comb;
    wire [31:0]	  esp_data;

    or2$ (ld_esp_comb, ld_esp, write_esp_enable);

    mux #(.WIDTH(32), .INPUTS(2)) esb_mux (
        {reg_inputs,write_esp},
        esp_data,
        ld_esp
    );
   
    // instantiate the registers
    register_32_reset 
    eax (eax_out, reg_inputs, eax_reset_in, ld_eax, clk, reset),
    ecx (ecx_out, reg_inputs, ecx_reset_in, ld_ecx, clk, reset),
    edx (edx_out, reg_inputs, edx_reset_in, ld_edx, clk, reset),
    ebx (ebx_out, reg_inputs, ebx_reset_in, ld_ebx, clk, reset),
    esp (esp_out,   esp_data, esp_reset_in, ld_esp_comb, clk, reset),
    ebp (ebp_out, reg_inputs, ebp_reset_in, ld_ebp, clk, reset),
    esi (esi_out, esi_mux_data_out, esi_reset_in, esi_mux_ld_out, clk, reset),
    edi (edi_out, edi_mux_data_out, edi_reset_in, esi_mux_ld_out, clk, reset);

endmodule

// ---------------- //
// Writeback Select //
// ---------------- //
module register_writeback_select(
    selected_reg,

    reg_num, 
    reg_size
);

    output [2:0] selected_reg;

    input [2:0] reg_num;
    input [1:0] reg_size;

    wire num2 = reg_num[2];
    wire num1 = reg_num[1];
    wire num0 = reg_num[0];

    wire size1 = reg_size[1];
    wire size0 = reg_size[0];

    wire and0;
    wire and1;
    wire and2;
    wire or0;
    wire and3;
    wire and4;
    wire or1;


    and2$ and_gate0(.out(and0), .in0(num2), .in1(size1));
    and2$ and_gate1(.out(and1), .in0(num1), .in1(size0));
    and2$ and_gate2(.out(and2), .in0(num1), .in1(size1));
    and2$ and_gate3(.out(and3), .in0(num0), .in1(size0));
    and2$ and_gate4(.out(and4), .in0(num0), .in1(size1));

    or2$ or_gate0(.out(or0), .in0(and1), .in1(and2));
    or2$ or_gate1(.out(or1), .in0(and3), .in1(and4));

    assign selected_reg[2] = and0;
    assign selected_reg[1] = or0;
    assign selected_reg[0] = or1;

endmodule


// ------------------- //
// Input Size Selector //
// ------------------- //

// Sets the register inputs based on register number, register contents, and size
// Does not do load enable. 
// This logic could probably be better. hope this isn't the critical path...
module register_input_size_selector (
    out,

    reg_select,
    size,
    data,

    eax,
    ecx,
    edx,
    ebx,
    esp,
    ebp,
    esi,
    edi
);

    output [31:0] out;

    input [2:0] reg_select;
    input [1:0] size;
    input [31:0] data;

    input [31:0] eax;
    input [31:0] ecx;
    input [31:0] edx;
    input [31:0] ebx;
    input [31:0] esp;
    input [31:0] ebp;
    input [31:0] esi;
    input [31:0] edi;

    wire [31:0] reg_mux_out0;
    wire [31:0] reg_mux_out1;
    wire [31:0] reg_mux_out2;
    wire [31:0] reg_mux_out3;
    wire [31:0] reg_mux_out4;
    wire [31:0] reg_mux_out5;
    wire [31:0] reg_mux_out6;
    wire [31:0] reg_mux_out7;

    // 16 bit registers
    wire [31:0] ax;
    wire [31:0] cx;
    wire [31:0] dx;
    wire [31:0] bx;
    wire [31:0] sp;
    wire [31:0] bp;
    wire [31:0] si;
    wire [31:0] di;

    register_16_bit_input_mask 
    ax_mask(ax, data, eax),
    cx_mask(cx, data, ecx),
    dx_mask(dx, data, edx),
    bx_mask(bx, data, ebx),
    sp_mask(sp, data, esp),
    bp_mask(bp, data, ebp),
    si_mask(si, data, esi),
    di_mask(di, data, edi);

    // 8 bit registers
    wire [31:0] al;
    wire [31:0] cl;
    wire [31:0] dl;
    wire [31:0] bl;
    wire [31:0] ah;
    wire [31:0] ch;
    wire [31:0] dh;
    wire [31:0] bh;

    register_low_byte_input_mask 
    al_mask(al, data, eax),
    cl_mask(cl, data, ecx),
    dl_mask(dl, data, edx),
    bl_mask(bl, data, ebx);

    register_high_byte_input_mask 
    ah_mask(ah, data, eax),
    ch_mask(ch, data, ecx),
    dh_mask(dh, data, edx),
    bh_mask(bh, data, ebx);


    // 8 muxes, one for each reg
    reg_mux4_32 
    reg_mux0 (reg_mux_out0, ,al, ax, data, size),
    reg_mux1 (reg_mux_out1, ,cl, cx, data, size),
    reg_mux2 (reg_mux_out2, ,dl, dx, data, size),
    reg_mux3 (reg_mux_out3, ,bl, bx, data, size),
    reg_mux4 (reg_mux_out4, ,ah, sp, data, size),
    reg_mux5 (reg_mux_out5, ,ch, bp, data, size),
    reg_mux6 (reg_mux_out6, ,dh, si, data, size),
    reg_mux7 (reg_mux_out7, ,bh, di, data, size);

    // mux these outputs to the final output
    reg_mux8_32 mux_final (
        out,

        reg_mux_out0,
        reg_mux_out1,
        reg_mux_out2,
        reg_mux_out3,
        reg_mux_out4,
        reg_mux_out5,
        reg_mux_out6,
        reg_mux_out7,

        reg_select

    );


endmodule

// ----------------- //
// 16-bit input mask //
// ----------------- //
module register_16_bit_input_mask (
    out,

    data,
    reg_data
);

    output [31:0] out;

    input [31:0] data;
    input [31:0] reg_data;

    // data[15:0] + reg_data[31:16]
    assign out[31:16] = reg_data[31:16];
    assign out[15:0] = data[15:0];

    
endmodule

// ------------------- //
// Low byte input mask //
// ------------------- //
module register_low_byte_input_mask (
    out,

    data,
    reg_data
);
    output [31:0] out;

    input [31:0] data;
    input [31:0] reg_data;

    // out = data[7:0] + reg_data[31:8]
    assign out[7:0] = data[7:0];
    assign out[31:8] = reg_data[31:8];


endmodule

// -------------------- //
// High byte input mask //
// -------------------- //
module register_high_byte_input_mask (
    out,

    data, 
    reg_data
);

    output [31:0] out;

    input [31:0] data;
    input [31:0] reg_data;

    // out = (data[7:0] << 8) + reg_data[31:16] + reg_data[7:0]
    assign out[15:8] = data[7:0];
    assign out[31:16] = reg_data[31:16];
    assign out[7:0] = reg_data[7:0];


endmodule

// -------------------- //
// Output Size Selector //
// -------------------- //

// Selects the proper amount of bits/proper register depending on the size of the operand
// size = 0: 32 bit
// size = 1: 16 bit
// size = 2: 8 bit
// size = 3: Not used. Will result in Z output
module register_output_size_selector (
    out, 

    reg_selection,
    size, 

    eax,
    ecx,
    edx,
    ebx,
    esp,
    ebp,
    esi,
    edi
);

    output [31:0] out;

    input [2:0] reg_selection;
    input [1:0] size;

    input [31:0] eax;
    input [31:0] ecx;
    input [31:0] edx;
    input [31:0] ebx;
    input [31:0] esp;
    input [31:0] ebp;
    input [31:0] esi;
    input [31:0] edi;

    // wire [31:0] unused; // useless wire for parameters that aren't used

    // mask each register to 16 bits
    
    wire [31:0] ax;
    wire [31:0] cx;
    wire [31:0] dx;
    wire [31:0] bx;
    wire [31:0] sp;
    wire [31:0] bp;
    wire [31:0] si;
    wire [31:0] di;

    register_16_bit_mask 
    ax_mask (ax, eax),
    cx_mask (cx, ecx),
    dx_mask (dx, edx),
    bx_mask (bx, ebx),
    sp_mask (sp, esp),
    bp_mask (bp, ebp),
    si_mask (si, esi),
    di_mask (di, edi);

    // mask registers to 4 bits
    wire [31:0] al;
    wire [31:0] cl;
    wire [31:0] dl;
    wire [31:0] bl;
    wire [31:0] ah;
    wire [31:0] ch;
    wire [31:0] dh;
    wire [31:0] bh;

    register_8_bit_mask 
    al_mask (al, eax),
    cl_mask (cl, ecx),
    dl_mask (dl, edx),
    bl_mask (bl, ebx);

    register_8_bit_mask_shift 
    ah_mask (ah, eax),
    ch_mask (ch, ecx),
    dh_mask (dh, edx),
    bh_mask (bh, ebx);

    // muxes for size
    wire [31:0] size_mux_out0;
    wire [31:0] size_mux_out1;
    wire [31:0] size_mux_out2;
    wire [31:0] size_mux_out3;
    wire [31:0] size_mux_out4;
    wire [31:0] size_mux_out5;
    wire [31:0] size_mux_out6;
    wire [31:0] size_mux_out7;

    reg_mux4_32 
    size_mux0 (size_mux_out0, eax, ax, al, , size),
    size_mux1 (size_mux_out1, ecx, cx, cl, , size),
    size_mux2 (size_mux_out2, edx, dx, dl, , size),
    size_mux3 (size_mux_out3, ebx, bx, bl, , size),
    size_mux4 (size_mux_out4, esp, sp, ah, , size),
    size_mux5 (size_mux_out5, ebp, bp, ch, , size),
    size_mux6 (size_mux_out6, esi, si, dh, , size),
    size_mux7 (size_mux_out7, edi, di, bh, , size);

    // use mux to select output based on register select
    reg_mux8_32 out_mux (
        out,

        size_mux_out0,
        size_mux_out1,
        size_mux_out2,
        size_mux_out3,
        size_mux_out4,
        size_mux_out5,
        size_mux_out6,
        size_mux_out7,

        reg_selection
    );



endmodule


// ----------- //
// 16-bit mask //
// ----------- //

// Masks out the first 16 bits for when using the 32 bit registers as 16 bit registers
module register_16_bit_mask (
    out,
    in
);

    output [31:0] out;
    input [31:0] in;

    // [31:16] are 0
    assign out [31:16] = 0;
    assign out [15:0] = in[15:0];


endmodule

// ---------- //
// 8-bit mask //
// ---------- //

// masks first 8 bits for when using 32 bit registers as 8 bit registers
module register_8_bit_mask (
    out,
    in
);

    output [31:0] out;
    input [31:0] in;

    assign out[31:8] = 0;
    assign out[7:0] = in[7:0];

endmodule

// -------------------- //
// 8-bit mask and shift //
// -------------------- //
module register_8_bit_mask_shift (
    out, 
    in
);

    output [31:0] out;
    input [31:0] in;

    assign out[31:8] = 0;
    assign out[7:0] = in[15:8];

endmodule



// ------------------------- //
// RESETABLE 32 BIT REGISTER //
// ------------------------- //

// Value of register can be reset by seting reset to 1 and setting clk to 1
// Set to the value on its reset input
module register_32_reset (q, d, d_reset, en, clk, reset);
      input [31:0] d, d_reset;
      input en, clk, reset;
      output [31:0] q;

      // mux selecting input as either d_reset or d

      // or gate on enable that is either en or rst

      wire [31:0] mux_out;

      reg_mux2_32 mux0 (mux_out, d, d_reset, reset);

      wire load_reg;

      or2$ or0 (load_reg, en, reset);

      register_32 r0 (q, mux_out, load_reg, clk);

endmodule


// --------------- //
// 32 Bit Register //
// --------------- //

// Register that has its value update when clk and en == 1
module register_32 (q, d, en, clk);
    input [31:0] d;
    input en, clk;
    output [31:0] q;

    wire [31:0] qbar;
    wire clr = 1;
    wire pre = 1;

    reg32e$ r (clk, d, q, qbar, clr, pre, en);

endmodule

//----------

// 32 bit 8-1 mux

//----------
module reg_mux8_32 (out, a, b, c, d, e, f, g, h, s);
    input [31:0] a, b, c, d, e, f, g, h;
    input [2:0] s;
    output [31:0] out;

    // 000 - a
    // 001 - b
    // 010 - c
    // 011 - d
    // 100 - e
    // 101 - f
    // 110 - g
    // 111 - h

    // 2 4-1 muxes at the top connecting to a 2-1 mux

    // abcd
    wire [31:0] abcd_out, efgh_out;

    reg_mux4_32 mux_abcd (abcd_out, a, b, c, d, s[1:0]),
            mux_efgh (efgh_out, e, f, g, h, s[1:0]);

    reg_mux2_32 mux_output (out, abcd_out, efgh_out, s[2]);

endmodule


//----------

// 32 bit 4-1 mux

//----------
module reg_mux4_32 (out, a, b, c, d, s);
    input [31:0] a, b, c, d;
    input [1:0] s;
    output [31:0] out;

    mux4_16$ mux0 (out[15:0], a[15:0], b[15:0], c[15:0], d[15:0], s[0], s[1]),
             mux1 (out[31:16], a[31:16], b[31:16], c[31:16], d[31:16], s[0], s[1]);

endmodule

//----------

// 32 bit 2-1 mux

//----------
module reg_mux2_32 (out, a, b, s);
    input [31:0] a, b;
    input s;
    output [31:0] out;

    mux2_16$ mux0 (out[15:0], a[15:0], b[15:0], s),
            mux1 (out[31:16], a[31:16], b[31:16], s);

endmodule
