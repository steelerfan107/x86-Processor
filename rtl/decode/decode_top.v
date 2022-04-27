
//////////////////////////////////////
//
//  Top Decode Stage Module
//

module decode_top (
   // Clock Interface
   clk,
   reset,
		   
   // Control Interface
   flush_0,
   flush_1,		   
   handle_int,
   handle_int_done,		   
   halt,

   // EIP Modification Interface		       
   write_eip,
   eip,

   // EFLAGS Interface  
   eflags_reg,		   

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
   d_size,
   d_set_d_flag,
   d_clear_d_flag,
   d_op0,
   d_op1,
   d_op0_reg,
   d_op1_reg,
   d_modrm,
   d_sib,
   d_imm,
   d_disp,
   d_alu_op,
   d_flag_0,
   d_flag_1,
   d_stack_op,
   d_seg_override,
   d_seg_override_valid,
   d_pc,
   d_branch_taken	  		  
		  
);
   // Instruction Memory Interface Parameters
   parameter IADDRW = 32;

   // Clock Interface
   input                clk;
   input                reset;

   // Control Interface
   input 	        flush_0;
   input 	        flush_1;   
   input                handle_int;
   output               handle_int_done;   
   output               halt;

   // EIP Modification Interface		       
   input                write_eip;
   input [31:0]         eip;

   // EFLAGS Interface  
   input [31:0] 	eflags_reg;   

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
   output 		d_valid;   
   input 		d_ready;	       
   output [2:0]		d_size;   
   output 		d_set_d_flag;  
   output 		d_clear_d_flag;   
   output [2:0]         d_op0;   
   output [2:0]         d_op1;   
   output [2:0]         d_op0_reg;   
   output [2:0]         d_op1_reg;   
   output [7:0]	        d_modrm;  
   output [7:0]         d_sib;   
   output [47:0]        d_imm;   
   output [31:0]        d_disp;   
   output [3:0]		d_alu_op;   
   output [2:0]         d_flag_0;   
   output [2:0]         d_flag_1;   
   output [1:0]         d_stack_op;   
   output [2:0]		d_seg_override;   
   output 		d_seg_override_valid;
   output [IADDRW-1:0]  d_pc;
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
   wire [2:0] 		s0_rom_control;
   wire                 s0_rom_in_control;
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
   wire [2:0] 		s0_rom_control_r;
   wire                 s0_rom_in_control_r;  
   wire [IADDRW-1:0] 	s0_pc_r;   
   wire 		s0_branch_taken_r;
   wire                 s0_size_override_r;
   
   localparam S0_PIPEWIDTH = IADDRW + 2 +24 +4 + 2 + 16 + 4 + 2 + 16 + 64 + 1 + 1 + 1 + 3;

   // Stage 1 Pipe  
   wire 		s1_valid;   
   wire 		s1_ready;	       
   wire [2:0]		s1_size;   
   wire 		s1_set_d_flag;  
   wire 		s1_clear_d_flag;   
   wire [2:0]           s1_op0;   
   wire [2:0]           s1_op1;   
   wire [2:0]           s1_op0_reg;   
   wire [2:0]           s1_op1_reg;   
   wire [7:0]	        s1_modrm;  
   wire [7:0]           s1_sib;   
   wire [47:0]          s1_imm;   
   wire [31:0]          s1_disp;   
   wire [3:0]		s1_alu_op;   
   wire [2:0]           s1_flag_0;   
   wire [2:0]           s1_flag_1;   
   wire [1:0]           s1_stack_op;   
   wire [2:0]		s1_seg_override;   
   wire 	        s1_seg_override_valid;
   wire [IADDRW-1:0]    s1_pc;
   wire                 s1_branch_taken;

   wire 		nc0;
   
   localparam S1_PIPEWIDTH = IADDRW + 1 + 1 + 3 + 2 + 3 + 3 + 4 + 32 + 48 + 8 + 8 +3 + 3 + 3 + 3 + 1 + 1 + 3;   

   // Stage 0 and Pipe
   
   decode_stage_0 #(.IADDRW(IADDRW)) ds0 (
       clk,
       reset,
       flush_0,
       nc0,	    
       halt,
       f_valid,
       f_ready,
       f_bytes_read,
       f_valid_bytes,
       f_instruction[255:128],
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
       s0_rom_control,
       s0_rom_in_control,					  
       s0_pc,
       s0_branch_taken,
       s0_size_override					  
   );

   wire [S0_PIPEWIDTH-1:0]		s0_data;
   wire [S0_PIPEWIDTH-1:0]		s0_data_r;

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
      s0_rom_control,
      s0_rom_in_control,   
      s0_pc,
      s0_branch_taken,
      s0_size_override	     
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
      s0_rom_control_r,
      s0_rom_in_control_r,   
      s0_pc_r,
      s0_branch_taken_r,
      s0_size_override_r
   } = s0_data_r;     
   
   pipestage #(.WIDTH(S0_PIPEWIDTH)) stage0 ( clk, (reset | flush_0), s0_valid, s0_ready, s0_data, s0_valid_r, s0_ready_r, s0_data_r);
   
   // Stage 0 and Pipe
   
   decode_stage_1 #(.IADDRW(IADDRW)) ds1 (
       clk,
       reset,
       flush_1,
       handle_int,
       handle_int_done,					  
       halt,		       
       write_eip,
       eip,
       eflags_reg,					  
       s0_valid_r,
       s0_ready_r,
       s0_displace_n_imm_r,
       s0_addressing_r,
       s0_addressing_bytes_r,
       s0_displacement_bytes_r,
       s0_opcode_r,
       s0_opcode_bytes_r,
       s0_immediete_bytes_r,
       s0_prefix_r,
       s0_prefix_bytes_r,
       s0_rom_control_r,
       s0_rom_in_control_r, 
       s0_pc_r,
       s0_branch_taken_r,
       s0_size_override_r,
       s1_valid,
       s1_ready,		       
       s1_size,
       s1_set_d_flag,
       s1_clear_d_flag,
       s1_op0,
       s1_op1,
       s1_op0_reg,
       s1_op1_reg,
       s1_modrm,
       s1_sib,
       s1_imm,
       s1_disp,
       s1_alu_op,
       s1_flag_0,
       s1_flag_1,
       s1_stack_op,
       s1_seg_override,
       s1_seg_override_valid,
       s1_pc,
       s1_branch_taken					  
   );

   wire [S1_PIPEWIDTH-1:0]		s1_data;
   wire [S1_PIPEWIDTH-1:0]		s1_data_r;

   assign s1_data = { 
       s1_set_d_flag,
       s1_clear_d_flag,
       s1_size,
       s1_op0,
       s1_op1,
       s1_op0_reg,
       s1_op1_reg,
       s1_modrm,
       s1_sib,
       s1_imm,
       s1_disp,
       s1_alu_op,
       s1_flag_0,
       s1_flag_1,
       s1_stack_op,
       s1_seg_override,
       s1_seg_override_valid,
       s1_pc,
       s1_branch_taken      
   };
   
   assign {  
       d_set_d_flag,
       d_clear_d_flag,
       d_size,
       d_op0,
       d_op1,
       d_op0_reg,
       d_op1_reg,
       d_modrm,
       d_sib,
       d_imm,
       d_disp,
       d_alu_op,
       d_flag_0,
       d_flag_1,
       d_stack_op,
       d_seg_override,
       d_seg_override_valid,
       d_pc,
       d_branch_taken
   } = s1_data_r;     
   
   pipestage #(.WIDTH(S1_PIPEWIDTH)) stage1 ( clk, (reset| flush_1), s1_valid, s1_ready, s1_data, d_valid, d_ready, s1_data_r);

endmodule  
