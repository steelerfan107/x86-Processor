//////////////////////////////////////
//
//  Register Access Stall
//
//  Determines if a stall due to consecutive register accesses

// Hold a table of registers currently being processed
// Register is added when it is OP0 
// Register is removed when it is written back
// Each table entry is a counter that is incremented/decrimented

module register_access_stall (
    is_stall,

    clk,
    reset,

    stack_op,			      

    register_size,

    op0,
    op0_reg,

    op1,
    op1_reg,

    mod_rm,

    sib,
    sib_valid,

    wb_data,    // not used...
    wb_reg,
    wb_size,
    wb_enable,

    next_stage_ready
);
    output is_stall;    // 1 if the stage should stall

    input clk;
    input reset;

    input  stack_op;

    input [1:0] register_size;

    input [2:0] op0;
    input [2:0] op0_reg;  

    input [2:0] op1;
    input [2:0] op1_reg;

    input [7:0] mod_rm;

    input [7:0] sib;
    input sib_valid;

    input [32:0] wb_data;
    input [2:0] wb_reg;
    input [1:0] wb_size;
    input wb_enable;

    input next_stage_ready;

    // wires
    wire [2:0] op0_r0;
    wire op0_r0_is_valid;
    
    wire [2:0] op0_r1;
    wire op0_r1_is_valid;

    wire [2:0] op1_r0;
    wire op1_r0_is_valid;
    
    wire [2:0] op1_r1;
    wire op1_r1_is_valid;

    // correct register index based on operand size
    wire [2:0] op0_reg_corrected;
    wire [2:0] op1_reg_corrected;
    wire [2:0] wb_reg_corrected;

    register_writeback_select 
    op0_reg_corrector (op0_reg_corrected, op0_reg, register_size),
    op1_reg_corrector (op1_reg_corrected, op1_reg, register_size),
    wb_reg_corrector (wb_reg_corrected, wb_reg, wb_size);

    register_stall_access_calculator logic0 (
        op0_r0,
        op0_r0_is_valid,

        op0_r1,
        op0_r1_is_valid,

        op1_r0,
        op1_r0_is_valid,

        op1_r1,
        op1_r1_is_valid,

        op0,
        op0_reg_corrected,

        op1,
        op1_reg_corrected,

        mod_rm,
        sib,
        register_size
    );

    // see if op0 is writing to a register
    wire op0_is_reg;
    wire [2:0] op0_reg_write;

    register_stall_is_op0_write register_stall_is_op0_write0 (
        op0_is_reg,
        op0_reg_write,

        register_size,

        op0,
        op0_reg,
        mod_rm
    );



    register_stall_table logic1 (
        clk,
        reset,

        is_stall,

	stack_op,			 

        wb_reg,
        wb_enable,

        op0_reg_write,
        op0_is_reg,

        op0_r0,
        op0_r0_is_valid,

        op0_r1,
        op0_r1_is_valid,

        op1_r0,
        op1_r0_is_valid,

        op1_r1,
        op1_r1_is_valid,

        next_stage_ready
    );

endmodule


// determines of op0 is starting a reg write
// reg write occurs when op0 is a reg, or modrm with mod 11
// decides what the reg is

module register_stall_is_op0_write (
    is_reg,
    reg_num,

    register_size,

    op0,
    op0_reg,
    mod_rm
);

    output is_reg;
    output [2:0] reg_num;

    input [1:0] register_size;

    input [2:0] op0;
    input [2:0] op0_reg;
    input [7:0] mod_rm;

    wire [1:0] mod = mod_rm[7:6];
    wire [2:0] rm = mod_rm[2:0];

    // is reg if:
        // - op0 is 1
        // - op0 is 4 and mod is 11
    
    // check if op0 is 1
    wire [2:0] op0_not;
    inv1$ 
    op0_not_inv_0 (op0_not[0], op0[0]),
    op0_not_inv_1 (op0_not[1], op0[1]),
    op0_not_inv_2 (op0_not[2], op0[2]);

    wire is_op0_1;
    and3$ is_op0_1_and (is_op0_1, op0_not[2], op0_not[1], op0[0]);

    // check if op0 is 4 (100)
    wire is_op0_4;
    and3$ os_op0_4_and (is_op0_4, op0[2], op0_not[1], op0_not[0]);

    // check if its mod rm reg
    wire is_mod_rm_reg;
    and3$ is_mod_rm_reg_and (is_mod_rm_reg, is_op0_4, mod[1], mod[0]);

    // set is_reg
    or2$ is_reg_or (is_reg, is_mod_rm_reg, is_op0_1);

    // set size of rm selection
    wire [2:0] rm_reg;
    register_writeback_select rm_size (rm_reg, rm, register_size);

    // select which value to use for output 
    ao_mux #(.WIDTH(3), .NINPUTS(2)) output_mux (
        {rm_reg, op0_reg},
        reg_num,
        {is_mod_rm_reg, is_op0_1}
    );


endmodule


// decides if a register in reg table should be modified
// +1 if op0 matches the register that the block modifies and the next segment is ready for new data
// -1 if writeback matches the register that the block modifies
module register_stall_modify_table (
    write_enable,
    reg_in,

    assigned_reg,
    op0_reg,
    op0_reg_is_valid,
    wb_reg,
    wb_reg_is_valid,
    next_stage_ready,
    reg_out
);

    // output [1:0] mux_control;   // 1 = +1 to reg; 2 = -1 to reg (one hot)
    output write_enable;
    output [3:0] reg_in;


    input [2:0] assigned_reg;   // reg number that this block is monitoring
    input [2:0] op0_reg;
    input op0_reg_is_valid;
    input [2:0] wb_reg;
    input wb_reg_is_valid;
    input next_stage_ready;     // only add to table if the data is passed through the pipeline
    input [3:0] reg_out;


    // add 1
    wire [3:0] reg_plus_one;
    wire        p1;

    mux2$ (p1, 1'b0, 1'b1, next_stage_ready);
   
    slow_addr #(.WIDTH(4)) plus_one (reg_out, {3'b0,p1}, reg_plus_one, );

    // sub 1
    wire [3:0] reg_minus_one;
    slow_addr #(.WIDTH(4)) minus_one (reg_out, 4'hf, reg_minus_one, );

    // decide on what to use
    //
    // 1 = add 1
    // 2 = subtract 1
    
    wire [1:0] mux_control;

    // mux_control[0] = 1 if assigned_reg == op0_reg and op0_reg is valid
    // using xnor to see if the assigned reg matches the reg that is being written to
    wire [2:0] add_and_result;
    xnor2$ 
    xnor0 (add_and_result[0], assigned_reg[0], op0_reg[0]), 
    xnor1 (add_and_result[1], assigned_reg[1], op0_reg[1]), 
    xnor2 (add_and_result[2], assigned_reg[2], op0_reg[2]);

    // see if match
    and4$ and3 (mux_control[0], add_and_result[0], add_and_result[1], add_and_result[2], op0_reg_is_valid);

    // mux_control[1] = 1 if assigned_reg == wb_reg and wb_reg is valid
    wire [2:0] sub_and_result;
    xnor2$ 
    xnor4 (sub_and_result[0], assigned_reg[0], wb_reg[0]), 
    xnor5 (sub_and_result[1], assigned_reg[1], wb_reg[1]), 
    xnor6 (sub_and_result[2], assigned_reg[2], wb_reg[2]);

    // see if match
    and4$ and7 (mux_control[1], sub_and_result[0], sub_and_result[1], sub_and_result[2], wb_reg_is_valid);

    // select input to reg with a mux
    ao_mux #(.WIDTH(4), .NINPUTS(2)) reg_in_mux (
        {reg_minus_one, reg_plus_one},
        reg_in,
        mux_control
    );

    // determine if we writing
    // write if mux control is 01 or 10, but not 11
  
    wire modifies_table;
    xor2$ xor0 (modifies_table, mux_control[0], mux_control[1]);
   
    and2$ and_out (write_enable, modifies_table, next_stage_ready);

endmodule


// table of regs
module register_stall_table (
    clk,
    reset,

    is_stall,

    stack_op,

    wb_reg,
    wb_is_valid,

    op0_reg,
    op0_reg_is_valid,

    op0_r0,
    op0_r0_is_valid,

    op0_r1,
    op0_r1_is_valid,

    op1_r0,
    op1_r0_is_valid,

    op1_r1,
    op1_r1_is_valid,


    next_stage_ready
);

    input clk;
    input reset;

    output is_stall;

    input  stack_op;

    input [2:0] wb_reg;
    input wb_is_valid;

    input [2:0] op0_reg;
    input op0_reg_is_valid;

    input [2:0] op0_r0;
    input op0_r0_is_valid;
    
    input [2:0] op0_r1;
    input op0_r1_is_valid;

    input [2:0] op1_r0;
    input op1_r0_is_valid;
    
    input [2:0] op1_r1;
    input op1_r1_is_valid;


    input next_stage_ready;

    // from register_file.v since this can be set to 0 at reset
    wire [3:0] 
    r0_out,
    r1_out,
    r2_out,
    r3_out,
    r4_out,
    r5_out,
    r6_out,
    r7_out;
   
    wire  is_stall_table, is_stall_stack, non_zero_r4;

    or4$ (non_zero_r4 , r4_out[3],r4_out[2],r4_out[1],r4_out[0] );
    and2$ (is_stall_stack, non_zero_r4, stack_op);
   
    or2$ (is_stall, is_stall_table, is_stall_stack);
   
    // 8 registers to hold counter values
    // Each with 4 bits (chosen arbitrarily lol)

    // from register_file.v since this can be set to 0 at reset

    wire [3:0] 
    r0_in,
    r1_in,
    r2_in,
    r3_in,
    r4_in,
    r5_in,
    r6_in,
    r7_in;

    wire 
    r0_en,
    r1_en,
    r2_en,
    r3_en,
    r4_en,
    r5_en,
    r6_en,
    r7_en;


    // doing this to prevent port width mismatch warning
    wire [31:0] 
    r0_out_32,
    r1_out_32,
    r2_out_32,
    r3_out_32,
    r4_out_32,
    r5_out_32,
    r6_out_32,
    r7_out_32;

    assign r0_out = r0_out_32[3:0];
    assign r1_out = r1_out_32[3:0];
    assign r2_out = r2_out_32[3:0];
    assign r3_out = r3_out_32[3:0];
    assign r4_out = r4_out_32[3:0];
    assign r5_out = r5_out_32[3:0];
    assign r6_out = r6_out_32[3:0];
    assign r7_out = r7_out_32[3:0];

    // assign r0_out_32[31:4] = 28'd0;
    // assign r1_out_32[31:4] = 28'd0;
    // assign r2_out_32[31:4] = 28'd0;
    // assign r3_out_32[31:4] = 28'd0;
    // assign r4_out_32[31:4] = 28'd0;
    // assign r5_out_32[31:4] = 28'd0;
    // assign r6_out_32[31:4] = 28'd0;
    // assign r7_out_32[31:4] = 28'd0;

    //register_32_reset 
    //r0 (r0_out_32, {28'd0, r0_in}, 0, r0_en, clk, reset), 
    //r1 (r1_out_32, {28'd0, r1_in}, 0, r1_en, clk, reset), 
    //r2 (r2_out_32, {28'd0, r2_in}, 0, r2_en, clk, reset), 
    //r3 (r3_out_32, {28'd0, r3_in}, 0, r3_en, clk, reset), 
    //r4 (r4_out_32, {28'd0, r4_in}, 0, r4_en, clk, reset), 
    //r5 (r5_out_32, {28'd0, r5_in}, 0, r5_en, clk, reset), 
    //r6 (r6_out_32, {28'd0, r6_in}, 0, r6_en, clk, reset), 
    //r7 (r7_out_32, {28'd0, r7_in}, 0, r7_en, clk, reset);

    register #(.WIDTH(32)) r0 (clk,reset,{28'd0, r0_in},r0_out_32,n_pc_out,r0_en);
    register #(.WIDTH(32)) r1 (clk,reset,{28'd0, r1_in},r1_out_32,n_pc_out,r1_en);
    register #(.WIDTH(32)) r2 (clk,reset,{28'd0, r2_in},r2_out_32,n_pc_out,r2_en);
    register #(.WIDTH(32)) r3 (clk,reset,{28'd0, r3_in},r3_out_32,n_pc_out,r3_en);
    register #(.WIDTH(32)) r4 (clk,reset,{28'd0, r4_in},r4_out_32,n_pc_out,r4_en);
    register #(.WIDTH(32)) r5 (clk,reset,{28'd0, r5_in},r5_out_32,n_pc_out,r5_en);
    register #(.WIDTH(32)) r6 (clk,reset,{28'd0, r6_in},r6_out_32,n_pc_out,r6_en);
    register #(.WIDTH(32)) r7 (clk,reset,{28'd0, r7_in},r7_out_32,n_pc_out,r7_en);


    // decide if they should be written
    register_stall_modify_table 
    r0_modifier (r0_en, r0_in, 3'd0, op0_reg, op0_reg_is_valid, wb_reg, wb_is_valid, next_stage_ready, r0_out), 
    r1_modifier (r1_en, r1_in, 3'd1, op0_reg, op0_reg_is_valid, wb_reg, wb_is_valid, next_stage_ready, r1_out), 
    r2_modifier (r2_en, r2_in, 3'd2, op0_reg, op0_reg_is_valid, wb_reg, wb_is_valid, next_stage_ready, r2_out), 
    r3_modifier (r3_en, r3_in, 3'd3, op0_reg, op0_reg_is_valid, wb_reg, wb_is_valid, next_stage_ready, r3_out), 
    r4_modifier (r4_en, r4_in, 3'd4, op0_reg, op0_reg_is_valid, wb_reg, wb_is_valid, next_stage_ready, r4_out), 
    r5_modifier (r5_en, r5_in, 3'd5, op0_reg, op0_reg_is_valid, wb_reg, wb_is_valid, next_stage_ready, r5_out), 
    r6_modifier (r6_en, r6_in, 3'd6, op0_reg, op0_reg_is_valid, wb_reg, wb_is_valid, next_stage_ready, r6_out), 
    r7_modifier (r7_en, r7_in, 3'd7, op0_reg, op0_reg_is_valid, wb_reg, wb_is_valid, next_stage_ready, r7_out);

    // check if there is a stall condition
    wire is_stall;
    register_stall_is_reg_in_table table_checker (
        .reg_in_table(is_stall_table),

        .r0(r0_out),
        .r1(r1_out),
        .r2(r2_out),
        .r3(r3_out),
        .r4(r4_out),
        .r5(r5_out),
        .r6(r6_out),
        .r7(r7_out),

        .op0_r0(op0_r0),
        .op0_r0_is_valid(op0_r0_is_valid),

        .op0_r1(op0_r1),
        .op0_r1_is_valid(op0_r1_is_valid),

        .op1_r0(op1_r0),
        .op1_r0_is_valid(op1_r0_is_valid),

        .op1_r1(op1_r1),
        .op1_r1_is_valid(op1_r1_is_valid)
    );

    


endmodule

// Sees if a reg that is needed is currently in the table
//
// For each valid operand, select its corresponding register and set reg_in_table to 1 if the value is at least 1
module register_stall_is_reg_in_table (
    reg_in_table,

    r0,
    r1,
    r2,
    r3,
    r4,
    r5,
    r6,
    r7,

    op0_r0,
    op0_r0_is_valid,
    
    op0_r1,
    op0_r1_is_valid,

    op1_r0,
    op1_r0_is_valid,
    
    op1_r1,
    op1_r1_is_valid
);
    output reg_in_table;

    input [3:0] 
    r0,
    r1,
    r2,
    r3,
    r4,
    r5,
    r6,
    r7;

    input [2:0] op0_r0;
    input op0_r0_is_valid;
    
    input [2:0] op0_r1;
    input op0_r1_is_valid;

    input [2:0] op1_r0;
    input op1_r0_is_valid;
    
    input [2:0] op1_r1;
    input op1_r1_is_valid;

    wire [3:0] in_table;

    // mux for each op0_r0
    wire [3:0] op0_r0_mux_out;
    mux #(.WIDTH(4), .INPUTS(8)) op0_r0_mux (
        {r7, r6, r5, r4, r3, r2, r1, r0},
        op0_r0_mux_out,
        op0_r0
    );

    wire is_op0_r0_not_empty;
    register_stall_reg_not_empty not_empty0 (is_op0_r0_not_empty, op0_r0_mux_out);

    and2$ and0 (in_table[0], is_op0_r0_not_empty, op0_r0_is_valid);

    // mux for each op0_r1
    wire [3:0] op0_r1_mux_out;
    mux #(.WIDTH(4), .INPUTS(8)) op0_r1_mux (
        {r7, r6, r5, r4, r3, r2, r1, r0},
        op0_r1_mux_out,
        op0_r1
    );

    wire is_op0_r1_not_empty;
    register_stall_reg_not_empty not_empty1 (is_op0_r1_not_empty, op0_r1_mux_out);

    and2$ and1 (in_table[1], is_op0_r1_not_empty, op0_r1_is_valid);

    // mux for each op1_r0
    wire [3:0] op1_r0_mux_out;
    mux #(.WIDTH(4), .INPUTS(8)) op1_r0_mux (
        {r7, r6, r5, r4, r3, r2, r1, r0},
        op1_r0_mux_out,
        op1_r0
    );

    wire is_op1_r0_not_empty;
    register_stall_reg_not_empty not_empty2 (is_op1_r0_not_empty, op1_r0_mux_out);

    and2$ and2 (in_table[2], is_op1_r0_not_empty, op1_r0_is_valid);

    // mux for each op0_r0
    wire [3:0] op1_r1_mux_out;
    mux #(.WIDTH(4), .INPUTS(8)) op1_r1_mux (
        {r7, r6, r5, r4, r3, r2, r1, r0},
        op1_r1_mux_out,
        op1_r1
    );

    wire is_op1_r1_not_empty;
    register_stall_reg_not_empty not_empty3 (is_op1_r1_not_empty, op1_r1_mux_out);

    and2$ and3 (in_table[3], is_op1_r1_not_empty, op1_r1_is_valid);


    // see if any are valid
    or4$ or0 (reg_in_table, in_table[0], in_table[1], in_table[2], in_table[3]);


endmodule

// sees if the register is not zero
module register_stall_reg_not_empty (
    out,
    in
);

    output out;
    input [3:0] in;

    or4$ or0 (out, in[0], in[1], in[2], in[3]);

endmodule


// determines what registers are being accessed by the current instruction
// up to two registers will be accessed
    // 0 registers if there's no op1
    // 1 register is op1 is a register only, or modrm with no SIB
    // 2 registers if op1 is modrm with SIB (MOD ==  00 | 01 | 10 and R/M == 100)
module register_stall_access_calculator (
    op0_r0,
    op0_r0_is_valid,

    op0_r1,
    op0_r1_is_valid,

    op1_r0,
    op1_r0_is_valid,

    op1_r1,
    op1_r1_is_valid,

    op0,
    op0_reg,

    op1,
    op1_reg,

    mod_rm,
    sib,
    register_size
);

    output [2:0] op0_r0;
    output op0_r0_is_valid;

    output [2:0] op0_r1;
    output op0_r1_is_valid;

    output [2:0] op1_r0;
    output op1_r0_is_valid;
    
    output [2:0] op1_r1;
    output op1_r1_is_valid;

    input [2:0] op0;
    input [2:0] op0_reg;

    input [2:0] op1;
    input [2:0] op1_reg;

    input [7:0] mod_rm;
    input [7:0] sib;
    input [1:0] register_size;

    // OP Types:
    //
    // "none"        : "0",
    // "register"    : "1",
    // "segment"     : "2",
    // "mm register" : "3",
    // "mod r/m"     : "4",
    // "immediete"   : "5",
    // "memory"      : "6"


    // mod rm register accesses
    wire [2:0] mod_rm_r0;  
    wire [2:0] mod_rm_r1;
    register_stall_mod_rm_registers logic0 (
        mod_rm_r0, 
        mod_rm_r1, // if r1 is being used it has to be bc of mod rm and SIB

        mod_rm,
        sib,
        register_size

    );

    // ---------- //
    // op0 Access //
    // ---------- //

    register_stall_r0_is_valid logic1 (op0_r0_is_valid, op0, mod_rm);

    register_stall_r1_is_valid logic2 (op0_r1_is_valid, op0, mod_rm, sib);

    // mux selecting output of r0
    mux #(.WIDTH(3), .INPUTS(8)) op0_r0_mux (
        {
            3'h0,   // 7
            op0_reg,    //6
            3'h0,   //5
            mod_rm_r0,  //4
            3'h0,   //3
            3'h0,   //2
            op0_reg,   //1
            3'h0   //0
        },
        op0_r0,
        op0_reg
    );

    // r1 always the mod rm r1
    assign op0_r1 = mod_rm_r1;


    // ---------- //
    // op1 Access //
    // ---------- //

    register_stall_r0_is_valid logic3 (op1_r0_is_valid, op1, mod_rm);

    register_stall_r1_is_valid logic4 (op1_r1_is_valid, op1, mod_rm, sib);

    // mux selecting output of r0
    mux #(.WIDTH(3), .INPUTS(8)) op1_r0_mux (
        {
            3'h0,   // 7
            op1_reg,    //6
            3'h0,   //5
            mod_rm_r0,  //4
            3'h0,   //3
            3'h0,   //2
            op1_reg,   //1
            3'h0   //0
        },
        op1_r0,
        op1_reg

    );

    // r1 always the mod rm r1
    assign op1_r1 = mod_rm_r1;


endmodule

// r0_is_valid if op1 is 1, and op1 is 4 and mod rm isn't 00 101
// OUT = (OP! == 1) || (OP1 == 4 && MODRM != 00101) || (OP1 == 6)
module register_stall_r0_is_valid (
    out,
    op1,
    modrm_byte
);

    output out;
    input [2:0] op1;
    input [7:0] modrm_byte;

    // "none" : "0", // No stall
    // "register" : "1", // Stall for register being accessed
    // "segment" : "2", // No stall
    // "mm register" : "3", // No stall
    // "mod r/m" : "4", // stall for up to 2 registers. R/M register if there is 1, and the 2 sib registers if they are there
    // "immediete" : "5", // no stall
    // "memory" : "6" // stall for the register with the address

    wire [4:0] modrm;   // just the mod and rm field
    assign modrm[4:3] = modrm_byte[7:6];
    assign modrm[2:0] = modrm_byte[2:0];

    wire [2:0] op1_not;
    inv1$ 
    op1_not_0 (op1_not[0], op1[0]), 
    op1_not_1 (op1_not[1], op1[1]), 
    op1_not_2 (op1_not[2], op1[2]);

    wire [4:0] modrm_not;
    inv1$ 
    modrm_not_0 (modrm_not[0], modrm[0]), 
    modrm_not_1 (modrm_not[1], modrm[1]), 
    modrm_not_2 (modrm_not[2], modrm[2]), 
    modrm_not_3 (modrm_not[3], modrm[3]), 
    modrm_not_4 (modrm_not[4], modrm[4]);

    // modrm != 00101
    wire modrm_00101;
    and5$ modrm_00101_and (modrm_00101, modrm_not[4], modrm_not[3], modrm[2], modrm_not[1], modrm[0]);

    wire modrm_not_00101;
    inv1$ modrm_not_00101_inv (modrm_not_00101, modrm_00101);

    // op1 is 4 (100)
    wire op1_is_4;
    and3$ op1_is_4_and (op1_is_4, op1[2], op1_not[1], op1_not[0]);

    // (OP1 == 4 && MODRM != 00101)
    wire op1_4_and_modrm_not;
    and2$ op1_4_and_modrm_not_and (op1_4_and_modrm_not, modrm_not_00101, op1_is_4);

    // op1 is 1 (001)
    wire op1_is_1;
    and3$ op1_is_1_and (op1_is_1, op1_not[2], op1_not[1], op1[0]);

    // op1 is 4 (110)
    wire op1_is_6;
    and3$ op1_is_6_and (op1_is_6, op1[2], op1[1], op1_not[0]);

    // SOP
    or4$ or0 (out, op1_4_and_modrm_not, op1_is_1, op1_is_4, op1_is_6);

endmodule

// Valid when there is a mod rm and that mod rm needs sib and the sib has an index
// OUT = (OP1 == 4 && MOD != 11 && RM == 100 && INDEX != 100)
module register_stall_r1_is_valid (
    out,

    op1,

    mod_rm,
    sib
);
    output out;

    input [2:0] op1;

    input [7:0] mod_rm;
    input [7:0] sib;

    wire [1:0] mod = mod_rm[7:6];
    wire [2:0] rm = mod_rm[2:0];

    wire [2:0] sib_index = sib[5:3];

    // wire [1:0] mod_not;
    // inv1$ 
    // inv0 (mod_not[1], mod[1]), 
    // inv1 (mod_not[0], mod[0]);

    wire [2:0] rm_not;
    inv1$
    inv2 (rm_not[0], rm[0]),
    inv3 (rm_not[1], rm[1]),
    inv4 (rm_not[2], rm[2]);

    wire [2:0] op1_not;
    inv1$ 
    inv_op1_0 (op1_not[0], op1[0]),
    inv_op1_1 (op1_not[1], op1[1]),
    inv_op1_2 (op1_not[2], op1[2]);

    wire mod_not_11;
    nand2$ nand0 (mod_not_11, mod[1], mod[0]);

    wire rm_100;
    and3$ 
    and3 (rm_100, rm[2], rm_not[1], rm_not[0]);

    wire op1_100;
    and3$ 
    and5 (op1_100, op1[2], op1_not[1], op1_not[0]);

    wire [2:0] sib_index_not;
    inv1$ 
    inv5 (sib_index_not[0], sib_index[0]), 
    inv6 (sib_index_not[1], sib_index[1]), 
    inv7 (sib_index_not[2], sib_index[2]);

    wire sib_index_not_100;
    nand3$ nand1 (sib_index_not_100, sib_index[2], sib_index_not[1], sib_index_not[0]);

    and4$ 
    and6 (out, op1_100, mod_not_11, rm_100, sib_index_not_100);

endmodule

// determines what registers are being accessed by mod rm
module register_stall_mod_rm_registers (
    r0,
    r1,

    mod_rm,
    sib,
    reg_size
);

    output [2:0] r0;
    output [2:0] r1;

    input [7:0] mod_rm;
    input [7:0] sib;
    input [1:0] reg_size;

    // r0 will either be the rm value, or the sib index (or none at all but the valid bit checks for that)
    // if mod is 11 then rm needs to be set for proper size
    wire [2:0] rm_unsized = mod_rm[2:0];
    wire [2:0] sib_index = sib[5:3];
    wire [2:0] sib_base = sib[2:0];

    wire [2:0] rm;
    wire [2:0] rm_sized;
    register_writeback_select register_writeback_select0 (rm_sized, rm_unsized, reg_size);
    // if mod is 11, use the sized one
    mux #(.WIDTH(3), .INPUTS(4)) rm_mux (
        {rm_sized, rm_unsized, rm_unsized, rm_unsized},
        rm,
        mod_rm[7:6]
    );


    wire is_rm;

    register_stall_is_r0_rm logic0 (
        is_rm,
        mod_rm[7:6],
        rm
    );

    mux #(.WIDTH(3), .INPUTS(2)) r0_mux (
        {rm, sib_base},
        r0,
        is_rm
    );
    

    // r1 is sib index
    assign r1 = sib_index;

endmodule

module register_stall_is_r0_rm (
    is_rm,
    mod,
    rm

);
    output is_rm;

    input [1:0] mod;
    input [2:0] rm;

    // is_rm = (mod1&mod0) | (!rm2) | (rm1) | (rm0)

    // mod1 & mod0
    wire mod1_and_mod0;
    and2$ and0 (mod1_and_mod0, mod[1], mod[0]);

    // not rm2
    wire not_rm2;
    inv1$ inv0 (not_rm2, rm[2]);

    // or
    or4$ or0 (is_rm, mod1_and_mod0, not_rm2, rm[1], rm[0]);

endmodule
