
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
    d_mmr,
    d_rega,
    d_regb,
    d_imm,
    d_disp,
    d_seg_ov,
    d_sib,
    d_op,
    d_opsize,
    d_alu,
    d_repeat,
    d_size_of_txn,
    d_branch_taken

    // Pipestage Interface
    r_valid,
    r_ready,
    r_mmr,
    r_reg_a_value,
    r_reg_b_value,
    r_sib_index,
    r_sib,
    r_disp,
    r_mem_seg,
    r_stack_ptr,
    r_op,
    r_opsize,
    r_size_of_txn,
    r_branch_taken

);

    // Clock Interface
    input clk;
    input reset;

    // Control Interface
    input flush;

    // Decode Interface
    input               d_valid;
    output                d_ready;
    input               d_mmr;
    input [2:0] 	d_rega;
    input [2:0] 	d_regb;
    input [31:0] 	d_imm;
    input [31:0] 	d_disp;
    input [5:0] 	d_seg_ov; // One Hot {CS, SS, DS, ES, FS, GS}
    input [7:0] 	d_sib;
    input [3:0] 	d_op;
    input               d_opsize;
    input [5:0] 	d_alu;
    input               d_repeat;
    input [3:0]         d_size_of_txn;
    input               d_branch_taken;

    // Pipestage Interface
    output r_valid;
    input r_ready;
    output r_mmr;
    output [63:0] r_reg_a_value;
    output [63:0] r_reg_b_value;
    output [31:0] r_sib_index;
    output [7:0] r_sib;
    output [31:0] r_disp;
    output [15:0] r_mem_seg;
    output [31:0] r_stack_ptr;
    output [3:0] r_op;
    output r_opsize;
    output [5:0] r_alu;
    output r_size_of_txn;
    output r_branch_taken;

endmodule