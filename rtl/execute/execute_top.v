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
    e_dest_reg,
    e_op_a_address,
    e_op_a_is_address,
    e_op_a_is_reg,
    e_op_a_is_segment,
    e_op_a_is_mmx, 
    e_op_b_reg,
    e_op_b_address,
    e_op_b_is_reg,
    e_op_b_is_address,
    e_mmr,
    e_op_a,
    e_op_b,
    e_eax,
    e_cs,
    e_stack_ptr,
    e_stack_op,
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
    wb_opcode,
    wb_mem_or_reg,
    wb_op_a_is_address,
    wb_op_a_is_reg,
    wb_op_a_is_segment,
    wb_op_a_is_mmx,
    wb_op_b_reg,
    wb_op_b_address,
    wb_op_b_is_reg,
    wb_op_b_is_address,
    wb_stack_op,		    
    wb_stack,
    wb_valid,
    wb_branch_taken,
    wb_to_sys_controller,
    wb_pc,
    wb_jump_load_address,
    wb_jump_address,		    
    wb_jump_load_cs,
    wb_cs_out,
    wb_br_misprediction,
    wb_alu_op,
    wb_eflags,
    e_eflags_out


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
    input [2:0] e_dest_reg;
    input [31:0] e_op_a_address;   
    input [63:0] e_op_a;
    input [63:0] e_op_b;
    input [31:0] e_eax;
    input [15:0]  e_cs;
    input [31:0] e_stack_ptr;
    input [1:0] e_stack_op;
    input [3:0] e_op;
    input [15:0] e_opcode;
    input [2:0] e_opsize;
    input [2:0] e_flag_0_map;
    input [2:0] e_flag_1_map;
    input e_set_d_flag;
    input e_clear_d_flag;
    input e_size_of_txn;
    input e_branch_taken;
    input e_to_sys_controller;
    input [31:0] e_pc;
    input e_op_a_is_address;
    input e_op_a_is_reg;
    input e_op_a_is_segment;
    input e_op_a_is_mmx;
    input [2:0] e_op_b_reg;
    input [31:0] e_op_b_address;
    input e_op_b_is_reg;
    input e_op_b_is_address;
   

    // Writeback Interface
    input wb_ready;
    output [31:0] wb_dest_address;
    output [31:0] wb_dest_reg;
    output [63:0] wb_result;
    output [2:0] wb_opsize;
    output [15:0] wb_opcode;   
    output wb_mem_or_reg;
    output [1:0] wb_stack_op;   
    output wb_stack;
    output wb_valid;
    output wb_branch_taken;
    output wb_to_sys_controller;
    output [31:0] wb_pc;
    output wb_jump_load_address;
    output [31:0] wb_jump_address;   
    output wb_jump_load_cs;
    output [31:0] wb_cs_out;
    output wb_br_misprediction;
    output wb_op_a_is_address;
    output wb_op_a_is_reg;
    output wb_op_a_is_segment;
    output wb_op_a_is_mmx;
    output [2:0] wb_op_b_reg;
    output [31:0] wb_op_b_address;
    output wb_op_b_is_reg;
    output wb_op_b_is_address;
    output [3:0] wb_alu_op;
    output [5:0]  wb_eflags;
   
    output [6:0] e_eflags_out;

   
    wire [63:0] a;
    wire [63:0] b;
    wire [63:0] e_alu_out;
    wire [5:0] e_alu_set_eflags;
    wire [5:0] e_alu_set_eflags_mask;    
    wire [5:0] e_alu_eflags_out; 
    wire [5:0] e_alu_eflags_out_in;    
    // wire [6:0] e_eflags_out;
    wire  wb_jump_load_address_unamsk;
    wire   cmp_xchg;
   
    and2$ (wb_jump_load_address, e_valid, wb_jump_load_address_unamsk);


    // -------   //
    // Pipestage //
    // -------   //
    // Some Temp Logic

    wire [6:0] e_eflags_next;
   
    // localparam PIPEWIDTH = 32+32+64+3+1+1+1+32+1+2+1+1+1+1+3+32+1+1+4;
    localparam PIPEWIDTH = 32+32+64+2+1+1+32+1+1+1+4+2+1+16+3+32+1+1+4+6;

    wire [31:0]  p_dest_address = e_op_a_address;
   wire [31:0] 	 p_dest_reg; // = e_dest_reg;
   wire [63:0] 	 p_result; // = e_alu_out;
   wire [2:0] 	 p_opsize; // = e_opsize;
    wire         p_mem_or_reg = 'h0;
    wire         p_branch_taken = 'h0;
    wire         p_to_sys_controller = e_to_sys_controller;
    wire  [31:0] p_pc = e_pc;
    // wire p_stack;
    // wire [1:0] e_stack_op
    wire p_op_a_is_address = e_op_a_is_address;
    wire p_op_a_is_reg = e_op_a_is_reg;
    wire p_op_a_is_segment = e_op_a_is_segment;
    wire p_op_a_is_mmx = e_op_a_is_mmx;
    wire [2:0] p_op_b_reg = e_op_b_reg;
    wire [31:0] p_op_b_address = e_op_b_address;
    wire p_op_b_is_reg = e_op_b_is_reg;
    wire p_op_b_is_address = e_op_b_is_address;
    wire [3:0] p_alu_op = e_op;
    wire [5:0] p_eflags = e_eflags_next[5:0];
    
   
    or2$ (p_stack, e_stack_op[0], e_stack_op[1]);

    wire [PIPEWIDTH-1:0] pipe_in_data, pipe_out_data;   

    assign pipe_in_data = {
	p_eflags,		   
        p_dest_address,
        p_dest_reg,
        p_result,
        p_opsize,
        p_mem_or_reg,
        e_branch_taken,
        e_to_sys_controller,
        e_pc,
        p_stack,
        e_stack_op,  			   
        p_op_a_is_address,
        p_op_a_is_reg,
        p_op_a_is_segment,
        p_op_a_is_mmx,
	    e_opcode,
        p_op_b_reg,
        p_op_b_address,
        p_op_b_is_reg,
        p_op_b_is_address,
        p_alu_op
    };

    assign {
	wb_eflags,    
        wb_dest_address,
        wb_dest_reg,
        wb_result,
        wb_opsize,
        wb_mem_or_reg,
        wb_branch_taken,
        wb_to_sys_controller,
        wb_pc,
	wb_stack,
	wb_stack_op,  	    
        wb_op_a_is_address,
        wb_op_a_is_reg,
        wb_op_a_is_segment,
        wb_op_a_is_mmx,
	    wb_opcode,
        wb_op_b_reg,
        wb_op_b_address,
        wb_op_b_is_reg,
        wb_op_b_is_address,
        wb_alu_op
    } = pipe_out_data; 

    pipestage #(.WIDTH(PIPEWIDTH)) stage ( clk, (reset | flush), e_valid, e_ready, pipe_in_data, wb_valid, wb_ready, pipe_out_data);
    //assign wb_valid = e_valid;
    //assign e_ready = wb_ready;
    //assign pipe_out_data = pipe_in_data;
   
   
    // XCHANGE Inner Register
   
    wire opsize_is_8, opcode_is_xchg, check_reg_a_b, a_and_b_regs, xchg_reg_select;
    wire [3:0] e_op_x;
   
    ucomp4 comp_opsize(.a({1'b0, e_opsize}), .b(4'b0001), .agb_in(1'b0), .eq_in(1'b1), .bga_in(1'b0), .eq_out(opsize_is_8));
    ucomp4 check_if_xchg(.a(e_op), .b(4'b1110), .agb_in(1'b0), .eq_in(1'b1), .bga_in(1'b0), .eq_out(opcode_is_xchg));
    ucomp4 check_if_regs_same(.a({2'b0, e_dest_reg[1:0]}), .b({2'b0, e_op_b_reg[1:0]}), .agb_in(1'b0), .eq_in(1'b1), .bga_in(1'b0), .eq_out(check_reg_a_b));
    and2$ and_ab_reg(.in0(e_op_a_is_reg), .in1(e_op_b_is_reg), .out(a_and_b_regs));
    and4$ xchg_special(.in0(opsize_is_8), .in1(opcode_is_xchg), .in2(check_reg_a_b), .in3(a_and_b_regs), .out(xchg_reg_select));
    mux #(.WIDTH(3), .INPUTS(2)) mux_chg_size(.in({3'b010, e_opsize}), .out(p_opsize), .select(xchg_reg_select));
    mux #(.WIDTH(3), .INPUTS(4)) mux_chg_dest(.in({e_alu_out[34:32],e_alu_out[34:32],{1'b0, e_dest_reg[1:0]}, e_dest_reg}), .out(p_dest_reg), .select({cmp_xchg, xchg_reg_select}));
    mux #(.WIDTH(4), .INPUTS(2)) mux_chg_op(.in({4'b0000, e_op}), .out(e_op_x), .select(xchg_reg_select));
    mux #(.WIDTH(64), .INPUTS(4)) mux_chg_res(.in({{48'd0, e_op_a[7:0], e_op_b[7:0]} ,
						   {48'd0, e_op_b[7:0], e_op_a[7:0]} ,
						  e_alu_out,
                                                  e_alu_out}), .out(p_result), .select({xchg_reg_select,~e_dest_reg[2]}));


    genvar i;
    generate
    for(i = 0; i < 64; i = i+1) begin : opa_buffer_block
         //bufferH64$ instance(.out(a[i]), .in(e_op_a[i]));
    end
    endgenerate

    generate
    for(i = 0; i < 64; i = i+1) begin : opb_buffer_block
         //bufferH64$ instance(.out(b[i]), .in(e_op_b[i]));
    end
    endgenerate

    ALU alu(
        .a(e_op_a), 
        .b(e_op_b),
        .eax(e_eax),
        .eip(e_pc),
        .cs(e_cs),
        .eflags_in(e_eflags_out[5:0]),
        .opsize(e_opsize),
        .opcode(e_opcode), 
        .alu_op(e_op_x), 
        .flag_0_map(e_flag_0_map),
        .flag_1_map(e_flag_1_map),
        .branch_taken(e_branch_taken),
        .jump_load_address(wb_jump_load_address_unamsk),
        .jump_load_cs(wb_jump_load_cs),
        .cs_out(wb_cs_out),
        .br_misprediction(wb_br_misprediction),
        .alu_out(e_alu_out),
        .set_eflags(e_alu_set_eflags), 
        .eflags_out(e_alu_eflags_out),
        .jump_address(wb_jump_address),
        .cmp_xchg(cmp_xchg));

    
    
    mux2$ mux_change_df(.outb(change_df), .in0(1'b0), .in1(1'b1), .s0(e_set_d_flag)); //if not set, then must be clear
    or2$ or_set_df(.out(set_df), .in0(e_set_d_flag), .in1(e_clear_d_flag));

    assign e_alu_eflags_out_in = (e_valid) ? e_alu_eflags_out : e_eflags_out;
   
    eflags eflags(
	.clk(clk),
	.reset(reset),
	.valid(1'b1),
        .eflags_in({change_df, e_alu_eflags_out_in}), 
        .set_eflags({set_df, e_alu_set_eflags}),
	.eflags_next(e_eflags_next),
        .eflags_out(e_eflags_out));

    
endmodule

