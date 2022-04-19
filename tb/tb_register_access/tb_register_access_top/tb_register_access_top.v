// tb_register_access_top.v
// 

// Testbench for register access stage

module TOP;
    // Clock Interface
    reg clk;
    reg reset;

    // Control Interface
    reg flush;

    // Decode Interface
    reg d_valid;
    wire d_ready;
    reg [2:0] d_size;
    reg d_set_d_flag;
    reg d_clear_d_flag;
    reg [2:0] d_op0;
    reg [2:0] d_op1;
    reg [2:0] d_op0_reg;
    reg [2:0] d_op1_reg;
    reg [7:0] d_modrm;
    reg [7:0] d_sib;
    reg [47:0] d_imm;
    reg [31:0] d_disp;
    reg [3:0] d_alu_op;
    reg [2:0] d_flag_0;
    reg [2:0] d_flag_1;
    reg [1:0] d_stack_op;
    reg [2:0] d_seg_override;
    reg d_seg_override_valid;
    reg [31:0] d_pc;
    reg d_branch_taken;

    // Address Generation Inferface
    wire r_valid;
    reg r_ready;
    wire [2:0] r_size;
    wire r_set_d_flag;
    wire r_clear_d_flag;
    wire [2:0] r_op0;
    wire [2:0] r_op1;
    wire [2:0] r_op0_reg;
    wire [2:0] r_op1_reg;
    wire [7:0] r_modrm;
    wire [7:0] r_sib;
    wire [47:0] r_imm;
    wire [31:0] r_disp;
    wire [3:0] r_alu_op;
    wire [2:0] r_flag_0;
    wire [2:0] r_flag_1;
    wire [1:0] r_stack_op;
    wire [2:0] r_seg_override;
    wire r_seg_override_valid;
    wire [31:0] r_eax;
    wire [31:0] r_ecx;
    wire [31:0] r_edx;
    wire [31:0] r_ebx;
    wire [31:0] r_esp;
    wire [31:0] r_ebp;
    wire [31:0] r_esi;
    wire [31:0] r_edi;
    wire [15:0] r_cs;
    wire [15:0] r_ds;
    wire [15:0] r_es;
    wire [15:0] r_fs;
    wire [15:0] r_gs;
    wire [15:0] r_ss;
    wire [63:0] r_mm0;
    wire [63:0] r_mm1;
    wire [63:0] r_mm2;
    wire [63:0] r_mm3;
    wire [63:0] r_mm4;
    wire [63:0] r_mm5;
    wire [63:0] r_mm6;
    wire [63:0] r_mm7;
    wire [31:0] r_pc;
    wire r_branch_taken;

    // --------- //
    // Writeback //
    // --------- //

    // register file writeback
    reg [2:0] wb_reg_number;
    reg wb_reg_en;
    reg [2:0] wb_reg_size;
    reg [31:0] wb_reg_data;

    // segment register writeback
    reg [2:0] wb_seg_number;
    reg wb_seg_en;
    reg [15:0] wb_seg_data;

    // mmx register writeback
    reg [2:0] wb_mmx_number;
    reg wb_mmx_en;
    reg [63:0] wb_mmx_data;

    register_access_top uut (
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
        d_branch_taken,

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
        r_branch_taken,

        wb_reg_number,
        wb_reg_en,
        wb_reg_size,
        wb_reg_data,

        wb_seg_number,
        wb_seg_en,
        wb_seg_data,

        wb_mmx_number,
        wb_mmx_en,
        wb_mmx_data

    );

    initial begin
        $display("============ \n Begin Test \n============");


        $display("==========\n End Test \n==========");
    end


    initial #1000 $finish;

    initial begin
        $vcdplusfile("register_access_top.dump.vpd");
        $vcdpluson(0, TOP);
    end


endmodule