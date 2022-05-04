
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

    // Pipestage interface
    e_valid,
    e_ready,
    e_size,
    e_set_d_flag,
    e_clear_d_flag,
    e_op_a,
    e_op_b,
    e_op_a_reg,
    e_op_a_address,
    e_op_a_is_address,
    e_stack_ptr,
    e_imm,
    e_alu_op,
    e_flag_0,
    e_flag_1,
    e_pc,
    e_branch_taken,
    e_to_sys_controller	

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
    input a_valid;
    output a_ready;
    input [2:0] a_size;
    input a_set_d_flag;
    input a_clear_d_flag;
    input [63:0] a_op0;
    input [63:0] a_op1;
    input [2:0] a_op0_reg;
    input [2:0] a_op1_reg;
    input a_op0_is_address;
    input a_op1_is_address;
    input [47:0] a_imm;
    input [3:0] a_alu_op;
    input [2:0] a_flag_0;
    input [2:0] a_flag_1;
    input [1:0] a_stack_op;
    input [31:0] a_pc;
    input a_branch_taken;
    input a_to_sys_controller;

    // Pipestage interface
    output e_valid;
    input e_ready;
    output [2:0] e_size;            // size of operand, following size defined in #decode channel
    output e_set_d_flag;
    output e_clear_d_flag;
    output [63:0] e_op_a;           // value for operand a
    output [63:0] e_op_b;           // value for operand b
    output [2:0] e_op_a_reg;        // register number for operand a
    output [31:0] e_op_a_address;    // address for operand a
    output e_op_a_is_address;       // Flag showing if operand a is an address (1 for address, 0 for register)
    output [31:0] e_stack_ptr;      // stack pointer address
    output [47:0] e_imm;            // immediate
    output [3:0] e_alu_op;          // alu operation defined in #decode channel
    output [2:0] e_flag_0;
    output [2:0] e_flag_1;
    output [31:0] e_pc;
    output e_branch_taken;
    output e_to_sys_controller; 

    // --------- //
    // Pipestage //
    // --------- //

    localparam PIPEWIDTH = 3+1+1+64+64+3+32+1+32+48+4+3+3+32+1;

    wire [PIPEWIDTH-1:0] pipe_in_datam, pipe_out_data;

    assign {
        e_size,
        e_set_d_flag,
        e_clear_d_flag,
        e_op_a,
        e_op_b,
        e_op_a_reg,
        e_op_b_reg,
        e_op_a_address,
        e_op_b_address,
        e_op_a_is_address,
        e_op_b_is_address,
        e_stack_ptr,
        e_imm,
        e_alu_op,
        e_flag_0,
        e_flag_1,
        e_pc,
        a_branch_taken
    } = pipe_out_data;

    assign pipe_in_data = {
        0   // not sure what to put here tbh
    };


    wire pipestage_reset;
    or2$ or_pipestage (pipestage_reset, reset, flush);

    pipestage #(.WIDTH(PIPEWIDTH)) stage0 ( clk, pipestage_reset, a_valid, a_ready, pip_in_data, e_valid, e_ready, pipe_out_data);
   
    wire    pop_address_dependency;
    wire    push_address_dependency;   
    wire    addr0_match;
    wire    addr1_match;
    wire    halt, halt0, halt1;

    and3$ ( pop_address_dependency , wb_valid, wb_ready, wb_to_memory);
    and3$ ( push_address_dependency, e_valid, e_ready, a_op0_is_address);   // changed from and2 to and3 - brandon

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
     .pop(pop_address_dependency)
   );

   and2$ (halt0, addr0_match, a_op0_is_address);
   and2$ (halt1, addr1_match, a_op1_is_address);
   or2$  (halt, halt0, halt1);

   // Use halt signal to hold tranaction until dependency is cleared
   

endmodule
