`timescale 1ns / 1ps
module ALU(
    a, b, 
    eax, eip, cs, 
    eflags_in, 
    opsize, opcode, alu_op, alu_out, 
    flag_0_map, flag_1_map, set_eflags, eflags_out, 
    branch_taken, br_misprediction, jump_load_address, jump_load_cs, cs_out, jump_address, cmp_xchg
    );
input [63:0] a; //destination operand
input [63:0] b; //source operand
input [31:0] eax;
input [31:0] eip;
input [31:0] cs;
input [5:0] eflags_in;
input [2:0] opsize;
input [15:0] opcode;
input [3:0] alu_op;
input [2:0] flag_0_map;
input [2:0] flag_1_map;
input branch_taken;
output [31:0] jump_address;
output jump_load_address;
output jump_load_cs;
output [31:0] cs_out;
output br_misprediction;
output [63:0] alu_out;
output [5:0] set_eflags; 
output [5:0] eflags_out;
output cmp_xchg;

   assign jump_load_cs = 'h0;
   assign cs_out = 'h0;

/*
PASS-MOV -alu_op 0, op 4
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
wire [63:0] pass_out;
wire [63:0] mov_out;   
wire [63:0] pass_mov_out;
wire [31:0] pass_mov_eax_out;
wire [5:0] pass_mov_set_eflags;
wire [5:0] pass_mov_eflags_out;
wire cf_used;

and2$ cf_required(.out(cf_used), .in0(eflags_in[1]), .in1(flag_0_map[0]));
mux #(.INPUTS(4), .WIDTH(64)) cmov_mux(.in({b,a,b,b}), .out(pass_out), .select({flag_0_map[0],cf_used}));   
   //mux #(.INPUTS(2), .WIDTH(64)) mov_mux(.in({b,a}), .out(pass_out), .select(cf_used));
   

//cmp = flag_0_map[1] & !flag_0_map[0]
wire cmp, not_flag_0_map0;
inv1$ inv_flag_0_map0(.in(flag_0_map[0]), .out(not_flag_0_map0));
and2$ cmp_flag(.in0(flag_0_map[1]), .in1(not_flag_0_map0), .out(cmp));

wire [7:0] cmpxchg8_dest;
wire [7:0] cmpxchg8_al_out;
wire [5:0] cmpxchg8_eflags;
wire [15:0] cmpxchg16_dest;
wire [15:0] cmpxchg16_ax_out;
wire [5:0] cmpxchg16_eflags;
wire [31:0] cmpxchg32_dest;
wire [31:0] cmpxchg32_eax_out;
wire [5:0] cmpxchg32_eflags;
wire [31:0] cmpxchg_dest;
wire [31:0] cmpxchg_eax_out;
wire [5:0] cmpxchg_eflags;
wire [5:0] cmpxchg_set_eflags = 6'b111111;
CMPXCHG8 cmpxchg8(.rm8(a[7:0]), .r8(b[7:0]), .al_in(eax[7:0]), .dest(cmpxchg8_dest), .al_out(cmpxchg8_al_out), .eflags(cmpxchg8_eflags));
CMPXCHG16 cmpxchg16(.rm16(a[15:0]), .r16(b[15:0]), .ax_in(eax[15:0]), .dest(cmpxchg16_dest), .ax_out(cmpxchg16_ax_out), .eflags(cmpxchg16_eflags));
CMPXCHG32 cmpxchg32(.rm32(a[31:0]), .r32(b[31:0]), .eax_in(eax[31:0]), .dest(cmpxchg32_dest), .eax_out(cmpxchg32_eax_out), .eflags(cmpxchg32_eflags));

mux #(.WIDTH(32), .INPUTS(8)) mux_cmpxchg_dest(.in({32'hz,32'hz,32'hz, 32'hz, cmpxchg32_dest, {16'h0000, cmpxchg16_dest}, {24'h000000, cmpxchg8_dest}, 32'hz}), .out(cmpxchg_dest), .select(opsize));
mux #(.WIDTH(32), .INPUTS(8)) mux_cmpxchg_eax_out(.in({32'hz,32'hz,32'hz, 32'hz, cmpxchg32_eax_out, {16'h0000, cmpxchg16_ax_out}, {24'h000000, cmpxchg8_al_out}, 32'hz}), .out(cmpxchg_eax_out), .select(opsize));
mux #(.WIDTH(6), .INPUTS(8)) mux_cmpxchg_eflags(.in({6'hz,6'hz, 6'hz, 6'hz, cmpxchg32_eflags, cmpxchg16_eflags, cmpxchg8_eflags, 32'hz}), .out(cmpxchg_eflags), .select(opsize));

mux #(.WIDTH(64), .INPUTS(2)) mux_mov_pass_out(.in({{cmpxchg_dest, pass_mov_eax_out}, pass_out}), .out(pass_mov_out), .select(cmp));
mux #(.WIDTH(32), .INPUTS(2)) mux_mov_pass_eax_out(.in({cmpxchg_eax_out, eax}), .out(pass_mov_eax_out), .select(cmp));
mux #(.WIDTH(6), .INPUTS(2)) mux_mov_eflags_out(.in({cmpxchg_eflags, 6'bz}), .out(pass_mov_eflags_out), .select(cmp));
mux #(.WIDTH(6), .INPUTS(2)) mux_mov_set_eflags(.in({cmpxchg_set_eflags, 6'b000000}), .out(pass_mov_set_eflags), .select(cmp));
assign  cmp_xchg = cmp;
   
/*ADD -alu_op 1
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
wire [31:0] add8b_out; 
wire [31:0] add16b_out; 
wire [31:0] add32b_out;
wire add8b_overflow, add16b_overflow, add32b_overflow;
wire [31:0] add_out;
wire [5:0] add_set_eflags;
wire [5:0] add_eflags_out;
wire add8b_carry, add16b_carry, add32b_carry;
CLA8 add8b(.a(a[7:0]), .b(b[7:0]), .Cin(1'b0), .s(add8b_out[7:0]), .Cout(add8b_carry), .overflow(add8b_overflow));
CLA16 add16b(.a(a[15:0]), .b(b[15:0]), .Cin(1'b0), .s(add16b_out[15:0]), .Cout(add16b_carry), .overflow(add16b_overflow));
CLA32 add32b(.a(a[31:0]), .b(b[31:0]), .Cin(1'b0), .s(add32b_out), .Cout(add32b_carry), .overflow(add32b_overflow));
//8b, 16b OPs are stored into 8b or 16b memory locations so type of bit-extension doesn't necessarily matter
wire add8b_zf, add16b_zf, add32b_zf;
assign add8b_out [31:8] = 24'h000000;
assign add16b_out [31:16] = 16'h0000;
ucomp8 zf_add8b(.a(add8b_out[7:0]), .b(8'h00), .eq(add8b_zf));
ucomp16 zf_add16b(.a(add16b_out[15:0]), .b(16'h0000), .eq(add16b_zf));
ucomp32 zf_add32b(.a(add32b_out), .b(32'h00000000), .eq(add32b_zf));
assign add_set_eflags = 6'b111111;
mux #(.WIDTH(32), .INPUTS(8)) add_mux(.in({32'h0,32'h0,32'h0, 32'h0, add32b_out, add16b_out, add8b_out, 32'h0}), .out(add_out), .select(opsize));
mux #(.WIDTH(1), .INPUTS(8)) add_of_mux(.in({1'bz, 1'bz,1'bz, 1'bz, add32b_overflow, add16b_overflow, add8b_overflow, 1'bz}), .out(add_eflags_out[5]), .select(opsize));
mux #(.WIDTH(1), .INPUTS(8)) add_sf_mux(.in({1'bz, 1'bz,1'bz, 1'bz, add32b_out[31], add16b_out[15], add8b_out[7], 1'bz}), .out(add_eflags_out[4]), .select(opsize));
mux #(.WIDTH(1), .INPUTS(8)) add_zf_mux(.in({1'bz, 1'bz,1'bz, 1'bz, add32b_zf, add16b_zf, add8b_zf, 1'bz}), .out(add_eflags_out[3]), .select(opsize));
CLA4 af_add(.a(a[3:0]), .b(b[3:0]), .Cin(1'b0), .Cout(add_eflags_out[2]));
mux #(.WIDTH(1), .INPUTS(8)) add_cf_mux(.in({1'bz, 1'bz,1'bz, 1'bz, add32b_carry, add16b_carry, add8b_carry, 1'bz}), .out(add_eflags_out[1]), .select(opsize));

/*AND -alu_op 2
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
wire [31:0] and8b_out; 
wire [31:0] and16b_out; 
wire [31:0] and32b_out;
wire [31:0] and_out;
wire [5:0] and_set_eflags;
wire [5:0] and_eflags_out;
ANDN #(.WIDTH(8)) and8b(.in0(a[7:0]), .in1(b[7:0]), .out(and8b_out[7:0]));
ANDN #(.WIDTH(16)) and16b(.in0(a[15:0]), .in1(b[15:0]), .out(and16b_out[15:0]));
ANDN #(.WIDTH(32)) and32b(.in0(a[31:0]), .in1(b[31:0]), .out(and32b_out));
//8b, 16b OPs are stored into 8b or 16b memory locations so type of bit-extension doesn't necessarily matter
wire and8b_zf, and16b_zf, and32b_zf;
assign and8b_out [31:8] = 24'h000000;
assign and16b_out [31:16] = 16'h0000;
ucomp8 zf_and8b(.a(and8b_out[7:0]), .b(8'h00), .eq(and8b_zf));
ucomp16 zf_and16b(.a(and16b_out[15:0]), .b(16'h0000), .eq(and16b_zf));
ucomp32 zf_and32b(.a(and32b_out), .b(32'h00000000), .eq(and32b_zf));
assign and_set_eflags = 6'b111z11;
mux #(.WIDTH(32), .INPUTS(8)) and_mux(.in({32'hz,32'hz,32'hz, 32'hz, and32b_out, and16b_out, and8b_out, 32'hz}), .out(and_out), .select(opsize));
assign and_eflags_out[5] = 1'b0;
mux #(.WIDTH(1), .INPUTS(8)) and_sf_mux(.in({1'bz, 1'bz,1'bz, 1'bz, and32b_out[31], and16b_out[15], and8b_out[7], 1'bz}), .out(and_eflags_out[4]), .select(opsize));
mux #(.WIDTH(1), .INPUTS(8)) and_zf_mux(.in({1'bz, 1'bz,1'bz, 1'bz, and32b_zf, and16b_zf, and8b_zf, 1'bz}), .out(and_eflags_out[3]), .select(opsize));
assign and_eflags_out[2] = 1'bz;
assign and_eflags_out[1] = 1'b0;

/*BSF -alu_op 3
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
wire [31:0] bsf16b_out; 
wire [31:0] bsf32b_out;
wire [31:0] bsf_out;
wire bsf_v;
wire [5:0] bsf_set_eflags;
wire [5:0] bsf_eflags_out;
BSF16 bsf16(.in(b[15:0]), .out(bsf16b_out), .v(bsf_v));
BSF32 bsf32(.in(b[31:0]), .out(bsf32b_out), .v(bsf_v));
assign bsf_set_eflags = 6'bzz1zzz;
mux #(.WIDTH(32), .INPUTS(8)) bsf_mux(.in({32'hz, 32'hz,32'hz, 32'hz, bsf32b_out, bsf16b_out, 32'hz, 32'hz}), .out(bsf_out), .select(opsize));
ucomp16 zf_bsf16b(.a(b[15:0]), .b(16'h0000), .eq(bsf_eflags_out[3]));
ucomp32 zf_bsf32b(.a(b[31:0]), .b(32'h00000000), .eq(bsf_eflags_out[3]));

/*DAA -alu_op 5
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
wire [7:0] daa_al_out;
wire [5:0] daa_set_eflags;
wire [5:0] daa_eflags_out;
DAA daa(.AL(a[7:0]),.CF(eflags_in[1]), .AF(eflags_in[2]), .AL_out(daa_al_out), .set_eflags(daa_set_eflags), .daa_eflags_out(daa_eflags_out)); 

/*JMP -alu_op 6
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
wire [31:0] jmp_out;
wire [31:0] jmp_cs;
wire zf_en, jmp_load_address, jmp_load_cs;
and2$ and_zfen(.out(zf_en), .in0(flag_0_map[0]), .in1(flag_0_map[1]));
JMP jmp(.EIP(eip), .CS(cs), .op0(a[31:0]), .opcode(opcode), .opsize(opsize), .ZF_en(zf_en), .CF_en(flag_1_map[0]), .eflags_in(eflags_in), .branch_taken(branch_taken), .br_misprediction(br_misprediction), .jump_load_address(jmp_load_address), .jump_address(jump_address), .jump_load_cs(jmp_load_cs), .jump_cs(jmp_cs), .alu_op(alu_op));

/*NOT -alu_op 7
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
wire [31:0] not8b_out; 
wire [31:0] not16b_out; 
wire [31:0] not32b_out;
wire [31:0] not_out;
wire [5:0] not_set_eflags;
NOTN #(.WIDTH(8)) not8b(.in(a[7:0]), .out(not8b_out[7:0]));
NOTN #(.WIDTH(16)) not16b(.in(a[15:0]), .out(not16b_out[15:0]));
NOTN #(.WIDTH(32)) not32b(.in(a[31:0]), .out(not32b_out));
//8b, 16b OPs are stored into 8b or 16b memory locations so type of bit-extension doesn't necessarily matter
assign not8b_out [31:8] = 24'h000000;
assign not16b_out [31:16] = 16'h0000;
assign not_set_eflags = 6'b000000;
mux #(.WIDTH(32), .INPUTS(8)) not_mux(.in({32'hz, 32'hz,32'hz, 32'hz, not32b_out, not16b_out, not8b_out, 32'hz}), .out(not_out), .select(opsize));

/*OP -alu_op 8
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
wire [31:0] or8b_out; 
wire [31:0] or16b_out; 
wire [31:0] or32b_out;
wire [31:0] or_out;
wire [5:0] or_set_eflags;
wire [5:0] or_eflags_out;
ORN #(.WIDTH(8)) or8b(.in0(a[7:0]), .in1(b[7:0]), .out(or8b_out[7:0]));
ORN #(.WIDTH(16)) or16b(.in0(a[15:0]), .in1(b[15:0]), .out(or16b_out[15:0]));
ORN #(.WIDTH(32)) or32b(.in0(a[31:0]), .in1(b[31:0]), .out(or32b_out));
//8b, 16b OPs are stored into 8b or 16b memory locations so type of bit-extension doesn't necessarily matter
wire or8b_zf, or16b_zf, or32b_zf;
assign or8b_out [31:8] = 24'h000000;
assign or16b_out [31:16] = 16'h0000;
assign or_set_eflags = 6'b111z11;
ucomp8 zf_or8b(.a(or8b_out[7:0]), .b(8'h00), .eq(or8b_zf));
ucomp16 zf_or16b(.a(or16b_out[15:0]), .b(16'h0000), .eq(or16b_zf));
ucomp32 zf_or32b(.a(or32b_out), .b(32'h00000000), .eq(or32b_zf));
mux #(.WIDTH(32), .INPUTS(8)) or_mux(.in({32'hz, 32'hz,32'hz, 32'hz, or32b_out, or16b_out, or8b_out, 32'hz}), .out(or_out), .select(opsize));
assign or_eflags_out[5] = 1'b0;
mux #(.WIDTH(1), .INPUTS(8)) or_sf_mux(.in({1'bz, 1'bz,1'bz, 1'bz, or32b_out[31], or16b_out[15], or8b_out[7], 1'bz}), .out(or_eflags_out[4]), .select(opsize));
mux #(.WIDTH(1), .INPUTS(8)) or_zf_mux(.in({1'bz, 1'bz,1'bz, 1'bz, or32b_zf, or16b_zf, or8b_zf, 1'bz}), .out(or_eflags_out[3]), .select(opsize));
assign or_eflags_out[2] = 1'bz;
assign or_eflags_out[1] = 1'b0;

/*paddw block, -alu_op 9
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
wire [63:0] paddw_out;
genvar i;
generate
for(i = 0; i < 64; i = i+16) begin : cla16_adder_block
    CLA16 instance(.a(a[(i+15):i]), .b(b[(i+15):i]), .Cin(1'b0), .s(paddw_out[(i+15):i]));
end
endgenerate

/*paddd block, -alu_op 10
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
wire [63:0] paddd_out;
generate
for(i = 0; i < 64; i = i+32) begin : cla32_adder_block
    CLA32 instance(.a(a[(i+31):i]), .b(b[(i+31):i]), .Cin(1'b0), .s(paddd_out[(i+31):i]));
end
endgenerate

/*pmax/pmin block, -alu_op 11 but from 11 register
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
wire [63:0] pcompare_out;
wire [3:0] agb;
wire [3:0] eq;
wire [3:0] bga;
wire [3:0] s_comp; //compare select
wire compare_op; //pmax = 0, pmin = 1

compare #(.WIDTH(16)) (16'h0FEA, opcode, compare_op);
   
//assign compare_op = alu_op[0];
generate
for(i = 0; i < 4; i = i+1) begin : comp16_block
    comp16 comp(.a(a[((i*16)+15):(i*16)]), .b(b[((i*16)+15):(i*16)]), .agb(agb[i]), .eq(eq[i]), .bga(bga[i]));
    xor2$ mux_select(.out(s_comp[i]), .in0(compare_op), .in1(bga[i]));
    mux #(.INPUTS(2), .WIDTH(16)) comp_mux(.out(pcompare_out[((i*16)+15):(i*16)]), .in({(b[((i*16)+15):(i*16)]), a[((i*16)+15):(i*16)]}),  .select(s_comp[i]));
end
endgenerate

/*SAL alu_op 12
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
wire count_one;
wire shift_zero;
ucomp8 count_equal_one(.a(8'h1f), .b(b[7:0]), .eq(count_one));
ucomp8 shift_equal_zero(.a(8'h00), .b(b[7:0]), .eq(shift_zero));

wire [31:0] sal_out;
wire sal_carry;
wire [5:0] sal_set_eflags;
wire [5:0] sal_eflags_out;
LBSHF sal(.in(a), .s(b[7:0]), .out(sal_out), .c(sal_carry));
wire sal_xor, sal_of;
xor2$ sal_xorg(.out(sal_xor), .in0(a[31]), .in1(sal_carry));
mux2$ sal_of_mux(.outb(sal_of), .in0(1'bz), .in1(sal_xor), .s0(count_one));
mux #(.WIDTH(6), .INPUTS(2)) sal_eflags_mux(.in({6'b000000, {count_one,5'b11z11}}), .out(sal_set_eflags), .select(shift_zero));
mux #(.WIDTH(1), .INPUTS(2)) sal_oflag_mux(.in({sal_of, 1'bz}), .out(sal_eflags_out[5]), .select(count_one));
assign sal_eflags_out[4] = sal_out[31];
ucomp32 sal_zero(.a(sal_out), .b(32'h00000000), .eq(sal_eflags_out[3]));
assign sal_eflags_out[2] = 1'bz;
assign sal_eflags_out[1] = sal_carry;

/*SAR alu_op 13
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
wire [31:0] sar_out;
wire sar_carry;
wire [5:0] sar_set_eflags;
wire [5:0] sar_eflags_out;
RBSHF sar(.in(a), .s(b[7:0]), .out(sar_out), .c(sar_carry));
wire sar_of;
mux2$ sar_of_mux(.outb(sar_of), .in0(1'bz), .in1(1'b0), .s0(count_one));
mux #(.WIDTH(6), .INPUTS(2)) sar_eflags_mux(.in({6'b000000, {count_one,5'b11z11}}), .out(sar_set_eflags), .select(shift_zero));
mux #(.WIDTH(1), .INPUTS(2)) sar_oflag_mux(.in({1'b0, 1'bz}), .out(sar_eflags_out[5]), .select(count_one));
assign sar_eflags_out[4] = sar_out[31];
ucomp32 sar_zero(.a(sar_out), .b(32'h00000000), .eq(sar_eflags_out[3]));
assign sar_eflags_out[2] = 1'bz;
assign sar_eflags_out[1] = sar_carry;

/*XCHG alu_op 14
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
wire [63:0] xchg_out;
XCHG xchg(.dest(a[31:0]), .src(b[31:0]), .out(xchg_out));

//-------------------------------------ALU OUTPUT-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
mux #(.WIDTH(64), .INPUTS(16)) alu_out_mux(.in({64'd0,
                                                xchg_out, 
                                                {32'd0,sar_out}, 
                                                {32'd0,sal_out}, 
                                                pcompare_out, 
                                                paddd_out, 
                                                paddw_out, 
                                                {32'd0,or_out}, 
                                                {32'd0,not_out}, 
                                                {32'd0,jmp_out}, 
                                                {56'd0,daa_al_out}, 
                                                pass_mov_out, 
                                                {32'd0,bsf_out}, 
                                                {32'd0,and_out}, 
                                                {32'd0,add_out}, 
                                                a}),
              .out(alu_out), .select(alu_op));
   
mux #(.WIDTH(6), .INPUTS(16)) set_eflags_mux(.in({6'd0,6'b000000, sar_set_eflags, sal_set_eflags, 6'b000000, 6'b000000, 6'b000000, or_set_eflags, not_set_eflags, 6'b000000, daa_set_eflags, pass_mov_set_eflags, bsf_set_eflags, and_set_eflags, add_set_eflags, pass_mov_set_eflags}), .out(set_eflags), .select(alu_op));
mux #(.WIDTH(1), .INPUTS(16)) mux_jump_load_address_out(.in({9'h00, jmp_load_address, 6'h00}), .out(jump_load_address), .select(alu_op));
mux #(.WIDTH(1), .INPUTS(16)) mux_ump_load_cs_out(.in({9'h00, jmp_load_cs, 6'h00}), .out(jump_load_cs), .select(alu_op));
mux #(.WIDTH(32), .INPUTS(16)) mux_cs_out(.in({32'h00000000,32'h00000000, 32'h00000000, 32'h00000000, 32'h00000000, 32'h00000000, 32'h00000000, 32'h00000000, 32'h00000000, jmp_cs, 32'h00000000, 32'h00000000, 32'h00000000, 32'h00000000, 32'h00000000, 32'h00000000}), .out(jump_load_cs), .select(alu_op));
//set_eflags, eflags_out
mux #(.WIDTH(6), .INPUTS(16)) eflags_out_mux(.in({12'bz, sar_eflags_out, sal_eflags_out, 6'bz, 6'bz, 6'bz, or_eflags_out, 6'bz, 6'bz, daa_eflags_out, pass_mov_eflags_out, bsf_eflags_out, and_eflags_out, add_eflags_out, pass_mov_eflags_out}), .out({eflags_out[5:1],nc}), .select(alu_op));
pfgen alu_pf_out(.in(a[7:0]), .pf(eflags_out[0]));

endmodule
