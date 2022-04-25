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
   
   // Clock Interface
   reg                   clk;
   reg                   reset;

   // Control Interface
   reg 	                 fetch_flush;
   reg                   handle_int;
   wire                  halt;

   // Control Interface
   reg   	         decode_flush;
   reg   [IADDRW-1:0]    load_address;
   reg  	         load;

   reg                   reg_flush;

   reg                   addr_gen_flush;   
 
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
   wire [IADDRW-1:0]    d_pc;
   wire                 d_branch_taken;

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

   reg   [2:0] wb_reg_number;
   reg   wb_reg_en;
   reg   [2:0] wb_reg_size;
   reg   [31:0] wb_reg_data;
   reg   [2:0] wb_seg_number;
   reg   wb_seg_en;
   reg   [15:0] wb_seg_data;
   reg   [2:0] wb_mmx_number;
   reg   wb_mmx_en;
   reg   [63:0] wb_mmx_data;

   wire a_valid;
   reg  a_ready;
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
 
   decode_top uut_decode (
      clk,
      reset,
      decode_flush,
      handle_int,
      halt,
      ras_address,
      ras_push,		  
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
      d_pc,
      d_branch_taken  		  		  
   );

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
      a_branch_taken

  );   

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
        $readmemh("rom/rom_program_0", test_rom_0.mem);
        $readmemh("rom/rom_program_1", test_rom_1.mem);
        $readmemh("rom/rom_program_2", test_rom_2.mem);
        $readmemh("rom/rom_program_3", test_rom_3.mem);

        $readmemh("rom/dec_rom_program_0", uut_decode.ds1.rom_block.b0.mem);
        $readmemh("rom/dec_rom_program_1", uut_decode.ds1.rom_block.b1.mem);
        $readmemh("rom/dec_rom_program_2", uut_decode.ds1.rom_block.b2.mem);

        wb_reg_number = 0;
        wb_reg_en = 0;
        wb_reg_size = 0;
        wb_reg_data = 0;
        wb_seg_number = 0;
        wb_seg_en = 0;
        wb_seg_data = 0;
        wb_mmx_number = 0;
        wb_mmx_en = 0;
        wb_mmx_data = 0;  
   
        clk = 0;
        fetch_flush = 0;
        handle_int = 0;
        decode_flush = 0;
        reg_flush = 0;
        addr_gen_flush = 0;
        load_address = 0;
        load = 0;
        a_ready = 1;
        reset = 1;
        $strobe("============ \n Begin Test \n============");       	  
        #55
        reset = 0;
        #20	 
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
  end

  always @ (*) begin
       imem_dp_valid     =  memory_valid;
       imem_dp_read_data =  memory_data;
       imem_ready        = ~memory_valid;
  end
   
  always #10  clk          = ~clk;

  initial begin
        $vcdplusfile("fsys_reg.dump.vpd");
        $vcdpluson(0, TOP);
  end

endmodule
