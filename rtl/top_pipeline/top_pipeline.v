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

    parameter SINGLE_TXN = 1'b0;   
  
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

   wire [31:0] 		   f_set_eip;
   wire                    f_eip;

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
   wire   [2:0]            wb_reg_number_2;
   wire                    wb_reg_qual_2;
   wire   [31:0]           wb_reg_data_2;
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
   wire                    a_op0_is_reg;
   wire                    a_op0_is_segment;
   wire                    a_op0_is_mmx;
   wire                    a_op1_is_reg;
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
   wire                    e_op_a_is_segment;
   wire                    e_op_a_is_reg;
   wire                    e_op_a_is_mmx;                   
   wire   [2:0]            e_op_b_reg;
   wire   [31:0]           e_op_b_address;
   wire                    e_op_b_is_reg;
   wire                    e_op_b_is_address;
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
   wire                    wb_ready;
   wire  [31:0]            wb_dest_address;
   wire  [31:0]            wb_dest_reg;
   wire  [63:0]            wb_result;
   wire  [1:0]             wb_opsize;
   wire                    wb_mem_or_reg;
   wire                    wb_op_a_is_address;
   wire                    wb_op_a_is_reg;
   wire                    wb_op_a_is_segment;
   wire                    wb_op_a_is_mmx;
   wire  [2:0]             wb_op_b_reg;
   wire  [31:0]            wb_op_b_address;
   wire                    wb_op_b_is_reg;
   wire                    wb_op_b_is_address;
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
   wire  [1:0]             wb_stack_op;
   wire  [15:0] 	   	   wb_opcode;
   wire  [3:0]             wb_alu_op;
 
   wire                    reg_load_cs;  
   wire     [15:0]         reg_cs;
   
   wire     [15:0]         r_cs_bypass;
   
   wire 	           busy_ahead_of_decode;  
   wire 	           wb_accept;

   wire                  test_rmem_valid;
   wire   	           test_rmem_ready;
   wire    [DADDRW-1:0]  test_rmem_address;
   wire    	           test_rmem_wr_en;
   wire   [DDATAW-1:0]   test_rmem_wr_data;
   wire   [DSIZEW-1:0]   test_rmem_wr_size;
   wire                   test_rmem_dp_valid;
   wire                  test_rmem_dp_ready;
   wire    [DDATAW-1:0]   test_rmem_dp_read_data;

   wire [31:0] 		  curr_pc;

   wire 		  test_valid_pipe;
   wire                   segment_limit_int;
  

   fetch_top uut_fetch (
      clk,
      reset,
      fetch_flush,
      load_address,
      load,
      r_cs_bypass,
      f_eip,		
      f_set_eip,		  
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

   wire decode_set_eip;
   wire [31:0] decode_eip;

   or2$ (decode_set_eip, wb_accept, f_set_eip);
   ao_mux #(.WIDTH(32), .NINPUTS(2)) ( {f_eip,wb_pc}, decode_eip, {f_eip,wb_accept});
     
   decode_top #(.SINGLE_TXN(SINGLE_TXN)) uut_decode (
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
      curr_pc,
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
   
   wire        wb_reg_qual, wb_seg_qual, wb_mmx_qual, wb_stack_qual;

   and2$ (wb_reg_qual, wb_valid, wb_op_a_is_reg );
   and2$ (wb_seg_qual, wb_valid, wb_op_a_is_segment );
   and2$ (wb_mmx_qual, wb_valid, wb_op_a_is_mmx );
   and3$ (wb_stack_qual, wb_valid, wb_ready, wb_stack );
   // see if it is xchg
   wire is_xchg;
   compare #(.WIDTH(4)) is_xchg_cmp (wb_alu_op, 4'd14, is_xchg);
   and3$ (wb_reg_qual_2, wb_valid, wb_op_b_is_reg, is_xchg);   // valid, is reg, and is xchg

   register_access_top uut_register_access (
      // Clock Interface
      .clk(clk),
      .reset(reset),

      // Control Interface
      .flush(reg_flush),

      // Direct Segment Write
      .write_cs(reg_cs),
      .write_cs_enable(reg_load_cs),
               
      // Decode Interface
      .d_valid(d_valid),
      .d_ready(d_ready),
      .d_size(d_size),
      .d_set_d_flag(d_set_d_flag),
      .d_clear_d_flag(d_clear_d_flag),
      .d_op0(d_op0),
      .d_op1(d_op1),
      .d_op0_reg(d_op0_reg),
      .d_op1_reg(d_op1_reg),
      .d_modrm(d_modrm),
      .d_sib(d_sib),
      .d_imm(d_imm),
      .d_disp(d_disp),
      .d_alu_op(d_alu_op),
      .d_flag_0(d_flag_0),
      .d_flag_1(d_flag_1),
      .d_stack_op(d_stack_op),
      .d_seg_override(d_seg_override),
      .d_seg_override_valid(d_seg_override_valid),
      .d_movs(d_movs),
      .d_pc(d_pc),
      .d_branch_taken(d_branch_taken),
      .d_opcode(d_opcode),

      // Address Generation Inferface
      .r_valid(r_valid),
      .r_ready(r_ready),
      .r_size(r_size),
      .r_set_d_flag(r_set_d_flag),
      .r_clear_d_flag(r_clear_d_flag),
      .r_op0(r_op0),
      .r_op1(r_op1),
      .r_op0_reg(r_op0_reg),
      .r_op1_reg(r_op1_reg),
      .r_modrm(r_modrm),
      .r_sib(r_sib),
      .r_imm(r_imm),
      .r_disp(r_disp),
      .r_alu_op(r_alu_op),
      .r_flag_0(r_flag_0),
      .r_flag_1(r_flag_1),
      .r_stack_op(r_stack_op),
      .r_stack_address(r_stack_address),
      .r_seg_override(r_seg_override),
      .r_seg_override_valid(r_seg_override_valid),
      .r_eax(r_eax),
      .r_ecx(r_ecx),
      .r_edx(r_edx),
      .r_ebx(r_ebx),
      .r_esp(r_esp),
      .r_ebp(r_ebp),
      .r_esi(r_esi),
      .r_edi(r_edi),
      .r_cs(r_cs),
      .r_ds(r_ds),
      .r_es(r_es),
      .r_fs(r_fs),
      .r_gs(r_gs),
      .r_ss(r_ss),
      .r_mm0(r_mm0),
      .r_mm1(r_mm1),
      .r_mm2(r_mm2),
      .r_mm3(r_mm3),
      .r_mm4(r_mm4),
      .r_mm5(r_mm5),
      .r_mm6(r_mm6),
      .r_mm7(r_mm7),
      .r_pc(r_pc),
      .r_branch_taken(r_branch_taken),
      .r_opcode(r_opcode),

      .flag_df(eflags_reg[10]),
               
      .wb_reg_number(wb_reg_number),
      .wb_reg_en(wb_reg_qual),   //(wb_op_a_is_reg & wb_valid),
      .wb_stack(wb_stack),
      .wb_reg_size(wb_opsize),
      .wb_reg_data(wb_reg_data[31:0]),
      
      .wb_reg_number_2(wb_reg_number_2),
      .wb_reg_en_2(wb_reg_qual_2),
      .wb_reg_data_2(wb_reg_data_2),

      .wb_seg_number(wb_reg_number),
      .wb_seg_en(wb_seg_qual),   //(wb_op_a_is_segment & wb_valid),
      .wb_seg_data(wb_reg_data[15:0]),

      .wb_mmx_number(wb_reg_number),
      .wb_mmx_en(wb_mmx_qual),   //(wb_op_a_is_mmx & wb_valid),
      .wb_mmx_data(wb_result),

      // Stack Commit Interface
      .wb_stack_en(wb_stack_qual),  //(wb_valid & wb_valid & wb_stack),
      .wb_stack_size(wb_opsize),
      .wb_stack_op(wb_stack_op)
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
      a_op0_is_reg,
      a_op0_is_segment,
      a_op0_is_mmx,
      a_op1_is_reg,
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
      segment_limit_int
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
      wb_op_a_is_address, 			

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
      a_op0_is_reg,
      a_op0_is_segment,
      a_op0_is_mmx,
      a_op1_is_reg,
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
      e_op_a_is_reg,
      e_op_a_is_segment,
      e_op_a_is_mmx,				   				   
      e_op_b_reg,
      e_op_b_address,
      e_op_b_is_reg,
      e_op_b_is_address,
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
    e_op_a_address,			  
    e_op_a_is_address,
    e_op_a_is_reg,
    e_op_a_is_segment,
    e_op_a_is_mmx,
    e_op_b_reg,
    e_op_b_address,
    e_op_b_is_reg,
    e_op_b_is_address,
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
    wb_opcode,			  
    wb_mem_or_reg,
    wb_op_a_is_address,
    wb_op_a_is_reg,
    wb_op_a_is_segment,
    wb_op_a_is_mmx,
    wb_op_b_reg,
    wb_op_b_address,
    wb_op_b_is_reg,
    wb_op_b_is_address,
    wb_stack_op,			  
    wb_stack,
    wb_valid,
    wb_branch_taken,
    wb_to_sys_controller,
    wb_pc,
    wb_jump_load_address,
    wb_jump_address,
    wb_jump_load_cs,
    wb_cs_out,
    wb_br_misprediction,		       
    wb_alu_op
  );

   // --------- //
   // writeback //
   // --------- //

   assign wb_reg_data_2[31:0] = wb_result[63:32];
   assign wb_reg_number_2 = wb_op_b_reg;

   // decide what address to use
   // if op_b is address and this is exchange, use that as wb address
   // is_xchg defined earlier
   wire wb_address_mux_sel;
   and2$ wb_address_mux_sel_and (wb_address_mux_sel, wb_op_b_is_address, is_xchg);

   // wire [31:0] wb_address_mux_out;
   mux #(.WIDTH(32), .INPUTS(2)) (
      {wb_op_b_address, wb_dest_address},
      wmem_address,
      wb_address_mux_sel
   );

   // see if we should do a write to mem
   wire wb_is_address;
   or2$ (wb_is_address, wb_address_mux_sel, wb_op_a_is_address);

   // determine what data to write
   mux #(.WIDTH(64), .INPUTS(2)) wr_data_mux (
      {{32'h0, wb_result[63:32]}, wb_result},   
      wmem_wr_data,
      wb_address_mux_sel
   );

   mux #(.WIDTH(1), .INPUTS(2)) wb_ready_mux (
      {wmem_ready, 1'b1},
      wb_ready,
      wb_is_address
   );

   
 //wmem_ready;
  // assign  wmem_valid = (wb_valid & wb_op_a_is_address);
   
  and3$ (wmem_valid, wb_valid, wmem_ready, wb_is_address);
   
  // assign  wmem_address = wb_dest_address;
  assign  wmem_wr_en = wb_is_address;
  // assign  wmem_wr_data = wb_result;

  // correct the size
  wmem_size_mapper wmem_size_mapper0 (wmem_wr_size, wb_opsize);
  // assign  wmem_wr_size = wb_opsize;    

  wire        sys_cont_val;
  and2$ (sys_cont_val, wb_to_sys_controller, wb_valid);
      
  sys_cont_top uut_sys_cont (
     clk,
     reset,
     //{3'b0, segment_limit_int, 12'b0},
     {3'b0, 1'b0, 12'b0},			     
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
     sys_cont_val, //iretd_pop_valid,
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


  or4$ ( busy_ahead_of_decode, wb_valid, a_valid, r_valid , e_valid);
   
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

  // Display Debug Items
  wire 		  wb_accept = wb_ready & wb_ready;

  reg 		  wb_accept0;
  reg [31:0] 	  curr_pc0,  wb_pc0;
  reg [15:0] 	  wb_opcode0;
  reg 		  wb_op_a_is_address0,  wb_op_a_is_reg0, wb_op_a_is_segment0, wb_op_a_is_mmx0;
  reg [31:0] 	  r0_eax, r0_ecx, r0_edx, r0_ebx, r0_esp, r0_ebp, r0_esi, r0_edi;
  reg [15:0] 	  r0_cs, r0_ds, r0_es, r0_fs, r0_gs, r0_ss;
  reg [63:0] 	  r0_mm0, r0_mm1, r0_mm2, r0_mm3, r0_mm4, r0_mm5, r0_mm6, r0_mm7;
   reg 		  wb_to_sys_controller0;
   
  always @ (posedge clk) begin
     begin    
	wb_accept0 <= wb_accept;
	curr_pc0 <= curr_pc;
	wb_pc0  <= wb_pc;
	wb_opcode0 <= wb_opcode;
	wb_op_a_is_address0 <= wb_op_a_is_address;
	wb_op_a_is_reg0 <= wb_op_a_is_reg;
	wb_op_a_is_segment0 <= wb_op_a_is_segment;
	wb_op_a_is_mmx0 <= wb_op_a_is_mmx;
	r0_eax <= r_eax;
	r0_ecx <= r_ecx;
	r0_edx <= r_edx;
	r0_ebx <= r_ebx;
	r0_esp <= r_esp; 
	r0_ebp <= r_ebp;
	r0_esi <= r_esi;
	r0_edi <= r_edi;	
	r0_cs <= r_cs;
	r0_ds <= r_ds;
	r0_es <= r_es;
	r0_fs <= r_fs;
	r0_gs <= r_gs;
	r0_ss <= r_ss ;
	r0_mm0 <= r_mm0;
	r0_mm1 <=r_mm1 ;
	r0_mm2 <= r_mm2;
	r0_mm3 <= r_mm3;
	r0_mm4 <= r_mm4;
	r0_mm5 <= r_mm5;
	r0_mm6 <= r_mm6;
	r0_mm7 <= r_mm7;
	wb_to_sys_controller0 <= wb_to_sys_controller;	
     end
  end   
  
  always @ (posedge clk) begin
     if(wb_accept0) begin
	$display("");	
	$display("================ TRANSACTION COMMITED ================ ");
	$display(" Opcode  : 0x%h", wb_opcode0);
	$display(" Previous EIP : 0x%h", curr_pc0);			
	$display(" Next EIP : 0x%h", wb_pc0);	
	$display(" Operation to Memory : %b, Operation to Reg : %b, Operation to Seg : %b, Operation to MMX : %b", 
                 wb_op_a_is_address0, wb_op_a_is_reg0, wb_op_a_is_segment0, wb_op_a_is_mmx0);
	$display(" Going to Sys Controller : %b", wb_to_sys_controller);
	$display(" Next ---------------------------");
	$display(" r_eax : %h, r_ecx : %h, \n r_edx : %h, r_ebx : %h, \n r_esp : %h, r_ebp : %h, \n r_esi : %h, r_edi : %h",
		 r_eax, r_ecx, r_edx, r_ebx, r_esp, r_ebp, r_esi, r_edi);
	$display(" r_cs  : %h, r_ds : %h, \n r_es  : %h, r_fs : %h, \n r_gs  : %h, r_ss : %h",
		 r_cs, r_ds, r_es, r_fs, r_gs, r_ss);
	$display(" r_mm0 : %h, r_mm1 : %h, \n r_mm2 : %h, r_mm3 : %h, \n r_mm4 : %h, r_mm5 : %h, \n r_mm6 : %h, r_mm7 : %h",
                 r_mm0, r_mm1, r_mm2, r_mm3, r_mm4, r_mm5, r_mm6, r_mm7);
	$display(" Previous   ---------------------------");
	$display(" r_eax : %h, r_ecx : %h, \n r_edx : %h, r_ebx : %h, \n r_esp : %h, r_ebp : %h, \n r_esi : %h, r_edi : %h",
		 r0_eax, r0_ecx, r0_edx, r0_ebx, r0_esp, r0_ebp, r0_esi, r0_edi);
	$display(" r_cs  : %h, r_ds : %h, \n r_es  : %h, r_fs : %h, \n r_gs  : %h, r_ss : %h",
		 r0_cs, r0_ds, r0_es, r0_fs, r0_gs, r0_ss);
	$display(" r_mm0 : %h, r_mm1 : %h, \n r_mm2 : %h, r_mm3 : %h, \n r_mm4 : %h, r_mm5 : %h, \n r_mm6 : %h, r_mm7 : %h",
                 r0_mm0, r0_mm1, r0_mm2, r0_mm3, r0_mm4, r0_mm5, r0_mm6, r0_mm7);     	 
	$display("====================================================== ");
	$display("");
     end
  end
     
endmodule   


module wmem_size_mapper (
   out,
   in
);
   output [1:0] out;
   input [2:0] in;

   // o1 = (!in2&in1&!in0) | (!in2&!in1&in0);
   // o0 = (in2&!in1&in0) | (!in2&in1&!in0);

   wire [2:0] in_not;
   inv1$ 
   in_not_inv_0 (in_not[0], in[0]),
   in_not_inv_1 (in_not[1], in[1]),
   in_not_inv_2 (in_not[2], in[2]);

   wire and0_out;
   and3$ and0 (and0_out, in_not[2], in[1], in_not[0]);
   wire and1_out;
   and3$ and1 (and1_out, in_not[2], in_not[1], in[0]);
   wire and2_out;
   and3$ and2 (and2_out, in[2], in_not[1], in[0]);
   wire and3_out;
   and3$ and3 (and_3_out, in_not[2], in[1], in_not[0]);

   or2$ (out[1], and0_out, and1_out);
   or2$ (out[0], and2_out, and3_out);

endmodule