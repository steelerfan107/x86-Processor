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
   wire    [ISIZEW-1:0]  wmem_wr_size_nc;   
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
  
   assign wmem_wr_size = 'h0; //wmem_wr_size_nc - 1; 
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
      wmem_wr_size_nc,
      wmem_dp_valid,
      wmem_dp_ready,
      wmem_dp_read_data  		     
  );

  always @ (posedge clk) begin
     r_emem_valid <=  emem_valid;
     r_r_emem_valid <=  r_emem_valid;     
  end
   
  initial begin
        //$readmemh("rom/rom_control_0_0", uut_memory.main_memory_top.genblk1[0-7].genblk1[0-31].sram32x32$.mem);
$readmemh("rom/rom_control_0_0", uut_memory.main_memory_top.genblk1[0].genblk1[0].sram32x32$.mem);
$readmemh("rom/rom_control_1_0", uut_memory.main_memory_top.genblk1[0].genblk1[1].sram32x32$.mem);
$readmemh("rom/rom_control_2_0", uut_memory.main_memory_top.genblk1[0].genblk1[2].sram32x32$.mem);
$readmemh("rom/rom_control_3_0", uut_memory.main_memory_top.genblk1[0].genblk1[3].sram32x32$.mem);
$readmemh("rom/rom_control_4_0", uut_memory.main_memory_top.genblk1[0].genblk1[4].sram32x32$.mem);
$readmemh("rom/rom_control_5_0", uut_memory.main_memory_top.genblk1[0].genblk1[5].sram32x32$.mem);
$readmemh("rom/rom_control_6_0", uut_memory.main_memory_top.genblk1[0].genblk1[6].sram32x32$.mem);
$readmemh("rom/rom_control_7_0", uut_memory.main_memory_top.genblk1[0].genblk1[7].sram32x32$.mem);
$readmemh("rom/rom_control_8_0", uut_memory.main_memory_top.genblk1[0].genblk1[8].sram32x32$.mem);
$readmemh("rom/rom_control_9_0", uut_memory.main_memory_top.genblk1[0].genblk1[9].sram32x32$.mem);
$readmemh("rom/rom_control_10_0", uut_memory.main_memory_top.genblk1[0].genblk1[10].sram32x32$.mem);
$readmemh("rom/rom_control_11_0", uut_memory.main_memory_top.genblk1[0].genblk1[11].sram32x32$.mem);
$readmemh("rom/rom_control_12_0", uut_memory.main_memory_top.genblk1[0].genblk1[12].sram32x32$.mem);
$readmemh("rom/rom_control_13_0", uut_memory.main_memory_top.genblk1[0].genblk1[13].sram32x32$.mem);
$readmemh("rom/rom_control_14_0", uut_memory.main_memory_top.genblk1[0].genblk1[14].sram32x32$.mem);
$readmemh("rom/rom_control_15_0", uut_memory.main_memory_top.genblk1[0].genblk1[15].sram32x32$.mem);
$readmemh("rom/rom_control_16_0", uut_memory.main_memory_top.genblk1[0].genblk1[16].sram32x32$.mem);
$readmemh("rom/rom_control_17_0", uut_memory.main_memory_top.genblk1[0].genblk1[17].sram32x32$.mem);
$readmemh("rom/rom_control_18_0", uut_memory.main_memory_top.genblk1[0].genblk1[18].sram32x32$.mem);
$readmemh("rom/rom_control_19_0", uut_memory.main_memory_top.genblk1[0].genblk1[19].sram32x32$.mem);
$readmemh("rom/rom_control_20_0", uut_memory.main_memory_top.genblk1[0].genblk1[20].sram32x32$.mem);
$readmemh("rom/rom_control_21_0", uut_memory.main_memory_top.genblk1[0].genblk1[21].sram32x32$.mem);
$readmemh("rom/rom_control_22_0", uut_memory.main_memory_top.genblk1[0].genblk1[22].sram32x32$.mem);
$readmemh("rom/rom_control_23_0", uut_memory.main_memory_top.genblk1[0].genblk1[23].sram32x32$.mem);
$readmemh("rom/rom_control_24_0", uut_memory.main_memory_top.genblk1[0].genblk1[24].sram32x32$.mem);
$readmemh("rom/rom_control_25_0", uut_memory.main_memory_top.genblk1[0].genblk1[25].sram32x32$.mem);
$readmemh("rom/rom_control_26_0", uut_memory.main_memory_top.genblk1[0].genblk1[26].sram32x32$.mem);
$readmemh("rom/rom_control_27_0", uut_memory.main_memory_top.genblk1[0].genblk1[27].sram32x32$.mem);
$readmemh("rom/rom_control_28_0", uut_memory.main_memory_top.genblk1[0].genblk1[28].sram32x32$.mem);
$readmemh("rom/rom_control_29_0", uut_memory.main_memory_top.genblk1[0].genblk1[29].sram32x32$.mem);
$readmemh("rom/rom_control_30_0", uut_memory.main_memory_top.genblk1[0].genblk1[30].sram32x32$.mem);
$readmemh("rom/rom_control_31_0", uut_memory.main_memory_top.genblk1[0].genblk1[31].sram32x32$.mem);
$readmemh("rom/rom_control_32_0", uut_memory.main_memory_top.genblk1[1].genblk1[0].sram32x32$.mem);
$readmemh("rom/rom_control_33_0", uut_memory.main_memory_top.genblk1[1].genblk1[1].sram32x32$.mem);
$readmemh("rom/rom_control_34_0", uut_memory.main_memory_top.genblk1[1].genblk1[2].sram32x32$.mem);
$readmemh("rom/rom_control_35_0", uut_memory.main_memory_top.genblk1[1].genblk1[3].sram32x32$.mem);
$readmemh("rom/rom_control_36_0", uut_memory.main_memory_top.genblk1[1].genblk1[4].sram32x32$.mem);
$readmemh("rom/rom_control_37_0", uut_memory.main_memory_top.genblk1[1].genblk1[5].sram32x32$.mem);
$readmemh("rom/rom_control_38_0", uut_memory.main_memory_top.genblk1[1].genblk1[6].sram32x32$.mem);
$readmemh("rom/rom_control_39_0", uut_memory.main_memory_top.genblk1[1].genblk1[7].sram32x32$.mem);
$readmemh("rom/rom_control_40_0", uut_memory.main_memory_top.genblk1[1].genblk1[8].sram32x32$.mem);
$readmemh("rom/rom_control_41_0", uut_memory.main_memory_top.genblk1[1].genblk1[9].sram32x32$.mem);
$readmemh("rom/rom_control_42_0", uut_memory.main_memory_top.genblk1[1].genblk1[10].sram32x32$.mem);
$readmemh("rom/rom_control_43_0", uut_memory.main_memory_top.genblk1[1].genblk1[11].sram32x32$.mem);
$readmemh("rom/rom_control_44_0", uut_memory.main_memory_top.genblk1[1].genblk1[12].sram32x32$.mem);
$readmemh("rom/rom_control_45_0", uut_memory.main_memory_top.genblk1[1].genblk1[13].sram32x32$.mem);
$readmemh("rom/rom_control_46_0", uut_memory.main_memory_top.genblk1[1].genblk1[14].sram32x32$.mem);
$readmemh("rom/rom_control_47_0", uut_memory.main_memory_top.genblk1[1].genblk1[15].sram32x32$.mem);
$readmemh("rom/rom_control_48_0", uut_memory.main_memory_top.genblk1[1].genblk1[16].sram32x32$.mem);
$readmemh("rom/rom_control_49_0", uut_memory.main_memory_top.genblk1[1].genblk1[17].sram32x32$.mem);
$readmemh("rom/rom_control_50_0", uut_memory.main_memory_top.genblk1[1].genblk1[18].sram32x32$.mem);
$readmemh("rom/rom_control_51_0", uut_memory.main_memory_top.genblk1[1].genblk1[19].sram32x32$.mem);
$readmemh("rom/rom_control_52_0", uut_memory.main_memory_top.genblk1[1].genblk1[20].sram32x32$.mem);
$readmemh("rom/rom_control_53_0", uut_memory.main_memory_top.genblk1[1].genblk1[21].sram32x32$.mem);
$readmemh("rom/rom_control_54_0", uut_memory.main_memory_top.genblk1[1].genblk1[22].sram32x32$.mem);
$readmemh("rom/rom_control_55_0", uut_memory.main_memory_top.genblk1[1].genblk1[23].sram32x32$.mem);
$readmemh("rom/rom_control_56_0", uut_memory.main_memory_top.genblk1[1].genblk1[24].sram32x32$.mem);
$readmemh("rom/rom_control_57_0", uut_memory.main_memory_top.genblk1[1].genblk1[25].sram32x32$.mem);
$readmemh("rom/rom_control_58_0", uut_memory.main_memory_top.genblk1[1].genblk1[26].sram32x32$.mem);
$readmemh("rom/rom_control_59_0", uut_memory.main_memory_top.genblk1[1].genblk1[27].sram32x32$.mem);
$readmemh("rom/rom_control_60_0", uut_memory.main_memory_top.genblk1[1].genblk1[28].sram32x32$.mem);
$readmemh("rom/rom_control_61_0", uut_memory.main_memory_top.genblk1[1].genblk1[29].sram32x32$.mem);
$readmemh("rom/rom_control_62_0", uut_memory.main_memory_top.genblk1[1].genblk1[30].sram32x32$.mem);
$readmemh("rom/rom_control_63_0", uut_memory.main_memory_top.genblk1[1].genblk1[31].sram32x32$.mem);
$readmemh("rom/rom_control_64_0", uut_memory.main_memory_top.genblk1[2].genblk1[0].sram32x32$.mem);
$readmemh("rom/rom_control_65_0", uut_memory.main_memory_top.genblk1[2].genblk1[1].sram32x32$.mem);
$readmemh("rom/rom_control_66_0", uut_memory.main_memory_top.genblk1[2].genblk1[2].sram32x32$.mem);
$readmemh("rom/rom_control_67_0", uut_memory.main_memory_top.genblk1[2].genblk1[3].sram32x32$.mem);
$readmemh("rom/rom_control_68_0", uut_memory.main_memory_top.genblk1[2].genblk1[4].sram32x32$.mem);
$readmemh("rom/rom_control_69_0", uut_memory.main_memory_top.genblk1[2].genblk1[5].sram32x32$.mem);
$readmemh("rom/rom_control_70_0", uut_memory.main_memory_top.genblk1[2].genblk1[6].sram32x32$.mem);
$readmemh("rom/rom_control_71_0", uut_memory.main_memory_top.genblk1[2].genblk1[7].sram32x32$.mem);
$readmemh("rom/rom_control_72_0", uut_memory.main_memory_top.genblk1[2].genblk1[8].sram32x32$.mem);
$readmemh("rom/rom_control_73_0", uut_memory.main_memory_top.genblk1[2].genblk1[9].sram32x32$.mem);
$readmemh("rom/rom_control_74_0", uut_memory.main_memory_top.genblk1[2].genblk1[10].sram32x32$.mem);
$readmemh("rom/rom_control_75_0", uut_memory.main_memory_top.genblk1[2].genblk1[11].sram32x32$.mem);
$readmemh("rom/rom_control_76_0", uut_memory.main_memory_top.genblk1[2].genblk1[12].sram32x32$.mem);
$readmemh("rom/rom_control_77_0", uut_memory.main_memory_top.genblk1[2].genblk1[13].sram32x32$.mem);
$readmemh("rom/rom_control_78_0", uut_memory.main_memory_top.genblk1[2].genblk1[14].sram32x32$.mem);
$readmemh("rom/rom_control_79_0", uut_memory.main_memory_top.genblk1[2].genblk1[15].sram32x32$.mem);
$readmemh("rom/rom_control_80_0", uut_memory.main_memory_top.genblk1[2].genblk1[16].sram32x32$.mem);
$readmemh("rom/rom_control_81_0", uut_memory.main_memory_top.genblk1[2].genblk1[17].sram32x32$.mem);
$readmemh("rom/rom_control_82_0", uut_memory.main_memory_top.genblk1[2].genblk1[18].sram32x32$.mem);
$readmemh("rom/rom_control_83_0", uut_memory.main_memory_top.genblk1[2].genblk1[19].sram32x32$.mem);
$readmemh("rom/rom_control_84_0", uut_memory.main_memory_top.genblk1[2].genblk1[20].sram32x32$.mem);
$readmemh("rom/rom_control_85_0", uut_memory.main_memory_top.genblk1[2].genblk1[21].sram32x32$.mem);
$readmemh("rom/rom_control_86_0", uut_memory.main_memory_top.genblk1[2].genblk1[22].sram32x32$.mem);
$readmemh("rom/rom_control_87_0", uut_memory.main_memory_top.genblk1[2].genblk1[23].sram32x32$.mem);
$readmemh("rom/rom_control_88_0", uut_memory.main_memory_top.genblk1[2].genblk1[24].sram32x32$.mem);
$readmemh("rom/rom_control_89_0", uut_memory.main_memory_top.genblk1[2].genblk1[25].sram32x32$.mem);
$readmemh("rom/rom_control_90_0", uut_memory.main_memory_top.genblk1[2].genblk1[26].sram32x32$.mem);
$readmemh("rom/rom_control_91_0", uut_memory.main_memory_top.genblk1[2].genblk1[27].sram32x32$.mem);
$readmemh("rom/rom_control_92_0", uut_memory.main_memory_top.genblk1[2].genblk1[28].sram32x32$.mem);
$readmemh("rom/rom_control_93_0", uut_memory.main_memory_top.genblk1[2].genblk1[29].sram32x32$.mem);
$readmemh("rom/rom_control_94_0", uut_memory.main_memory_top.genblk1[2].genblk1[30].sram32x32$.mem);
$readmemh("rom/rom_control_95_0", uut_memory.main_memory_top.genblk1[2].genblk1[31].sram32x32$.mem);
$readmemh("rom/rom_control_96_0", uut_memory.main_memory_top.genblk1[3].genblk1[0].sram32x32$.mem);
$readmemh("rom/rom_control_97_0", uut_memory.main_memory_top.genblk1[3].genblk1[1].sram32x32$.mem);
$readmemh("rom/rom_control_98_0", uut_memory.main_memory_top.genblk1[3].genblk1[2].sram32x32$.mem);
$readmemh("rom/rom_control_99_0", uut_memory.main_memory_top.genblk1[3].genblk1[3].sram32x32$.mem);
$readmemh("rom/rom_control_100_0", uut_memory.main_memory_top.genblk1[3].genblk1[4].sram32x32$.mem);
$readmemh("rom/rom_control_101_0", uut_memory.main_memory_top.genblk1[3].genblk1[5].sram32x32$.mem);
$readmemh("rom/rom_control_102_0", uut_memory.main_memory_top.genblk1[3].genblk1[6].sram32x32$.mem);
$readmemh("rom/rom_control_103_0", uut_memory.main_memory_top.genblk1[3].genblk1[7].sram32x32$.mem);
$readmemh("rom/rom_control_104_0", uut_memory.main_memory_top.genblk1[3].genblk1[8].sram32x32$.mem);
$readmemh("rom/rom_control_105_0", uut_memory.main_memory_top.genblk1[3].genblk1[9].sram32x32$.mem);
$readmemh("rom/rom_control_106_0", uut_memory.main_memory_top.genblk1[3].genblk1[10].sram32x32$.mem);
$readmemh("rom/rom_control_107_0", uut_memory.main_memory_top.genblk1[3].genblk1[11].sram32x32$.mem);
$readmemh("rom/rom_control_108_0", uut_memory.main_memory_top.genblk1[3].genblk1[12].sram32x32$.mem);
$readmemh("rom/rom_control_109_0", uut_memory.main_memory_top.genblk1[3].genblk1[13].sram32x32$.mem);
$readmemh("rom/rom_control_110_0", uut_memory.main_memory_top.genblk1[3].genblk1[14].sram32x32$.mem);
$readmemh("rom/rom_control_111_0", uut_memory.main_memory_top.genblk1[3].genblk1[15].sram32x32$.mem);
$readmemh("rom/rom_control_112_0", uut_memory.main_memory_top.genblk1[3].genblk1[16].sram32x32$.mem);
$readmemh("rom/rom_control_113_0", uut_memory.main_memory_top.genblk1[3].genblk1[17].sram32x32$.mem);
$readmemh("rom/rom_control_114_0", uut_memory.main_memory_top.genblk1[3].genblk1[18].sram32x32$.mem);
$readmemh("rom/rom_control_115_0", uut_memory.main_memory_top.genblk1[3].genblk1[19].sram32x32$.mem);
$readmemh("rom/rom_control_116_0", uut_memory.main_memory_top.genblk1[3].genblk1[20].sram32x32$.mem);
$readmemh("rom/rom_control_117_0", uut_memory.main_memory_top.genblk1[3].genblk1[21].sram32x32$.mem);
$readmemh("rom/rom_control_118_0", uut_memory.main_memory_top.genblk1[3].genblk1[22].sram32x32$.mem);
$readmemh("rom/rom_control_119_0", uut_memory.main_memory_top.genblk1[3].genblk1[23].sram32x32$.mem);
$readmemh("rom/rom_control_120_0", uut_memory.main_memory_top.genblk1[3].genblk1[24].sram32x32$.mem);
$readmemh("rom/rom_control_121_0", uut_memory.main_memory_top.genblk1[3].genblk1[25].sram32x32$.mem);
$readmemh("rom/rom_control_122_0", uut_memory.main_memory_top.genblk1[3].genblk1[26].sram32x32$.mem);
$readmemh("rom/rom_control_123_0", uut_memory.main_memory_top.genblk1[3].genblk1[27].sram32x32$.mem);
$readmemh("rom/rom_control_124_0", uut_memory.main_memory_top.genblk1[3].genblk1[28].sram32x32$.mem);
$readmemh("rom/rom_control_125_0", uut_memory.main_memory_top.genblk1[3].genblk1[29].sram32x32$.mem);
$readmemh("rom/rom_control_126_0", uut_memory.main_memory_top.genblk1[3].genblk1[30].sram32x32$.mem);
$readmemh("rom/rom_control_127_0", uut_memory.main_memory_top.genblk1[3].genblk1[31].sram32x32$.mem);
$readmemh("rom/rom_control_128_0", uut_memory.main_memory_top.genblk1[4].genblk1[0].sram32x32$.mem);
$readmemh("rom/rom_control_129_0", uut_memory.main_memory_top.genblk1[4].genblk1[1].sram32x32$.mem);
$readmemh("rom/rom_control_130_0", uut_memory.main_memory_top.genblk1[4].genblk1[2].sram32x32$.mem);
$readmemh("rom/rom_control_131_0", uut_memory.main_memory_top.genblk1[4].genblk1[3].sram32x32$.mem);
$readmemh("rom/rom_control_132_0", uut_memory.main_memory_top.genblk1[4].genblk1[4].sram32x32$.mem);
$readmemh("rom/rom_control_133_0", uut_memory.main_memory_top.genblk1[4].genblk1[5].sram32x32$.mem);
$readmemh("rom/rom_control_134_0", uut_memory.main_memory_top.genblk1[4].genblk1[6].sram32x32$.mem);
$readmemh("rom/rom_control_135_0", uut_memory.main_memory_top.genblk1[4].genblk1[7].sram32x32$.mem);
$readmemh("rom/rom_control_136_0", uut_memory.main_memory_top.genblk1[4].genblk1[8].sram32x32$.mem);
$readmemh("rom/rom_control_137_0", uut_memory.main_memory_top.genblk1[4].genblk1[9].sram32x32$.mem);
$readmemh("rom/rom_control_138_0", uut_memory.main_memory_top.genblk1[4].genblk1[10].sram32x32$.mem);
$readmemh("rom/rom_control_139_0", uut_memory.main_memory_top.genblk1[4].genblk1[11].sram32x32$.mem);
$readmemh("rom/rom_control_140_0", uut_memory.main_memory_top.genblk1[4].genblk1[12].sram32x32$.mem);
$readmemh("rom/rom_control_141_0", uut_memory.main_memory_top.genblk1[4].genblk1[13].sram32x32$.mem);
$readmemh("rom/rom_control_142_0", uut_memory.main_memory_top.genblk1[4].genblk1[14].sram32x32$.mem);
$readmemh("rom/rom_control_143_0", uut_memory.main_memory_top.genblk1[4].genblk1[15].sram32x32$.mem);
$readmemh("rom/rom_control_144_0", uut_memory.main_memory_top.genblk1[4].genblk1[16].sram32x32$.mem);
$readmemh("rom/rom_control_145_0", uut_memory.main_memory_top.genblk1[4].genblk1[17].sram32x32$.mem);
$readmemh("rom/rom_control_146_0", uut_memory.main_memory_top.genblk1[4].genblk1[18].sram32x32$.mem);
$readmemh("rom/rom_control_147_0", uut_memory.main_memory_top.genblk1[4].genblk1[19].sram32x32$.mem);
$readmemh("rom/rom_control_148_0", uut_memory.main_memory_top.genblk1[4].genblk1[20].sram32x32$.mem);
$readmemh("rom/rom_control_149_0", uut_memory.main_memory_top.genblk1[4].genblk1[21].sram32x32$.mem);
$readmemh("rom/rom_control_150_0", uut_memory.main_memory_top.genblk1[4].genblk1[22].sram32x32$.mem);
$readmemh("rom/rom_control_151_0", uut_memory.main_memory_top.genblk1[4].genblk1[23].sram32x32$.mem);
$readmemh("rom/rom_control_152_0", uut_memory.main_memory_top.genblk1[4].genblk1[24].sram32x32$.mem);
$readmemh("rom/rom_control_153_0", uut_memory.main_memory_top.genblk1[4].genblk1[25].sram32x32$.mem);
$readmemh("rom/rom_control_154_0", uut_memory.main_memory_top.genblk1[4].genblk1[26].sram32x32$.mem);
$readmemh("rom/rom_control_155_0", uut_memory.main_memory_top.genblk1[4].genblk1[27].sram32x32$.mem);
$readmemh("rom/rom_control_156_0", uut_memory.main_memory_top.genblk1[4].genblk1[28].sram32x32$.mem);
$readmemh("rom/rom_control_157_0", uut_memory.main_memory_top.genblk1[4].genblk1[29].sram32x32$.mem);
$readmemh("rom/rom_control_158_0", uut_memory.main_memory_top.genblk1[4].genblk1[30].sram32x32$.mem);
$readmemh("rom/rom_control_159_0", uut_memory.main_memory_top.genblk1[4].genblk1[31].sram32x32$.mem);
$readmemh("rom/rom_control_160_0", uut_memory.main_memory_top.genblk1[5].genblk1[0].sram32x32$.mem);
$readmemh("rom/rom_control_161_0", uut_memory.main_memory_top.genblk1[5].genblk1[1].sram32x32$.mem);
$readmemh("rom/rom_control_162_0", uut_memory.main_memory_top.genblk1[5].genblk1[2].sram32x32$.mem);
$readmemh("rom/rom_control_163_0", uut_memory.main_memory_top.genblk1[5].genblk1[3].sram32x32$.mem);
$readmemh("rom/rom_control_164_0", uut_memory.main_memory_top.genblk1[5].genblk1[4].sram32x32$.mem);
$readmemh("rom/rom_control_165_0", uut_memory.main_memory_top.genblk1[5].genblk1[5].sram32x32$.mem);
$readmemh("rom/rom_control_166_0", uut_memory.main_memory_top.genblk1[5].genblk1[6].sram32x32$.mem);
$readmemh("rom/rom_control_167_0", uut_memory.main_memory_top.genblk1[5].genblk1[7].sram32x32$.mem);
$readmemh("rom/rom_control_168_0", uut_memory.main_memory_top.genblk1[5].genblk1[8].sram32x32$.mem);
$readmemh("rom/rom_control_169_0", uut_memory.main_memory_top.genblk1[5].genblk1[9].sram32x32$.mem);
$readmemh("rom/rom_control_170_0", uut_memory.main_memory_top.genblk1[5].genblk1[10].sram32x32$.mem);
$readmemh("rom/rom_control_171_0", uut_memory.main_memory_top.genblk1[5].genblk1[11].sram32x32$.mem);
$readmemh("rom/rom_control_172_0", uut_memory.main_memory_top.genblk1[5].genblk1[12].sram32x32$.mem);
$readmemh("rom/rom_control_173_0", uut_memory.main_memory_top.genblk1[5].genblk1[13].sram32x32$.mem);
$readmemh("rom/rom_control_174_0", uut_memory.main_memory_top.genblk1[5].genblk1[14].sram32x32$.mem);
$readmemh("rom/rom_control_175_0", uut_memory.main_memory_top.genblk1[5].genblk1[15].sram32x32$.mem);
$readmemh("rom/rom_control_176_0", uut_memory.main_memory_top.genblk1[5].genblk1[16].sram32x32$.mem);
$readmemh("rom/rom_control_177_0", uut_memory.main_memory_top.genblk1[5].genblk1[17].sram32x32$.mem);
$readmemh("rom/rom_control_178_0", uut_memory.main_memory_top.genblk1[5].genblk1[18].sram32x32$.mem);
$readmemh("rom/rom_control_179_0", uut_memory.main_memory_top.genblk1[5].genblk1[19].sram32x32$.mem);
$readmemh("rom/rom_control_180_0", uut_memory.main_memory_top.genblk1[5].genblk1[20].sram32x32$.mem);
$readmemh("rom/rom_control_181_0", uut_memory.main_memory_top.genblk1[5].genblk1[21].sram32x32$.mem);
$readmemh("rom/rom_control_182_0", uut_memory.main_memory_top.genblk1[5].genblk1[22].sram32x32$.mem);
$readmemh("rom/rom_control_183_0", uut_memory.main_memory_top.genblk1[5].genblk1[23].sram32x32$.mem);
$readmemh("rom/rom_control_184_0", uut_memory.main_memory_top.genblk1[5].genblk1[24].sram32x32$.mem);
$readmemh("rom/rom_control_185_0", uut_memory.main_memory_top.genblk1[5].genblk1[25].sram32x32$.mem);
$readmemh("rom/rom_control_186_0", uut_memory.main_memory_top.genblk1[5].genblk1[26].sram32x32$.mem);
$readmemh("rom/rom_control_187_0", uut_memory.main_memory_top.genblk1[5].genblk1[27].sram32x32$.mem);
$readmemh("rom/rom_control_188_0", uut_memory.main_memory_top.genblk1[5].genblk1[28].sram32x32$.mem);
$readmemh("rom/rom_control_189_0", uut_memory.main_memory_top.genblk1[5].genblk1[29].sram32x32$.mem);
$readmemh("rom/rom_control_190_0", uut_memory.main_memory_top.genblk1[5].genblk1[30].sram32x32$.mem);
$readmemh("rom/rom_control_191_0", uut_memory.main_memory_top.genblk1[5].genblk1[31].sram32x32$.mem);
$readmemh("rom/rom_control_192_0", uut_memory.main_memory_top.genblk1[6].genblk1[0].sram32x32$.mem);
$readmemh("rom/rom_control_193_0", uut_memory.main_memory_top.genblk1[6].genblk1[1].sram32x32$.mem);
$readmemh("rom/rom_control_194_0", uut_memory.main_memory_top.genblk1[6].genblk1[2].sram32x32$.mem);
$readmemh("rom/rom_control_195_0", uut_memory.main_memory_top.genblk1[6].genblk1[3].sram32x32$.mem);
$readmemh("rom/rom_control_196_0", uut_memory.main_memory_top.genblk1[6].genblk1[4].sram32x32$.mem);
$readmemh("rom/rom_control_197_0", uut_memory.main_memory_top.genblk1[6].genblk1[5].sram32x32$.mem);
$readmemh("rom/rom_control_198_0", uut_memory.main_memory_top.genblk1[6].genblk1[6].sram32x32$.mem);
$readmemh("rom/rom_control_199_0", uut_memory.main_memory_top.genblk1[6].genblk1[7].sram32x32$.mem);
$readmemh("rom/rom_control_200_0", uut_memory.main_memory_top.genblk1[6].genblk1[8].sram32x32$.mem);
$readmemh("rom/rom_control_201_0", uut_memory.main_memory_top.genblk1[6].genblk1[9].sram32x32$.mem);
$readmemh("rom/rom_control_202_0", uut_memory.main_memory_top.genblk1[6].genblk1[10].sram32x32$.mem);
$readmemh("rom/rom_control_203_0", uut_memory.main_memory_top.genblk1[6].genblk1[11].sram32x32$.mem);
$readmemh("rom/rom_control_204_0", uut_memory.main_memory_top.genblk1[6].genblk1[12].sram32x32$.mem);
$readmemh("rom/rom_control_205_0", uut_memory.main_memory_top.genblk1[6].genblk1[13].sram32x32$.mem);
$readmemh("rom/rom_control_206_0", uut_memory.main_memory_top.genblk1[6].genblk1[14].sram32x32$.mem);
$readmemh("rom/rom_control_207_0", uut_memory.main_memory_top.genblk1[6].genblk1[15].sram32x32$.mem);
$readmemh("rom/rom_control_208_0", uut_memory.main_memory_top.genblk1[6].genblk1[16].sram32x32$.mem);
$readmemh("rom/rom_control_209_0", uut_memory.main_memory_top.genblk1[6].genblk1[17].sram32x32$.mem);
$readmemh("rom/rom_control_210_0", uut_memory.main_memory_top.genblk1[6].genblk1[18].sram32x32$.mem);
$readmemh("rom/rom_control_211_0", uut_memory.main_memory_top.genblk1[6].genblk1[19].sram32x32$.mem);
$readmemh("rom/rom_control_212_0", uut_memory.main_memory_top.genblk1[6].genblk1[20].sram32x32$.mem);
$readmemh("rom/rom_control_213_0", uut_memory.main_memory_top.genblk1[6].genblk1[21].sram32x32$.mem);
$readmemh("rom/rom_control_214_0", uut_memory.main_memory_top.genblk1[6].genblk1[22].sram32x32$.mem);
$readmemh("rom/rom_control_215_0", uut_memory.main_memory_top.genblk1[6].genblk1[23].sram32x32$.mem);
$readmemh("rom/rom_control_216_0", uut_memory.main_memory_top.genblk1[6].genblk1[24].sram32x32$.mem);
$readmemh("rom/rom_control_217_0", uut_memory.main_memory_top.genblk1[6].genblk1[25].sram32x32$.mem);
$readmemh("rom/rom_control_218_0", uut_memory.main_memory_top.genblk1[6].genblk1[26].sram32x32$.mem);
$readmemh("rom/rom_control_219_0", uut_memory.main_memory_top.genblk1[6].genblk1[27].sram32x32$.mem);
$readmemh("rom/rom_control_220_0", uut_memory.main_memory_top.genblk1[6].genblk1[28].sram32x32$.mem);
$readmemh("rom/rom_control_221_0", uut_memory.main_memory_top.genblk1[6].genblk1[29].sram32x32$.mem);
$readmemh("rom/rom_control_222_0", uut_memory.main_memory_top.genblk1[6].genblk1[30].sram32x32$.mem);
$readmemh("rom/rom_control_223_0", uut_memory.main_memory_top.genblk1[6].genblk1[31].sram32x32$.mem);
$readmemh("rom/rom_control_224_0", uut_memory.main_memory_top.genblk1[7].genblk1[0].sram32x32$.mem);
$readmemh("rom/rom_control_225_0", uut_memory.main_memory_top.genblk1[7].genblk1[1].sram32x32$.mem);
$readmemh("rom/rom_control_226_0", uut_memory.main_memory_top.genblk1[7].genblk1[2].sram32x32$.mem);
$readmemh("rom/rom_control_227_0", uut_memory.main_memory_top.genblk1[7].genblk1[3].sram32x32$.mem);
$readmemh("rom/rom_control_228_0", uut_memory.main_memory_top.genblk1[7].genblk1[4].sram32x32$.mem);
$readmemh("rom/rom_control_229_0", uut_memory.main_memory_top.genblk1[7].genblk1[5].sram32x32$.mem);
$readmemh("rom/rom_control_230_0", uut_memory.main_memory_top.genblk1[7].genblk1[6].sram32x32$.mem);
$readmemh("rom/rom_control_231_0", uut_memory.main_memory_top.genblk1[7].genblk1[7].sram32x32$.mem);
$readmemh("rom/rom_control_232_0", uut_memory.main_memory_top.genblk1[7].genblk1[8].sram32x32$.mem);
$readmemh("rom/rom_control_233_0", uut_memory.main_memory_top.genblk1[7].genblk1[9].sram32x32$.mem);
$readmemh("rom/rom_control_234_0", uut_memory.main_memory_top.genblk1[7].genblk1[10].sram32x32$.mem);
$readmemh("rom/rom_control_235_0", uut_memory.main_memory_top.genblk1[7].genblk1[11].sram32x32$.mem);
$readmemh("rom/rom_control_236_0", uut_memory.main_memory_top.genblk1[7].genblk1[12].sram32x32$.mem);
$readmemh("rom/rom_control_237_0", uut_memory.main_memory_top.genblk1[7].genblk1[13].sram32x32$.mem);
$readmemh("rom/rom_control_238_0", uut_memory.main_memory_top.genblk1[7].genblk1[14].sram32x32$.mem);
$readmemh("rom/rom_control_239_0", uut_memory.main_memory_top.genblk1[7].genblk1[15].sram32x32$.mem);
$readmemh("rom/rom_control_240_0", uut_memory.main_memory_top.genblk1[7].genblk1[16].sram32x32$.mem);
$readmemh("rom/rom_control_241_0", uut_memory.main_memory_top.genblk1[7].genblk1[17].sram32x32$.mem);
$readmemh("rom/rom_control_242_0", uut_memory.main_memory_top.genblk1[7].genblk1[18].sram32x32$.mem);
$readmemh("rom/rom_control_243_0", uut_memory.main_memory_top.genblk1[7].genblk1[19].sram32x32$.mem);
$readmemh("rom/rom_control_244_0", uut_memory.main_memory_top.genblk1[7].genblk1[20].sram32x32$.mem);
$readmemh("rom/rom_control_245_0", uut_memory.main_memory_top.genblk1[7].genblk1[21].sram32x32$.mem);
$readmemh("rom/rom_control_246_0", uut_memory.main_memory_top.genblk1[7].genblk1[22].sram32x32$.mem);
$readmemh("rom/rom_control_247_0", uut_memory.main_memory_top.genblk1[7].genblk1[23].sram32x32$.mem);
$readmemh("rom/rom_control_248_0", uut_memory.main_memory_top.genblk1[7].genblk1[24].sram32x32$.mem);
$readmemh("rom/rom_control_249_0", uut_memory.main_memory_top.genblk1[7].genblk1[25].sram32x32$.mem);
$readmemh("rom/rom_control_250_0", uut_memory.main_memory_top.genblk1[7].genblk1[26].sram32x32$.mem);
$readmemh("rom/rom_control_251_0", uut_memory.main_memory_top.genblk1[7].genblk1[27].sram32x32$.mem);
$readmemh("rom/rom_control_252_0", uut_memory.main_memory_top.genblk1[7].genblk1[28].sram32x32$.mem);
$readmemh("rom/rom_control_253_0", uut_memory.main_memory_top.genblk1[7].genblk1[29].sram32x32$.mem);
$readmemh("rom/rom_control_254_0", uut_memory.main_memory_top.genblk1[7].genblk1[30].sram32x32$.mem);
$readmemh("rom/rom_control_255_0", uut_memory.main_memory_top.genblk1[7].genblk1[31].sram32x32$.mem);
     
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
   
  initial #200000 $finish;

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
   
  always #25 clk          = ~clk;

  initial begin
        $vcdplusfile("fsys_reg.dump.vpd");
        $vcdpluson(0, TOP);
  end

endmodule // TOP
