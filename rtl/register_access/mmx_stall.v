
//////////////////////////////////////
//
//  MMX Stall Module
//
//  Holds components for mmx register stalling

module mmx_stall (  // fanout good
    clk,
    reset,

    // size,

    is_stall,

    write_select,
    write_enable,

    size,
    mod_rm,

    op0,
    op0_reg,

    op1,
    op1_reg,

    next_stage_ready
);

    input clk;
    input reset;

    // input [2:0] size;

    output is_stall;

    input [2:0] write_select;
    input write_enable;

    input [2:0] size;
    input [7:0] mod_rm;

    input [2:0] op0;
    input [2:0] op0_reg;

    input [2:0] op1;
    input [2:0] op1_reg;

    input next_stage_ready;

    // first see if op0 and op1 are mmx
    wire is_mmx_size;
    compare (.WIDTH(3)) is_mmx_cmp (size, 3'd5, is_mmx);



    // value can come from either mm register or modr/m
    wire op0_is_mmx_reg;
    wire [2:0] op0_mmx_reg;
    mmx_stall_is_reg op0_mmx_is_reg (
        op0_is_mmx_reg, 
        op0_mmx_reg,

        op0,
        op0_reg,
        mod_rm
    );

    wire op0_is_mmx;
    or2$ is_mmx_or (op0_is_mmx, op0_is_mmx_reg, is_mmx_size);

    wire op1_is_mmx;
    wire [2:0] op1_mmx_reg;
    mmx_stall_is_reg op1_mmx_is_reg (
        op1_is_mmx, 
        op1_mmx_reg,

        op1,
        op1_reg,
        mod_rm
    );

    // instantiate regs for each entry
    wire [31:0] mm0_in;
    wire [31:0] mm1_in;
    wire [31:0] mm2_in;
    wire [31:0] mm3_in;
    wire [31:0] mm4_in;
    wire [31:0] mm5_in;
    wire [31:0] mm6_in;
    wire [31:0] mm7_in;

    wire [31:0] mm0_out;
    wire [31:0] mm1_out;
    wire [31:0] mm2_out;
    wire [31:0] mm3_out;
    wire [31:0] mm4_out;
    wire [31:0] mm5_out;
    wire [31:0] mm6_out;
    wire [31:0] mm7_out;

    wire mm0_en;
    wire mm1_en;
    wire mm2_en;
    wire mm3_en;
    wire mm4_en;
    wire mm5_en;
    wire mm6_en;
    wire mm7_en;

    register #(.WIDTH(32)) mm0_accesses (clk, reset, mm0_in, mm0_out, , mm0_en);
    register #(.WIDTH(32)) mm1_accesses (clk, reset, mm1_in, mm1_out, , mm1_en);
    register #(.WIDTH(32)) mm2_accesses (clk, reset, mm2_in, mm2_out, , mm2_en);
    register #(.WIDTH(32)) mm3_accesses (clk, reset, mm3_in, mm3_out, , mm3_en);
    register #(.WIDTH(32)) mm4_accesses (clk, reset, mm4_in, mm4_out, , mm4_en);
    register #(.WIDTH(32)) mm5_accesses (clk, reset, mm5_in, mm5_out, , mm5_en);
    register #(.WIDTH(32)) mm6_accesses (clk, reset, mm6_in, mm6_out, , mm6_en);
    register #(.WIDTH(32)) mm7_accesses (clk, reset, mm7_in, mm7_out, , mm7_en);

    // buffering
    wire [2:0] op0_mmx_reg_buf;
    bufferH16$ 
    op0_mmx_reg_16_0 (op0_mmx_reg_buf[0], op0_mmx_reg[0]),
    op0_mmx_reg_16_1 (op0_mmx_reg_buf[1], op0_mmx_reg[1]),
    op0_mmx_reg_16_2 (op0_mmx_reg_buf[2], op0_mmx_reg[2]);

    wire op0_is_mmx_buf;
    bufferH16$ op0_is_mmx_16 (op0_is_mmx_buf, op0_is_mmx);

    wire [2:0] write_select_buf;
    bufferH16$ 
    write_select_16_0 (write_select_buf[0], write_select[0]),
    write_select_16_1 (write_select_buf[1], write_select[1]),
    write_select_16_2 (write_select_buf[2], write_select[2]);

    wire write_enable_buf;
    bufferH16$ write_enable_16 (write_enable_buf, write_enable);

    wire next_stage_ready_buf;
    bufferH16$ next_stage_ready_16 (next_stage_ready_buf, next_stage_ready);




    // determine when it be modified
    mmx_stall_modify_table 
    mm0_modify (mm0_in, mm0_out, mm0_en, 3'd0, op0_mmx_reg_buf, op0_is_mmx_buf, write_select_buf, write_enable_buf, next_stage_ready_buf),
    mm1_modify (mm1_in, mm1_out, mm1_en, 3'd1, op0_mmx_reg_buf, op0_is_mmx_buf, write_select_buf, write_enable_buf, next_stage_ready_buf),
    mm2_modify (mm2_in, mm2_out, mm2_en, 3'd2, op0_mmx_reg_buf, op0_is_mmx_buf, write_select_buf, write_enable_buf, next_stage_ready_buf),
    mm3_modify (mm3_in, mm3_out, mm3_en, 3'd3, op0_mmx_reg_buf, op0_is_mmx_buf, write_select_buf, write_enable_buf, next_stage_ready_buf),
    mm4_modify (mm4_in, mm4_out, mm4_en, 3'd4, op0_mmx_reg_buf, op0_is_mmx_buf, write_select_buf, write_enable_buf, next_stage_ready_buf),
    mm5_modify (mm5_in, mm5_out, mm5_en, 3'd5, op0_mmx_reg_buf, op0_is_mmx_buf, write_select_buf, write_enable_buf, next_stage_ready_buf),
    mm6_modify (mm6_in, mm6_out, mm6_en, 3'd6, op0_mmx_reg_buf, op0_is_mmx_buf, write_select_buf, write_enable_buf, next_stage_ready_buf),
    mm7_modify (mm7_in, mm7_out, mm7_en, 3'd7, op0_mmx_reg_buf, op0_is_mmx_buf, write_select_buf, write_enable_buf, next_stage_ready_buf);

    // see if there is a stall
    wire [31:0] op0_table_data;
    mux #(.WIDTH(32), .INPUTS(8)) op0_table_mux (
        {
            mm7_out,
            mm6_out,
            mm5_out,
            mm4_out,
            mm3_out,
            mm2_out,
            mm1_out,
            mm0_out
        },
        op0_table_data,
        op0_mmx_reg
    );

    wire op0_table_zero;
    compare #(.WIDTH(32)) op0_table_cmp (op0_table_data, 32'd0, op0_table_zero);

    wire op0_table_not_empty;
    inv1$ op0_inv (op0_table_not_empty, op0_table_zero);

    wire op0_stall;
    and2$ op0_and (op0_stall, op0_table_not_empty, op0_is_mmx);

    // see if there is a stall
    wire [31:0] op1_table_data;
    mux #(.WIDTH(32), .INPUTS(8)) op1_table_mux (
        {
            mm7_out,
            mm6_out,
            mm5_out,
            mm4_out,
            mm3_out,
            mm2_out,
            mm1_out,
            mm0_out
        },
        op1_table_data,
        op1_mmx_reg
    );

    wire op1_table_zero;
    compare #(.WIDTH(32)) op1_table_cmp (op1_table_data, 32'd0, op1_table_zero);

    wire op1_table_not_empty;
    inv1$ op1_inv (op1_table_not_empty, op1_table_zero);

    wire op1_stall;
    and2$ op1_and (op1_stall, op1_table_not_empty, op1_is_mmx);

    // final stall signal
    or2$ or_stall (is_stall, op0_stall, op1_stall);


endmodule


// add to table if op0 is valid
// subtract from table if wb is valid
// do nothing if both are valid
// copied from segment register stall
module mmx_stall_modify_table (
    reg_in,
    reg_out,

    reg_we,

    reg_number,

    op0_reg,
    op0_is_valid,

    wb_reg,
    wb_is_valid,

    next_stage_ready
);

    output [31:0] reg_in;

    input [31:0] reg_out;

    output reg_we;

    input [2:0] reg_number;

    input [2:0] op0_reg;
    input op0_is_valid;

    input [2:0] wb_reg;
    input wb_is_valid;

    input next_stage_ready;

    // increment reg if (op0_reg == reg_number) && op0_is_valid
    // decrement reg if (wb_reg == reg_number) && wb_is_valid
    // stay the same if both are true

    // see if op0_reg == reg_number using xnor
    wire [2:0] op0_xnor_out;
    xnor2$ 
    op0_xnor_0 (op0_xnor_out[0], op0_reg[0], reg_number[0]),
    op0_xnor_1 (op0_xnor_out[1], op0_reg[1], reg_number[1]),
    op0_xnor_2 (op0_xnor_out[2], op0_reg[2], reg_number[2]);

    // see if all match
    wire increment;
    and4$ op0_and (increment, op0_xnor_out[0], op0_xnor_out[1], op0_xnor_out[2], op0_is_valid);

    // see if wb_reg == reg_number
    wire [2:0] wb_xnor_out;
    xnor2$ 
    wb_xnor_0 (wb_xnor_out[0], wb_reg[0], reg_number[0]),
    wb_xnor_1 (wb_xnor_out[1], wb_reg[1], reg_number[1]),
    wb_xnor_2 (wb_xnor_out[2], wb_reg[2], reg_number[2]);

    // see if all match
    wire decrement;
    and4$ wb_and (decrement, wb_xnor_out[0], wb_xnor_out[1], wb_xnor_out[2], wb_is_valid);

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
    wire add_or_sub;
    xor2$ we_xor (add_or_sub, increment, decrement);

    // only write if next stage is ready
    and2$ next_stage_and (reg_we, add_or_sub, next_stage_ready);

endmodule

module mmx_stall_is_reg (
    is_mmx,
    mmx_reg,

    op,
    op_reg,
    mod_rm
);
    output is_mmx;
    output [2:0] mmx_reg;

    input [2:0] op;
    input [2:0] op_reg;
    input [7:0] mod_rm;

    // what is reg if mod rm is being used
    wire [1:0] mod = mod_rm[7:6];
    wire [2:0] rm = mod_rm[2:0];

    mux #(.WIDTH(3), .INPUTS(8)) op_mux (
        {
            3'h0,   // not used
            3'h0,   // mem
            3'h0,   // imm
            rm,   // mod rm
            op_reg,   // mm reg
            3'h0,   // segment
            3'h0,   // reg
            3'h0    // none
        },
        mmx_reg,
        op
    );

    // is valid?
    // valid = (op == 3) || (op == 4 && mod == 2'b11)
    wire op_is_3;
    compare #(.WIDTH(3)) op_3_cmp (op, 3'd3, op_is_3);

    wire op_is_4;
    compare #(.WIDTH(3)) op_4_cmp (op, 3'd4, op_is_4);

    wire mod_is_3;
    compare #(.WIDTH(2)) mod_3_cmp (mod, 2'b11, mod_is_3);

    wire and_res;
    and2$ and0 (and_res, op_is_4, mod_is_3);

    or2$ or0 (is_mmx, and_res, op_is_3);


endmodule
