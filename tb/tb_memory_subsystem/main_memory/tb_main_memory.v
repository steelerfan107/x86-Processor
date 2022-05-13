// tb_icache.v
// 

// Testbench for ICache

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
    reg clk;
    reg reset;
 
    // Instruction Memory Interface
    reg 	            imem_valid;
    wire 	            imem_ready;
    reg [IADDRW-1:0]  imem_address;
    reg               imem_wr_en;   // unused 
    reg [IDATAW-1:0]	imem_wr_data; // unused
    reg [ISIZEW-1:0] 	imem_wr_size; // unused
    wire              imem_dp_valid;
    reg               imem_dp_ready;
    wire [IDATAW-1:0] imem_dp_read_data;

    // Data Memory Read Interface
    reg 	            dmem_r_valid;
    wire 	            dmem_r_ready;
    reg [DADDRW-1:0]  dmem_r_address;
    reg               dmem_r_wr_en;   // unused 
    reg [DDATAW-1:0]	dmem_r_wr_data; // unused
    reg [DSIZEW-1:0] 	dmem_r_wr_size; // unused
    wire              dmem_r_dp_valid;
    reg               dmem_r_dp_ready;
    wire [DDATAW-1:0] dmem_r_dp_read_data;

    // Data Memory Write Interface
    reg 	            dmem_w_valid;
    wire 	            dmem_w_ready;
    reg [IADDRW-1:0]  dmem_w_address;
    reg               dmem_w_wr_en;
    reg [IDATAW-1:0]	dmem_w_wr_data;
    reg [ISIZEW-1:0] 	dmem_w_wr_size;
    wire              dmem_w_dp_valid;     // unused 
    reg               dmem_w_dp_ready;     // unused
    wire [IDATAW-1:0] dmem_w_dp_read_data; // unused

    // System Controller Read Interface
    reg sys_r_valid;
    wire sys_r_ready;
    reg [31:0] sys_r_address;
    wire sys_r_dp_valid;
    reg sys_r_dp_ready;
    wire [31:0] sys_r_dp_read_data;


    reg [43:0] contents [0:7];

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


    memory_subsystem_top(
        .clk(clk),
        .reset(reset),
        .imem_valid(imem_valid),
        .imem_ready(imem_ready),
        .imem_address(imem_address),
        .imem_wr_en(imem_wr_en),    // unused
        .imem_wr_data(imem_wr_data),  // unused
        .imem_wr_size(imem_wr_size),  // unused
        .imem_dp_valid(imem_dp_valid),
        .imem_dp_ready(imem_dp_ready),
        .imem_dp_read_data(imem_dp_read_data),
        .dmem_r_valid(dmem_r_valid),
        .dmem_r_ready(dmem_r_ready),
        .dmem_r_address(dmem_r_address),
        .dmem_r_wr_en(dmem_r_wr_en),    // unused
        .dmem_r_wr_data(dmem_r_wr_data),  // unused
        .dmem_r_wr_size(dmem_r_wr_size),  // unused
        .dmem_r_dp_valid(dmem_r_dp_valid),
        .dmem_r_dp_ready(dmem_r_dp_ready),
        .dmem_r_dp_read_data(dmem_r_dp_read_data),
        .dmem_w_valid(dmem_w_valid),
        .dmem_w_ready(dmem_w_ready),
        .dmem_w_address(dmem_w_address),
        .dmem_w_wr_en(dmem_w_wr_en),    
        .dmem_w_wr_data(dmem_w_wr_data),  
        .dmem_w_wr_size(dmem_w_wr_size),  
        .dmem_w_dp_valid(dmem_w_dp_valid),      // unused
        .dmem_w_dp_ready(dmem_w_dp_ready),      // unused
        .dmem_w_dp_read_data(dmem_w_dp_read_data),   // unused
        .sys_r_valid(sys_r_valid),
        .sys_r_ready(sys_r_ready),
        .sys_r_address(sys_r_address),
        .sys_r_dp_valid(sys_r_dp_valid),
        .sys_r_dp_ready(sys_r_dp_ready),
        .sys_r_dp_read_data(sys_r_dp_read_data),
        .tlb_contents(contents_concat)
    );
   


    initial begin
        $readmemh("rom/rom_control_0_0", test_memory.test_rom_0.mem);
        $readmemh("rom/rom_control_0_1", test_memory.test_rom_1.mem);
        $readmemh("rom/rom_control_0_2", test_memory.test_rom_2.mem);
        $readmemh("rom/rom_control_0_3", test_memory.test_rom_3.mem);

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
    imem_valid = 0;
    imem_address = 0;
    imem_dp_ready = 0;

    	            dmem_r_valid = 0;
    dmem_r_address = 0;
                  dmem_r_dp_ready = 0;

    	            dmem_w_valid = 0;
    dmem_w_address = 0;
                  dmem_w_wr_en = 0;
    dmem_w_wr_data = 0;
    dmem_w_wr_size = 0;

    // System Controller Read Interface
    sys_r_valid = 0;
    sys_r_address = 0;
    sys_r_dp_ready = 0;






        #20
        reset = 0;
memory_subsystem_top.dma.src  = 32'h0;
memory_subsystem_top.dma.size = 12'h1000;
memory_subsystem_top.dma.dst = 32'h00002000;

        #120
memory_subsystem_top.dma.start = 1'b1;
        
       
        #10000
    imem_valid = 1;
    imem_address = 32'h02000000;
    imem_dp_ready = 1;
        #10000
        imem_address = 32'h02000072;
        dmem_r_address = 32'h02000071;

        #500
        dmem_r_valid = 1;
        dmem_r_dp_ready = 1;

        dmem_w_address = 32'h0200006e;
        dmem_w_wr_data = 32'h12345678;
        #2000 dmem_w_valid = 1;  
        #60
        dmem_w_valid = 0;

        #10000
        dmem_r_address = 32'h02000077;

        #10000
        imem_address = 32'h02000041;

        #10000
        imem_address = 32'h020000c0;


        $display("==========\n End Test \n==========");
    end


    initial #100000 $finish;



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

