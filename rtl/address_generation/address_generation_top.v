
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
    r_stack_address,			       
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
    a_op0_is_reg,
    a_op0_is_segment,
    a_op0_is_mmx,
    a_op1_is_reg,
    a_op1_is_address,
    a_imm,
    a_alu_op,
    a_flag_0,
    a_flag_1,
    a_stack_op,
    a_stack_address,
    a_pc,
    a_branch_taken,
    a_to_sys_controller,			       
    a_opcode,

    segment_limit_exception
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
    input [31:0] r_stack_address;   
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
    output a_op0_is_reg;
    output a_op0_is_segment;
    output a_op0_is_mmx;
    output a_op1_is_reg;
    output a_op1_is_address;
    output [47:0] a_imm;
    output [3:0] a_alu_op;
    output [2:0] a_flag_0;
    output [2:0] a_flag_1;
    output [1:0] a_stack_op;
    output [31:0] a_stack_address;   
    output [31:0] a_pc;
    output a_branch_taken;
    output a_to_sys_controller;
    output [15:0] a_opcode;

    // exception output
    output segment_limit_exception;

    // buffers
    wire [2:0] r_size_buf;
    bufferH16 #(.WIDTH(3)) r_size_16 (r_size_buf, r_size);

    wire [2:0] r_op0_buf;
    bufferH64 #(.WIDTH(3)) r_op0_64 (r_op0_buf, r_op0);

    wire [2:0] r_op1_buf;
    bufferH64 #(.WIDTH(3)) r_op1_64 (r_op1_buf, r_op1);

    wire [2:0] r_op0_reg_buf;
    bufferH16 #(.WIDTH(3)) r_op0_reg_16 (r_op0_reg_buf, r_op0_reg);

    wire [2:0] r_op1_reg_buf;
    bufferH16 #(.WIDTH(3)) r_op1_reg_16 (r_op1_reg_buf, r_op1_reg);

    wire [7:0] r_modrm_buf;
    bufferH64 #(.WIDTH(8)) r_modrm_64 (r_modrm_buf, r_modrm);

    wire [7:0] r_sib_buf;
    bufferH16 #(.WIDTH(8)) r_sib_buf_16 (r_sib_buf, r_sib);

    wire [47:0] r_imm_buf;
    bufferH16 #(.WIDTH(48)) r_imm_16 (r_imm_buf, r_imm);

    wire [31:0] r_disp_buf;
    bufferH64 #(.WIDTH(32)) r_disp_64 (r_disp_buf, r_disp);

    wire [2:0] r_seg_override_buf;
    bufferH16 #(.WIDTH(3)) r_seg_override_64 (r_seg_override_buf, r_seg_override);

    wire r_seg_override_valid_buf;
    bufferH16 #(.WIDTH(1)) r_seg_override_valid_16 (r_seg_override_valid_buf, r_seg_override_valid);

    wire [31:0] r_eax_buf;
    wire [31:0] r_ecx_buf;
    wire [31:0] r_edx_buf;
    wire [31:0] r_ebx_buf;
    wire [31:0] r_esp_buf;
    wire [31:0] r_ebp_buf;
    wire [31:0] r_esi_buf;
    wire [31:0] r_edi_buf;

    bufferH16 #(.WIDTH(32)) 
    r_eax_16 (r_eax_buf, r_eax),
    r_ecx_16 (r_ecx_buf, r_ecx),
    r_edx_16 (r_edx_buf, r_edx),
    r_ebx_16 (r_ebx_buf, r_ebx),
    r_esp_16 (r_esp_buf, r_esp),
    r_ebp_16 (r_ebp_buf, r_ebp),
    r_esi_16 (r_esi_buf, r_esi),
    r_edi_16 (r_edi_buf, r_edi);


   
    // -------   //
    // Pipestage //
    // -------   //

    // localparam PIPEWIDTH = 3+1+1+64+64+3+3+1+1+1+1+1+1+48+4+3+3+2+32+32+1+1+16;
    localparam PIPEWIDTH = 3+1+1+64+64+3+3+1+1+48+4+3+3+2+32+1+16+32+3+3+1+1;
   
    wire [PIPEWIDTH-1:0] pipe_in_data, pipe_out_data;

    wire [2:0] p_size;
    wire  p_set_d_flag;
    wire  p_clear_d_flag;
    wire  [63:0] p_op0;
    wire  [63:0] p_op1;
    wire  [63:0] gen_op1;   
    wire  [2:0] p_op0_reg;
    wire  [2:0] p_op1_reg;
    wire  p_op0_is_address;
    wire  p_op0_is_reg;
    wire  p_op0_is_segment;
    wire  p_op0_is_mmx;
    wire  p_op1_is_reg;
    wire  p_op1_is_address;
    wire  gen_op1_is_address;   
    wire  [47:0] p_imm;
    wire  [3:0] p_alu_op;
    wire  [2:0] p_flag_0;
    wire  [2:0] p_flag_1;
    wire  [1:0] p_stack_op;
    wire  [31:0] p_stack_address;   
    wire  [31:0] p_pc;
    wire  p_branch_taken;
    wire  p_to_sys_controller;
   
    assign {
      a_size,
      a_set_d_flag,
      a_clear_d_flag,
      a_op0,
      a_op1,
      a_op0_reg,
      a_op1_reg,
      a_op0_is_address,
      a_op0_is_reg,
      a_op0_is_segment,
      a_op0_is_mmx,
      a_op1_is_reg,
      a_op1_is_address,
      a_imm,
      a_alu_op,
      a_flag_0,
      a_flag_1,
      a_stack_op,
      a_stack_address,
      a_pc,
      a_branch_taken,
      a_opcode,
      a_to_sys_controller	    
    } = pipe_out_data;

    assign pipe_in_data = {
      r_size_buf,
      r_set_d_flag,
      r_clear_d_flag,
      p_op0,
      p_op1,
      r_op0_reg_buf,
      r_op1_reg_buf,
      p_op0_is_address,
      p_op0_is_reg,
      p_op0_is_segment,
      p_op0_is_mmx,
      p_op1_is_reg,
      p_op1_is_address,
      r_imm_buf,
      r_alu_op,
      r_flag_0,
      r_flag_1,
      r_stack_op,
      r_stack_address,
      r_pc,
      r_branch_taken,
      r_opcode,
      p_to_sys_controller		    
    };   
 
    pipestage #(.WIDTH(PIPEWIDTH)) stage0 ( clk, (reset | flush), r_valid, r_ready, pipe_in_data, a_valid, a_ready, pipe_out_data);

    // -------                    //
    // Indicate What Dest Op0 is  //
    // -------                    //

    wire not_is_an_address,  p_op0_is_modrm, p_op0_is_modrm, gen_op0_is_address, gen_op0_is_address, is_an_address_modrm;
   
    compare #(.WIDTH(2)) (r_modrm_buf[7:6], 2'b11, not_is_an_address); 
    and2$ ( p_op0_is_modrm_mask, p_op0_is_modrm, not_is_an_address);
    inv1$ ( is_an_address_modrm, not_is_an_address);

    compare #(.WIDTH(3)) (r_op0_buf , 3'd1, p_op0_is_register);      
    compare #(.WIDTH(3)) (r_op0_buf , 3'd4, p_op0_is_modrm);
    
    or2$ ( p_op0_is_reg, p_op0_is_register, p_op0_is_modrm_mask);     
      
    compare #(.WIDTH(3)) (r_op0_buf , 3'd2, p_op0_is_segment);      
    compare #(.WIDTH(3)) (r_size_buf, 3'd5, p_op0_is_mmx);

    // -------                            //
    // For Pops force op1 to be stack op  //
    // -------                            //

    mux  #(.WIDTH(64),.INPUTS(2)) idt_select ( {{32'b0,r_stack_address}, gen_op1}, p_op1, r_stack_op[1]);
   
    or2$ (p_op1_is_address, gen_op1_is_address, r_stack_op[1]);
   
    // -------                    //
    // Indicate to Sys Controller //
    // -------                    //

   compare #(.WIDTH(3)) (r_op0_buf, 3'h7, p_to_sys_controller);

    // ------------------- //
    // Segment Limit Check //
    // ------------------- //
    wire [2:0] op0_segment;
    wire op0_check_segment_limit;
    wire [2:0] op1_segment;
    wire op1_check_segment_limit;

    wire op0_exception;
    segment_limit_check op0_seg_check (
        op0_exception,
        p_op0[31:0],
        op0_check_segment_limit,

        op0_segment,

        r_cs,
        r_ds,
        r_ss,
        r_es,
        r_fs,
        r_gs,

        r_size_buf
    );

    // checks op1 and the stack operand
    wire op1_exception;
    segment_limit_check op1_seg_check (
        op1_exception,
        p_op1[31:0],
        op1_check_segment_limit,

        op1_segment,

        r_cs,
        r_ds,
        r_ss,
        r_es,
        r_fs,
        r_gs,

        r_size_buf
    );

    wire stack_is_address;
    or2$ (stack_is_address, a_stack_op[1], a_stack_op[0]);

    wire stack_exception;
    segment_limit_check stack_seg_check (
        stack_exception,
        a_stack_address,
        stack_is_address,

        3'b010,

        r_cs,
        r_ds,
        r_ss,
        r_es,
        r_fs,
        r_gs,

        r_size_buf
    );

    wire maybe_segment_limit_exception;
    or3$ exception_or (maybe_segment_limit_exception, op0_exception, op1_exception, stack_exception);

    // only cause exception if the incoming data is valid
    and2$ except_and (segment_limit_exception, r_valid, maybe_segment_limit_exception);

    // ---------------------------- //
    // Determine if OP1 is Register //
    // ---------------------------- //

    // a register if op1 is reg or is mod rm with mod 11
    is_op1_reg (p_op1_is_reg, r_op1_buf, r_modrm_buf);

    // ------- //
    // OP0 Mux //
    // ------- //
    op0_generator op0_generator0 (
        p_op0,
        p_op0_is_address,
        op0_segment,
        op0_check_segment_limit,

        r_size_buf,

        r_op0_buf,
        r_op0_reg_buf,
        
        r_modrm_buf,
        r_sib_buf,
        r_imm_buf,
        r_disp_buf,
        r_seg_override_buf,
        r_seg_override_valid_buf,

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
    gen_op1,
    gen_op1_is_address,
    op1_segment,
    op1_check_segment_limit,

    r_size_buf,

    r_op1_buf,
    r_op1_reg_buf,
    
    r_modrm_buf,
    r_sib_buf,
    r_imm_buf,
    r_disp_buf,
    r_seg_override_buf,
    r_seg_override_valid_buf,

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

module is_op1_reg (
    out,

    op1,
    mod_rm
);
    output out;

    input [2:0] op1;
    input [7:0] mod_rm;

    // reg if op1 == 1 or (op1 == 4 and mod == 11)

    wire [1:0] mod = mod_rm[7:6];

    wire op1_is_1;
    compare #(.WIDTH(3)) op1_cmp (op1, 3'd1, op1_is_1);

    wire mod_rm_reg;
    compare #(.WIDTH(5)) mod_rm_cmp ({op1, mod}, 5'b10011, mod_rm_reg);

    or2$ or_out (out, op1_is_1, mod_rm_reg);



endmodule

module op0_generator (
    a_op0,
    a_op0_is_address,
    op0_segment_num,
    op0_check_segment_limit,

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
    output [2:0] op0_segment_num;
    output op0_check_segment_limit;

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
    wire [2:0] selected_seg_id;
    mod_rm op0_mod_rm_calculator(
        op0_mod_rm,

        op0_mod_rm_is_address,

        selected_seg_id,
        
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
    // wire op0_mux_is_address = 1'b0;
    wire op0_mux_is_address;
    op0_is_address op0_is_address0 (
        r_op0[2], r_op0[1], r_op0[0],
        op0_mux_is_address
    );

 
    wire  op0_rm_and_address, op0_is_modrm;
   
    compare #(.WIDTH(3)) (r_op0, 3'd4, op0_is_modrm);
    and2$ (op0_rm_and_address, op0_is_modrm,  op0_mod_rm_is_address);  

    // see if mod_rm is address
    or2$ is_address_combine (a_op0_is_address, op0_mux_is_address, op0_rm_and_address);

    // select segment
    // if its memory, segment is ES
    // if its not overridden then its ds
    // if its overridden then its the overridden value

    // {is_memory, r_seg_override_valid}
    // 00: DS
    // 01: r_seg_override
    // 10: ES
    // 11: ES

    wire is_memory;
    compare #(.WIDTH(3)) is_mem_cmp (r_op0, 3'd6, is_memory);

    mux #(.WIDTH(3), .INPUTS(4)) (
        {
            3'd0,
            3'd0,
            r_seg_override,
            selected_seg_id
        },
        op0_segment_num,
        {is_memory, r_seg_override_valid}
    );

    // will this be read from memory later?
    wire op0_check_segment_limit_mem;
    op0_is_address op0_is_address1 (
        r_op0[2], r_op0[1], r_op0[0],
        op0_check_segment_limit_mem
    );

    or2$ is_segment_check (op0_check_segment_limit, op0_check_segment_limit_mem, op0_rm_and_address);

endmodule

module op1_generator (
    a_op1,
    a_op1_is_address,
    op1_segment_num,
    op1_check_segment_limit,

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
    output [2:0] op1_segment_num;
    output op1_check_segment_limit;

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
    wire [2:0] selected_seg_id;
    mod_rm op1_mod_rm_calculator(
        op1_mod_rm,

        op1_mod_rm_is_address,

        selected_seg_id,
        
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

   wire  op1_rm_and_address;
   
   compare #(.WIDTH(3)) (r_op1, 3'd4, op1_is_modrm);
   and2$ (op1_rm_and_address, op1_is_modrm,  op1_mod_rm_is_address);
   
   or2$ is_address_combine (a_op1_is_address, op1_mux_is_address, op1_rm_and_address);

   // set segment limit
   // if its overridden, use that
   // else use ds

   mux #(.WIDTH(3), .INPUTS(2)) op1_seg_mux (
       {r_seg_override, selected_seg_id},
       op1_segment_num,
       r_seg_override_valid
   );

   assign op1_check_segment_limit = a_op1_is_address;

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
