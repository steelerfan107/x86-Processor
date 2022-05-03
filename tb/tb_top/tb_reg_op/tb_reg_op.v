// tb_register_file.v
// Eric Taylor

// Testbench for testing the fetch stage seperately from everything else

module TOP;
   // Instruction Memory Interface Parameters
   parameter IDATAW = 128;
   parameter ISIZEW = 8;
   parameter IADDRW = 32;

   reg [127:0]           memory_data;
   reg                   memory_valid;
   reg [31:0]            memory_address;
 
   reg [31:0]            ememory_data;
   reg                   ememory_valid;
   reg [31:0]            ememory_address;
  
   // Clock Interface
   reg                   clk;
   reg                   reset;

   // Control Interface
   wire                  pending_int;
   wire                  hold_int;
   wire	                 fetch_flush;
   wire                  handle_int;
   wire                  halt;

   // Control Interface
   wire   	         decode_1_flush;
   wire   	         decode_0_flush;   
   wire   [IADDRW-1:0]   load_address;
   wire  	         load;
   wire                  reg_flush;
   wire                  addr_gen_flush;  
   wire                  exe_flush;
   wire                  wb_flush;  

   reg [3:0] 		 int_vec;
 
   // Code Segment
   wire [15:0] 	         cs_register;	

   // Instruction Memory Interface
   wire                  imem_valid;
   reg   	         imem_ready;
   wire    [IADDRW-1:0]  imem_address;
   wire    	         imem_wr_en;
   wire    [IDATAW-1:0]	 imem_wr_data;
   wire    [ISIZEW-1:0]  imem_wr_size;
   reg                   imem_dp_valid;
   wire                  imem_dp_ready;
   reg    [IDATAW-1:0] 	 imem_dp_read_data;

   // Inturrupt Memory Interface
   wire                  emem_valid;
   reg   	         emem_ready;
   wire    [IADDRW-1:0]  emem_address;
   wire    	         emem_wr_en;
   wire    [32-1:0]	 emem_wr_data;
   wire    [ISIZEW-1:0]  emem_wr_size;
   reg                   emem_dp_valid;
   wire                  emem_dp_ready;
   reg    [32-1:0] 	 emem_dp_read_data;   

   // Branch Predictor Interface
   wire  [IADDRW-1:0] 	bp_pc;
   reg [IADDRW-1:0] 	bp_target;
   reg                  bp_taken;
		  
   // Return Address Stack Interface
   wire                 ras_pop;
   wire [IADDRW-1:0] 	ras_target;
   
   // Return Address Stack Interface
   wire [IADDRW-1:0]    ras_address;
   wire                 ras_push;
	   
   // Fetch Interface  
   wire                 f_valid;
   wire                 f_ready;
   wire [5:0]           f_bytes_read;
   wire [5:0]           f_valid_bytes;
   wire [255:0]         f_instruction;
   wire [IADDRW-1:0]    f_pc;
   wire                 f_branch_taken;

   // Pipestage Interface
   wire  		d_valid;   
   wire   		d_ready;	       
   wire [2:0]		d_size;   
   wire 		d_set_d_flag;  
   wire 		d_clear_d_flag;   
   wire [2:0]           d_op0;   
   wire [2:0]           d_op1;   
   wire [2:0]           d_op0_reg;   
   wire [2:0]           d_op1_reg;   
   wire [7:0]	        d_modrm;  
   wire [7:0]           d_sib;   
   wire [47:0]          d_imm;   
   wire [31:0]          d_disp;   
   wire [3:0]		d_alu_op;   
   wire [2:0]           d_flag_0;   
   wire [2:0]           d_flag_1;   
   wire [1:0]           d_stack_op;   
   wire [2:0]		d_seg_override;   
   wire 		d_seg_override_valid;
   wire                 d_movs;
   wire [IADDRW-1:0]    d_pc;
   wire                 d_branch_taken;

   wire                 handle_int_done;
   reg                  write_eip;
   reg [31:0]           eip;
   reg [31:0]	        eflags_reg;

   wire   iretd;
   wire   iretd_halt;
   wire   iretd_pop_valid;
   wire   iretd_pop_data; 
   wire   reg_load_eflags;  
   wire   reg_eflags;
   wire   reg_load_eip;  
   wire   reg_eip;   
   
   wire   r_valid;
   wire   r_ready;
   wire   [2:0] r_size;
   wire   r_set_d_flag;
   wire   r_clear_d_flag;
   wire   [2:0] r_op0;
   wire   [2:0] r_op1;
   wire   [2:0] r_op0_reg;
   wire   [2:0] r_op1_reg;
   wire   [7:0] r_modrm;
   wire   [7:0] r_sib;
   wire   [47:0] r_imm;
   wire   [31:0] r_disp;
   wire   [3:0] r_alu_op;
   wire   [2:0] r_flag_0;
   wire   [2:0] r_flag_1;
   wire   [1:0] r_stack_op;
   wire   [2:0] r_seg_override;
   wire   r_seg_override_valid;
   wire   [31:0] r_eax;
   wire   [31:0] r_ecx;
   wire   [31:0] r_edx;
   wire   [31:0] r_ebx;
   wire   [31:0] r_esp;
   wire   [31:0] r_ebp;
   wire   [31:0] r_esi;
   wire   [31:0] r_edi;
   wire   [15:0] r_cs;
   wire   [15:0] r_ds;
   wire   [15:0] r_es;
   wire   [15:0] r_fs;
   wire   [15:0] r_gs;
   wire   [15:0] r_ss;
   wire   [63:0] r_mm0;
   wire   [63:0] r_mm1;
   wire   [63:0] r_mm2;
   wire   [63:0] r_mm3;
   wire   [63:0] r_mm4;
   wire   [63:0] r_mm5;
   wire   [63:0] r_mm6;
   wire   [63:0] r_mm7;
   wire   [31:0] r_pc;
   wire   r_branch_taken;

   wire   [2:0] wb_reg_number;
   wire   wb_reg_en;
   wire   [2:0] wb_reg_size;
   wire   [31:0] wb_reg_data;
   wire   [2:0] wb_seg_number;
   wire   wb_seg_en;
   wire   [15:0] wb_seg_data;
   wire   [2:0] wb_mmx_number;
   wire   wb_mmx_en;
   wire  [63:0] wb_mmx_data;
   wire [31:0] 	wb_pc;

   wire               dec_wb_valid;
   wire [2:0]         dec_wb_reg;
   wire [31:0]        dec_wb_data;  
   wire [2:0]         dec_wb_size; 

   wire a_valid;
   wire a_ready;
   wire [2:0] a_size;
   wire a_set_d_flag;
   wire a_clear_d_flag;
   wire [63:0] a_op0;
   wire [63:0] a_op1;
   wire [2:0] a_op0_reg;
   wire [2:0] a_op1_reg;
   wire a_op0_is_address;
   wire a_op1_is_address;
   wire [47:0] a_imm;
   wire [3:0] a_alu_op;
   wire [2:0] a_flag_0;
   wire [2:0] a_flag_1;
   wire [1:0] a_stack_op;
   wire [31:0] a_pc;
   wire a_branch_taken;
   wire a_to_sys_controller;
   

   // Writeback Interface
   reg   wb_ready;
   wire  [31:0] wb_dest_address;
   wire  [31:0] wb_dest_reg;
   wire  [63:0] wb_result;
   wire  [1:0] wb_opsize;
   wire  wb_mem_or_reg;
   wire  wb_valid;
   wire  wb_branch_taken;
   wire  wb_sys_controller_valid;
 
   wire     reg_load_cs;  
   wire     [15:0] reg_cs;

   wire 	   busy_ahead_of_decode;
   
   fetch_top uut_fetch (
      clk,
      reset,
      fetch_flush,
      load_address,
      load,
      r_cs,		  
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

   wire 	   wb_accept;
 
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
      d_branch_taken  		  		  
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
      wb_reg_number,
      wb_reg_en,
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
      a_pc,
      a_branch_taken,
      a_to_sys_controller

  ); 

  temp_execute_top uut_execute(
      clk,
      reset,
      exe_flush,
      a_valid,
      a_ready,
      1'b0,
      a_op0_reg,		       
      a_op0,
      a_op1,
      32'h0,
      a_alu_op,
      a_size,
      1'b0,
      a_branch_taken,
      a_to_sys_controller,
      a_pc,			       
      wb_ready,
      wb_dest_address,
      wb_dest_reg,
      wb_result,
      wb_opsize,
      wb_mem_or_reg,
      wb_valid,					 			       
      wb_branch_taken,
      wb_sys_controller_valid,
      wb_pc		       
  );
   
  sys_cont_top uut_sys_cont (
     clk,
     reset,
     int_vec,		     
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
     iretd,
     iretd_halt,
     (wb_sys_controller_valid & wb_valid), //iretd_pop_valid,
     wb_result, //iretd_pop_data,
     reg_load_eflags,
     reg_eflags,
     reg_load_eip,
     reg_eip,
     pending_int,
     hold_int	  
  );   

  assign busy_ahead_of_decode = wb_valid | a_valid | r_valid;
   
  or2$ (wb_reg_en, wb_valid, dec_wb_valid);
  
  mux  #(.WIDTH(3),.INPUTS(2))  ( {dec_wb_reg, wb_dest_reg[2:0]} , wb_reg_number, dec_wb_valid);
  mux  #(.WIDTH(3),.INPUTS(2))  ( {dec_wb_size, wb_opsize}       , wb_reg_size  , dec_wb_valid);
  mux  #(.WIDTH(32),.INPUTS(2)) ( {dec_wb_data, wb_result[31:0]} , wb_reg_data  , dec_wb_valid);   
   
  assign wb_seg_number = 'h0;
  assign wb_seg_en = 'h0;
  assign wb_seg_data = 'h0;
  assign wb_mmx_number = 'h0;
  assign wb_mmx_en = 'h0;
  assign wb_mmx_data = 'h0; 

  wire [31:0] 		rom_data_0, rom_data_1, rom_data_2, rom_data_3;

  wire [31:0] 		rom_data_0_0, rom_data_0_1, rom_data_0_2, rom_data_0_3;
  wire [31:0] 		rom_data_1_0, rom_data_1_1, rom_data_1_2, rom_data_1_3;
   
  rom32b32w$ test_rom_0 (
     memory_address[8:4],
     1'b1,
     rom_data_0		      
  );

  rom32b32w$ test_rom_1 (
     memory_address[8:4],
     1'b1,
     rom_data_1		      
  );
   
  rom32b32w$ test_rom_2 (
     memory_address[8:4],
     1'b1,
     rom_data_2		      
  );
   
  rom32b32w$ test_rom_3 (
     memory_address[8:4],
     1'b1,
     rom_data_3		      
  );    
   
  initial begin
        $readmemh("rom/rom_control_0_0", test_rom_0.mem);
        $readmemh("rom/rom_control_0_1", test_rom_1.mem);
        $readmemh("rom/rom_control_0_2", test_rom_2.mem);
        $readmemh("rom/rom_control_0_3", test_rom_3.mem);

        $readmemb("rom/dec_rom_program_0_0", uut_decode.ds1.rom_block.b0.mem);
        $readmemb("rom/dec_rom_program_0_1", uut_decode.ds1.rom_block.b1.mem);

        eflags_reg = 'h0;   
        clk = 0;
        wb_ready = 1;
        reset = 1;
        int_vec = 'h0;     
     
        $strobe("============ \n Begin Test \n============");       	  
        #55
        reset = 0;
        #350
        int_vec = 0;     
	#50
        int_vec = 0;     	  
        $display("==========\n End Test \n==========");
  end

  initial #2000 $finish;
   
  always @ (posedge clk or posedge reset) begin
       if (reset) begin
          memory_data  <= 0;
          memory_valid <= 0;
          memory_address <= 0;	  
       end else begin
          memory_data  <= {rom_data_0, rom_data_1, rom_data_2, rom_data_3};
          memory_valid <= (memory_valid) ? ~(imem_dp_ready) : imem_valid;
	  memory_address <= imem_address;
       end
  end // always @ (posedge clk or posedge reset)

  always @ (posedge clk or posedge reset) begin
       if (reset) begin
          ememory_data  <= 0;
          ememory_valid <= 0;
          ememory_address <= 0;	  
       end else begin
          ememory_data  <= 32'h400;
          ememory_valid <= (ememory_valid) ? ~(emem_dp_ready) : emem_valid;
	  ememory_address <= emem_address;
       end
  end   

  always @ (*) begin
       imem_dp_valid     =  memory_valid;
       imem_dp_read_data =  {rom_data_0, rom_data_1, rom_data_2, rom_data_3};
       imem_ready        = ~memory_valid;

       emem_dp_valid     =  ememory_valid;
       emem_dp_read_data =  32'h040;
       emem_ready        = ~ememory_valid;     
  end
   
  always #10  clk          = ~clk;

  initial begin
        $vcdplusfile("fsys_reg.dump.vpd");
        $vcdpluson(0, TOP);
  end

endmodule

module temp_execute_top (
    // Clock Interface
    clk,
    reset,

    // Control Interface
    flush,

    // Pipestage Interface
    e_valid,
    e_ready,
    e_mmr,
    e_dest_reg, 		 
    e_op_a,
    e_op_b,
    e_stack_ptr,
    e_op,
    e_opsize,
    e_size_of_txn,
    e_branch_taken,
    e_to_sys_controller,
    e_pc,			 

    // Writeback Interface
    wb_ready,
    wb_dest_address,
    wb_dest_reg,
    wb_result,
    wb_opsize,
    wb_mem_or_reg,
    wb_valid,
    wb_branch_taken,
    wb_sys_controller_valid,
    wb_pc
);
    // Clock Interface
    input clk;
    input reset;

    // Control Interface
    input flush;

    // Pipestage Interface
    input e_valid;
    output e_ready;
    input e_mmr;
    input [2:0] e_dest_reg;
    input [63:0] e_op_a;
    input [63:0] e_op_b;
    input [31:0] e_stack_ptr;
    input [3:0] e_op;
    input [2:0] e_opsize;
    input e_size_of_txn;
    input e_branch_taken;
    input e_to_sys_controller;
    input [31:0] e_pc;

    // Writeback Interface
    input wb_ready;
    output [31:0] wb_dest_address;
    output [31:0] wb_dest_reg;
    output [63:0] wb_result;
    output [2:0] wb_opsize;
    output wb_mem_or_reg;
    output wb_valid;
    output wb_branch_taken;
    output wb_sys_controller_valid;
    output [31:0] wb_pc;

    wire [63:0] a;
    wire [63:0] b;
    wire [15:0] sext16_b;
    wire [31:0] sext32_b;
    wire [31:0] e_alu_out;
    wire [5:0] e_alu_set_eflags; 
    wire [5:0] e_alu_eflags_out; 
    wire [63:0] e_simd_out;
    wire [5:0] e_eflags_out;
    wire [31:0] e_cmovc_out;
    wire [31:0] e_cmpxchg_out;

   // -------   //
   // Pipestage //
   // -------   //
   // Some Temp Logic
   
    localparam PIPEWIDTH = 32+3+64+3+1+1+1+32;

    wire [31:0] p_dest_address;
    wire [2:0] p_dest_reg;
    wire [63:0] p_result;
    wire [2:0] p_opsize;
    wire p_mem_or_reg;
    wire p_branch_taken;
    wire p_sys_controller_valid;
    wire [31:0] p_pc;

   
    wire [PIPEWIDTH-1:0] pipe_in_data, pipe_out_data;   

    assign p_sys_controller_valid = e_to_sys_controller;
    assign p_dest_address = 'h0;   
    assign p_dest_reg = e_dest_reg;
    assign p_result = (~|e_op) ? e_op_b : e_op_a + e_op_b;
    assign p_opsize = e_opsize;
    assign p_mem_or_reg = 'h0;
    assign p_branch_taken = 'h0;
    assign p_pc = e_pc;

    assign pipe_in_data = {
	p_sys_controller_valid,		   
        p_dest_address,
        p_dest_reg,
        p_result,
        p_opsize,
        p_mem_or_reg,
        p_branch_taken,
        p_pc	    
    };

    assign {
	wb_sys_controller_valid,    
        wb_dest_address,
        wb_dest_reg[2:0],
        wb_result,
        wb_opsize,
        wb_mem_or_reg,
        wb_branch_taken,
        wb_pc	    
    } = pipe_out_data; 

    pipestage #(.WIDTH(PIPEWIDTH)) stage ( clk, (reset | flush), e_valid, e_ready, pipe_in_data, wb_valid, wb_ready, pipe_out_data);
endmodule
