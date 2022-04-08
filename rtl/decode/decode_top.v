
//////////////////////////////////////
//
//  Top Decode Stage Module
//

module decode_top (
   // Clock Interface
   clk,
   reset,
		   
   // Control Interface
   flush,
   handle_int,
   halt,

   // Return Address Stack Interface
   ras_address,
   ras_push,		  
   
   // Fetch Interface  
   f_valid,
   f_ready,
   f_bytes_read,		   
   f_valid_bytes,
   f_instruction,
   f_pc,
   f_branch_taken,

   // Pipestage Interface
   d_valid,
   d_ready,		  
   d_mmr,
   d_rega,
   d_regb,
   d_imm,
   d_disp,
   d_seg_ov,
   d_sib,
   d_op,
   d_opsize,
   d_alu,
   d_repeat,
   d_size_of_txn,
   d_branch_taken	  		  
		  
);
   // Instruction Memory Interface Parameters
   parameter IADDRW = 32;

   // Clock Interface
   input                clk;
   input                reset;

   // Control Interface
   input 	        flush;
   input                handle_int;
   output               halt;

   // Return Address Stack Interface
   output [IADDRW-1:0] 	ras_address;
   output               ras_push;
	   
   // Fetch Interface  
   input                f_valid;
   output               f_ready;
   output [5:0]         f_bytes_read;
   input [5:0]          f_valid_bytes;
   input [255:0]        f_instruction;
   input [IADDRW-1:0]   f_pc;
   input                f_branch_taken;

   // Pipestage Interface
   output               d_valid;
   input                d_ready;
   output               d_mmr;
   output [2:0] 	d_rega;
   output [2:0] 	d_regb;
   output [31:0] 	d_imm;
   output [31:0] 	d_disp;
   output [5:0] 	d_seg_ov; // One Hot {CS, SS, DS, ES, FS, GS}
   output [7:0] 	d_sib;
   output [3:0] 	d_op;
   output               d_opsize;
   output [5:0] 	d_alu;
   output               d_repeat;
   output [3:0]         d_size_of_txn;
   output               d_branch_taken;

   wire 		s0_valid;   
   wire 		s0_ready;   
   wire [63:0] 	        s0_displace_n_imm;   
   wire [15:0] 	        s0_addressing;   
   wire [1:0] 	        s0_addressing_bytes;   
   wire [3:0] 	        s0_displacement_bytes;   
   wire [15:0] 	        s0_opcode;   
   wire [1:0] 	        s0_opcode_bytes;  
   wire [3:0] 	        s0_immediete_bytes;   
   wire [23:0] 	        s0_prefix;   
   wire [1:0] 	        s0_prefix_bytes;   
   wire [IADDRW-1:0] 	s0_pc;   
   wire 		s0_branch_taken;   

   wire 		s0_valid_r;   
   wire 		s0_ready_r;   
   wire [63:0] 	        s0_displace_n_imm_r;   
   wire [15:0] 	        s0_addressing_r;   
   wire [1:0] 	        s0_addressing_bytes_r;   
   wire [3:0] 	        s0_displacement_bytes_r;   
   wire [15:0] 	        s0_opcode_r;   
   wire [1:0] 	        s0_opcode_bytes_r;  
   wire [3:0] 	        s0_immediete_bytes_r;   
   wire [23:0] 	        s0_prefix_r;   
   wire [1:0] 	        s0_prefix_bytes_r;   
   wire [IADDRW-1:0] 	s0_pc_r;   
   wire 		s0_branch_taken_r;

   localparam PIPEWIDTH = IADDRW + 2 +24 +4 + 2 + 16 + 4 + 2 + 16 + 64 +1;
   
   decode_stage_0 #(.IADDRW(IADDRW)) ds0 (
       clk,
       reset,
       flush,
       handle_int,
       halt,
       f_valid,
       f_ready,
       f_bytes_read,
       f_valid_bytes,
       f_instruction,
       f_pc,
       f_branch_taken,
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
       s0_branch_taken					  
   );

   wire [PIPEWIDTH-1:0]		s0_data;
   wire [PIPEWIDTH-1:0]		s0_data_r;

   assign s0_data = {   
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
      s0_branch_taken		     
   };
   
   assign {   
      s0_displace_n_imm_r,   
      s0_addressing_r,  
      s0_addressing_bytes_r,   
      s0_displacement_bytes_r,   
      s0_opcode_r,   
      s0_opcode_bytes_r,  
      s0_immediete_bytes_r,   
      s0_prefix_r,   
      s0_prefix_bytes_r,   
      s0_pc_r,
      s0_branch_taken_r 
   } = s0_data_r;     
   
   pipestage #(.WIDTH(PIPEWIDTH)) ( clk, reset, s0_valid, s0_ready, s0_data, s0_valid_r, s0_ready_r, s0_data_r);
   

   assign halt = 'h0;
   assign ras_address = 'h0;
   assign ras_push = 'h0;
   assign f_ready = 'h0;
   assign f_bytes_read = 'h0;
   assign d_valid = 'h0;
   assign d_mmr = 'h0;
   assign d_rega = 'h0;
   assign d_regb = 'h0;
   assign d_imm = 'h0;
   assign d_disp = 'h0;
   assign d_seg_ov = 'h0;
   assign d_sib = 'h0;
   assign d_op = 'h0;
   assign d_opsize = 'h0;
   assign d_alu = 'h0;
   assign d_repeat = 'h0;
   assign d_size_of_txn = 'h0;
   assign d_branch_taken = 'h0; 

endmodule  
