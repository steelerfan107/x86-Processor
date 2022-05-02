
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

    // Write Back Interface (To Pop Addr Dependency)
    wb_valid,
    wb_ready,
    wb_to_memory, 			

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

    // Write Back Interface (To Pop Addr Dependency)
    input wb_valid;
    input wb_ready;
    input wb_to_memory;

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

    wire    [31:0] a_op0;
    wire    a_op0_is_address;

    wire    [31:0] a_op1;
    wire    a_op1_is_address;   
   
    wire    pop_address_dependency;
    wire    push_address_dependency;   
    wire    addr0_match;
    wire    addr1_match;
    wire    halt, halt0, halt1;

    and3$ ( pop_address_dependency , wb_valid, wb_ready, wb_to_memory);
    and2$ ( push_address_dependency, e_valid, e_ready, a_op0_is_address);

    address_dependency_table (
     // Clock Interface
     .clk(clk),
     .reset(reset),  

     // Control Interface
     .flush(flush),

     // Address Interface In	
     .push(push_address_dependency),		  
     .push_address(a_op0),
     .push_size(a_opsize),

     // Address Compare Interface
     .compare_address_0(a_op0),
     .compare_address_0_size(a_opsize),			  
     .compare_address_0_hit(addr0_match),			  

     .compare_address_1(a_op1),
     .compare_address_1_size(a_opsize),			  
     .compare_address_1_hit(addr1_match),
		  
     // Address Interface Out
     .pop(pop_address_dependency),
   );

   and2$ (halt0, addr0_match, a_op0_is_address);
   and2$ (halt1, addr1_match, a_op1_is_address);
   or2$  (halt, halt0, halt1);

   // Use halt signal to hold tranaction until dependency is cleared
   

endmodule
