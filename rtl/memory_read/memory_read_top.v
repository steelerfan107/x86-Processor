
//////////////////////////////////////
//
//  Top Memory Read Stage Module
//

module memory_read_top (
    // Clock Interface
    clk,
    reset,

    // Control Interface
    flush,

    // Memory Read Interface
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

    // Pipestage Interface
    e_valid,
    e_ready,
    e_mmr,
    e_op_a,
    e_op_b,
    e_stack_ptr,
    e_op,
    e_opsize,
    e_size_of_txn,
    e_branch_taken

);

    // Clock Interface
    input clk;
    input reset;

    // Control Interface
    input flush;

    // Memory Read Interface
    input m_valid;
    output m_ready;
    input m_mmr;
    input [63:0] m_reg_a;
    input [63:0] m_reg_b;
    input m_descriptor_a;
    input m_descriptor_b;
    input [31:0] m_stack_ptr;
    input [3:0] m_op;
    input m_opsize;
    input m_size_of_txn;
    input m_branch_taken;

    // Pipestage Interface
    output e_valid;
    input e_ready;
    output e_mmr;
    output [63:0] e_op_a;
    output [63:0] e_op_b;
    output [31:0] e_stack_ptr;
    output [3:0] e_op;
    output e_opsize;
    output e_size_of_txn;
    output e_branch_taken;

endmodule