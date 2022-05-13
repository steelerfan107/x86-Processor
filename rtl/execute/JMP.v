module JMP
   (EIP,
    CS,
    op0,
    opcode,
    opsize,
    ZF_en,
    CF_en,
    eflags_in,
    branch_taken,
    br_misprediction,
    jump_load_address,
    jump_address,
    jump_load_cs,
    jump_cs,
    alu_op);
  input [31:0]EIP;
  input [31:0]CS;
  input [31:0]op0;
  input [15:0]opcode;
  input [2:0]opsize;
  input ZF_en;
  input CF_en;
  input [5:0]eflags_in;
  input branch_taken;
  output br_misprediction;
  output jump_load_address;
  output [31:0]jump_address;
  output jump_load_cs;
  output [31:0]jump_cs;
  input [2:0] alu_op;

  wire jnbe;
  wire zfen_and_cfen;
  wire notzf_or_notcf;
  wire cf_in_not;
  wire jne;
  wire zfen_and_notcfen;
  wire zf_in_not;
  wire CF_en_not;
  wire [31:0]addr_jump_near;
  wire unQualopcodeFF;
  wire opcodeFF;   
  wire opcodeEA;
  wire opcodeEB_E9;
  wire opcode77_75_0F;
  wire opcodeEB;
  wire opcode0F;
  wire opcodeE9;
  wire opcode77_75;
  wire opcode77;
  wire opcode75;
  wire [31:0] jump_address_i_0;
  wire [31:0] jump_address_i_1;

  wire if_jcc;
  wire jump_addrEBE9;
  wire jump_addr_s0;
  wire jump_addr_s1;
  wire [31:0] jump_address_i_n;
  
  wire jump_ld_addr0;
  wire jump_ld_addr1;
  wire jump_ld_addr_s;
  wire jne_or_jnbe;

  inv1$ CF_en_not_i(.in(CF_en), .out(CF_en_not));
  inv1$ zf_in_not_i(.in(eflags_in[3]), .out(zf_in_not));
  inv1$ cf_in_not_i(.in(eflags_in[1]), .out(cf_in_not));

  and2$ zfen_and_cfen_i(.in0(ZF_en), .in1(CF_en), .out(zfen_and_cfen));
  and2$ zfen_and_notcfen_i (.in0(ZF_en), .in1(CF_en_not), .out(zfen_and_notcfen));
  or2$ notzf_or_notcf_i(.in0(zf_in_not), .in1(cf_in_not), .out(notzf_or_notcf));
  ucomp8 comp_opcode_0F(.a(opcode[15:8]), .b(8'h0F), .eq(opcode0F));
  ucomp8 comp_opcode_75(.a(opcode[15:8]), .b(8'h75), .eq(opcode75));
  ucomp8 comp_opcode_77(.a(opcode[15:8]), .b(8'h77), .eq(opcode77));
  ucomp8 comp_opcode_E9(.a(opcode[15:8]), .b(8'hE9), .eq(opcodeE9));
  ucomp8 comp_opcode_EA(.a(opcode[15:8]), .b(8'hEA), .eq(opcodeEA));
  ucomp8 comp_opcode_EB(.a(opcode[15:8]), .b(8'hEB), .eq(opcodeEB));
  ucomp8 comp_opcode_FF(.a(opcode[15:8]), .b(8'hFF), .eq(unQualopcodeFF));
  ucomp8 comp_alu_op_six(.a({5'd0,alu_op}), .b(8'h06),  .eq(aluOpIsSix));

  and2$ (opcodeFF, aluOpIsSix, unQualopcodeFF);
  
  and2$ jne_i(.in0(zfen_and_notcfen), .in1(zf_in_not), .out(jne));
  and2$ jnbe_i(.in0(zfen_and_cfen), .in1(notzf_or_notcf), .out(jnbe));
  or2$ opcodeEB_i(.in0(opcode77), .in1(opcode75), .out(opcode77_75));
  
  or2$ jne_or_jnbe_i(.in0(jne), .in1(jnbe), .out(jne_or_jnbe));
  or2$ opcode77_75_0F_i(.in0(opcode77_75), .in1(opcode0F), .out(opcode77_75_0F));

  mux2$ if_jcc_1(.in0(1'b0), .in1(jne_or_jnbe), .outb(if_jcc), .s0(opcode77_75_0F));
  or2$ opcodeEB_E9_i(.in0(opcodeEB), .in1(opcodeE9), .out(opcodeEB_E9));
  
  mux2$ jump_addrEBE9_i(.in0(if_jcc), .in1(1'b1), .outb(jump_addrEBE9), .s0(opcodeEB_E9));
  CLA32 add_jump_near(.a(EIP), .b(op0), .Cin(1'b0), .s(addr_jump_near));
  
  xor2$ br_misprediction_out(.in0(jne_or_jnbe), .in1(branch_taken), .out(br_misprediction));
  mux2$ jump_addrFF_i(.in0(opcodeEB_E9), .in1(1'b1), .outb(jump_ld_addr0), .s0(opcodeFF));
  mux2$ jump_address_select0(.in0(jump_addrEBE9), .in1(1'b1), .outb(jump_addr_s0), .s0(opcodeFF));
  mux #(.WIDTH(32), .INPUTS(2)) jump_address_i(.in({op0, addr_jump_near}), .out(jump_address_i_n), .select(opcodeFF));

  mux2$ jump_load_address_i(.in0(1'b0), .in1(jne_or_jnbe), .outb(jump_ld_addr_s), .s0(opcode77_75_0F));
  mux2$ jump_addrEA_i(.in0(jump_ld_addr0), .in1(1'b1), .outb(jump_ld_addr1), .s0(opcodeEA));
  mux #(.WIDTH(32), .INPUTS(2)) mux_jump_address_i_0(.in({op0, jump_address_i_n}), .out(jump_address_i_0), .select(opcodeEA));
  mux2$ jump_address_select1(.in0(jump_addr_s0), .in1(1'b1), .outb(jump_addr_s1), .s0(opcodeEA));

  mux2$ jump_load_cs_i(.in0(1'b0), .in1(1'b1), .outb(jump_load_cs), .s0(opcodeEA));
  mux #(.WIDTH(32), .INPUTS(2)) jump_cs_i(.in({CS, 32'h00000000}), .out(jump_cs), .select(opcodeEA));
  mux #(.WIDTH(32), .INPUTS(2)) jump_address_out(.in({jump_address_i_0, 32'h0000000}), .out(jump_address_i_1), .select(jump_addr_s1));
  mux2$ jump_load_address_out(.in0(jump_ld_addr1), .in1(jne_or_jnbe), .outb(jump_load_address), .s0(jump_ld_addr_s));
  
  mux #(.WIDTH(32), .INPUTS(4)) mask_jump_addr(.in({jump_address_i_1, {16'h00, jump_address_i_1[15:0]}, {24'b0,jump_address_i_1[7:0]},32'b0}), .out(jump_address), .select(opsize)); 
endmodule
