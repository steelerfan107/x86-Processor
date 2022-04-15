//////////////////////////////////////
//
//  Top Decode Stage Module
//

module decode_stage_0 (
   // Clock Interface
   clk,
   reset,

   // Control Interface
   flush,
   handle_int,
   halt,

   // Fetch Interface
   f_valid,
   f_ready,
   f_bytes_read,
   f_valid_bytes,
   f_instruction,
   f_pc,
   f_branch_taken,

   // Stage 0 Pipe
   s0_valid,
   s0_ready,
   s0_displace_n_imm,
   s0_addressing,
   s0_addressing_bytes,
   s0_displacement_bytes,
   s0_opcode,
   s0_opcode_bytes,
   s0_immediete_bytes,
   s0_prefix,
   s0_prefix_bytes,
   s0_pc,
   s0_branch_taken,
   s0_size_override		       
);

   // Instruction Memory Interface Parameters
   parameter IADDRW = 32;

   // Clock Interface
   input                clk;
   input                reset;

   // Control Interface
   input                flush;
   input                handle_int;
   output               halt;
   
   // Fetch Interface
   input                f_valid;
   output               f_ready;
   output [5:0]         f_bytes_read;
   input [5:0]          f_valid_bytes;
   input [127:0]        f_instruction;
   input [IADDRW-1:0]   f_pc;
   input                f_branch_taken;
   
   // Stage 0 Pipe
   output 		s0_valid;   
   input 		s0_ready;   
   output [63:0] 	s0_displace_n_imm;   
   output [15:0] 	s0_addressing;   
   output [1:0] 	s0_addressing_bytes;   
   output [3:0] 	s0_displacement_bytes;   
   output [15:0] 	s0_opcode;   
   output [1:0] 	s0_opcode_bytes;  
   output [3:0] 	s0_immediete_bytes;   
   output [23:0] 	s0_prefix;   
   output [1:0] 	s0_prefix_bytes;   
   output [IADDRW-1:0] 	s0_pc;   
   output 		s0_branch_taken;
   output               s0_size_override;

   wire [15:0]		opcode_aligned;
   wire [15:0]	        addressing_aligned;

   wire [2:0] 		po_bytes;   
   wire [3:0] 		poa_bytes;

   wire [4:0] 		imm_p_disp;

   wire 		vr_gate;
   wire                 have_modrm;
   wire 		size_prefix;   
   wire 		nc0, nc1;

   // Allign Displacement and Immediete
   byte_shifter_16B  disp_n_imm_shift ({16'b0,f_instruction[119:8]}, poa_bytes, s0_displace_n_imm);

   // Addressing Processing
   addressing_disp_size_detect asd (addressing_aligned, s0_addressing, s0_addressing_bytes, s0_displacement_bytes , have_modrm);
   byte_shifter_8B             addressing_shift ({16'b0,f_instruction[55:8]}, po_bytes, addressing_aligned);

   // Opcode Processing
   opcode_imm_size_detect osd              (opcode_aligned[15:0], s0_opcode, s0_opcode_bytes, s0_immediete_bytes, size_prefix, have_modrm);
   byte_shifter_8B        opcode_shifter   ({24'b0,f_instruction[39:0]}, s0_prefix_bytes, opcode_aligned);

   // Prefix Processing
   assign s0_prefix = f_instruction[23:0];
   assign s0_size_override = size_prefix;
   
   prefix_size_detect psd (f_instruction[23:0], s0_prefix_bytes, size_prefix);

   // Adds - Can make these faster by doing one hot adds. or lookahead carry ads. Probable Long Path
   slow_addr  #(.WIDTH(2))            po_addr  (s0_prefix_bytes, s0_opcode_bytes, po_bytes[1:0], po_bytes[2]);
   slow_addr  #(.WIDTH(3))           poa_addr  (po_bytes, {1'b0,s0_addressing_bytes}, poa_bytes[2:0], poa_bytes[3]);
   slow_addr  #(.WIDTH(4))      imm_disp_addr  (s0_displacement_bytes, s0_immediete_bytes, imm_p_disp[3:0], imm_p_disp[4]);
   slow_addr  #(.WIDTH(5))       ins_len_addr  ({1'b0,poa_bytes}, imm_p_disp, f_bytes_read, nc0);
    
   mag_comp8$                  four_b_compare  ({2'b0,f_bytes_read}, {2'b0,f_valid_bytes}, nc1 , vr_gate);
   
   and2$ ready_and (f_ready,vr_gate,s0_ready);
   and2$ valid_and (s0_valid,vr_gate,f_valid);

   assign s0_pc           = f_pc;
   assign s0_branch_taken = f_branch_taken;
   
endmodule
