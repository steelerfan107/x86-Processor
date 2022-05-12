// tb_icache.v
// 

// Testbench for ICache

module TOP;
    // wires and regs

    reg clk;
    reg reset;
   
    // read interface 
    reg rd_req_valid;
    wire rd_req_ready;
    reg [31:0] rd_req_address;
    wire rd_dp_valid;
    reg rd_dp_ready;
    wire [63:0] rd_dp_read_data;

    // write interface
    // TODO ...
    reg wr_req_valid;
    wire wr_req_ready;
    reg [31:0] wr_req_address;
    reg [63:0] wr_req_data;
    reg wr_size_in;

    // interrupt
    wire page_fault;

    // interface to interconnect
    wire [31:0] mem_addr;
    wire mem_req;
    wire mem_data_valid;
    wire [31:0] mem_data;
    wire mem_rd_wr;
    wire mem_en;
    wire [1:0] mem_wr_size;

    // Arbiter Interface
    reg grant_in;
    wire grant_out;

    wire bus_busy_out;
    reg bus_busy_in;



    reg [43:0] contents [0:7];
    
    // icache port
    wire [31:0] i_addr_in;
    wire i_hit;
    wire i_rd_wr_out;
    wire i_PCD_out;
    wire [31:0] i_pa_out;

    // dcache port
    wire [31:0] d_addr_in;
    wire d_hit;
    wire d_rd_wr_out;
    wire d_PCD_out;
    wire [31:0] d_pa_out;

    assign d_addr_in = i_addr_in;

    wire [351:0] contents_concat;

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

    TLB tlb(
        contents_concat,
        
        // icache port
        d_addr_in,
        i_hit,
        i_rd_wr_out,
        i_pa_out,
        i_PCD_out,

        // dcache port
        d_addr_in,
        d_hit,
        d_rd_wr_out,
        d_pa_out,
        d_PCD_out
    );
   
    reg [5:0] in;
    wire [63:0] out;
 
    dcache uut(
        .clk(clk),
        .reset(reset),
    
        // read interface 
        .rd_req_valid(rd_req_valid),
        .rd_req_ready(rd_req_ready),
        .rd_req_address(rd_req_address),
        .rd_dp_valid(rd_dp_valid),
        .rd_dp_ready(rd_dp_ready),
        .rd_dp_read_data(rd_dp_read_data),

        //  TLB
        .virt_addr(d_addr_in),
        .phys_addr(d_pa_out),
        .tlb_hit(d_hit),
        .tlb_pcd(d_PCD_out),
        .tlb_rd_wr(d_rd_wr_out),

        // write interface
        // TODO ...
        .wr_req_valid(wr_req_valid),
        .wr_req_ready(wr_req_ready),
        .wr_req_address(wr_req_address),
        .wr_req_data(wr_req_data),
        .wr_size_in(wr_size_in),

        // interrupt
        .page_fault(page_fault),

        // interface to interconnect
        .mem_addr(mem_addr),
        .mem_req(mem_req),
        .mem_data_valid(mem_data_valid),
        .mem_data(mem_data),
        .mem_rd_wr(mem_rd_wr),
        .mem_en(mem_en),
        .mem_wr_size(mem_wr_size),

        // Arbiter Interface
        .grant_in(grant_in),
        .grant_out(grant_out),

        .bus_busy_out(bus_busy_out),
        .bus_busy_in(bus_busy_in)
    );


    main_memory_top uut_memory(
        clk,
        reset,
        mem_en,
        mem_rd_wr,
        mem_wr_size,
        mem_addr,
        mem_data,
        mem_data_valid
    );

    //test_memory mem(
    //    clk,
    //    reset,
    //    mem_addr,
    //    mem_en,
    //    mem_data_valid,
    //    mem_data,
    //    mem_rd_wr
    //);

    initial begin
$readmemh("rom/rom_control_0_0", uut_memory.genblk1[0].genblk1[0].sram32x32$.mem);
$readmemh("rom/rom_control_1_0", uut_memory.genblk1[0].genblk1[1].sram32x32$.mem);
$readmemh("rom/rom_control_2_0", uut_memory.genblk1[0].genblk1[2].sram32x32$.mem);
$readmemh("rom/rom_control_3_0", uut_memory.genblk1[0].genblk1[3].sram32x32$.mem);
$readmemh("rom/rom_control_4_0", uut_memory.genblk1[0].genblk1[4].sram32x32$.mem);
$readmemh("rom/rom_control_5_0", uut_memory.genblk1[0].genblk1[5].sram32x32$.mem);
$readmemh("rom/rom_control_6_0", uut_memory.genblk1[0].genblk1[6].sram32x32$.mem);
$readmemh("rom/rom_control_7_0", uut_memory.genblk1[0].genblk1[7].sram32x32$.mem);
$readmemh("rom/rom_control_8_0", uut_memory.genblk1[0].genblk1[8].sram32x32$.mem);
$readmemh("rom/rom_control_9_0", uut_memory.genblk1[0].genblk1[9].sram32x32$.mem);
$readmemh("rom/rom_control_10_0", uut_memory.genblk1[0].genblk1[10].sram32x32$.mem);
$readmemh("rom/rom_control_11_0", uut_memory.genblk1[0].genblk1[11].sram32x32$.mem);
$readmemh("rom/rom_control_12_0", uut_memory.genblk1[0].genblk1[12].sram32x32$.mem);
$readmemh("rom/rom_control_13_0", uut_memory.genblk1[0].genblk1[13].sram32x32$.mem);
$readmemh("rom/rom_control_14_0", uut_memory.genblk1[0].genblk1[14].sram32x32$.mem);
$readmemh("rom/rom_control_15_0", uut_memory.genblk1[0].genblk1[15].sram32x32$.mem);
$readmemh("rom/rom_control_16_0", uut_memory.genblk1[0].genblk1[16].sram32x32$.mem);
$readmemh("rom/rom_control_17_0", uut_memory.genblk1[0].genblk1[17].sram32x32$.mem);
$readmemh("rom/rom_control_18_0", uut_memory.genblk1[0].genblk1[18].sram32x32$.mem);
$readmemh("rom/rom_control_19_0", uut_memory.genblk1[0].genblk1[19].sram32x32$.mem);
$readmemh("rom/rom_control_20_0", uut_memory.genblk1[0].genblk1[20].sram32x32$.mem);
$readmemh("rom/rom_control_21_0", uut_memory.genblk1[0].genblk1[21].sram32x32$.mem);
$readmemh("rom/rom_control_22_0", uut_memory.genblk1[0].genblk1[22].sram32x32$.mem);
$readmemh("rom/rom_control_23_0", uut_memory.genblk1[0].genblk1[23].sram32x32$.mem);
$readmemh("rom/rom_control_24_0", uut_memory.genblk1[0].genblk1[24].sram32x32$.mem);
$readmemh("rom/rom_control_25_0", uut_memory.genblk1[0].genblk1[25].sram32x32$.mem);
$readmemh("rom/rom_control_26_0", uut_memory.genblk1[0].genblk1[26].sram32x32$.mem);
$readmemh("rom/rom_control_27_0", uut_memory.genblk1[0].genblk1[27].sram32x32$.mem);
$readmemh("rom/rom_control_28_0", uut_memory.genblk1[0].genblk1[28].sram32x32$.mem);
$readmemh("rom/rom_control_29_0", uut_memory.genblk1[0].genblk1[29].sram32x32$.mem);
$readmemh("rom/rom_control_30_0", uut_memory.genblk1[0].genblk1[30].sram32x32$.mem);
$readmemh("rom/rom_control_31_0", uut_memory.genblk1[0].genblk1[31].sram32x32$.mem);
$readmemh("rom/rom_control_32_0", uut_memory.genblk1[1].genblk1[0].sram32x32$.mem);
$readmemh("rom/rom_control_33_0", uut_memory.genblk1[1].genblk1[1].sram32x32$.mem);
$readmemh("rom/rom_control_34_0", uut_memory.genblk1[1].genblk1[2].sram32x32$.mem);
$readmemh("rom/rom_control_35_0", uut_memory.genblk1[1].genblk1[3].sram32x32$.mem);
$readmemh("rom/rom_control_36_0", uut_memory.genblk1[1].genblk1[4].sram32x32$.mem);
$readmemh("rom/rom_control_37_0", uut_memory.genblk1[1].genblk1[5].sram32x32$.mem);
$readmemh("rom/rom_control_38_0", uut_memory.genblk1[1].genblk1[6].sram32x32$.mem);
$readmemh("rom/rom_control_39_0", uut_memory.genblk1[1].genblk1[7].sram32x32$.mem);
$readmemh("rom/rom_control_40_0", uut_memory.genblk1[1].genblk1[8].sram32x32$.mem);
$readmemh("rom/rom_control_41_0", uut_memory.genblk1[1].genblk1[9].sram32x32$.mem);
$readmemh("rom/rom_control_42_0", uut_memory.genblk1[1].genblk1[10].sram32x32$.mem);
$readmemh("rom/rom_control_43_0", uut_memory.genblk1[1].genblk1[11].sram32x32$.mem);
$readmemh("rom/rom_control_44_0", uut_memory.genblk1[1].genblk1[12].sram32x32$.mem);
$readmemh("rom/rom_control_45_0", uut_memory.genblk1[1].genblk1[13].sram32x32$.mem);
$readmemh("rom/rom_control_46_0", uut_memory.genblk1[1].genblk1[14].sram32x32$.mem);
$readmemh("rom/rom_control_47_0", uut_memory.genblk1[1].genblk1[15].sram32x32$.mem);
$readmemh("rom/rom_control_48_0", uut_memory.genblk1[1].genblk1[16].sram32x32$.mem);
$readmemh("rom/rom_control_49_0", uut_memory.genblk1[1].genblk1[17].sram32x32$.mem);
$readmemh("rom/rom_control_50_0", uut_memory.genblk1[1].genblk1[18].sram32x32$.mem);
$readmemh("rom/rom_control_51_0", uut_memory.genblk1[1].genblk1[19].sram32x32$.mem);
$readmemh("rom/rom_control_52_0", uut_memory.genblk1[1].genblk1[20].sram32x32$.mem);
$readmemh("rom/rom_control_53_0", uut_memory.genblk1[1].genblk1[21].sram32x32$.mem);
$readmemh("rom/rom_control_54_0", uut_memory.genblk1[1].genblk1[22].sram32x32$.mem);
$readmemh("rom/rom_control_55_0", uut_memory.genblk1[1].genblk1[23].sram32x32$.mem);
$readmemh("rom/rom_control_56_0", uut_memory.genblk1[1].genblk1[24].sram32x32$.mem);
$readmemh("rom/rom_control_57_0", uut_memory.genblk1[1].genblk1[25].sram32x32$.mem);
$readmemh("rom/rom_control_58_0", uut_memory.genblk1[1].genblk1[26].sram32x32$.mem);
$readmemh("rom/rom_control_59_0", uut_memory.genblk1[1].genblk1[27].sram32x32$.mem);
$readmemh("rom/rom_control_60_0", uut_memory.genblk1[1].genblk1[28].sram32x32$.mem);
$readmemh("rom/rom_control_61_0", uut_memory.genblk1[1].genblk1[29].sram32x32$.mem);
$readmemh("rom/rom_control_62_0", uut_memory.genblk1[1].genblk1[30].sram32x32$.mem);
$readmemh("rom/rom_control_63_0", uut_memory.genblk1[1].genblk1[31].sram32x32$.mem);
$readmemh("rom/rom_control_64_0", uut_memory.genblk1[2].genblk1[0].sram32x32$.mem);
$readmemh("rom/rom_control_65_0", uut_memory.genblk1[2].genblk1[1].sram32x32$.mem);
$readmemh("rom/rom_control_66_0", uut_memory.genblk1[2].genblk1[2].sram32x32$.mem);
$readmemh("rom/rom_control_67_0", uut_memory.genblk1[2].genblk1[3].sram32x32$.mem);
$readmemh("rom/rom_control_68_0", uut_memory.genblk1[2].genblk1[4].sram32x32$.mem);
$readmemh("rom/rom_control_69_0", uut_memory.genblk1[2].genblk1[5].sram32x32$.mem);
$readmemh("rom/rom_control_70_0", uut_memory.genblk1[2].genblk1[6].sram32x32$.mem);
$readmemh("rom/rom_control_71_0", uut_memory.genblk1[2].genblk1[7].sram32x32$.mem);
$readmemh("rom/rom_control_72_0", uut_memory.genblk1[2].genblk1[8].sram32x32$.mem);
$readmemh("rom/rom_control_73_0", uut_memory.genblk1[2].genblk1[9].sram32x32$.mem);
$readmemh("rom/rom_control_74_0", uut_memory.genblk1[2].genblk1[10].sram32x32$.mem);
$readmemh("rom/rom_control_75_0", uut_memory.genblk1[2].genblk1[11].sram32x32$.mem);
$readmemh("rom/rom_control_76_0", uut_memory.genblk1[2].genblk1[12].sram32x32$.mem);
$readmemh("rom/rom_control_77_0", uut_memory.genblk1[2].genblk1[13].sram32x32$.mem);
$readmemh("rom/rom_control_78_0", uut_memory.genblk1[2].genblk1[14].sram32x32$.mem);
$readmemh("rom/rom_control_79_0", uut_memory.genblk1[2].genblk1[15].sram32x32$.mem);
$readmemh("rom/rom_control_80_0", uut_memory.genblk1[2].genblk1[16].sram32x32$.mem);
$readmemh("rom/rom_control_81_0", uut_memory.genblk1[2].genblk1[17].sram32x32$.mem);
$readmemh("rom/rom_control_82_0", uut_memory.genblk1[2].genblk1[18].sram32x32$.mem);
$readmemh("rom/rom_control_83_0", uut_memory.genblk1[2].genblk1[19].sram32x32$.mem);
$readmemh("rom/rom_control_84_0", uut_memory.genblk1[2].genblk1[20].sram32x32$.mem);
$readmemh("rom/rom_control_85_0", uut_memory.genblk1[2].genblk1[21].sram32x32$.mem);
$readmemh("rom/rom_control_86_0", uut_memory.genblk1[2].genblk1[22].sram32x32$.mem);
$readmemh("rom/rom_control_87_0", uut_memory.genblk1[2].genblk1[23].sram32x32$.mem);
$readmemh("rom/rom_control_88_0", uut_memory.genblk1[2].genblk1[24].sram32x32$.mem);
$readmemh("rom/rom_control_89_0", uut_memory.genblk1[2].genblk1[25].sram32x32$.mem);
$readmemh("rom/rom_control_90_0", uut_memory.genblk1[2].genblk1[26].sram32x32$.mem);
$readmemh("rom/rom_control_91_0", uut_memory.genblk1[2].genblk1[27].sram32x32$.mem);
$readmemh("rom/rom_control_92_0", uut_memory.genblk1[2].genblk1[28].sram32x32$.mem);
$readmemh("rom/rom_control_93_0", uut_memory.genblk1[2].genblk1[29].sram32x32$.mem);
$readmemh("rom/rom_control_94_0", uut_memory.genblk1[2].genblk1[30].sram32x32$.mem);
$readmemh("rom/rom_control_95_0", uut_memory.genblk1[2].genblk1[31].sram32x32$.mem);
$readmemh("rom/rom_control_96_0", uut_memory.genblk1[3].genblk1[0].sram32x32$.mem);
$readmemh("rom/rom_control_97_0", uut_memory.genblk1[3].genblk1[1].sram32x32$.mem);
$readmemh("rom/rom_control_98_0", uut_memory.genblk1[3].genblk1[2].sram32x32$.mem);
$readmemh("rom/rom_control_99_0", uut_memory.genblk1[3].genblk1[3].sram32x32$.mem);
$readmemh("rom/rom_control_100_0", uut_memory.genblk1[3].genblk1[4].sram32x32$.mem);
$readmemh("rom/rom_control_101_0", uut_memory.genblk1[3].genblk1[5].sram32x32$.mem);
$readmemh("rom/rom_control_102_0", uut_memory.genblk1[3].genblk1[6].sram32x32$.mem);
$readmemh("rom/rom_control_103_0", uut_memory.genblk1[3].genblk1[7].sram32x32$.mem);
$readmemh("rom/rom_control_104_0", uut_memory.genblk1[3].genblk1[8].sram32x32$.mem);
$readmemh("rom/rom_control_105_0", uut_memory.genblk1[3].genblk1[9].sram32x32$.mem);
$readmemh("rom/rom_control_106_0", uut_memory.genblk1[3].genblk1[10].sram32x32$.mem);
$readmemh("rom/rom_control_107_0", uut_memory.genblk1[3].genblk1[11].sram32x32$.mem);
$readmemh("rom/rom_control_108_0", uut_memory.genblk1[3].genblk1[12].sram32x32$.mem);
$readmemh("rom/rom_control_109_0", uut_memory.genblk1[3].genblk1[13].sram32x32$.mem);
$readmemh("rom/rom_control_110_0", uut_memory.genblk1[3].genblk1[14].sram32x32$.mem);
$readmemh("rom/rom_control_111_0", uut_memory.genblk1[3].genblk1[15].sram32x32$.mem);
$readmemh("rom/rom_control_112_0", uut_memory.genblk1[3].genblk1[16].sram32x32$.mem);
$readmemh("rom/rom_control_113_0", uut_memory.genblk1[3].genblk1[17].sram32x32$.mem);
$readmemh("rom/rom_control_114_0", uut_memory.genblk1[3].genblk1[18].sram32x32$.mem);
$readmemh("rom/rom_control_115_0", uut_memory.genblk1[3].genblk1[19].sram32x32$.mem);
$readmemh("rom/rom_control_116_0", uut_memory.genblk1[3].genblk1[20].sram32x32$.mem);
$readmemh("rom/rom_control_117_0", uut_memory.genblk1[3].genblk1[21].sram32x32$.mem);
$readmemh("rom/rom_control_118_0", uut_memory.genblk1[3].genblk1[22].sram32x32$.mem);
$readmemh("rom/rom_control_119_0", uut_memory.genblk1[3].genblk1[23].sram32x32$.mem);
$readmemh("rom/rom_control_120_0", uut_memory.genblk1[3].genblk1[24].sram32x32$.mem);
$readmemh("rom/rom_control_121_0", uut_memory.genblk1[3].genblk1[25].sram32x32$.mem);
$readmemh("rom/rom_control_122_0", uut_memory.genblk1[3].genblk1[26].sram32x32$.mem);
$readmemh("rom/rom_control_123_0", uut_memory.genblk1[3].genblk1[27].sram32x32$.mem);
$readmemh("rom/rom_control_124_0", uut_memory.genblk1[3].genblk1[28].sram32x32$.mem);
$readmemh("rom/rom_control_125_0", uut_memory.genblk1[3].genblk1[29].sram32x32$.mem);
$readmemh("rom/rom_control_126_0", uut_memory.genblk1[3].genblk1[30].sram32x32$.mem);
$readmemh("rom/rom_control_127_0", uut_memory.genblk1[3].genblk1[31].sram32x32$.mem);
$readmemh("rom/rom_control_128_0", uut_memory.genblk1[4].genblk1[0].sram32x32$.mem);
$readmemh("rom/rom_control_129_0", uut_memory.genblk1[4].genblk1[1].sram32x32$.mem);
$readmemh("rom/rom_control_130_0", uut_memory.genblk1[4].genblk1[2].sram32x32$.mem);
$readmemh("rom/rom_control_131_0", uut_memory.genblk1[4].genblk1[3].sram32x32$.mem);
$readmemh("rom/rom_control_132_0", uut_memory.genblk1[4].genblk1[4].sram32x32$.mem);
$readmemh("rom/rom_control_133_0", uut_memory.genblk1[4].genblk1[5].sram32x32$.mem);
$readmemh("rom/rom_control_134_0", uut_memory.genblk1[4].genblk1[6].sram32x32$.mem);
$readmemh("rom/rom_control_135_0", uut_memory.genblk1[4].genblk1[7].sram32x32$.mem);
$readmemh("rom/rom_control_136_0", uut_memory.genblk1[4].genblk1[8].sram32x32$.mem);
$readmemh("rom/rom_control_137_0", uut_memory.genblk1[4].genblk1[9].sram32x32$.mem);
$readmemh("rom/rom_control_138_0", uut_memory.genblk1[4].genblk1[10].sram32x32$.mem);
$readmemh("rom/rom_control_139_0", uut_memory.genblk1[4].genblk1[11].sram32x32$.mem);
$readmemh("rom/rom_control_140_0", uut_memory.genblk1[4].genblk1[12].sram32x32$.mem);
$readmemh("rom/rom_control_141_0", uut_memory.genblk1[4].genblk1[13].sram32x32$.mem);
$readmemh("rom/rom_control_142_0", uut_memory.genblk1[4].genblk1[14].sram32x32$.mem);
$readmemh("rom/rom_control_143_0", uut_memory.genblk1[4].genblk1[15].sram32x32$.mem);
$readmemh("rom/rom_control_144_0", uut_memory.genblk1[4].genblk1[16].sram32x32$.mem);
$readmemh("rom/rom_control_145_0", uut_memory.genblk1[4].genblk1[17].sram32x32$.mem);
$readmemh("rom/rom_control_146_0", uut_memory.genblk1[4].genblk1[18].sram32x32$.mem);
$readmemh("rom/rom_control_147_0", uut_memory.genblk1[4].genblk1[19].sram32x32$.mem);
$readmemh("rom/rom_control_148_0", uut_memory.genblk1[4].genblk1[20].sram32x32$.mem);
$readmemh("rom/rom_control_149_0", uut_memory.genblk1[4].genblk1[21].sram32x32$.mem);
$readmemh("rom/rom_control_150_0", uut_memory.genblk1[4].genblk1[22].sram32x32$.mem);
$readmemh("rom/rom_control_151_0", uut_memory.genblk1[4].genblk1[23].sram32x32$.mem);
$readmemh("rom/rom_control_152_0", uut_memory.genblk1[4].genblk1[24].sram32x32$.mem);
$readmemh("rom/rom_control_153_0", uut_memory.genblk1[4].genblk1[25].sram32x32$.mem);
$readmemh("rom/rom_control_154_0", uut_memory.genblk1[4].genblk1[26].sram32x32$.mem);
$readmemh("rom/rom_control_155_0", uut_memory.genblk1[4].genblk1[27].sram32x32$.mem);
$readmemh("rom/rom_control_156_0", uut_memory.genblk1[4].genblk1[28].sram32x32$.mem);
$readmemh("rom/rom_control_157_0", uut_memory.genblk1[4].genblk1[29].sram32x32$.mem);
$readmemh("rom/rom_control_158_0", uut_memory.genblk1[4].genblk1[30].sram32x32$.mem);
$readmemh("rom/rom_control_159_0", uut_memory.genblk1[4].genblk1[31].sram32x32$.mem);
$readmemh("rom/rom_control_160_0", uut_memory.genblk1[5].genblk1[0].sram32x32$.mem);
$readmemh("rom/rom_control_161_0", uut_memory.genblk1[5].genblk1[1].sram32x32$.mem);
$readmemh("rom/rom_control_162_0", uut_memory.genblk1[5].genblk1[2].sram32x32$.mem);
$readmemh("rom/rom_control_163_0", uut_memory.genblk1[5].genblk1[3].sram32x32$.mem);
$readmemh("rom/rom_control_164_0", uut_memory.genblk1[5].genblk1[4].sram32x32$.mem);
$readmemh("rom/rom_control_165_0", uut_memory.genblk1[5].genblk1[5].sram32x32$.mem);
$readmemh("rom/rom_control_166_0", uut_memory.genblk1[5].genblk1[6].sram32x32$.mem);
$readmemh("rom/rom_control_167_0", uut_memory.genblk1[5].genblk1[7].sram32x32$.mem);
$readmemh("rom/rom_control_168_0", uut_memory.genblk1[5].genblk1[8].sram32x32$.mem);
$readmemh("rom/rom_control_169_0", uut_memory.genblk1[5].genblk1[9].sram32x32$.mem);
$readmemh("rom/rom_control_170_0", uut_memory.genblk1[5].genblk1[10].sram32x32$.mem);
$readmemh("rom/rom_control_171_0", uut_memory.genblk1[5].genblk1[11].sram32x32$.mem);
$readmemh("rom/rom_control_172_0", uut_memory.genblk1[5].genblk1[12].sram32x32$.mem);
$readmemh("rom/rom_control_173_0", uut_memory.genblk1[5].genblk1[13].sram32x32$.mem);
$readmemh("rom/rom_control_174_0", uut_memory.genblk1[5].genblk1[14].sram32x32$.mem);
$readmemh("rom/rom_control_175_0", uut_memory.genblk1[5].genblk1[15].sram32x32$.mem);
$readmemh("rom/rom_control_176_0", uut_memory.genblk1[5].genblk1[16].sram32x32$.mem);
$readmemh("rom/rom_control_177_0", uut_memory.genblk1[5].genblk1[17].sram32x32$.mem);
$readmemh("rom/rom_control_178_0", uut_memory.genblk1[5].genblk1[18].sram32x32$.mem);
$readmemh("rom/rom_control_179_0", uut_memory.genblk1[5].genblk1[19].sram32x32$.mem);
$readmemh("rom/rom_control_180_0", uut_memory.genblk1[5].genblk1[20].sram32x32$.mem);
$readmemh("rom/rom_control_181_0", uut_memory.genblk1[5].genblk1[21].sram32x32$.mem);
$readmemh("rom/rom_control_182_0", uut_memory.genblk1[5].genblk1[22].sram32x32$.mem);
$readmemh("rom/rom_control_183_0", uut_memory.genblk1[5].genblk1[23].sram32x32$.mem);
$readmemh("rom/rom_control_184_0", uut_memory.genblk1[5].genblk1[24].sram32x32$.mem);
$readmemh("rom/rom_control_185_0", uut_memory.genblk1[5].genblk1[25].sram32x32$.mem);
$readmemh("rom/rom_control_186_0", uut_memory.genblk1[5].genblk1[26].sram32x32$.mem);
$readmemh("rom/rom_control_187_0", uut_memory.genblk1[5].genblk1[27].sram32x32$.mem);
$readmemh("rom/rom_control_188_0", uut_memory.genblk1[5].genblk1[28].sram32x32$.mem);
$readmemh("rom/rom_control_189_0", uut_memory.genblk1[5].genblk1[29].sram32x32$.mem);
$readmemh("rom/rom_control_190_0", uut_memory.genblk1[5].genblk1[30].sram32x32$.mem);
$readmemh("rom/rom_control_191_0", uut_memory.genblk1[5].genblk1[31].sram32x32$.mem);
$readmemh("rom/rom_control_192_0", uut_memory.genblk1[6].genblk1[0].sram32x32$.mem);
$readmemh("rom/rom_control_193_0", uut_memory.genblk1[6].genblk1[1].sram32x32$.mem);
$readmemh("rom/rom_control_194_0", uut_memory.genblk1[6].genblk1[2].sram32x32$.mem);
$readmemh("rom/rom_control_195_0", uut_memory.genblk1[6].genblk1[3].sram32x32$.mem);
$readmemh("rom/rom_control_196_0", uut_memory.genblk1[6].genblk1[4].sram32x32$.mem);
$readmemh("rom/rom_control_197_0", uut_memory.genblk1[6].genblk1[5].sram32x32$.mem);
$readmemh("rom/rom_control_198_0", uut_memory.genblk1[6].genblk1[6].sram32x32$.mem);
$readmemh("rom/rom_control_199_0", uut_memory.genblk1[6].genblk1[7].sram32x32$.mem);
$readmemh("rom/rom_control_200_0", uut_memory.genblk1[6].genblk1[8].sram32x32$.mem);
$readmemh("rom/rom_control_201_0", uut_memory.genblk1[6].genblk1[9].sram32x32$.mem);
$readmemh("rom/rom_control_202_0", uut_memory.genblk1[6].genblk1[10].sram32x32$.mem);
$readmemh("rom/rom_control_203_0", uut_memory.genblk1[6].genblk1[11].sram32x32$.mem);
$readmemh("rom/rom_control_204_0", uut_memory.genblk1[6].genblk1[12].sram32x32$.mem);
$readmemh("rom/rom_control_205_0", uut_memory.genblk1[6].genblk1[13].sram32x32$.mem);
$readmemh("rom/rom_control_206_0", uut_memory.genblk1[6].genblk1[14].sram32x32$.mem);
$readmemh("rom/rom_control_207_0", uut_memory.genblk1[6].genblk1[15].sram32x32$.mem);
$readmemh("rom/rom_control_208_0", uut_memory.genblk1[6].genblk1[16].sram32x32$.mem);
$readmemh("rom/rom_control_209_0", uut_memory.genblk1[6].genblk1[17].sram32x32$.mem);
$readmemh("rom/rom_control_210_0", uut_memory.genblk1[6].genblk1[18].sram32x32$.mem);
$readmemh("rom/rom_control_211_0", uut_memory.genblk1[6].genblk1[19].sram32x32$.mem);
$readmemh("rom/rom_control_212_0", uut_memory.genblk1[6].genblk1[20].sram32x32$.mem);
$readmemh("rom/rom_control_213_0", uut_memory.genblk1[6].genblk1[21].sram32x32$.mem);
$readmemh("rom/rom_control_214_0", uut_memory.genblk1[6].genblk1[22].sram32x32$.mem);
$readmemh("rom/rom_control_215_0", uut_memory.genblk1[6].genblk1[23].sram32x32$.mem);
$readmemh("rom/rom_control_216_0", uut_memory.genblk1[6].genblk1[24].sram32x32$.mem);
$readmemh("rom/rom_control_217_0", uut_memory.genblk1[6].genblk1[25].sram32x32$.mem);
$readmemh("rom/rom_control_218_0", uut_memory.genblk1[6].genblk1[26].sram32x32$.mem);
$readmemh("rom/rom_control_219_0", uut_memory.genblk1[6].genblk1[27].sram32x32$.mem);
$readmemh("rom/rom_control_220_0", uut_memory.genblk1[6].genblk1[28].sram32x32$.mem);
$readmemh("rom/rom_control_221_0", uut_memory.genblk1[6].genblk1[29].sram32x32$.mem);
$readmemh("rom/rom_control_222_0", uut_memory.genblk1[6].genblk1[30].sram32x32$.mem);
$readmemh("rom/rom_control_223_0", uut_memory.genblk1[6].genblk1[31].sram32x32$.mem);
$readmemh("rom/rom_control_224_0", uut_memory.genblk1[7].genblk1[0].sram32x32$.mem);
$readmemh("rom/rom_control_225_0", uut_memory.genblk1[7].genblk1[1].sram32x32$.mem);
$readmemh("rom/rom_control_226_0", uut_memory.genblk1[7].genblk1[2].sram32x32$.mem);
$readmemh("rom/rom_control_227_0", uut_memory.genblk1[7].genblk1[3].sram32x32$.mem);
$readmemh("rom/rom_control_228_0", uut_memory.genblk1[7].genblk1[4].sram32x32$.mem);
$readmemh("rom/rom_control_229_0", uut_memory.genblk1[7].genblk1[5].sram32x32$.mem);
$readmemh("rom/rom_control_230_0", uut_memory.genblk1[7].genblk1[6].sram32x32$.mem);
$readmemh("rom/rom_control_231_0", uut_memory.genblk1[7].genblk1[7].sram32x32$.mem);
$readmemh("rom/rom_control_232_0", uut_memory.genblk1[7].genblk1[8].sram32x32$.mem);
$readmemh("rom/rom_control_233_0", uut_memory.genblk1[7].genblk1[9].sram32x32$.mem);
$readmemh("rom/rom_control_234_0", uut_memory.genblk1[7].genblk1[10].sram32x32$.mem);
$readmemh("rom/rom_control_235_0", uut_memory.genblk1[7].genblk1[11].sram32x32$.mem);
$readmemh("rom/rom_control_236_0", uut_memory.genblk1[7].genblk1[12].sram32x32$.mem);
$readmemh("rom/rom_control_237_0", uut_memory.genblk1[7].genblk1[13].sram32x32$.mem);
$readmemh("rom/rom_control_238_0", uut_memory.genblk1[7].genblk1[14].sram32x32$.mem);
$readmemh("rom/rom_control_239_0", uut_memory.genblk1[7].genblk1[15].sram32x32$.mem);
$readmemh("rom/rom_control_240_0", uut_memory.genblk1[7].genblk1[16].sram32x32$.mem);
$readmemh("rom/rom_control_241_0", uut_memory.genblk1[7].genblk1[17].sram32x32$.mem);
$readmemh("rom/rom_control_242_0", uut_memory.genblk1[7].genblk1[18].sram32x32$.mem);
$readmemh("rom/rom_control_243_0", uut_memory.genblk1[7].genblk1[19].sram32x32$.mem);
$readmemh("rom/rom_control_244_0", uut_memory.genblk1[7].genblk1[20].sram32x32$.mem);
$readmemh("rom/rom_control_245_0", uut_memory.genblk1[7].genblk1[21].sram32x32$.mem);
$readmemh("rom/rom_control_246_0", uut_memory.genblk1[7].genblk1[22].sram32x32$.mem);
$readmemh("rom/rom_control_247_0", uut_memory.genblk1[7].genblk1[23].sram32x32$.mem);
$readmemh("rom/rom_control_248_0", uut_memory.genblk1[7].genblk1[24].sram32x32$.mem);
$readmemh("rom/rom_control_249_0", uut_memory.genblk1[7].genblk1[25].sram32x32$.mem);
$readmemh("rom/rom_control_250_0", uut_memory.genblk1[7].genblk1[26].sram32x32$.mem);
$readmemh("rom/rom_control_251_0", uut_memory.genblk1[7].genblk1[27].sram32x32$.mem);
$readmemh("rom/rom_control_252_0", uut_memory.genblk1[7].genblk1[28].sram32x32$.mem);
$readmemh("rom/rom_control_253_0", uut_memory.genblk1[7].genblk1[29].sram32x32$.mem);
$readmemh("rom/rom_control_254_0", uut_memory.genblk1[7].genblk1[30].sram32x32$.mem);
$readmemh("rom/rom_control_255_0", uut_memory.genblk1[7].genblk1[31].sram32x32$.mem);
 
        //$readmemh("rom/rom_control_0_0", test_memory.test_rom_0.mem);
        //$readmemh("rom/rom_control_0_1", test_memory.test_rom_1.mem);
        //$readmemh("rom/rom_control_0_2", test_memory.test_rom_2.mem);
        //$readmemh("rom/rom_control_0_3", test_memory.test_rom_3.mem);

        $display("============ \n Begin Test \n============");
       
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

        // read interface 
        rd_req_valid = 0;
        rd_req_address = 0;
        rd_dp_ready = 1;

        //  TLB
        // phys_addr = 0;
        // tlb_hit = 0;
        // tlb_pcd = 0;
        // tlb_rd_wr = 0;

        // write interface
         wr_req_valid = 0;
         wr_req_address = 0;
         wr_req_data = 0;
         wr_size_in = 1;

        // Arbiter Interface
         grant_in = 0;
         bus_busy_in = 0;


        #20
        reset = 0;

        #20
        #20
        wr_size_in = 0;
        rd_req_valid = 0;
        //rd_req_address = 32'h02000003;

        wr_req_address = 32'h0b0000ff;

        #20
        grant_in = 1;

        wr_req_valid = 1;
        wr_req_data = 64'h0000000012342020;
        #20 
        wr_req_valid = 0;
        wr_req_data = 64'b0;
        wr_req_address = 32'h0b0000fb;
        #1300
        wr_req_valid = 1;
        wr_req_data = 64'h01010101;
        #20
        wr_req_valid = 0;
        wr_req_data = 64'b0;
        wr_req_address = 32'h0b0000f7;
        #1300
        wr_req_valid=1;
        wr_req_data = 64'h34345634;
        
   
        #20
        wr_req_valid=0; 
        rd_req_address = 32'h0b0000f7;
        
        #1300
        rd_req_valid = 1;

        #1300
        rd_req_address = 32'h0b0000fb;
        #1300
        rd_req_address = 32'h0b0000ff;
        
        

        $display("==========\n End Test \n==========");
    end


    initial #10000 $finish;



    always #10 clk = ~clk;

    initial begin
        $vcdplusfile("name.dump.vpd");
        $vcdpluson(0, TOP);
    end


endmodule

module test_memory(
    clk,
    reset,
    addr,
    en,
    data_valid,
    data,
    rd_wr
);
    input clk;
    input reset;

    input [31:0] addr;
    input en;
    output data_valid;
    output [31:0] data;
    input rd_wr;

    reg [31:0] memory [0:1023];

    reg [31:0] out_data;

    wire [31:0] 		rom_data_0, rom_data_1, rom_data_2, rom_data_3;

    wire [31:0]			rom_data;

    assign rom_data = (addr[3:2] == 3) ? rom_data_0 : 
                      (addr[3:2] == 2) ? rom_data_1 :    
                      (addr[3:2] == 1) ? rom_data_2 : rom_data_3;
 
    rom32b32w$ test_rom_0 (
     addr[8:4],
     1'b1,
     rom_data_0		      
    );

    rom32b32w$ test_rom_1 (
     addr[8:4],
     1'b1,
     rom_data_1		      
    );
   
    rom32b32w$ test_rom_2 (
     addr[8:4],
     1'b1,
     rom_data_2		      
    );
   
    rom32b32w$ test_rom_3 (
     addr[8:4],
     1'b1,
     rom_data_3		      
    );       

    //always @(posedge clk, negedge reset) begin
    //
    //
    //end

    //always @(posedge clk) begin
    //    out_data <= addr;
    //end
    //
    always @(*) begin
        out_data = rom_data;
    end

    assign data_valid = 1'b1;
    assign data = (en & !rd_wr) ? out_data : 32'dz;


endmodule

