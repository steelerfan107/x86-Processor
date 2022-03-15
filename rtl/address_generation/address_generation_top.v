
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
    r_branch_taken,

    // Pipestage Interface
    m_valid,
    m_ready,
    m_mmr,
    m_reg_a,
    m_reg_b,
    m_descriptor_a,
    m_descriptor_b,
    m_stack_ptr,
    m_op,
    m_opsize,
    m_size_of_txn,
    m_branch_taken

);

    // Clock Interface
    input clk;
    input reset;

    // Control Interface
    input flush;

    // Register Access Interface
    input r_valid;
    output r_ready;
    input r_mmr;
    input [63:0] r_reg_a_value;
    input [63:0] r_reg_b_value;
    input [31:0] r_sib_index;
    input [7:0] r_sib;
    input [31:0] r_disp;
    input [15:0] r_mem_seg;
    input [31:0] r_stack_ptr;
    input [3:0] r_op;
    input r_opsize;
    input [5:0] r_alu;
    input r_size_of_txn;
    input r_branch_taken;

    // Pipestage Interface
    output m_valid;
    input m_ready;
    output m_mmr;
    output [63:0] m_reg_a;
    output [63:0] m_reg_b;
    output m_descriptor_a;
    output m_descriptor_b;
    output [31:0] m_stack_ptr;
    output [3:0] m_op;
    output m_opsize;
    output m_size_of_txn;
    output m_branch_taken;

endmodule