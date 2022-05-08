
//////////////////////////////////////
//
//  Top Address Generation Access Stage Module
//

module address_generation_top (
    // Clock Interface
    clk,
    reset,

    // Control Interface
    flush,

    // Register Access Interface
    r_valid,
    r_ready,
    r_size,
    r_set_d_flag,
    r_clear_d_flag,
    r_op0,
    r_op1,
    r_op0_reg,
    r_op1_reg,
    r_modrm,
    r_sib,
    r_imm,
    r_disp,
    r_alu_op,
    r_flag_0,
    r_flag_1,
    r_stack_op,
    r_seg_override,
    r_seg_override_valid,
    r_eax,
    r_ecx,
    r_edx,
    r_ebx,
    r_esp,
    r_ebp,
    r_esi,
    r_edi,
    r_cs,
    r_ds,
    r_es,
    r_fs,
    r_gs,
    r_ss,
    r_mm0,
    r_mm1,
    r_mm2,
    r_mm3,
    r_mm4,
    r_mm5,
    r_mm6,
    r_mm7,
    r_pc,
    r_branch_taken,
    r_opcode,
			       
    // Memory Access Interface
    a_valid,
    a_ready,
    a_size,
    a_set_d_flag,
    a_clear_d_flag,
    a_op0,
    a_op1,
    a_op0_reg,
    a_op1_reg,
    a_op0_is_address,
    a_op1_is_address,
    a_imm,
    a_alu_op,
    a_flag_0,
    a_flag_1,
    a_stack_op,
    a_pc,
    a_branch_taken,
    a_to_sys_controller,			       
    a_opcode
);

    // Clock Interface
    input clk;
    input reset;

    // Control Interface
    input flush;

    // Register Access Inferface
    input r_valid;
    output r_ready;
    input [2:0] r_size;
    input r_set_d_flag;
    input r_clear_d_flag;
    input [2:0] r_op0;
    input [2:0] r_op1;
    input [2:0] r_op0_reg;
    input [2:0] r_op1_reg;
    input [7:0] r_modrm;
    input [7:0] r_sib;
    input [47:0] r_imm;
    input [31:0] r_disp;
    input [3:0] r_alu_op;
    input [2:0] r_flag_0;
    input [2:0] r_flag_1;
    input [1:0] r_stack_op;
    input [2:0] r_seg_override;
    input r_seg_override_valid;
    input [31:0] r_eax;
    input [31:0] r_ecx;
    input [31:0] r_edx;
    input [31:0] r_ebx;
    input [31:0] r_esp;
    input [31:0] r_ebp;
    input [31:0] r_esi;
    input [31:0] r_edi;
    input [15:0] r_cs;
    input [15:0] r_ds;
    input [15:0] r_es;
    input [15:0] r_fs;
    input [15:0] r_gs;
    input [15:0] r_ss;
    input [63:0] r_mm0;
    input [63:0] r_mm1;
    input [63:0] r_mm2;
    input [63:0] r_mm3;
    input [63:0] r_mm4;
    input [63:0] r_mm5;
    input [63:0] r_mm6;
    input [63:0] r_mm7;
    input [31:0] r_pc;
    input r_branch_taken;
    input [15:0] r_opcode;
   
    // Memory Read Interface Interface
    output a_valid;
    input a_ready;
    output [2:0] a_size;
    output a_set_d_flag;
    output a_clear_d_flag;
    output [63:0] a_op0;
    output [63:0] a_op1;
    output [2:0] a_op0_reg;
    output [2:0] a_op1_reg;
    output a_op0_is_address;
    output a_op1_is_address;
    output [47:0] a_imm;
    output [3:0] a_alu_op;
    output [2:0] a_flag_0;
    output [2:0] a_flag_1;
    output [1:0] a_stack_op;
    output [31:0] a_pc;
    output a_branch_taken;
    output a_to_sys_controller;
    output [15:0] a_opcode;
   
    // -------   //
    // Pipestage //
    // -------   //

    localparam PIPEWIDTH = 3+1+1+64+64+3+3+1+1+48+4+3+3+2+32+1+16;
   
    wire [PIPEWIDTH-1:0] pipe_in_data, pipe_out_data;

    wire [2:0] p_size;
    wire  p_set_d_flag;
    wire  p_clear_d_flag;
    wire  [63:0] p_op0;
    wire  [63:0] p_op1;
    wire  [2:0] p_op0_reg;
    wire  [2:0] p_op1_reg;
    wire  p_op0_is_address;
    wire  p_op1_is_address;
    wire  [47:0] p_imm;
    wire  [3:0] p_alu_op;
    wire  [2:0] p_flag_0;
    wire  [2:0] p_flag_1;
    wire  [1:0] p_stack_op;
    wire  [31:0] p_pc;
    wire  p_branch_taken;
   
    assign {
      a_size,
      a_set_d_flag,
      a_clear_d_flag,
      a_op0,
      a_op1,
      a_op0_reg,
      a_op1_reg,
      a_op0_is_address,
      a_op1_is_address,
      a_imm,
      a_alu_op,
      a_flag_0,
      a_flag_1,
      a_stack_op,
      a_pc,
      a_branch_taken,
      a_opcode	    
    } = pipe_out_data;

    assign pipe_in_data = {
      r_size,
      r_set_d_flag,
      r_clear_d_flag,
      p_op0,
      p_op1,
      r_op0_reg,
      r_op1_reg,
      p_op0_is_address,
      p_op1_is_address,
      r_imm,
      r_alu_op,
      r_flag_0,
      r_flag_1,
      r_stack_op,
      r_pc,
      r_branch_taken,
      r_opcode		    
    };   
 
    pipestage #(.WIDTH(PIPEWIDTH)) stage0 ( clk, (reset | flush), r_valid, r_ready, pipe_in_data, a_valid, a_ready, pipe_out_data);

    // -------                    //
    // Indicate to Sys Controller //
    // -------                    //

   compare #(.WIDTH(3)) (r_op0, 3'h7, a_to_sys_controller);
         
    // ------- //
    // OP0 Mux //
    // ------- //
    op0_generator op0_generator0 (
        p_op0,
        p_op0_is_address,

        r_size,

        r_op0,
        r_op0_reg,
        
        r_modrm,
        r_sib,
        r_imm,
        r_disp,
        r_seg_override,
        r_seg_override_valid,

        r_eax,
        r_ecx,
        r_edx,
        r_ebx,
        r_esp,
        r_ebp,
        r_esi,
        r_edi,

        r_cs,
        r_ds,
        r_es,
        r_fs,
        r_gs,
        r_ss,

        r_mm0,
        r_mm1,
        r_mm2,
        r_mm3,
        r_mm4,
        r_mm5,
        r_mm6,
        r_mm7
    );

    // ------- //
    // OP1 Mux //
    // ------- //
    op1_generator op1_generator0 (
    p_op1,
    p_op1_is_address,

    r_size,

    r_op1,
    r_op1_reg,
    
    r_modrm,
    r_sib,
    r_imm,
    r_disp,
    r_seg_override,
    r_seg_override_valid,

    r_eax,
    r_ecx,
    r_edx,
    r_ebx,
    r_esp,
    r_ebp,
    r_esi,
    r_edi,

    r_cs,
    r_ds,
    r_es,
    r_fs,
    r_gs,
    r_ss,

    r_mm0,
    r_mm1,
    r_mm2,
    r_mm3,
    r_mm4,
    r_mm5,
    r_mm6,
    r_mm7

);


endmodule

module op0_generator (
    a_op0,
    a_op0_is_address,

    r_size,

    r_op0,
    r_op0_reg,
    
    r_modrm,
    r_sib,
    r_imm,
    r_disp,
    r_seg_override,
    r_seg_override_valid,

    r_eax,
    r_ecx,
    r_edx,
    r_ebx,
    r_esp,
    r_ebp,
    r_esi,
    r_edi,

    r_cs,
    r_ds,
    r_es,
    r_fs,
    r_gs,
    r_ss,

    r_mm0,
    r_mm1,
    r_mm2,
    r_mm3,
    r_mm4,
    r_mm5,
    r_mm6,
    r_mm7
);

    output [63:0] a_op0;
    output a_op0_is_address;

    input [2:0] r_size;

    input [2:0] r_op0;
    input [2:0] r_op0_reg;

    input [7:0] r_modrm;
    input [7:0] r_sib;
    input [47:0] r_imm;
    input [31:0] r_disp;
    input [2:0] r_seg_override;
    input r_seg_override_valid;

    input [31:0] r_eax;
    input [31:0] r_ecx;
    input [31:0] r_edx;
    input [31:0] r_ebx;
    input [31:0] r_esp;
    input [31:0] r_ebp;
    input [31:0] r_esi;
    input [31:0] r_edi;

    input [15:0] r_cs;
    input [15:0] r_ds;
    input [15:0] r_es;
    input [15:0] r_fs;
    input [15:0] r_gs;
    input [15:0] r_ss;

    input [63:0] r_mm0;
    input [63:0] r_mm1;
    input [63:0] r_mm2;
    input [63:0] r_mm3;
    input [63:0] r_mm4;
    input [63:0] r_mm5;
    input [63:0] r_mm6;
    input [63:0] r_mm7;

    // Decides the input for OP 0

    // "none"        : "0",
    // "register"    : "1",
    // "segment"     : "2",
    // "mm register" : "3",
    // "mod r/m"     : "4",
    // "immediete"   : "5",
    // "memory"      : "6"


    // select register
    wire [63:0] reg_file_0;
    wire [63:0] reg_file_1;
    wire [63:0] reg_file_2;
    wire [63:0] reg_file_3;
    wire [63:0] reg_file_4;
    wire [63:0] reg_file_5;
    wire [63:0] reg_file_6;
    wire [63:0] reg_file_7;

   // set the register size input for modr/m since it can be 8, 16, 32, or 64 bit
    reg_size_selector reg_file_size_sel_0 (
        r_size, 

        r_eax,
        r_ecx,
        r_edx,
        r_ebx,
        r_esp,
        r_ebp,
        r_esi,
        r_edi,

        r_mm0,
        r_mm1,
        r_mm2,
        r_mm3,
        r_mm4,
        r_mm5,
        r_mm6,
        r_mm7,


        reg_file_0,
        reg_file_1,
        reg_file_2,
        reg_file_3,
        reg_file_4,
        reg_file_5,
        reg_file_6,
        reg_file_7
    );

    wire [63:0] op0_register;
    mux #(.WIDTH(64), .INPUTS(8)) op0_register_mux (
        {reg_file_7, reg_file_6, reg_file_5, reg_file_4, reg_file_3, reg_file_2, reg_file_1, reg_file_0},
        op0_register,
        r_op0_reg
    );

    // select segment register
    wire [15:0] op0_segment;
    mux #(.WIDTH(16), .INPUTS(8)) op0_segment_mux (
        {16'h0000, 16'h0000, r_gs, r_fs, r_ds, r_ss, r_cs, r_es},
        op0_segment,
        r_op0_reg
    );

    // select mmx register
    wire [63:0] op0_mmx;
    mux #(.WIDTH(64), .INPUTS(8)) op0_mmx_mux (
        {r_mm7, r_mm6, r_mm5, r_mm4, r_mm3, r_mm2, r_mm1, r_mm0},
        op0_mmx,
        r_op0_reg
    );

    // calculate mod_rm
    wire [63:0] op0_mod_rm;
    wire op0_mod_rm_is_address;
    mod_rm op0_mod_rm_calculator(
        op0_mod_rm,

        op0_mod_rm_is_address,
        
        r_modrm,
        r_sib,

        r_eax,
        r_ecx,
        r_edx,
        r_ebx,
        r_esp,
        r_ebp,
        r_esi,
        r_edi,

        reg_file_0,
        reg_file_1,
        reg_file_2,
        reg_file_3,
        reg_file_4,
        reg_file_5,
        reg_file_6,
        reg_file_7,

        r_disp,

        r_seg_override,
        r_seg_override_valid,

        r_es,
        r_cs,
        r_ss,
        r_ds,
        r_fs,
        r_gs
    );

    // memory address in ES:EDI
    // add shifted segment register
    // segment will always be ES, never overridden 
    wire [31:0] es_shifted;
    segment_shifter es_shifter (es_shifted, r_es);

    wire [31:0] op0_memory;

    slow_addr #(.WIDTH(32)) op0_memory_adder (es_shifted, r_edi, op0_memory, );

    mux #(.WIDTH(64), .INPUTS(8)) op0_mux (
        {
            64'd0,                      // n/a
            {32'd0, op0_memory},        // memory address
            {16'd0, r_imm},             // immediate
            op0_mod_rm,                 // mod r/m
            op0_mmx,                    // mm register
            {48'd0, op0_segment},       // segment register
            op0_register,               // register                       
            64'd0                       // none
        },
        a_op0,
        r_op0
    );

    // determine if op0 is an address or normie value
    // only read from memory if mod rm is an address
    // if op0 is memory, is_address should be zero since mem_read shouldn't do anything
    wire op0_mux_is_address = 1'b0;
    // op0_is_address op0_is_address0 (
    //     r_op0[2], r_op0[1], r_op0[0],
    //     op0_mux_is_address
    // );

    // see if mod_rm is address
    or2$ is_address_combine (a_op0_is_address, op0_mux_is_address, op0_mod_rm_is_address);

endmodule

module op1_generator (
    a_op1,
    a_op1_is_address,

    r_size,

    r_op1,
    r_op1_reg,
    
    r_modrm,
    r_sib,
    r_imm,
    r_disp,
    r_seg_override,
    r_seg_override_valid,

    r_eax,
    r_ecx,
    r_edx,
    r_ebx,
    r_esp,
    r_ebp,
    r_esi,
    r_edi,

    r_cs,
    r_ds,
    r_es,
    r_fs,
    r_gs,
    r_ss,

    r_mm0,
    r_mm1,
    r_mm2,
    r_mm3,
    r_mm4,
    r_mm5,
    r_mm6,
    r_mm7

);

    output [63:0] a_op1;
    output a_op1_is_address;

    input [2:0] r_size;

    input [2:0] r_op1;
    input [2:0] r_op1_reg;

    input [7:0] r_modrm;
    input [7:0] r_sib;
    input [47:0] r_imm;
    input [31:0] r_disp;
    input [2:0] r_seg_override;
    input r_seg_override_valid;

    input [31:0] r_eax;
    input [31:0] r_ecx;
    input [31:0] r_edx;
    input [31:0] r_ebx;
    input [31:0] r_esp;
    input [31:0] r_ebp;
    input [31:0] r_esi;
    input [31:0] r_edi;

    input [15:0] r_cs;
    input [15:0] r_ds;
    input [15:0] r_es;
    input [15:0] r_fs;
    input [15:0] r_gs;
    input [15:0] r_ss;

    input [63:0] r_mm0;
    input [63:0] r_mm1;
    input [63:0] r_mm2;
    input [63:0] r_mm3;
    input [63:0] r_mm4;
    input [63:0] r_mm5;
    input [63:0] r_mm6;
    input [63:0] r_mm7;

    // ------- //
    // OP1 Mux //
    // ------- //

    // "none"        : "0",
    // "register"    : "1",
    // "segment"     : "2",
    // "mm register" : "3",
    // "mod r/m"     : "4",
    // "immediete"   : "5",
    // "memory"      : "6"

    // register
    // select register
    wire [63:0] reg_file_0;
    wire [63:0] reg_file_1;
    wire [63:0] reg_file_2;
    wire [63:0] reg_file_3;
    wire [63:0] reg_file_4;
    wire [63:0] reg_file_5;
    wire [63:0] reg_file_6;
    wire [63:0] reg_file_7;

   // set the register size input for modr/m since it can be 8, 16, 32, or 64 bit
    reg_size_selector reg_file_size_sel_0 (
        r_size, 

        r_eax,
        r_ecx,
        r_edx,
        r_ebx,
        r_esp,
        r_ebp,
        r_esi,
        r_edi,

        r_mm0,
        r_mm1,
        r_mm2,
        r_mm3,
        r_mm4,
        r_mm5,
        r_mm6,
        r_mm7,


        reg_file_0,
        reg_file_1,
        reg_file_2,
        reg_file_3,
        reg_file_4,
        reg_file_5,
        reg_file_6,
        reg_file_7
    );

    wire [63:0] op1_register;
    mux #(.WIDTH(64), .INPUTS(8)) op0_register_mux (
        {reg_file_7, reg_file_6, reg_file_5, reg_file_4, reg_file_3, reg_file_2, reg_file_1, reg_file_0},
        op1_register,
        r_op1_reg
    );

    // select segment register
    wire [15:0] op1_segment;
    mux #(.WIDTH(16), .INPUTS(8)) op0_segment_mux (
        {16'h0000, 16'h0000, r_gs, r_fs, r_ds, r_ss, r_cs, r_es},
        op1_segment,
        r_op1_reg
    );

    // select mmx register
    wire [63:0] op1_mmx;
    mux #(.WIDTH(64), .INPUTS(8)) op0_mmx_mux (
        {r_mm7, r_mm6, r_mm5, r_mm4, r_mm3, r_mm2, r_mm1, r_mm0},
        op1_mmx,
        r_op1_reg
    );

    // calculate mod_rm
    wire [63:0] op1_mod_rm;
    wire op1_mod_rm_is_address;
    mod_rm op1_mod_rm_calculator(
        op1_mod_rm,

        op1_mod_rm_is_address,
        
        r_modrm,
        r_sib,

        r_eax,
        r_ecx,
        r_edx,
        r_ebx,
        r_esp,
        r_ebp,
        r_esi,
        r_edi,

        reg_file_0,
        reg_file_1,
        reg_file_2,
        reg_file_3,
        reg_file_4,
        reg_file_5,
        reg_file_6,
        reg_file_7,

        r_disp,

        r_seg_override,
        r_seg_override_valid,

        r_es,
        r_cs,
        r_ss,
        r_ds,
        r_fs,
        r_gs
    );

    // memory address in DS:ESI
    // If segment override is zero, use DS
    // If 1, use a value from a mux based on segement override

    wire [15:0] seg_override_mux_out;
    mux #(.WIDTH(16), .INPUTS(8)) seg_override_mux (
        {16'd0, 16'd0, r_gs, r_fs, r_ds, r_ss, r_cs, r_es},
        seg_override_mux_out,
        r_seg_override
    );

    wire [15:0] selected_seg;
    mux #(.WIDTH(16), .INPUTS(2)) is_seg_override_mux (
        {seg_override_mux_out, r_ds},
        selected_seg,
        r_seg_override_valid
    );

    // add selected seg
    wire [31:0] shifted_seg;
    segment_shifter op1_shifter (shifted_seg, selected_seg);

    wire [31:0] op1_memory;

    slow_addr #(.WIDTH(32)) op1_memory_adder (shifted_seg, r_esi, op1_memory, );


    mux #(.WIDTH(64), .INPUTS(8)) op1_mux (
        {
            64'h0000_0000_0000_0000,                // n/a
            {32'd0, op1_memory},                    // memory
            {16'd0, r_imm},                         // immediate
            op1_mod_rm,                             // mod r/m
            op1_mmx,                                // mm register
            {48'd0, op1_segment},                   // segment
            op1_register,                           // register
            64'h0000_0000_0000_0000                 // none
        },
        a_op1,
        r_op1
    );

    wire op1_mux_is_address;
    // same logic as op0. for now at least
    op0_is_address op1_is_address0 (
        r_op1[2], r_op1[1], r_op1[0],
        op1_mux_is_address
    );

    or2$ is_address_combine (a_op1_is_address, op1_mux_is_address, op1_mod_rm_is_address);

endmodule

module op0_is_address (
    op0_2, op0_1, op0_0,
    op0_is_address
);
    input op0_2, op0_1, op0_0;
    output op0_is_address;

    wire op0_0_not;
    wire and0;

    inv1$ op0_0_inv (.out(op0_0_not), .in(op0_0));

    and3$ and_gate0(.out(and0), .in0(op0_2), .in1(op0_1), .in2(op0_0_not));


    assign op0_is_address = and0;

endmodule


module reg_size_selector (
    size, 

    eax,
    ecx,
    edx,
    ebx,
    esp,
    ebp,
    esi,
    edi,

    mm0,
    mm1,
    mm2,
    mm3,
    mm4,
    mm5,
    mm6,
    mm7,

    reg_0,
    reg_1,
    reg_2,
    reg_3,
    reg_4,
    reg_5,
    reg_6,
    reg_7


);

    input [2:0] size;

    input [31:0] eax;
    input [31:0] ecx;
    input [31:0] edx;
    input [31:0] ebx;
    input [31:0] esp;
    input [31:0] ebp;
    input [31:0] esi;
    input [31:0] edi;
    
    input [63:0] mm0;
    input [63:0] mm1;
    input [63:0] mm2;
    input [63:0] mm3;
    input [63:0] mm4;
    input [63:0] mm5;
    input [63:0] mm6;
    input [63:0] mm7;

    output [63:0] reg_0;
    output [63:0] reg_1;
    output [63:0] reg_2;
    output [63:0] reg_3;
    output [63:0] reg_4;
    output [63:0] reg_5;
    output [63:0] reg_6;
    output [63:0] reg_7;

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

    mux #(.WIDTH(64), .INPUTS(8)) 
    size_mux0 ({ 64'd0, 64'd0, mm0, 64'd0, {32'h0000_0000, eax}, {32'h0000_0000, ax}, {32'h0000_0000, al}, 64'd0 }, reg_0, size), 
    size_mux1 ({ 64'd0, 64'd0, mm1, 64'd0, {32'h0000_0000, ecx}, {32'h0000_0000, cx}, {32'h0000_0000, cl}, 64'd0 }, reg_1, size), 
    size_mux2 ({ 64'd0, 64'd0, mm2, 64'd0, {32'h0000_0000, edx}, {32'h0000_0000, dx}, {32'h0000_0000, dl}, 64'd0 }, reg_2, size), 
    size_mux3 ({ 64'd0, 64'd0, mm3, 64'd0, {32'h0000_0000, ebx}, {32'h0000_0000, bx}, {32'h0000_0000, bl}, 64'd0 }, reg_3, size), 
    size_mux4 ({ 64'd0, 64'd0, mm4, 64'd0, {32'h0000_0000, esp}, {32'h0000_0000, sp}, {32'h0000_0000, ah}, 64'd0 }, reg_4, size), 
    size_mux5 ({ 64'd0, 64'd0, mm5, 64'd0, {32'h0000_0000, ebp}, {32'h0000_0000, bp}, {32'h0000_0000, ch}, 64'd0 }, reg_5, size), 
    size_mux6 ({ 64'd0, 64'd0, mm6, 64'd0, {32'h0000_0000, esi}, {32'h0000_0000, si}, {32'h0000_0000, dh}, 64'd0 }, reg_6, size), 
    size_mux7 ({ 64'd0, 64'd0, mm7, 64'd0, {32'h0000_0000, edi}, {32'h0000_0000, di}, {32'h0000_0000, bh}, 64'd0 }, reg_7, size);
    



endmodule
