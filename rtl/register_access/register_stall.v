
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
module modify_table (
    
);
    output [1:0] mux_control;   // 0 = +1 to reg; 2 = -1 to reg
    output write_enable;

    input [2:0] assigned_reg;   // reg number that this block is monitoring
    input [2:0] op0_reg;
    input [2:0] wb_reg;
    input next_stage_ready;

endmodule


// table of regs
module table (

);

endmodule