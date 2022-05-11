
//////////////////////////////////////
//
//  Top Register Access Stage Module
//

module register_access_top (
    // Clock Interface
    clk,
    reset,

    // Control Interface
    flush,

    // Direct Segment Write
    write_cs,
    write_cs_enable,     
			    
    // Decode Interface
    d_valid,
    d_ready,
    d_size,
    d_set_d_flag,
    d_clear_d_flag,
    d_op0,
    d_op1,
    d_op0_reg,
    d_op1_reg,
    d_modrm,
    d_sib,
    d_imm,
    d_disp,
    d_alu_op,
    d_flag_0,
    d_flag_1,
    d_stack_op,
    d_seg_override,
    d_seg_override_valid,
    d_movs,
    d_pc,
    d_branch_taken,
    d_opcode,

    // Address Generation Inferface
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

    flag_df,
			    
    wb_reg_number,
    wb_reg_en,
    wb_stack,
    wb_reg_size,
    wb_reg_data,
    
    wb_reg_number_2,
    wb_reg_en_2,
    wb_reg_data_2,

    wb_seg_number,
    wb_seg_en,
    wb_seg_data,

    wb_mmx_number,
    wb_mmx_en,
    wb_mmx_data,

    // Stack Commit Interface
    wb_stack_en,
    wb_stack_size,
    wb_stack_op
);

    // Clock Interface
    input clk;
    input reset;

    // Control Interface
    input flush;

    // Direct Segment Write
    input  [15:0] write_cs;
    input  write_cs_enable;    

    // Decode Interface
    input d_valid;
    output d_ready;
    input [2:0] d_size;
    input d_set_d_flag;
    input d_clear_d_flag;
    input [2:0] d_op0;
    input [2:0] d_op1;
    input [2:0] d_op0_reg;
    input [2:0] d_op1_reg;
    input [7:0] d_modrm;
    input [7:0] d_sib;
    input [47:0] d_imm;
    input [31:0] d_disp;
    input [3:0] d_alu_op;
    input [2:0] d_flag_0;
    input [2:0] d_flag_1;
    input [1:0] d_stack_op;
    input [2:0] d_seg_override;
    input d_seg_override_valid;
    input d_movs;
    input [31:0] d_pc;
    input d_branch_taken;
    input [15:0] d_opcode;

    // Address Generation Inferface
    output r_valid;
    input r_ready;
    output [2:0] r_size;
    output r_set_d_flag;
    output r_clear_d_flag;
    output [2:0] r_op0;
    output [2:0] r_op1;
    output [2:0] r_op0_reg;
    output [2:0] r_op1_reg;
    output [7:0] r_modrm;
    output [7:0] r_sib;
    output [47:0] r_imm;
    output [31:0] r_disp;
    output [3:0] r_alu_op;
    output [2:0] r_flag_0;
    output [2:0] r_flag_1;
    output [1:0] r_stack_op;
    output [31:0] r_stack_address;   
    output [2:0] r_seg_override;
    output r_seg_override_valid;
    output [31:0] r_eax;
    output [31:0] r_ecx;
    output [31:0] r_edx;
    output [31:0] r_ebx;
    output [31:0] r_esp;
    output [31:0] r_ebp;
    output [31:0] r_esi;
    output [31:0] r_edi;
    output [15:0] r_cs;
    output [15:0] r_ds;
    output [15:0] r_es;
    output [15:0] r_fs;
    output [15:0] r_gs;
    output [15:0] r_ss;
    output [63:0] r_mm0;
    output [63:0] r_mm1;
    output [63:0] r_mm2;
    output [63:0] r_mm3;
    output [63:0] r_mm4;
    output [63:0] r_mm5;
    output [63:0] r_mm6;
    output [63:0] r_mm7;
    output [31:0] r_pc;
    output r_branch_taken;
    output [15:0] r_opcode;
   
    // --------- //
    // Writeback //
    // --------- //

    // register file writeback
    input [2:0] wb_reg_number;
    input wb_reg_en;
    input wb_stack;   
    input [2:0] wb_reg_size;
    input [31:0] wb_reg_data;

    // second writeback
    input [2:0] wb_reg_number_2;
    input wb_reg_en_2;
    input [31:0] wb_reg_data_2;


    // segment register writeback
    input [2:0] wb_seg_number;
    input wb_seg_en;
    input [15:0] wb_seg_data;

    // mmx register writeback
    input [2:0] wb_mmx_number;
    input wb_mmx_en;
    input [63:0] wb_mmx_data;

    // misc
    input flag_df;
    input 	 wb_stack_en;
    input [2:0] 	 wb_stack_size;
    input [1:0]	 wb_stack_op; 

    wire 	stack_operation;
   
    // ------                     //
    // Pipestage (Bypass for now) //
    // ------                     //
   
    localparam PIPEWIDTH = 1+32+1+3+2+3+3+4+32+48+8+8+3+3+3+3+1+1+3+8*32+6*16+8*64+16+32;

    wire [PIPEWIDTH-1:0] pipe_in_data, pipe_out_data;

    wire [2:0]  p_op0_reg;
    wire [2:0]  p_op1_reg;
    wire [31:0] p_eax;
    wire [31:0] p_ecx;
    wire [31:0] p_edx;
    wire [31:0] p_ebx;
    wire [31:0] p_esp;
    wire [31:0] p_ebp;
    wire [31:0] p_esi;
    wire [31:0] p_edi;
    wire [15:0] p_cs;
    wire [15:0] p_ds;
    wire [15:0] p_es;
    wire [15:0] p_fs;
    wire [15:0] p_gs;
    wire [15:0] p_ss;
    wire [63:0] p_mm0;
    wire [63:0] p_mm1;
    wire [63:0] p_mm2;
    wire [63:0] p_mm3;
    wire [63:0] p_mm4;
    wire [63:0] p_mm5;
    wire [63:0] p_mm6;
    wire [63:0] p_mm7;
    wire [31:0] p_stack_address;

    assign {
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
       r_pc,
       r_branch_taken,
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
       r_opcode	    
    } = pipe_in_data;

    assign pipe_in_data = {
       d_size,
       d_set_d_flag,
       d_clear_d_flag,
       d_op0,
       d_op1,
       p_op0_reg,
       p_op1_reg,
       d_modrm,
       d_sib,
       d_imm,
       d_disp,
       d_alu_op,
       d_flag_0,
       d_flag_1,
       d_stack_op,
       p_stack_address,
       d_seg_override,
       d_seg_override_valid,
       d_pc,
       d_branch_taken,	
       p_eax,
       p_ecx,
       p_edx,
       p_ebx,
       p_esp,
       p_ebp,
       p_esi,
       p_edi,
       p_cs,
       p_ds,
       p_es,
       p_fs,
       p_gs,
       p_ss,
       p_mm0,
       p_mm1,
       p_mm2,
       p_mm3,
       p_mm4,
       p_mm5,
       p_mm6,
       p_mm7,
       d_opcode    
    };

    //assign r_valid = d_valid;
    //assign d_ready = r_ready;
    wire register_file_stall;  
    wire seg_reg_is_stall;
    wire mmx_is_stall;

    wire reg_file_valid, seg_reg_valid, mmx_valid;

    inv1$ 
    reg_file_valid_inv (reg_file_valid, register_file_stall), 
    seg_reg_valid_inv (seg_reg_valid, seg_reg_is_stall),
    mmx_valid_inv (mmx_valid, mmx_is_stall);

    and4$ r_valid_and (r_valid, d_valid, reg_file_valid, seg_reg_valid, mmx_valid); 
    and4$ d_ready_and (d_ready, r_ready, reg_file_valid, seg_reg_valid, mmx_valid);

    //pipestage #(.WIDTH(PIPEWIDTH)) stage0 ( clk, (reset | flush), d_valid, d_ready, pipe_in_data, r_valid, r_ready, pipe_out_data);
   
    // ------ //
    // Stalls //
    // ------ //

    wire  in_accept;

    and2$ (in_accept, d_valid, d_ready);
    
    // Register File Stall
    register_access_stall register_access_stall0 (
        register_file_stall,

        clk,
        reset,

	    stack_operation,					  

        d_size[1:0],

        d_op0,
        p_op0_reg,

        d_op1,
        p_op1_reg,

        d_modrm,

        d_sib,
        ,   // not used...

        ,    // not used...
        wb_reg_number,
        wb_reg_size[1:0],
        wb_reg_en,

        in_accept     
    );

    // Segment Register Stall
    segment_register_stall segment_register_stall0 (
        clk,
        reset,

        seg_reg_is_stall,

        wb_seg_number,
        wb_seg_en,

        d_op0,
        d_op0_reg,

        d_op1,
        d_op1_reg,

        in_accept
    );

    mmx_stall mmx_stall0 (
        clk,
        reset,

        mmx_is_stall,

        wb_mmx_number,
        wb_mmx_en,

        d_modrm,

        d_op0,
        d_op0_reg,

        d_op1,
        d_op1_reg,

        in_accept
    );

    // ---- //
    // MOVS //
    // ---- //

    wire [31:0] write_esi_data, write_edi_data;

    // Directly modify ESI and EDI depending on size and DF flag

    // Add and subtract 1, 2, and 4 to both ESI and EDI

    register_access_movs_add_subtract add_sub_esi (
        write_esi_data,
        p_esi,
        flag_df,
        d_size
    );

        register_access_movs_add_subtract add_sub_edi (
        write_edi_data,
        p_edi,
        flag_df,
        d_size
    );

    // d_movs
    // change the value in esi and edi if address generation is ready for new value
    wire esi_edi_en;
    and2$ and_change_esi_edi (esi_edi_en, d_movs, r_ready);
    

    // --------------- //
    // Stack Logic     //
    // --------------- //

    // This contains the working esp. The true esp is only commited at the writeback stage in case of flush
    wire [31:0] local_esp, local_esp_in, n_local_esp;
    wire 	stack_pop = d_stack_op[1];
    wire 	stack_push = d_stack_op[0];

    or2$ (stack_operation, stack_pop, stack_push);
   
    wire 	n_wb_stack;
    inv1$ (n_wb_stack, wb_stack);
 
    wire 	reg_eq_esp;   

    wire 	local_commit;
    wire 	wb_commit;
    wire 	temp_esp_commit;

    wire 	n_wb_commit_delay,wb_commit_delay; 
   
    wire [31:0] new_local_esp_pop,  new_local_esp_push;
    wire [31:0] new_local_esp_pop_p2;
    wire [31:0] new_local_esp_pop_p4;
    wire [31:0] new_local_esp_push_m1;   
    wire [31:0] new_local_esp_push_m2;
    wire [31:0] new_local_esp_push_m4; 

    wire [31:0] new_esp_pop,  new_esp_push;
    wire [31:0] new_esp_pop_p2;
    wire [31:0] new_esp_pop_p4;
    wire [31:0] new_esp_push_m1;   
    wire [31:0] new_esp_push_m2;
    wire [31:0] new_esp_push_m4; 
   
    wire [31:0] p_stack_address_push;
    wire [31:0] p_stack_address_pop; 
   
    compare #(.WIDTH(3)) esp_write (3'd4, wb_reg_number,reg_eq_esp);
   
    and3$ (local_commit    , d_valid  , d_ready   , stack_operation);
    and3$ (wb_commit       , wb_reg_en, n_wb_stack, reg_eq_esp);


    // Stack commit logic from the writeback.
    wire  	write_esp_enable;
    wire [31:0] write_esp;

    assign write_esp_enable = wb_stack_en;

    slow_addr #(.WIDTH(32)) com_add4 (r_esp, 32'd4, new_esp_pop_p4, nc0);
    slow_addr #(.WIDTH(32)) com_add2 (r_esp, 32'd2, new_esp_pop_p2, nc0);

    slow_addr #(.WIDTH(32)) com_m4 (r_esp, 32'hFFFFFFFC, new_esp_push_m4, nc0);
    slow_addr #(.WIDTH(32)) com_m2 (r_esp, 32'hFFFFFFFE, new_esp_push_m2, nc0);   
    slow_addr #(.WIDTH(32)) com_m1 (r_esp, 32'hFFFFFFFF, new_esp_push_m1, nc0);   

    mux #(.INPUTS(2),.WIDTH(32)) com_pop_sel  ({new_esp_pop_p4 , new_esp_pop_p2} , new_esp_pop , wb_stack_size[0]);	
    mux #(.INPUTS(4),.WIDTH(32)) com_push_sel ({new_esp_push_m4, 
                                                new_esp_push_m2,
                                                new_esp_push_m1,
                                                new_esp_push_m1}, new_esp_push, wb_stack_size);

    mux #(.INPUTS(2),.WIDTH(32)) com  ({ new_esp_pop, new_esp_push} , write_esp , wb_stack_op[1]);
   
    // After any non stack access to the ESP register load the tmp with what was written
    // Stack operations cant start anyways until all ESP writes are out of the pipeline ahead of it.
    register #(.WIDTH(32)) local_commit_delay (
               clk,
               reset,
               wb_commit,
               wb_commit_delay,
               n_wb_commit_delay,
               1'b1				    
    );
   
    or2$  (temp_esp_commit , wb_commit, local_commit);
   
    slow_addr #(.WIDTH(32)) add4 (local_esp, 32'd4, new_local_esp_pop_p4, nc0);
    slow_addr #(.WIDTH(32)) add2 (local_esp, 32'd2, new_local_esp_pop_p2, nc0);

    slow_addr #(.WIDTH(32)) m4 (local_esp, 32'hFFFFFFFC, new_local_esp_push_m4, nc0);
    slow_addr #(.WIDTH(32)) m2 (local_esp, 32'hFFFFFFFE, new_local_esp_push_m2, nc0);   
    slow_addr #(.WIDTH(32)) m1 (local_esp, 32'hFFFFFFFF, new_local_esp_push_m1, nc0);   

    mux #(.INPUTS(2),.WIDTH(32)) pop_sel  ({new_local_esp_pop_p4 , new_local_esp_pop_p2} , new_local_esp_pop , d_size[0]);	
    mux #(.INPUTS(4),.WIDTH(32)) push_sel ({new_local_esp_push_m4, 
                                            new_local_esp_push_m2,
                                            new_local_esp_push_m1,
                                            new_local_esp_push_m1}, new_local_esp_push, d_size);
    
    mux #(.INPUTS(4),.WIDTH(32)) in_sel ({wb_reg_data, wb_reg_data, 
                                          new_local_esp_pop, new_local_esp_push}, local_esp_in, {wb_commit,stack_pop});	
     
    slow_addr #(.WIDTH(32)) pop  (r_ss, local_esp         , p_stack_address_pop, nc0);
    slow_addr #(.WIDTH(32)) push (r_ss, new_local_esp_push, p_stack_address_push, nc0);

    mux #(.INPUTS(2),.WIDTH(32)) addr_sel  ({p_stack_address_pop,p_stack_address_push} ,  p_stack_address, stack_pop);	   

    register #(.WIDTH(32)) local_esp_reg (
               clk,
               reset,
               local_esp_in,
               local_esp,
               n_local_esp,
               temp_esp_commit				    
    );
   
    // --------------- //
    // Set Reg Numbers //
    // --------------- //
    wire [2:0]  d_op0_not;
    wire [2:0]  d_op1_not;

    inv1$
    d_op0_not0 (d_op0_not[0], d_op0[0]),
    d_op0_not1 (d_op0_not[1], d_op0[1]),
    d_op0_not2 (d_op0_not[2], d_op0[2]);

    inv1$
    d_op1_not0 (d_op1_not[0], d_op1[0]),
    d_op1_not1 (d_op1_not[1], d_op1[1]),
    d_op1_not2 (d_op1_not[2], d_op0[2]);
   
    // op0 reg
    // 
    // if op0 is 4, then set it op0_reg to mod_rm_reg
    // else set it to decode reg

    wire use_mod_rm_reg_op0;

    // 4 = 100
    and3$ use_mod_rm_reg_op0_and (use_mod_rm_reg_op0, d_op0[2], d_op0_not[1], d_op0_not[0]);

    mux #(.WIDTH(3), .INPUTS(2)) op0_reg_mux (
        {d_modrm[2:0], d_op0_reg},
        p_op0_reg,
        use_mod_rm_reg_op0
    );

    // op1 reg

    wire use_mod_rm_reg_op1;

    // 4 = 100
    and3$ use_mod_rm_reg_op1_and (use_mod_rm_reg_op1, d_op1[2], d_op1_not[1], d_op1_not[0]);
   

    mux #(.WIDTH(3), .INPUTS(2)) op1_reg_mux (
        {d_modrm[2:0], d_op1_reg},
        p_op1_reg,
        use_mod_rm_reg_op1
    );

    // ------------- //
    // Register File //
    // ------------- //

    register_file register_file0 (
        .clk(clk),
        .reset(reset),

        // no longer used
        .register_size(),

        // no longer used
        .op_1(),
        .op_1_value(),

        // no longer used
        .op_2(),
        .op_2_value(),

        // no longer used
        .sib_base_reg(),
        .sib_base_value(),
        .sib_index_reg(),
        .sib_index_value(),
        
        .writeback_reg(wb_reg_number),
        .writeback_en(wb_reg_en),
        .writeback_size(wb_reg_size[1:0]),
        .writeback_data(wb_reg_data),

        .writeback_2_reg(wb_reg_number_2),
        .writeback_2_en(wb_reg_en_2),
        .writeback_2_data(wb_reg_data_2),

        .esi_data(write_esi_data),
        .esi_en(esi_edi_en),
        .edi_data(write_edi_data),
        .edi_en(esi_edi_en),
        .write_esp(write_esp),
        .write_esp_enable(write_esp_enable),

        .eax_out(p_eax),
        .ecx_out(p_ecx),
        .edx_out(p_edx),
        .ebx_out(p_ebx),
        .esp_out(p_esp),
        .ebp_out(p_ebp),
        .esi_out(p_esi),
        .edi_out(p_edi)
    );

    // --------------------- //
    // Segment Register File //
    // --------------------- //

    segment_register_file segment_register_file0 (
        .clk(clk),
        .reset(reset),

        .write_select(wb_seg_number),
        .write_data(wb_seg_data),
        .write_enable(wb_seg_en),

        .write_cs(write_cs),
        .write_cs_enable(write_cs_enable),
						  
        .cs_out(p_cs),
        .ds_out(p_ds),
        .es_out(p_es),
        .fs_out(p_fs),
        .gs_out(p_gs),
        .ss_out(p_ss)
    );

    // ----------------- //
    // MMX Register File //
    // ----------------- //

    mmx_register_file mmx_register_file0 (
        .clk(clk),
        .reset(reset),

        .writeback_data(wb_mmx_data),
        .writeback_select(wb_mmx_number),
        .writeback_enable(wb_mmx_en),

        .mm0_out(p_mm0),
        .mm1_out(p_mm1),
        .mm2_out(p_mm2),
        .mm3_out(p_mm3),
        .mm4_out(p_mm4),
        .mm5_out(p_mm5),
        .mm6_out(p_mm6),
        .mm7_out(p_mm7)
    );

endmodule

module register_access_movs_add_subtract (
    out,

    in,
    df_flag,
    size
);

    output [31:0] out;

    input [31:0] in;
    input df_flag;
    input [2:0] size;

    // +1
    wire [31:0] in_plus_1;
    slow_addr #(.WIDTH(32)) plus_1 (in, 32'h1, in_plus_1, );

    // -1
    wire [31:0] in_minus_1;
    slow_addr #(.WIDTH(32)) minus_1 (in, 32'hFFFFFFFF, in_minus_1, );

    // +2
    wire [31:0] in_plus_2;
    slow_addr #(.WIDTH(32)) plus_2 (in, 32'h2, in_plus_2, );

    // -2
    wire [31:0] in_minus_2;
    slow_addr #(.WIDTH(32)) minus_2 (in, 32'hFFFFFFFE, in_minus_2, );

    // +4
    wire [31:0] in_plus_4;
    slow_addr #(.WIDTH(32)) plus_4 (in, 32'h4, in_plus_4, );

    // -4
    wire [31:0] in_minus_4;
    slow_addr #(.WIDTH(32)) minus_4 (in, 32'hFFFFFFFC, in_minus_4, );

    // select correct size
    wire [31:0] size_mux_out_plus, size_mux_out_minus;

    mux #(.WIDTH(32), .INPUTS(4)) size_mux_plus (
        {
            in_plus_4,   // 3
            in_plus_2,   // 2
            in_plus_1,   // 1
            32'h0    // 0
        },
        size_mux_out_plus,
        size[1:0]
    );

    mux #(.WIDTH(32), .INPUTS(4)) size_mux_minus (
        {
            in_minus_4,   // 3
            in_minus_2,   // 2
            in_minus_1,   // 1
            32'h0    // 0
        },
        size_mux_out_minus,
        size[1:0]
    );

    // plus or minus
    mux #(.WIDTH(32), .INPUTS(2)) out_mux (
        {size_mux_out_minus, size_mux_out_plus},
        out,
        df_flag
    );
    

endmodule;
