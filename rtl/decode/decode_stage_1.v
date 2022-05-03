//////////////////////////////////////
//
//  Top Decode Stage Module
//

module decode_stage_1 (
   // Clock Interface
   clk,
   reset,

   // Control Interface
   flush,
   pending_int,
   hold_int,
   handle_int,
   handle_int_done,
   busy_ahead_of_decode,		        
   halt,
   iretd,
   iretd_halt,
		       
   // EIP Modification Interface		       
   write_eip,
   eip,

   // Repeat Interface
   ecx_register,
   wb_valid,
   wb_reg,
   wb_data, 
   wb_size,		       

   // EFLAGS Interface  
   eflags_reg,

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
   s0_rom_control,
   s0_rom_in_control,
   s0_pc,
   s0_branch_taken,
   s0_size_override,
		       
   // Stage 1 Pipe
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
   s1_movs,
   s1_pc,
   s1_branch_taken	       
);

   // Instruction Memory Interface Parameters
   parameter IADDRW = 32;

   // Clock Interface
   input                clk;
   input                reset;

   // Control Interface
   input                flush;
   input                pending_int;
   output               hold_int;
   input                handle_int;
   output               handle_int_done;  
   input                busy_ahead_of_decode; 
   output               halt;
   output               iretd_halt;
   input                iretd;

   // Repeat Interface
   input [31:0]         ecx_register;
   output               wb_valid;
   output [2:0]         wb_reg;
   output [31:0]        wb_data;  
   output [2:0]         wb_size;  

   // EIP Modification Interface		       
   input                write_eip;
   input [31:0]         eip;

   // EFLAGS Interface  
   input [31:0] 	eflags_reg;
   
   // Stage 0 Pipe
   input               s0_valid;
   output              s0_ready;
   input [63:0]        s0_displace_n_imm;
   input [15:0]        s0_addressing;
   input [1:0]         s0_addressing_bytes;
   input [3:0]         s0_displacement_bytes;
   input[15:0]         s0_opcode;
   input [1:0]         s0_opcode_bytes;
   input [3:0]         s0_immediete_bytes;
   input [23:0]        s0_prefix;
   input[1:0]          s0_prefix_bytes;
   input [3:0] 	       s0_rom_control;   
   input               s0_rom_in_control;   
   input [IADDRW-1:0]  s0_pc;
   input               s0_branch_taken;
   input               s0_size_override;

   // Stage 1 Pipe  
   output 		s1_valid;   
   input 		s1_ready;	       
   output [2:0]		s1_size;   
   output 		s1_set_d_flag;  
   output 		s1_clear_d_flag;   
   output [2:0]         s1_op0;   
   output [2:0]         s1_op1;   
   output [2:0]         s1_op0_reg;   
   output [2:0]         s1_op1_reg;   
   output [7:0]	        s1_modrm;  
   output [7:0]         s1_sib;   
   output [47:0]        s1_imm;   
   output [31:0]        s1_disp;   
   output [3:0]		s1_alu_op;   
   output [2:0]         s1_flag_0;   
   output [2:0]         s1_flag_1;   
   output [1:0]         s1_stack_op;   
   output [2:0]		s1_seg_override;   
   output 		s1_seg_override_valid;
   output               s1_movs;
   output [IADDRW-1:0]  s1_pc;
   output               s1_branch_taken;

   wire 		pre_s1_valid;
   wire 		pre_s1_ready;   

   wire 		dec_valid,rom_valid;   
   wire 		dec_ready,rom_ready;	       
   wire    [2:0]	dec_size,rom_size;   
   wire    		dec_set_d_flag,rom_set_d_flag;  
   wire    		dec_clear_d_flag,rom_clear_d_flag;   
   wire    [2:0]        dec_op0,rom_op0;   
   wire    [2:0]        dec_op1,rom_op1;   
   wire    [2:0]        dec_op0_reg,rom_op0_reg;   
   wire    [2:0]        dec_op1_reg,rom_op1_reg;   
   wire    [7:0]	dec_modrm,rom_modrm;  
   wire    [7:0]        dec_sib,rom_sib;   
   wire    [47:0]       dec_imm,rom_imm;   
   wire    [31:0]       dec_disp,rom_disp;   
   wire    [3:0]        dec_alu_op,rom_alu_op;   
   wire    [2:0]        dec_flag_0,rom_flag_0;   
   wire    [2:0]        dec_flag_1,rom_flag_1;   
   wire    [1:0]        dec_stack_op,rom_stack_op;   
   wire    [2:0]        dec_seg_override,rom_seg_override;   
   wire    		dec_seg_override_valid,rom_seg_override_valid;
   wire    [IADDRW-1:0] dec_pc,rom_pc;
   wire                 dec_branch_taken,rom_branch_taken;
   
   wire 		rom_in_control;
   wire [2:0] 		rom_control;
   wire [2:0] 		rom_control_nc;
   wire [31:0] 		eip_reg_not,eip_reg;

   wire [23:0] 		mask_prefix;
   wire [2:0] 		pre_seg_override;
   wire                 pre_seg_override_valid;
   wire                 pre_repeat;
   wire                 pre_size_override;
   
   wire                 repeat_halt_mask;
   wire                 cs_is_non_one;
   wire                 cs_is_one;
   wire                 not_movs;
   
   wire                 out_accept, out_accept_writeecx;
   wire                 not_busy;

   wire                 halt_forward_progress;
   wire                 not_halt_forward_progress;
   wire                 halt_forward_progress_mask;

   wire [31:0] 		ecx_register_selected;
 
   // Dependency Logic
   wire                 in_repeat_in, in_repeat, not_in_repeat;
   wire                 in_accept;
   wire 		repeat_and_busy;
   wire 		repeat_and_out_accept;

   and2$ (in_accept, s0_valid, s0_ready);
  
   and3$ ( repeat_and_busy, busy_ahead_of_decode, pre_repeat, not_halt_forward_progress);
   inv1$ ( not_busy, busy_ahead_of_decode);
	   
   mux2$ ( halt_forward_progress_in, not_busy, ~in_accept, halt_forward_progress);
   
   register #(.WIDTH(1)) half_forward_reg (
               clk,
               reset,
               halt_forward_progress_in,
               halt_forward_progress,
               not_halt_forward_progress,
               s0_valid				    
   );

   and2$ ( halt_forward_progress_mask, repeat_and_busy, not_halt_forward_progress);

   and2$ ( hold_int_repeat, pending_int, pre_repeat);
   
   and3$ (s1_valid    , pre_s1_valid, ~halt_forward_progress_mask, ~hold_int_repeat);
   and3$ (pre_s1_ready,     s1_ready, ~halt_forward_progress_mask, ~hold_int_repeat);   

   // Repeat Logic
   wire 		store_temp_ecx, valid_temp_ecx_in, valid_temp_ecx, not_valid_temp_ecx;
   wire [31:0] 		temp_ecx_register, not_temp_ecx_register;
   
   and3$ (store_temp_ecx, pending_int, pre_repeat, cs_is_non_one);
   
   register #(.WIDTH(16)) temp_ecx (
               clk,
               reset,
               ecx_register,
               temp_ecx_register,
               not_temp_ecx_register,
               store_temp_ecx		    
   );

   mux #(.INPUTS(2),.WIDTH(1)) ({~out_accept_writeecx,store_temp_ecx}, valid_temp_ecx_in, valid_temp_ecx);

   register #(.WIDTH(1)) v_temp_ecx (
               clk,
               reset,
               valid_temp_ecx_in,
               valid_temp_ecx,
               not_valid_temp_ecx,
               1'b1		    
   );  
   
   and3$ (hold_int, pending_int, busy_ahead_of_decode, pre_repeat); 
   
   and4$ (out_accept_writeecx, s1_valid, s1_ready, ~halt_forward_progress_mask, pre_repeat);
   
   compare #(.WIDTH(8)) movs_comp (8'hA5, s0_opcode[15:8], s1_movs);
   inv1$ ( not_movs, s1_movs);
   
   compare #(.WIDTH(32)) (ecx_register, 32'd1,  cs_is_one);
   inv1$ (cs_is_non_one, cs_is_one);

   mux2$ (repeat_halt_mask, 1'b1, cs_is_one, pre_repeat);

   mux #(.INPUTS(2),.WIDTH(32)) ({temp_ecx_register,ecx_register}, ecx_register_selected, valid_temp_ecx);
   
   assign wb_valid = out_accept_writeecx;
   assign wb_reg   = 3'b001;
   assign wb_data  = ecx_register_selected - 1;  
   assign wb_size  = 3;
   
   // IRETd Logic
   wire 		iretd_halt_mask;
   compare #(.WIDTH(8)) halt_comp (8'hCF, s0_opcode[15:8], iretd);

   wire 		rom_in_control_mask;
   and2$ ricm (rom_in_control_mask, not_movs, s0_rom_in_control);
   
   // Int Handle and EIP
   mux #(.INPUTS(2),.WIDTH(4))  int_rc_mux ({4'd6,s0_rom_control}        , rom_control   , handle_int);   
   mux #(.INPUTS(2),.WIDTH(1))  int_ric_mux({1'b1,rom_in_control_mask}   , rom_in_control, handle_int);

   register  #(.WIDTH(32)) state_reg (clk, reset, eip, eip_reg, eip_reg_not, write_eip);   
   
   // Seperate Imm and Disp
   imm_disp_seperate imm_disp_seperate(
	s0_displace_n_imm,
        s0_immediete_bytes,
        s0_displacement_bytes,	    
       	dec_imm,
        dec_disp	    
   );
   
   assign dec_modrm = s0_addressing[15:8];
   assign dec_sib = s0_addressing[7:0];

   wire [15:0] 		mask_op;
   
   mux #(.INPUTS(2),.WIDTH(16)) op_mask_mux( {s0_opcode, {s0_opcode[15:8], 8'b0} }, mask_op, s0_opcode_bytes[1]);

   // Prefix Decode
   mux #(.INPUTS(4),.WIDTH(24)) prefix_mask_mux( 
           {s0_prefix, {s0_prefix[23:8],8'b0}, {s0_prefix[23:16], 16'b0}, 24'b0}, 
            mask_prefix, 
            s0_prefix_bytes
   );  

   prefix_decode prefix_decode (
       	mask_prefix,
        pre_seg_override,
        pre_seg_override_valid,
        pre_repeat,
        pre_size_override			
   );
   
   assign dec_seg_override = pre_seg_override;
   assign dec_seg_override_valid = pre_seg_override_valid;   

   // Field to Control Signal
   op_and_rm_decode op_and_rm_decode(
      	mask_op,
        dec_modrm,
        s0_size_override,
        rom_control_nc,
        dec_size,  
        dec_set_d_flag,
        dec_clear_d_flag,   
        dec_op0,   
        dec_op1,
        dec_op0_reg,
        dec_op1_reg,  
        dec_modrm, 
        dec_sib,   
        dec_alu_op,  
        dec_flag_0,  
        dec_flag_1,  
        dec_stack_op        			     
   );
 
   assign dec_valid = s0_valid;
   and2$ dra (dec_ready, repeat_halt_mask, pre_s1_ready);

   // Output Muxes
   mux #(.INPUTS(2),.WIDTH(1))  ready_mux({rom_ready,dec_ready},s0_ready, rom_in_control);     
   mux #(.INPUTS(2),.WIDTH(1))  valid_mux({rom_valid,dec_valid},pre_s1_valid, rom_in_control);   
   mux #(.INPUTS(2),.WIDTH(3))  size_mux({rom_size,dec_size},s1_size, rom_in_control);  
   mux #(.INPUTS(2),.WIDTH(1))  set_d_flag_mux({rom_set_d_flag,dec_set_d_flag},s1_set_d_flag, rom_in_control);  
   mux #(.INPUTS(2),.WIDTH(1))  clear_d_flag_mux({rom_clear_d_flag,dec_clear_d_flag},s1_clear_d_flag, rom_in_control);  
   mux #(.INPUTS(2),.WIDTH(3))  op0_mux({rom_op0,dec_op0},s1_op0, rom_in_control);   
   mux #(.INPUTS(2),.WIDTH(3))  op1_mux({rom_op1,dec_op1},s1_op1, rom_in_control);   
   mux #(.INPUTS(2),.WIDTH(3))  op0_reg_mux({rom_op0_reg,dec_op0_reg},s1_op0_reg, rom_in_control);   
   mux #(.INPUTS(2),.WIDTH(3))  op1_reg_mux({rom_op1_reg,dec_op1_reg},s1_op1_reg, rom_in_control);  
   mux #(.INPUTS(2),.WIDTH(8))  modrm_mux({dec_modrm,dec_modrm},s1_modrm, rom_in_control);   
   mux #(.INPUTS(2),.WIDTH(8))  sib_mux({dec_sib,dec_sib},s1_sib, rom_in_control);   
   mux #(.INPUTS(2),.WIDTH(32)) imm_mux({rom_imm,dec_imm},s1_imm, rom_in_control);   
   mux #(.INPUTS(2),.WIDTH(32)) disp_mux({rom_disp,dec_disp},s1_disp, rom_in_control);   
   mux #(.INPUTS(2),.WIDTH(4))  alu_op_mux({rom_alu_op,dec_alu_op},s1_alu_op, rom_in_control);  
   mux #(.INPUTS(2),.WIDTH(3))  flag_0_mux({rom_flag_0,dec_flag_0},s1_flag_0, rom_in_control);   
   mux #(.INPUTS(2),.WIDTH(3))  flag_1_mux({rom_flag_1,dec_flag_1},s1_flag_1, rom_in_control);   
   mux #(.INPUTS(2),.WIDTH(2))  stack_op_mux({rom_stack_op,dec_stack_op},s1_stack_op, rom_in_control);   
   mux #(.INPUTS(2),.WIDTH(3))  seg_override_mux({dec_seg_override,dec_seg_override},s1_seg_override, rom_in_control);   
   mux #(.INPUTS(2),.WIDTH(1))  seg_override_valid_mux({dec_seg_override_valid,dec_seg_override_valid},s1_seg_override_valid, rom_in_control);   
   //mux #(.INPUTS(2),.WIDTH(IADDRW)) pc_mux({rom_pc,dec_pc},s1_pc, rom_in_control);   
   //mux #(.INPUTS(2),.WIDTH(1))      branch_taken_mux({rom_branch_taken,dec_branch_taken},s1_branch_taken, rom_in_control);

   assign s1_pc = s0_pc;
   assign s1_branch_taken = s0_branch_taken;
   
   wire nc_ric;  
   
   // ROM Block
   rom_block #(.IADDRW(IADDRW)) rom_block (
      clk,
      reset,
      s0_ready,
      s0_valid,
      s1_valid,
      s1_ready,
      rom_valid,   
      rom_ready,	       
      rom_size,   
      rom_set_d_flag,  
      rom_clear_d_flag,   
      rom_op0,   
      rom_op1,   
      rom_op0_reg,   
      rom_op1_reg,   
      rom_modrm,  
      rom_sib,   
      rom_imm,   
      rom_disp,   
      rom_alu_op,   
      rom_flag_0,   
      rom_flag_1,   
      rom_stack_op,   
      rom_seg_override,   
      rom_seg_override_valid,
      rom_pc,
      rom_branch_taken,  
      rom_in_control,
      rom_control,
      eflags_reg,
      eip_reg,	
      dec_imm,
      handle_int_done	
   );
 

endmodule   
