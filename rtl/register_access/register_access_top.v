
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
    d_pc,
    d_branch_taken

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
    r_branch_taken
);

    // Clock Interface
    input clk;
    input reset;

    // Control Interface
    input flush;

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
    input [31:0] d_pc;
    input d_branch_taken;

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

    // ------ //
    // Stalls //
    // ------ //
    
    // Read after write for all registers

endmodule