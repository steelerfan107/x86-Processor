// tb_register_file.v
// Eric Taylor

// Testbench for testing the fetch stage seperately from everything else

module TOP;
   // Instruction Memory Interface Parameters
   parameter IDATAW = 128;
   parameter ISIZEW = 8;
   parameter IADDRW = 32;

   reg [127:0]         memory_data;
   reg                 memory_valid;
   reg [31:0]          memory_address;
   
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
   reg  		d_ready;	       
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
   
   fetch_top uut_fetch (
      clk,
      reset,
      fetch_flush,
      load_address,
      load,
      16'b0,		  
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

  wire [31:0] 		rom_data_0, rom_data_1, rom_data_2, rom_data_3;

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
     
        clk = 0;
        fetch_flush = 0;
        handle_int = 0;
        decode_flush = 0;
        load_address = 0;
        load = 0;
        d_ready = 1;
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
