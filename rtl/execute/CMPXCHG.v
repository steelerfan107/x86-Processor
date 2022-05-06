`timescale 1ns / 1ps
module CMPXCHG32(rm32, r32, eax_in, dest, eax_out, eflags);
input [31:0] rm32; //register or memory value, dest
input [31:0] r32; //always a register value, src
input [31:0] eax_in;
output [31:0] dest;
output [31:0] eax_out;

output [5:0] eflags;
input [31:0] eax_in;
input [31:0] eax_out; 

wire zf;

comp32 cmp(.a(eax_in), .b(r32), .eq(zf), .bga(eflags[4]), .overflow(eflags[5]), .carry(eflags[1]));
/*IF accumulator = DEST
    THEN
        ZF ← 1
        DEST ← SRC
    ELSE
        ZF ← 0
        accumulator ← DEST
*/

mux #(.INPUT(2), .WIDTH(32)) dest_mux (.in({r32, rm32}), .out(dest), .select(zf));
mux #(.INPUT(2), .WIDTH(32)) eax_mux (.in({rm32, eax_in}), .out(eax_out), .select(zf));
assign eflags[3] = zf;
CLA4 cmpxchg_add(.a(rm32[3:0]), .b(eax_in[3:0]), .Cin(1'b0), .Cout(eflags_out[2]));


endmodule

`timescale 1ns / 1ps
module CMPXCHG16(rm16, r16, ax_in, dest, ax_out, eflags);
input [15:0] rm16; //register or memory value, dest
input [15:0] r16; //always a register value, src
input [15:0] ax_in;
output [15:0] dest;
output [15:0] ax_out;
output [5:0] eflags;

wire zf;

comp16 cmp(.a(ax_in), .b(r16), .eq(zf), .bga(eflags[4]), .overflow(eflags[5]), .carry(eflags[1]));
/*IF accumulator = DEST
    THEN
        ZF ← 1
        DEST ← SRC
    ELSE
        ZF ← 0
        accumulator ← DEST
*/

mux #(.INPUT(2), .WIDTH(16)) dest_mux (.in({r16, rm16}), .out(dest), .select(zf));
mux #(.INPUT(2), .WIDTH(16)) ax_mux (.in({rm16, ax_in}), .out(ax_out), .select(zf));
assign eflags[3] = zf;
CLA4 cmpxchg_add(.a(rm16[3:0]), .b(ax_in[3:0]), .Cin(1'b0), .Cout(eflags_out[2]));

endmodule

`timescale 1ns / 1ps
module CMPXCHG8(rm8, r8, al_in, dest, al_out, eflags);
input [7:0] rm8; //register or memory value, dest
input [7:0] r8; //always a register value, src
input [7:0] al_in;
output [7:0] dest;
output [7:0] al_out;
output [5:0] eflags;

wire zf;

comp8 cmp(.a(al_in), .b(r8), .eq(zf), .bga(eflags[4]), .overflow(eflags[5]), .carry(eflags[1]));
/*IF accumulator = DEST
    THEN
        ZF ← 1
        DEST ← SRC
    ELSE
        ZF ← 0
        accumulator ← DEST
*/

mux #(.INPUT(2), .WIDTH(8)) dest_mux (.in({r8, rm8}), .out(dest), .select(zf));
mux #(.INPUT(2), .WIDTH(8)) al_mux (.in({rm8, al_in}), .out(al_out), .select(zf));
assign eflags[3] = zf;
CLA4 cmpxchg_add(.a(rm8[3:0]), .b(al_in[3:0]), .Cin(1'b0), .Cout(eflags_out[2]));


endmodule
