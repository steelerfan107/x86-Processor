module top_pipeline (
   clk,
   reset,
		     
   interrupt,
		     
   imem_valid,
   imem_ready,
   imem_address,
   imem_wr_en,
   imem_wr_data,
   imem_wr_size,
   imem_dp_valid,
   imem_dp_ready,
   imem_dp_read_data,

   emem_valid,
   emem_ready,
   emem_address,
   emem_wr_en,
   emem_wr_data,
   emem_wr_size,
   emem_dp_valid,
   emem_dp_ready,
   emem_dp_read_data, 

   rmem_valid,
   rmem_ready,
   rmem_address,
   rmem_wr_en,
   rmem_wr_data,
   rmem_wr_size,
   rmem_dp_valid,
   rmem_dp_ready,
   rmem_dp_read_data,

   wmem_valid,
   wmem_ready,
   wmem_address,
   wmem_wr_en,
   wmem_wr_data,
   wmem_wr_size,
   wmem_dp_valid,
   wmem_dp_ready,
   wmem_dp_read_data  		     
);

   // Instruction Memory Interface Parameters
   parameter IDATAW = 128;
   parameter ISIZEW = 8;
   parameter IADDRW = 32;
 
    // Data Memory Interface Parameters
    parameter DDATAW = 64;
    parameter DSIZEW = 4;
    parameter DADDRW = 32;

    // Bus Parameters   
    parameter BUSDATAW = 32;
  
   input                   clk;
   input                   reset;

   input [15:0] 	   interrupt;

   output                  imem_valid;
   input   	           imem_ready;
   output    [IADDRW-1:0]  imem_address;
   output    	           imem_wr_en;
   output    [IDATAW-1:0]  imem_wr_data;
   output    [ISIZEW-1:0]  imem_wr_size;
   input                   imem_dp_valid;
   output                  imem_dp_ready;
   input    [IDATAW-1:0]   imem_dp_read_data;

   output                  emem_valid;
   input   	           emem_ready;
   output    [IADDRW-1:0]  emem_address;
   output    	           emem_wr_en;
   output    [32-1:0]	   emem_wr_data;
   output   [ISIZEW-1:0]   emem_wr_size;
   input                   emem_dp_valid;
   output                  emem_dp_ready;
   input    [32-1:0] 	   emem_dp_read_data;

   output                  rmem_valid;
   input   	           rmem_ready;
   output    [DADDRW-1:0]  rmem_address;
   output    	           rmem_wr_en;
   output   [DDATAW-1:0]   rmem_wr_data;
   output   [DSIZEW-1:0]   rmem_wr_size;
   input                   rmem_dp_valid;
   output                  rmem_dp_ready;
   input    [DDATAW-1:0]   rmem_dp_read_data;

   output                  wmem_valid;
   input   	           wmem_ready;
   output    [DADDRW-1:0]  wmem_address;
   output    	           wmem_wr_en;
   output    [DDATAW-1:0]  wmem_wr_data;
   output    [DSIZEW-1:0]  wmem_wr_size;
   input                   wmem_dp_valid;
   output                  wmem_dp_ready;
   input    [DDATAW-1:0]   wmem_dp_read_data;   

   // Interrupt Interface
   wire                    pending_int;
   wire                    hold_int;
   wire                    handle_int;
   wire                    halt;

   // Address Load Interface
   wire   [IADDRW-1:0]     load_address;
   wire  	           load;
   
   // Flush Interface
   wire	                   fetch_flush;   
   wire   	           decode_1_flush;
   wire   	           decode_0_flush;  
   wire                    reg_flush;
   wire                    addr_gen_flush;  
   wire                    exe_flush;
   wire                    wb_flush;  

   // Code Segment
   wire [15:0] 	           cs_register;

   // Branch Predictor Interface
   wire  [IADDRW-1:0]      bp_pc;
   wire [IADDRW-1:0] 	   bp_target = 'h0;
   wire                    bp_taken = 'h0;
		  
   // Return Address Stack Interface
   wire                    ras_pop;
   wire [IADDRW-1:0] 	   ras_target;
   
   // Return Address Stack Interface
   wire [IADDRW-1:0]       ras_address;
   wire                    ras_push;

   // Fetch Interface  
   wire                    f_valid;
   wire                    f_ready;
   wire [5:0]              f_bytes_read;
   wire [5:0]              f_valid_bytes;
   wire [255:0]            f_instruction;
   wire [IADDRW-1:0]       f_pc;
   wire                    f_branch_taken;

   // Pipestage Interface
   wire  		   d_valid;   
   wire   		   d_ready;	       
   wire [2:0]		   d_size;   
   wire 		   d_set_d_flag;  
   wire 		   d_clear_d_flag;   
   wire [2:0]              d_op0;   
   wire [2:0]              d_op1;   
   wire [2:0]              d_op0_reg;   
   wire [2:0]              d_op1_reg;   
   wire [7:0]	           d_modrm;  
   wire [7:0]              d_sib;   
   wire [47:0]             d_imm;   
   wire [31:0]             d_disp;   
   wire [3:0]		   d_alu_op;   
   wire [2:0]              d_flag_0;   
   wire [2:0]              d_flag_1;   
   wire [1:0]              d_stack_op;   
   wire [2:0]		   d_seg_override;   
   wire 		   d_seg_override_valid;
   wire                    d_movs;
   wire [IADDRW-1:0]       d_pc;
   wire                    d_branch_taken;  
   wire [15:0] 		   d_opcode; 
	
   wire                    handle_int_done;
   wire                    write_eip; // Connect
   wire [31:0]             eip; // Connect
   wire [31:0]	           eflags_reg; // Connect

   wire                    ret_near;
   wire                    ret_far;
   wire                    iretd;
   wire                    iretd_halt;
   wire                    iretd_pop_valid;
   wire                    iretd_pop_data; 
   wire                    reg_load_eflags;  
   wire                    reg_eflags;
   wire                    reg_load_eip;  
   wire                    reg_eip;   	

   wire                    r_valid;
   wire                    r_ready;
   wire   [2:0]            r_size;
   wire                    r_set_d_flag;
   wire                    r_clear_d_flag;
   wire   [2:0]            r_op0;
   wire   [2:0]            r_op1;
   wire   [2:0]            r_op0_reg;
   wire   [2:0]            r_op1_reg;
   wire   [7:0]            r_modrm;
   wire   [7:0]            r_sib;
   wire   [47:0]           r_imm;
   wire   [31:0]           r_disp;
   wire   [3:0]            r_alu_op;
   wire   [2:0]            r_flag_0;
   wire   [2:0]            r_flag_1;
   wire   [1:0]            r_stack_op;
   wire   [31:0] 	   r_stack_address;
   wire   [2:0]            r_seg_override;
   wire                    r_seg_override_valid;
   wire   [31:0]           r_eax;
   wire   [31:0]           r_ecx;
   wire   [31:0]           r_edx;
   wire   [31:0]           r_ebx;
   wire   [31:0]           r_esp;
   wire   [31:0]           r_ebp;
   wire   [31:0]           r_esi;
   wire   [31:0]           r_edi;
   wire   [15:0]           r_cs;
   wire   [15:0]           r_ds;
   wire   [15:0]           r_es;
   wire   [15:0]           r_fs;
   wire   [15:0]           r_gs;
   wire   [15:0]           r_ss;
   wire   [63:0]           r_mm0;
   wire   [63:0]           r_mm1;
   wire   [63:0]           r_mm2;
   wire   [63:0]           r_mm3;
   wire   [63:0]           r_mm4;
   wire   [63:0]           r_mm5;
   wire   [63:0]           r_mm6;
   wire   [63:0]           r_mm7;
   wire   [31:0]           r_pc;
   wire                    r_branch_taken;
   wire   [15:0]           r_opcode;

   wire   [2:0]            wb_reg_number;
   wire                    wb_reg_en;
   wire   [2:0]            wb_reg_size;
   wire   [31:0]           wb_reg_data;
   wire   [2:0]            wb_seg_number;
   wire                    wb_seg_en;
   wire   [15:0]           wb_seg_data;
   wire   [2:0]            wb_mmx_number;
   wire                    wb_mmx_en;
   wire  [63:0]            wb_mmx_data;
   wire [31:0] 	           wb_pc;

   wire                    dec_wb_valid;
   wire [2:0]              dec_wb_reg;
   wire [31:0]             dec_wb_data;  
   wire [2:0]              dec_wb_size; 

   wire                    a_valid;
   wire                    a_ready;
   wire [2:0]              a_size;
   wire                    a_set_d_flag;
   wire                    a_clear_d_flag;
   wire [63:0]             a_op0;
   wire [63:0]             a_op1;
   wire [2:0]              a_op0_reg;
   wire [2:0]              a_op1_reg;
   wire                    a_op0_is_address;
   wire                    a_op1_is_address;
   wire [47:0]             a_imm;
   wire [3:0]              a_alu_op;
   wire [2:0]              a_flag_0;
   wire [2:0]              a_flag_1;
   wire [1:0]              a_stack_op;
   wire [31:0] 		   a_stack_address;
   wire [31:0]             a_pc;
   wire                    a_branch_taken;
   wire                    a_to_sys_controller;
   wire [15:0] 		   a_opcode;

   // Pipestage interface
   wire                    e_valid;
   wire                    e_ready;
   wire   [2:0]            e_size;            // size of operand, following size defined in #decode channel
   wire                    e_set_d_flag;
   wire                    e_clear_d_flag;
   wire   [63:0]           e_op_a;           // value for operand a
   wire   [63:0]           e_op_b;           // value for operand b
   wire   [2:0]            e_op_a_reg;        // register number for operand a
   wire   [31:0]           e_op_a_address;    // address for operand a
   wire                    e_op_a_is_address;       
   wire  [31:0]            e_stack_ptr;      // stack pointer address
   wire   [47:0]           e_imm;            // immediate
   wire   [3:0]            e_alu_op;          // alu operation defined in #decode channel
   wire [1:0] 		   e_stack_op;
   wire  [2:0]             e_flag_0;
   wire   [2:0]            e_flag_1;
   wire   [31:0]           e_pc;
   wire                    e_branch_taken;
   wire                    e_to_sys_controller;
   wire [15:0] 		   e_opcode;
   
   // Writeback Interfacre
   wire                    wb_ready = 1'b1;
   wire  [31:0]            wb_dest_address;
   wire  [31:0]            wb_dest_reg;
   wire  [63:0]            wb_result;
   wire  [1:0]             wb_opsize;
   wire                    wb_mem_or_reg;
   wire                    wb_valid;
   wire                    wb_branch_taken;
   wire                    wb_to_sys_controller;
   wire  [31:0]            wb_pc;
   wire                    wb_jump_load_address;
   wire  [31:0]            wb_jump_address;   
   wire                    wb_jump_load_cs;
   wire  [31:0]            wb_cs_out;
   wire                    wb_br_misprediction;
   wire                    wb_stack;
 
   wire                    reg_load_cs;  
   wire     [15:0]         reg_cs;
   
   wire     [15:0]         r_cs_bypass;
   
   wire 	           busy_ahead_of_decode;  
   wire 	           wb_accept;

   fetch_top uut_fetch (
      clk,
      reset,
      fetch_flush,
      load_address,
      load,
      r_cs_bypass,		  
      imem_valid,
      imem_ready,
      imem_address,
      imem_wr_en,
      imem_wr_data,
      imem_wr_size,
      imem_dp_valid,
      imem_dp_ready,
      imem_dp_read_data,
      bp_pc,
      bp_target,
      bp_taken,
      ras_pop,
      ras_target,
      f_valid,
      f_ready,
      f_bytes_read,		   
      f_valid_bytes,
      f_instruction,
      f_pc,
      f_branch_taken	  		  		  
   );

   decode_top uut_decode (
      clk,
      reset,
      decode_0_flush,
      decode_1_flush,
      pending_int,
      hold_int,			  
      handle_int,
      handle_int_done,
      busy_ahead_of_decode,			  
      halt,
      wb_accept,
      wb_pc,
      r_ecx,
      dec_wb_valid,
      dec_wb_reg,
      dec_wb_data, 
      dec_wb_size,			  
      eflags_reg,				  
      ras_address,
      ras_push,
      ret_near,
      ret_far,
      iretd,
      iretd_halt,		  
      f_valid,
      f_ready,
      f_bytes_read,		   
      f_valid_bytes,
      f_instruction,
      f_pc,
      f_branch_taken,
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
      d_movs,
      d_pc,
      d_branch_taken,
      d_opcode		  		  
   );

   and2$ wb_and ( wb_accept, wb_valid, wb_ready );

   register_access_top uut_register_access (
      clk,
      reset,
      reg_flush,
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
      d_movs,
      d_pc,
      d_branch_taken,
      d_opcode,					    
      r_valid,
      r_ready,
      r_size,
      r_set_d_flag,
      r_clear_d_flag,
      r_op0,
      r_op1,
      r_op0_reg,
      r_op1_reg,
      r_modrm,
      r_sib,
      r_imm,
      r_disp,
      r_alu_op,
      r_flag_0,
      r_flag_1,
      r_stack_op,
      r_stack_address,
      r_seg_override,
      r_seg_override_valid,
      r_eax,
      r_ecx,
      r_edx,
      r_ebx,
      r_esp,
      r_ebp,
      r_esi,
      r_edi,
      r_cs,
      r_ds,
      r_es,
      r_fs,
      r_gs,
      r_ss,
      r_mm0,
      r_mm1,
      r_mm2,
      r_mm3,
      r_mm4,
      r_mm5,
      r_mm6,
      r_mm7,
      r_pc,
      r_branch_taken,
      r_opcode,					    
      wb_reg_number,
      (wb_reg_en & ~wb_stack),
      wb_stack,
      wb_reg_size,
      wb_reg_data,
      wb_seg_number,
      wb_seg_en,
      wb_seg_data,
      wb_mmx_number,
      wb_mmx_en,
      wb_mmx_data
  );

  address_generation_top uut_address_gen(
      clk,
      reset,
      addr_gen_flush,
      r_valid,
      r_ready,
      r_size,
      r_set_d_flag,
      r_clear_d_flag,
      r_op0,
      r_op1,
      r_op0_reg,
      r_op1_reg,
      r_modrm,
      r_sib,
      r_imm,
      r_disp,
      r_alu_op,
      r_flag_0,
      r_flag_1,
      r_stack_op,
      r_stack_address,
      r_seg_override,
      r_seg_override_valid,
      r_eax,
      r_ecx,
      r_edx,
      r_ebx,
      r_esp,
      r_ebp,
      r_esi,
      r_edi,
      r_cs,
      r_ds,
      r_es,
      r_fs,
      r_gs,
      r_ss,
      r_mm0,
      r_mm1,
      r_mm2,
      r_mm3,
      r_mm4,
      r_mm5,
      r_mm6,
      r_mm7,
      r_pc,
      r_branch_taken,
      r_opcode,					 
      a_valid,
      a_ready,
      a_size,
      a_set_d_flag,
      a_clear_d_flag,
      a_op0,
      a_op1,
      a_op0_reg,
      a_op1_reg,
      a_op0_is_address,
      a_op1_is_address,
      a_imm,
      a_alu_op,
      a_flag_0,
      a_flag_1,
      a_stack_op,
      a_stack_address,
      a_pc,
      a_branch_taken,
      a_to_sys_controller,
      a_opcode
  );  

  memory_read_top uut_memory_read (
      // Clock Interface
      clk,
      reset,

      // Control Interface
      addr_gen_flush,

      // Write Back Interface (To Pop Addr Dependency)
      wb_valid,
      wb_ready,
      wb_to_memory, 			

      // Memory Read Interface
      a_valid,
      a_ready,
      a_size,
      a_set_d_flag,
      a_clear_d_flag,
      a_op0,
      a_op1,
      a_op0_reg,
      a_op1_reg,
      a_op0_is_address,
      a_op1_is_address,
      a_imm,
      a_alu_op,
      a_flag_0,
      a_flag_1,
      a_stack_op,
      a_stack_address,
      a_pc,
      a_branch_taken,
      a_to_sys_controller,
      a_opcode,
				   
      // Pipestage interface
      e_valid,
      e_ready,
      e_size,
      e_set_d_flag,
      e_clear_d_flag,
      e_op_a,
      e_op_b,
      e_op_a_reg,
      e_op_a_address,
      e_op_a_is_address,
      e_stack_ptr,
      e_stack_op,
      e_imm,
      e_alu_op,
      e_flag_0,
      e_flag_1,
      e_pc,
      e_branch_taken,
      e_to_sys_controller,
      e_opcode,

      rmem_valid,
      rmem_ready,
      rmem_address,
      rmem_wr_en,
      rmem_wr_data,
      rmem_wr_size,
      rmem_dp_valid,
      rmem_dp_ready,
      rmem_dp_read_data	
  );
   
  execute_top uut_execute(
    clk,
    reset,
    exe_flush,
    e_valid,
    e_ready,
    e_op_a_reg, 
    1'b0,
    e_op_a,
    e_op_b,
    r_eax,
    r_cs,
    e_stack_ptr,
    e_stack_op,
    e_alu_op,
    e_opcode,
    e_size,
    e_flag_0,
    e_flag_1,
    e_set_d_flag,
    e_clear_d_flag,
    1'b0,
    e_branch_taken,
    e_to_sys_controller,
    e_pc,
    wb_ready,
    wb_dest_address,
    wb_dest_reg,
    wb_result,
    wb_opsize,
    wb_mem_or_reg,
    wb_stack,
    wb_valid,
    wb_branch_taken,
    wb_to_sys_controller,
    wb_pc,
    wb_jump_load_address,
    wb_jump_address,
    wb_jump_load_cs,
    wb_cs_out,
    wb_br_misprediction		       
  );

  sys_cont_top uut_sys_cont (
     clk,
     reset,
     interrupt[3:0],
     r_cs,		     
     emem_valid,
     emem_ready,
     emem_address,
     emem_wr_en,
     emem_wr_data,
     emem_wr_size,
     emem_dp_valid,
     emem_dp_ready,
     emem_dp_read_data,
     fetch_flush,
     decode_0_flush,
     decode_1_flush,
     reg_flush,
     addr_gen_flush,
     exe_flush,
     wb_flush,
     load,
     load_address,
     handle_int,
     handle_int_done,
     reg_load_cs,
     reg_cs,
     ret_near,
     ret_far,			     
     iretd,
     iretd_halt,
     (wb_to_sys_controller & wb_valid), //iretd_pop_valid,
     wb_result, //iretd_pop_data,
     reg_load_eflags,
     reg_eflags,
     reg_load_eip,
     reg_eip,
     pending_int,
     hold_int,
     wb_jump_load_address,
     wb_jump_address,   
     wb_jump_load_cs[15:0],
     wb_cs_out  
  );   

  assign busy_ahead_of_decode = wb_valid | a_valid | r_valid;
   
  or2$ (wb_reg_en, wb_valid, dec_wb_valid);

  //mux  #(.WIDTH(16),.INPUTS(2)) ( {wb_jump_load_cs[15:0], r_cs}        , r_cs_bypass  , wb_jump_load_cs);
  assign r_cs_bypass = r_cs;
 
  mux  #(.WIDTH(3),.INPUTS(2))  ( {dec_wb_reg, wb_dest_reg[2:0]} , wb_reg_number, dec_wb_valid);
  mux  #(.WIDTH(3),.INPUTS(2))  ( {dec_wb_size, wb_opsize}       , wb_reg_size  , dec_wb_valid);
  mux  #(.WIDTH(32),.INPUTS(2)) ( {dec_wb_data, wb_result[31:0]} , wb_reg_data  , dec_wb_valid);   
   
  assign wb_seg_number = 'h0;
  assign wb_seg_en = 'h0;
  assign wb_seg_data = 'h0;
  assign wb_mmx_number = 'h0;
  assign wb_mmx_en = 'h0;
  assign wb_mmx_data = 'h0;  
     
endmodule   
