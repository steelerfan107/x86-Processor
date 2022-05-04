`timescale 1ns / 1ps
module CMPXCHG32(rm32, r32, eax_in, eflags, dest, out, eax_out);
input [31:0] rm32; //register or memory value, dest
input [31:0] r32; //always a register value, src
output [31:0] dest;
output [31:0] out;    
output [5:0] eflags;
input [31:0] eax_in;
input [31:0] eax_out; 

ucomp32 cmp(.a(rm32), .b(src), .eq(eflags[3]));
/*IF accumulator = DEST
    THEN
        ZF ← 1
        DEST ← SRC
    ELSE
        ZF ← 0
        accumulator ← DEST
*/
wire [31:0] src;
mux #(.INPUT(2), .WIDTH(32)) src_mux (.in({r32, rm32}), .out(src), .select(ZF));

wire zf_not;
inv1$ zf_inv(.out(zf_not), .in(eflags[3]));


endmodule
