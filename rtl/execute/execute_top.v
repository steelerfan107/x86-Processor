//////////////////////////////////////
//
//  Top Execute Stage Module
//

module execute_top (
    // Clock Interface
    clk,
    reset,

    // Control Interface
    flush,

    // Pipestage Interface
    e_valid,
    e_ready,
    e_mmr,
    e_op_a,
    e_op_b,
    e_eax,
    e_stack_ptr,
    e_op,
    e_opcode,
    e_opsize,
    e_flag_0_map,
    e_flag_1_map,
    e_set_d_flag,
    e_clear_d_flag,
    e_size_of_txn,
    e_branch_taken,
    e_to_sys_controller,
    e_pc,

    // Writeback Interface
    wb_ready,
    wb_dest_address,
    wb_dest_reg,
    wb_result,
    wb_opsize,
    wb_mem_or_reg,
    wb_valid,
    wb_branch_taken,
    wb_to_sys_controller,
    wb_pc,
    wb_jump_load_address,
    wb_jump_load_cs,
    wb_cs_out,
    wb_br_misprediction

);
    // Clock Interface
    input clk;
    input reset;

    // Control Interface
    input flush;

    // Pipestage Interface
    input e_valid;
    output e_ready;
    input e_mmr;
    input [63:0] e_op_a;
    input [63:0] e_op_b;
    input [31:0] e_eax;
    input [31:0] e_stack_ptr;
    input [3:0] e_op;
    input [15:0] e_opcode;
    input [1:0] e_opsize;
    input [2:0] e_flag_0_map;
    input [2:0] e_flag_1_map;
    input e_set_d_flag;
    input e_clear_d_flag;
    input e_size_of_txn;
    input e_branch_taken;
    input e_to_sys_controller;
    input [31:0] e_pc;

    // Writeback Interface
    input wb_ready;
    output [31:0] wb_dest_address;
    output [31:0] wb_dest_reg;
    output [63:0] wb_result;
    output [1:0] wb_opsize;
    output wb_mem_or_reg;
    output wb_valid;
    output wb_branch_taken;
    output wb_to_sys_controller;
    output [31:0] wb_pc;
    output wb_jump_load_address;
    output wb_jump_load_cs;
    output [31:0] wb_cs_out;
    output wb_br_misprediction;
   
    wire [63:0] a;
    wire [63:0] b;
    wire [63:0] e_alu_out;
    wire [5:0] e_alu_set_eflags; 
    wire [5:0] e_alu_eflags_out; 
    wire [6:0] e_eflags_out;
    wire [31:0] e_cs; //not sure what this is concerning far jump atm
    
   
    // -------   //
    // Pipestage //
    // -------   //
    // Some Temp Logic
   
    localparam PIPEWIDTH = 32+32+64+2+1+1+33;

    wire [31:0] p_dest_address;
    wire [31:0] p_dest_reg;
    wire [63:0] p_result;
    wire [1:0] p_opsize;
    wire p_mem_or_reg;
    wire p_branch_taken;
    wire p_to_sys_controller;    
    wire [31:0] p_pc;
    wire change_df;
    wire set_df;

    wire [PIPEWIDTH-1:0] pipe_in_data, pipe_out_data;   

    assign p_dest_address = 'h0;   
    assign p_dest_reg = 'h0;
    assign p_result = (~|e_op) ? e_op_b : e_op_a + e_op_b;
    assign p_opsize = 'h0;
    assign p_mem_or_reg = 'h0;
    assign p_branch_taken = 'h0;

    assign pipe_in_data = {
        p_dest_address,
        p_dest_reg,
        p_result,
        p_opsize,
        p_mem_or_reg,
        p_branch_taken,
        p_to_sys_controller,
        p_pc	    
    };

    assign {
        wb_dest_address,
        wb_dest_reg,
        wb_result,
        wb_opsize,
        wb_mem_or_reg,
        wb_branch_taken,
        wb_to_sys_controller,
        wb_pc
    } = pipe_out_data; 

    pipestage #(.WIDTH(PIPEWIDTH)) stage ( clk, (reset | flush), e_valid, e_ready, pipe_in_data, wb_valid, wb_ready, pipe_out_data);
    genvar i;
    generate
    for(i = 0; i < 64; i = i+1) begin : opa_buffer_block
        bufferH64$ instance(.out(a[i]), .in(e_op_a[i]));
    end
    endgenerate

    generate
    for(i = 0; i < 64; i = i+1) begin : opb_buffer_block
        bufferH64$ instance(.out(b[i]), .in(e_op_b[i]));
    end
    endgenerate

    ALU alu(
        .a(a), 
        .b(b),
        .eax(eax),
        .eip(e_pc),
        .cs(e_cs),
        .eflags_in(e_eflags_out[5:0]),
        .opsize(e_opsize),
        .opcode(opcode), 
        .alu_op(e_op), 
        .flag_0_map(e_flag_0_map),
        .flag_1_map(e_flag_1_map),
        .branch_taken(e_branch_taken),
        .jump_load_address(wb_jump_load_address),
        .jump_load_cs(wb_jump_load_cs),
        .cs_out(wb_cs_out),
        .br_misprediction(wb_br_misprediction),
        .alu_out(e_alu_out),
        .set_eflags(e_alu_set_eflags), 
        .eflags_out(e_alu_eflags_out));
    
    mux2$ mux_change_df(.outb(change_df), .in0(1'b0), .in1(1'b1), .s0(e_set_d_flag)); //if not set, then must be clear
    or2$ or_set_df(.out(set_df), .in0(e_set_d_flag), .in1(e_clear_d_flag));

    eflags eflags(
        .eflags_in({change_df, e_alu_eflags_out}), 
        .set_eflags({set_df, e_alu_set_eflags}), 
        .eflags_out(e_eflags_out));

    
endmodule