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

   reg [15:0] 		 interrupt;

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

   wire                  rmem_valid;
   reg   	         rmem_ready;
   wire    [IADDRW-1:0]  rmem_address;
   wire    	         rmem_wr_en;
   wire   [IDATAW-1:0]   rmem_wr_data;
   wire   [ISIZEW-1:0]   rmem_wr_size;
   reg                   rmem_dp_valid;
   wire                  rmem_dp_ready;
   reg    [64-1:0]       rmem_dp_read_data;

   wire                  wmem_valid;
   reg   	         wmem_ready;
   wire    [IADDRW-1:0]  wmem_address;
   wire    	         wmem_wr_en;
   wire    [32-1:0]	 wmem_wr_data;
   wire    [ISIZEW-1:0]  wmem_wr_size;
   reg                   wmem_dp_valid;
   wire                  wmem_dp_ready;
   reg    [64-1:0] 	 wmem_dp_read_data;   


   top_pipeline uut_pipeline(
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

        $readmemb("rom/dec_rom_program_0_0", uut_pipeline.uut_decode.ds1.rom_block.b0.mem);
        $readmemb("rom/dec_rom_program_0_1", uut_pipeline.uut_decode.ds1.rom_block.b1.mem);

        clk = 0;
        reset = 1;
        interrupt = 'h0;   
  
        rmem_ready = 'h0;
        rmem_dp_valid = 'h0;
        rmem_dp_read_data = 'h0;
        wmem_ready = 'h0;
        wmem_dp_valid = 'h0;
        wmem_dp_read_data = 'h0;
     
        $strobe("============ \n Begin Test \n============");       	  
        #55
        reset = 0;
        #350
        interrupt = 0;     
	#50
        interrupt = 0;     	  
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
