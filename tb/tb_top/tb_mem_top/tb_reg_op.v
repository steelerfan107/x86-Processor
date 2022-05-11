// tb_register_file.v
// Eric Taylor

// Testbench for testing the fetch stage seperately from everything else

module TOP;
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
    parameter BUSADDRW = 32;    

    parameter SINGLE_TXN = 1'b1;
   
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
   wire   	         imem_ready;
   wire    [IADDRW-1:0]  imem_address;
   wire    	         imem_wr_en;
   wire    [IDATAW-1:0]	 imem_wr_data;
   wire    [ISIZEW-1:0]  imem_wr_size;
   wire                  imem_dp_valid;
   wire                  imem_dp_ready;
   wire    [IDATAW-1:0]  imem_dp_read_data;

   // Inturrupt Memory Interface
   wire                  emem_valid;
   wire   	         emem_ready;
   wire    [IADDRW-1:0]  emem_address;
   wire    	         emem_wr_en;
   wire    [32-1:0]	 emem_wr_data;
   wire    [ISIZEW-1:0]  emem_wr_size;
   wire                  emem_dp_valid;
   wire                  emem_dp_ready;
   wire    [32-1:0] 	 emem_dp_read_data; 

   wire                  rmem_valid;
   wire   	         rmem_ready;
   wire    [IADDRW-1:0]  rmem_address;
   wire    	         rmem_wr_en;
   wire   [IDATAW-1:0]   rmem_wr_data;
   wire   [ISIZEW-1:0]   rmem_wr_size;
   wire                  rmem_dp_valid;
   wire                  rmem_dp_ready;
   wire    [64-1:0]      rmem_dp_read_data;

   wire                  wmem_valid;
   wire   	         wmem_ready;
   wire    [IADDRW-1:0]  wmem_address;
   wire    	         wmem_wr_en;
   wire    [32-1:0]	 wmem_wr_data;
   wire    [ISIZEW-1:0]  wmem_wr_size;
   wire                  wmem_dp_valid;
   wire                  wmem_dp_ready;
   wire    [64-1:0] 	 wmem_dp_read_data;   

   reg [43:0] contents [0:7];

   // icache port
   wire [31:0] i_addr_in;
   wire i_hit;
   wire i_rd_wr_out;
   wire i_PCD_out;
   wire [31:0] i_pa_out;
   
   wire [351:0] contents_concat;
   
   // Interface to Interconnect
   wire [32-1:0]  mem_addr;
   wire           mem_req;
   wire           mem_data_valid;
   wire  [32-1:0] mem_data;
   wire           mem_rd_wr;
   wire           mem_en;
   
   assign contents_concat = {
        contents[0],
        contents[1],
        contents[2],
        contents[3],
        contents[4],
        contents[5],
        contents[6],
        contents[7]
   };

   wire [31:0] tlb_va;

   // Data Memory Read Interface
   wire  	            dmem_r_valid;
   wire 	            dmem_r_ready;
   wire  [DADDRW-1:0]  dmem_r_address;
   wire                dmem_r_wr_en;   // unused 
   wire  [DDATAW-1:0]	dmem_r_wr_data; // unused
   wire  [DSIZEW-1:0] 	dmem_r_wr_size; // unused
   wire               dmem_r_dp_valid;
   wire                dmem_r_dp_ready ;
   wire  [DDATAW-1:0] dmem_r_dp_read_data;

   // Data Memory Write Interface
   wire  	            dmem_w_valid;
   wire  	            dmem_w_ready;
   wire  [IADDRW-1:0]  dmem_w_address;
   wire                dmem_w_wr_en;
   wire               dmem_w_dp_valid;     // unused 
   wire                dmem_w_dp_ready;     // unused
   wire  [IDATAW-1:0] dmem_w_dp_read_data; // unused

   wire                  test_emem_valid;
   wire   	         test_emem_ready = 1'b1;
   wire    [IADDRW-1:0]  test_emem_address;
   wire    	         test_emem_wr_en;
   wire    [32-1:0]	 test_emem_wr_data;
   wire    [ISIZEW-1:0]  test_emem_wr_size;
   wire                  test_emem_dp_valid = 1'b1;
   wire                  test_emem_dp_ready;
   wire    [32-1:0] 	 test_emem_dp_read_data = 32'h40;    

   // System Controller Read Interface
   wire  sys_r_valid = 'h0 ;
   wire  sys_r_ready;
   wire  [31:0] sys_r_address = 'h0;
   wire  sys_r_dp_valid;
   wire  sys_r_dp_ready = 'h0;
   wire  [31:0] sys_r_dp_read_data;   

   memory_subsystem_top uut_memory (
    .clk                    (clk            ),
    .reset                  (reset          ),
    .imem_valid             (imem_valid     ),
    .imem_ready            (imem_ready     ),
    .imem_address           (imem_address   ),
    .imem_wr_en             (imem_wr_en     ), 
    .imem_wr_data           (imem_wr_data   ), 
    .imem_wr_size           (imem_wr_size   ), 
    .imem_dp_valid          (imem_dp_valid  ),
    .imem_dp_ready          (imem_dp_ready  ),
    .imem_dp_read_data      (imem_dp_read_data  ),
    .dmem_r_valid           (rmem_valid),
    .dmem_r_ready           (rmem_ready),
    .dmem_r_address         (rmem_address     ),
    .dmem_r_wr_en           (rmem_wr_en     ),
    .dmem_r_wr_data         (rmem_wr_data   ),
    .dmem_r_wr_size         (rmem_wr_size     ),
    .dmem_r_dp_valid        (rmem_dp_valid   ),
    .dmem_r_dp_ready        (rmem_dp_ready   ),
    .dmem_r_dp_read_data    (rmem_dp_read_data  ),
    .dmem_w_valid           (wmem_valid  ),
    .dmem_w_ready           (wmem_ready),
    .dmem_w_address         (wmem_address     ),
    .dmem_w_wr_en           (wmem_wr_en     ),    
    .dmem_w_wr_data         (wmem_wr_data   ),  
    .dmem_w_wr_size         (wmem_wr_size    ),  
    .dmem_w_dp_valid        (wmem_dp_valid   ),
    .dmem_w_dp_ready        (wmem_dp_ready   ),
    .dmem_w_dp_read_data    (wmem_dp_read_data  ),
    .sys_r_valid            (emem_valid  ),
    .sys_r_ready            (emem_ready),
    .sys_r_address          (emem_address     ),
    .sys_r_dp_valid         (emem_dp_valid     ),
    .sys_r_dp_ready         (emem_dp_ready   ),
    .sys_r_dp_read_data     (emem_dp_read_data  ),
    .tlb_contents           (contents_concat)
   );                                        
                             
   reg 		r_emem_valid;
   reg 		r_r_emem_valid;
   
   top_pipeline #(.SINGLE_TXN(SINGLE_TXN)) uut_pipeline(
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
      1'b1, //emem_ready,
      emem_address,
      emem_wr_en,
      emem_wr_data,
      emem_wr_size,
      r_emem_valid, //emem_dp_valid,
      emem_dp_ready,
      (r_r_emem_valid ? (32'h00000000) : (32'h52000000)), //emem_dp_read_data, 

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

  always @ (posedge clk) begin
     r_emem_valid <=  emem_valid;
     r_r_emem_valid <=  r_emem_valid;     
  end
   
  initial begin
        //$readmemh("rom/rom_control_0_0", uut_memory.main_memory_top.genblk1[0-7].genblk1[0-31].sram32x32$);

        //$readmemh("rom/rom_control_0_0", uut_memory.main_memory_top.genblk1[0].sram32x32$.mem);
        //$readmemh("rom/rom_control_0_1", uut_memory.main_memory_top..mem);
        //$readmemh("rom/rom_control_0_2", uut_memory.main_memory_top..mem);
        //$readmemh("rom/rom_control_0_3", uut_memory.main_memory_top..mem);

        $readmemb("rom/dec_rom_program_0_0", uut_pipeline.uut_decode.ds1.rom_block.b0.mem);
        $readmemb("rom/dec_rom_program_0_1", uut_pipeline.uut_decode.ds1.rom_block.b1.mem);

        $readmemb("rom/dcache_interface_rom.bit", uut_pipeline.uut_memory_read.dcache_interface0.rom.mem);
     
        contents[0] = {20'h00000,   20'h00000,   1'b1,   1'b1,   1'b0, 1'b0};
        contents[1] = {20'h02000,   20'h00002,   1'b1,   1'b1,   1'b1, 1'b0};
        contents[2] = {20'h04000,   20'h00005,   1'b1,   1'b1,   1'b1, 1'b0};
        contents[3] = {20'h0b000,   20'h00004,   1'b1,   1'b1,   1'b1, 1'b0};
        contents[4] = {20'h0c000,   20'h00007,   1'b1,   1'b1,   1'b1, 1'b0};
        contents[5] = {20'h0a000,   20'h00005,   1'b1,   1'b1,   1'b1, 1'b0};
        contents[6] = 44'h12345123451;
        contents[7] = 44'h12344123441;
     
        clk = 0;
        reset = 1;
        interrupt = 'h0;   
  
        //rmem_ready = 'h0;
        //rmem_dp_valid = 'h0;
        //rmem_dp_read_data = 'h0;
        //contents[2] = {20'h04000,   20'h00005,   1'b1,   1'b1,   1'b1, 1'b0};
        //contents[3] = {20'h0b000,   20'h00004,   1'b1,   1'b1,   1'b1, 1'b0};
        //contents[4] = {20'h0c000,   20'h00007,   1'b1,   1'b1,   1'b1, 1'b0};
        //contents[5] = {20'h0a000,   20'h00005,   1'b1,   1'b1,   1'b1, 1'b0};
        //contents[6] = 44'h12345123451;
        //contents[7] = 44'h12344123441;
     
        //clk = 0;
        //reset = 1;
        interrupt = 'h0;   

        $strobe("============ \n Begin Test \n============");       	  
        #55
        reset = 0;
        #2350
        interrupt = 'h0; //16'h04;     
	#50
        interrupt = 0;     	  
  end
   
  initial #20000 $finish;

  always @ (posedge clk or posedge reset) begin
       if (reset) begin
          ememory_data    <= 0;
          ememory_valid   <= 0;
          ememory_address <= 0;	  
       end else begin
          ememory_data    <= 32'h400;
          ememory_valid   <= (ememory_valid) ? ~(emem_dp_ready) : emem_valid;
	  ememory_address <= emem_address;
       end
  end   

  //always @ (*) begin
  //     emem_dp_valid     =  ememory_valid;
  //     emem_dp_read_data =  32'h040;
  //     emem_ready        = ~ememory_valid;     
  //end
   
  always #25  clk          = ~clk;

  initial begin
        $vcdplusfile("fsys_reg.dump.vpd");
        $vcdpluson(0, TOP);
  end

endmodule // TOP
