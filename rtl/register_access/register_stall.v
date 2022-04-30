
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

);
    output is_stall;    // 1 if the stage should stall

    input [2:0] op0;
    input [2:0] op0_type;   // if its none, a reg, segment, etc...

    input [2:0] op1;
    input [2:0] op1_type;

    input [7:0] mod_rm;

    input [7:0] sib;
    input sib_valid;

    input [32:0] wb_data;
    input [2:0] wb_reg;
    input wb_enable;

    // only add if op0 is register

    // only stall if any of op1's operands access a register
        // can be a direct register access, or modrm, or a sib byte

    // table component should have multiple register ports to see if any of the possible register accesses will be in it

endmodule


// decides if a register in reg table should be modified
// +1 if op0 matches the register that the block modifies and the next segment is ready for new data
// -1 if writeback matches the register that the block modifies
module register_stall_modify_table (
    
);
    output [1:0] mux_control;   // 0 = +1 to reg; 2 = -1 to reg
    output write_enable;

    input [2:0] assigned_reg;   // reg number that this block is monitoring
    input [2:0] op0_reg;
    input [2:0] wb_reg;
    input next_stage_ready;

endmodule


// table of regs
module register_stall_table (

);

endmodule

// determines what registers are being accessed by the current instruction
// up to two registers will be accessed
    // 0 registers if there's no op1
    // 1 register is op1 is a register only, or modrm with no SIB
    // 2 registers if op1 is modrm with SIB (MOD ==  00 | 01 | 10 and R/M == 100)
module register_stall_access_calculator (


);
    output [2:0] r0;
    output r0_is_valid;
    
    output [2:0] r1;
    output r1_is_valid;

    input [2:0] op1;
    input [2:0] op1_reg;

    input [7:0] mod_rm;
    input [7:0] sib;

    // OP1 Types:
    //
    // "none"        : "0",
    // "register"    : "1",
    // "segment"     : "2",
    // "mm register" : "3",
    // "mod r/m"     : "4",
    // "immediete"   : "5",
    // "memory"      : "6"


    // r0_is_valid if 1 or 4
    register_stall_r0_is_valid register_stall_r0_is_valid0 (r0_is_valid, op1);

    // r1_is_valid if 4 and there's mod_rm
    register_stall_r1_is_valid register_stall_r1_is_valid0 (r1_is_valid, op1, mod_rm);

    // determine what registers are being accessed
    



endmodule

// r0_is_valid if op1 is 1, and op1 is 4 and mod rm isn't 00 101
// OUT = (OP1 == 1) || (OP1 == 4 && MODRM != 00101)
module register_stall_r0_is_valid (
    out,
    op1
);

    output out;
    input [2:0] op1;

    wire [2:0] op1_not;
    inv1$ 
    op1_not_0 (op1_not[0], op1[0]), 
    op1_not_1 (op1_not[1], op1[1]), 
    op1_not_2 (op1_not[2], op1[2]);

    wire [1:0] and_result;
    and3$ 
    and0 (and_result[0], op1_not[2], op1_not[1], op1[0]),
    and1 (and_result[1], op1[2], op1_not[1], op1_not[0]);

    or2$ or0 (out, and_result[0], and_result[1]);

endmodule

module register_stall_r1_is_valid (

);
    output out;

    input [2:0] op1;

    input [7:0] mod_rm;

    // (OP1 == 4) && ((MOD == 00 || MOD == 01 || MOD == 10) && R/M == 100)

    wire [1:0] mod = mod_rm[7:6];
    wire [2:0] rm = mod_rm[2:0];

    wire [1:0] mod_not;
    inv1$ 
    inv0 (mod_not[1], mod[1]), 
    inv1 (mod_not[0], mod[0]);

    wire [2:0] rm_not;
    inv1$
    inv2 (rm_not[0], rm[0]),
    inv3 (rm_not[1], rm[1]),
    inv4 (rm_not[2], rm[2]);

    wire mod_00, mod_01, mod_10;
    and2$ 
    and0 (mod_00, mod_not[1], mod_not[0]),
    and1 (mod_01, mod_not[1], mod[0]),
    and2 (mod_10, mod[1], mod_not[0]);

    wire mod_or;
    or3$ (mod_or, mod_00, mod_01, mod_10);

    wire rm_100;
    and3$ 
    and3 (rm_100, rm[2], rm_not[1], rm_not[0]);

    wire mod_rm_or_and;
    and2$ 
    and4 (mod_rm_or_and, mod_or, rm_100);

    wire op1_100;
    and3$ 
    and5 (op1_100, op1[2], op1_not[1], op1_not[0])

    and2$ 
    and5 (out, op1_100, mod_rm_or_and);

endmodule

// determines what registers are being accessed by mod rm
module register_stall_mod_rm_registers (

);

    output [2:0] r0;
    output [2:0] r1;

    input [7:0] mod_rm;
    input [7:0] sib;

    // r0 will either be the rm value, or the sib index
    

    // r1 is sib base

endmodule

module register_stall_is_r0_rm (

);

endmodule