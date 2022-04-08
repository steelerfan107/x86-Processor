module opcode_imm_size_detect (
  input [15:0] opcode_aligned,	
  output [15:0] opcode,
  output [1:0] opcode_bytes,
  output [3:0] immediete_bytes,
  input size_prefix,
  output have_modrm		       
);

   wire  opsize;
   wire  modrm;
   wire  imm1;
   wire  imm0;
   wire  f16;
   wire [3:0] imm_size_unmasked;
   wire       non_zero_imm;
   wire [1:0] imm_size_sel;

   mux #(.WIDTH(2),.INPUTS(2)) opcode_size_mux( {2'd2, 2'd1} , opcode_bytes, opsize);
   
   assign have_modrm = modrm;
   assign opcode = opcode_aligned;
   
   mux #(.WIDTH(4),.INPUTS(4)) imm_size_mux( {4'd6, 4'd4, 4'd2, 4'd1}, imm_size_unmasked, imm_size_sel);

   imm_size_sel iss (f16, size_prefix, imm1, imm0, imm_size_sel[1], imm_size_sel[0]);

   or2$ (non_zero_imm, imm1, imm0);

   and2$ imm3a (immediete_bytes[3], imm_size_unmasked[3], non_zero_imm);
   and2$ imm2a (immediete_bytes[2], imm_size_unmasked[2], non_zero_imm);
   and2$ imm1a (immediete_bytes[1], imm_size_unmasked[1], non_zero_imm);
   and2$ imm0a (immediete_bytes[0], imm_size_unmasked[0], non_zero_imm);   
   
   opcode_size_map_cloud osmc (
	opcode_aligned[15],
        opcode_aligned[14],
        opcode_aligned[13],
        opcode_aligned[12],
        opcode_aligned[11],
        opcode_aligned[10],
        opcode_aligned[9],
        opcode_aligned[8],
        opcode_aligned[7],
        opcode_aligned[6],
        opcode_aligned[5],
        opcode_aligned[4],
        opcode_aligned[3],
        opcode_aligned[2],
        opcode_aligned[1],
        opcode_aligned[0],
        opsize,
        modrm,
        imm1,
        imm0,
        f16		       
   );
   
endmodule
