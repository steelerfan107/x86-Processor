
//////////////////////////////////////
//
//  Segment Register Stall Module
//
//  Holds components for Segment Register Stalling

module segment_register_stall (
    clk,
    reset,

    is_stall,

    write_select,
    write_enable,

    op0,
    op0_reg,

    op1,
    op1_reg,
);

    // first determine if segment register is being used
    wire op0_is_segment, op1_is_segment;
    segment_stall_op_is_segment 
    op0_is_segment_check (op0_is_segment, op0_reg),
    op1_is_segment_check (op1_is_segment, op1_reg);

    // never a case where they're both a segment

    // creae a table of regs to hold the number of pending acesses
    // reg comes from register file

    wire [31:0] es_out;
    wire [31:0] cs_out;
    wire [31:0] ss_out;
    wire [31:0] ds_out;
    wire [31:0] fs_out;
    wire [31:0] gs_out;

    wire [31:0] es_in;
    wire [31:0] cs_in;
    wire [31:0] ss_in;
    wire [31:0] ds_in;
    wire [31:0] fs_in;
    wire [31:0] gs_in;

    wire es_en;
    wire cs_en;
    wire ss_en;
    wire ds_en;
    wire fs_en;
    wire gs_en;


    register_32_reset 
    es_accesses (es_out, es_in, 32'h0, es_en, clk, reset),
    cs_accesses (cs_out, cs_in, 32'h0, cs_en, clk, reset),
    ss_accesses (ss_out, ss_in, 32'h0, ss_en, clk, reset),
    ds_accesses (ds_out, ds_in, 32'h0, ds_en, clk, reset),
    fs_accesses (fs_out, fs_in, 32'h0, fs_en, clk, reset),
    gs_accesses (gs_out, gs_in, 32'h0, gs_en, clk, reset);

    // see if the value of the regs is going to be changed





    


endmodule;

module segment_stall_modify_table (
    reg_in,
    reg_out,

    reg_we,

    reg_number,

    op0_reg,
    op0_is_valid,

    wb_reg
    wb_is_valid

);

    output [31:0] reg_in;

    input [31:0] reg_out;

    output reg_we;

    input [2:0] reg_number;

    input [2:0] op0_reg;
    input op0_is_valid;

    input [2:0] wb_reg;
    input wb_is_valid;

    // increment reg if (op0_reg == reg_number) && op0_is_valid
    // decrement reg if (wb_reg == reg_number) && wb_is_valid
    // stay the same if both are true

    // see if op0_reg == reg_number using xnor
    wire [2:0] op0_xnor_out
    xnor2$ 
    op0_xnor_0 (op0_xnor_out[0], op0_reg[0], reg_number[0]),
    op0_xnor_1 (op0_xnor_out[1], op0_reg[1], reg_number[1]),
    op0_xnor_2 (op0_xnor_out[2], op0_reg[2], reg_number[2]);

    // see if all match
    wire increment;
    and4$ op0_and (increment, op0_xnor_out[0], op0_xnor_out[1], op0_xnor_out[2], op0_is_valid);

    // see if wb_reg == reg_number
    wire [2:0] wb_xnor_out
    xnor2$ 
    wb_xnor_0 (wb_xnor_out[0], wb_reg[0], reg_number[0]),
    wb_xnor_1 (wb_xnor_out[1], wb_reg[1], reg_number[1]),
    wb_xnor_2 (wb_xnor_out[2], wb_reg[2], reg_number[2]);

    // see if all match
    wire decrement;
    and4$ wb_and (increment, wb_xnor_out[0], wb_xnor_out[1], wb_xnor_out[2], wb_is_valid);

    // add to reg out
    wire [31:0] reg_out_add;
    slow_addr #(.WIDTH(32)) add_1 (reg_out, 32'h1, reg_out_add, );

    // sub to reg out
    wire [31:0] reg_out_sub;
    slow_addr #(.WIDTH(32)) sub_1 (reg_out, 32'hFFFFFFFF, reg_out_sub, );

    // mux selecting which to use
    ao_mux #(.WIDTH(32), .NINPUTS(2)) reg_in_mux (
        {reg_out_sub, reg_out_add},
        reg_in,
        {decrement, increment}
    );

    // set write enable only if we are adding or subtracting
    xor2$ we_xor (reg_we, increment, decrement);


// determines if segment is being accessed this instruction
module segment_stall_op_is_segment (
    is_segment,
    op
);
    output is_segment;
    input [2:0] op;

    // is segment is 1 if op is 2 (010)
    // is_segment = ~op[2] & op[1] & ~op[0]

    wire [2:0] op_not;
    inv1$ 
    op_not_0 (op_not[0], op[0]),
    // skip op[1] 
    op_not_2 (op_not[2], op[2]); 

    and3$ out_and (is_segment, op_not[2], op[1], op_not[0]);

endmodule;