// xchg_wb.v
// logic for doing writeback for xchg operation

module xchg_wb (
    wb0_data,
    wb1_data,

    wb0_reg,
    wb0_is_reg,

    wb1_reg,
    wb1_is_reg,

    wb0_address,
    wb0_is_address,

    wb1_address,
    wb1_is_address,


    op0_source,
    op1_source,

);

// this probably doesn't need much logic tbh
// just need to connect up the proper writeback results and do writeback at the right time

endmodule