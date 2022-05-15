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
   ret_near,
   ret_far,	
   iretd,
   iretd_halt,
		       
   // EIP Modification Interface		       
   write_eip,
   eip,
   curr_eip,
		       
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
   s1_branch_taken,
   s1_opcode	       
);

   // Instruction Memory Interface Parameters
   parameter IADDRW = 32;
   parameter SINGLE_TXN = 1'b0;

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
   output               ret_near;
   output               ret_far;
   input                iretd_halt;
   output               iretd;

   // Repeat Interface
   input [31:0]         ecx_register;
   output               wb_valid;
   output [2:0]         wb_reg;
   output [31:0]        wb_data;  
   output [2:0]         wb_size;  

   // EIP Modification Interface		       
   input                write_eip;
   input [31:0]         eip;
   output [31:0]        curr_eip;

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
   output [15:0] 	s1_opcode;
   
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
   wire    [15:0]       dec_opcode,rom_opcode;
   
   wire 		rom_in_control;
   wire [3:0] 		rom_control;
   wire [3:0] 		rom_control_nc;
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

   always @ (posedge ret_near or posedge ret_far or posedge iretd) begin
      if (iretd) begin
	 $display("=================== Approx Timing == Seen IRETD");	 
      end
      if (ret_near) begin
	 $display("=================== Approx Timing == Seen RET Near");	 	 
      end
      if (ret_far) begin
	 $display("=================== Approx Timing == Seen Ret Far");	 	 
      end      
   end

   // For Segment Overrides force Size to 32
   wire pCS, pSS, pDS, pES, pFS, pGS, force_size_32;

   compare #(.WIDTH(8))   (8'h0E, s0_opcode[15:8], pCS);
   compare #(.WIDTH(8))   (8'h16, s0_opcode[15:8], pSS);
   compare #(.WIDTH(8))   (8'h1E, s0_opcode[15:8], pDS);
   compare #(.WIDTH(8))   (8'h06, s0_opcode[15:8], pES);
   compare #(.WIDTH(16))  (16'h0FA0, s0_opcode[15:0], pFS );
   compare #(.WIDTH(16))  (16'h0FA8, s0_opcode[15:0], pGS);

   or6$ ( force_size_32, pCS, pSS, pDS, pES, pFS, pGS);
      
   // Force SHift to be 1 for D0,D1
   wire force_1_d0, force_1_d1, force_1;
   
   compare #(.WIDTH(8))  (8'hD0, s0_opcode[15:8], force_1_d0);
   compare #(.WIDTH(8))  (8'hD1, s0_opcode[15:8], force_1_d1);
   or2$ (force_1, force_1_d0, force_1_d1);
   
   and2$ (in_accept, s0_valid, s0_ready);
  
   and3$ ( repeat_and_busy, busy_ahead_of_decode, pre_repeat, not_halt_forward_progress);
   inv1$ ( not_busy, busy_ahead_of_decode);

   wire not_in_accept;
   inv1$ ( not_in_accept, in_accept);
	   
   mux2$ ( halt_forward_progress_in, not_busy, not_in_accept, halt_forward_progress);
   
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

   wire single_txn_mask;
   nand2$ (single_txn_mask, SINGLE_TXN, busy_ahead_of_decode);

   wire not_halt_forward_progress_mask, not_hold_int_repeat;
   inv1$ (not_halt_forward_progress_mask,halt_forward_progress_mask);
   inv1$ (not_hold_int_repeat,hold_int_repeat);
   
   and4$ (s1_valid    , pre_s1_valid, not_halt_forward_progress_mask, not_hold_int_repeat, single_txn_mask);
   and4$ (pre_s1_ready,     s1_ready, not_halt_forward_progress_mask, not_hold_int_repeat, single_txn_mask);   

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

   wire 		not_out_accept_writeecx;
   inv1$ (not_out_accept_writeecx, out_accept_writeecx);
   
   mux #(.INPUTS(2),.WIDTH(1)) ({not_out_accept_writeecx,store_temp_ecx}, valid_temp_ecx_in, valid_temp_ecx);

   register #(.WIDTH(1)) v_temp_ecx (
               clk,
               reset,
               valid_temp_ecx_in,
               valid_temp_ecx,
               not_valid_temp_ecx,
               1'b1		    
   );  
   
   and3$ (hold_int, pending_int, busy_ahead_of_decode, pre_repeat); 
   
   and4$ (out_accept_writeecx, s1_valid, s1_ready, not_halt_forward_progress_mask, pre_repeat);
   
   compare #(.WIDTH(8)) movs_comp (8'hA5, s0_opcode[15:8], s1_movs);
   inv1$ ( not_movs, s1_movs);
   
   compare #(.WIDTH(32)) (ecx_register, 32'd1,  cs_is_one);
   inv1$ (cs_is_non_one, cs_is_one);

   mux2$ (repeat_halt_mask, 1'b1, cs_is_one, pre_repeat);

   mux #(.INPUTS(2),.WIDTH(32)) ({temp_ecx_register,ecx_register}, ecx_register_selected, valid_temp_ecx);
   
   assign wb_valid = out_accept_writeecx;
   assign wb_reg   = 3'b001;
   
   //assign wb_data  = ecx_register_selected - 1;
   subtract #(.WIDTH(32)) (
	ecx_register_selected,
        32'd1,
        wb_data	 
   );
   
   assign wb_size  = 3;
   
   // IRETd Logic
   wire 		iretd_halt_mask;
   inv1$ ( iretd_halt_mask, iretd_halt);

   wire 		ret_near0, ret_near1, ret_far0, ret_far1;
   wire 		ret_near_non_mask;
   wire 		ret_far_non_mask;
   wire 		iretd_non_mask;
   
   compare #(.WIDTH(8)) iretd_comp (8'hCF, s0_opcode[15:8], iretd_non_mask);
   compare #(.WIDTH(8)) ret_n_comp (8'hC3, s0_opcode[15:8], ret_near0);
   compare #(.WIDTH(8)) ret_n0_comp (8'hC2, s0_opcode[15:8], ret_near1);

   compare #(.WIDTH(8)) ret_f_comp (8'hCB, s0_opcode[15:8], ret_far0);
   compare #(.WIDTH(8)) ret_f0_comp (8'hCA, s0_opcode[15:8], ret_far1);
   
   or2$ (ret_near_non_mask,ret_near0, ret_near1);
   or2$ (ret_far_non_mask,ret_far0, ret_far1);

   and3$ (ret_near, ret_near_non_mask, s0_valid, not_busy);
   and3$ (ret_far, ret_far_non_mask, s0_valid, not_busy);
   and2$ (iretd, iretd_non_mask, s0_valid);   

   wire 		rom_in_control_mask;
   and3$ ricm (rom_in_control_mask, not_movs, s0_rom_in_control, s0_valid);
   
   // Int Handle and EIP
   mux #(.INPUTS(2),.WIDTH(4))  int_rc_mux ({4'd6,s0_rom_control}        , rom_control   , handle_int);   
   mux #(.INPUTS(2),.WIDTH(1))  int_ric_mux({1'b1,rom_in_control_mask}   , rom_in_control, handle_int);

   wire [31:0] 		eip_in;
   
   mux #(.INPUTS(2),.WIDTH(32)) eip_mux ({eip, eip} , eip_in , handle_int);      

   assign curr_eip = eip_reg;

   register  #(.WIDTH(32)) state_reg (clk, reset, eip, eip_reg, eip_reg_not, (write_eip & !(handle_int | ret_near | ret_far | iretd)) );   
   
   // Seperate Imm and Disp
   imm_disp_seperate imm_disp_seperate(
	s0_displace_n_imm,
        s0_immediete_bytes,
        s0_displacement_bytes,
       	dec_imm,
        dec_disp,	
        dec_size	    
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
   and3$ dra (dec_ready, repeat_halt_mask, pre_s1_ready, iretd_halt_mask);

   wire 		rom_ready_mask;
   and2$ rrm (rom_ready_mask, rom_ready, pre_s1_ready);
   
   // Output Muxes
   mux #(.INPUTS(2),.WIDTH(1))  ready_mux({rom_ready_mask,dec_ready},s0_ready, rom_in_control);     
   mux #(.INPUTS(2),.WIDTH(1))  valid_mux({rom_valid,dec_valid},pre_s1_valid, rom_in_control);   
   mux #(.INPUTS(4),.WIDTH(3))  size_mux({3'd3,3'd3,rom_size,dec_size},s1_size, {force_size_32, rom_in_control});  
   mux #(.INPUTS(2),.WIDTH(1))  set_d_flag_mux({rom_set_d_flag,dec_set_d_flag},s1_set_d_flag, rom_in_control);  
   mux #(.INPUTS(2),.WIDTH(1))  clear_d_flag_mux({rom_clear_d_flag,dec_clear_d_flag},s1_clear_d_flag, rom_in_control);  
   mux #(.INPUTS(4),.WIDTH(3))  op0_mux({3'd6, 3'd6, rom_op0,dec_op0},s1_op0, {s1_movs, rom_in_control});   
   mux #(.INPUTS(4),.WIDTH(3))  op1_mux({3'd6, 3'd6, rom_op1,dec_op1},s1_op1, {s1_movs, rom_in_control});   
   mux #(.INPUTS(2),.WIDTH(3))  op0_reg_mux({rom_op0_reg,dec_op0_reg},s1_op0_reg, rom_in_control);   
   mux #(.INPUTS(2),.WIDTH(3))  op1_reg_mux({rom_op1_reg,dec_op1_reg},s1_op1_reg, rom_in_control);  
   mux #(.INPUTS(2),.WIDTH(8))  modrm_mux({dec_modrm,dec_modrm},s1_modrm, rom_in_control);   
   mux #(.INPUTS(2),.WIDTH(8))  sib_mux({dec_sib,dec_sib},s1_sib, rom_in_control);   
   mux #(.INPUTS(4),.WIDTH(48)) imm_mux({48'd1,48'd1, rom_imm,dec_imm},s1_imm, {force_1,rom_in_control});   
   mux #(.INPUTS(2),.WIDTH(32)) disp_mux({dec_disp,dec_disp},s1_disp, rom_in_control);   
   mux #(.INPUTS(4),.WIDTH(4))  alu_op_mux({4'd4,4'd4,rom_alu_op,dec_alu_op},s1_alu_op, {s1_movs,rom_in_control});  
   mux #(.INPUTS(2),.WIDTH(3))  flag_0_mux({rom_flag_0,dec_flag_0},s1_flag_0, rom_in_control);   
   mux #(.INPUTS(2),.WIDTH(3))  flag_1_mux({rom_flag_1,dec_flag_1},s1_flag_1, rom_in_control);   
   mux #(.INPUTS(2),.WIDTH(2))  stack_op_mux({rom_stack_op,dec_stack_op},s1_stack_op, rom_in_control);   
   mux #(.INPUTS(2),.WIDTH(3))  seg_override_mux({dec_seg_override,dec_seg_override},s1_seg_override, rom_in_control);   
   mux #(.INPUTS(2),.WIDTH(1))  seg_override_valid_mux({dec_seg_override_valid,dec_seg_override_valid},s1_seg_override_valid, rom_in_control);
   mux #(.INPUTS(2),.WIDTH(16)) opcode_mux({rom_opcode,mask_op},s1_opcode, rom_in_control);   
   
   //mux #(.INPUTS(2),.WIDTH(IADDRW)) pc_mux({rom_pc,dec_pc},s1_pc, rom_in_control);   
   //mux #(.INPUTS(2),.WIDTH(1))      branch_taken_mux({rom_branch_taken,dec_branch_taken},s1_branch_taken, rom_in_control);

   assign s1_pc = (ret_near_non_mask | ret_far_non_mask) ? curr_eip : s0_pc;
   assign s1_branch_taken = s0_branch_taken;
   
   wire nc_ric;  
   wire [31:0] eip_to_use = (handle_int) ? curr_eip : s0_pc;
   
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
      rom_opcode,					   
      rom_in_control,
      rom_control,
      eflags_reg,
      eip_to_use,	
      dec_imm,
      handle_int_done	
   );
 

endmodule   
