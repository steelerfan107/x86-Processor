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

    //  TLB
    wire [31:0] virt_addr;
    reg [31:0] phys_addr;
    reg tlb_hit;
    reg tlb_pcd;
    reg tlb_rd_wr;

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
    reg mem_data_valid;
    wire [31:0] mem_data;
    wire mem_rd_wr;
    wire mem_en;

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

        // Arbiter Interface
        .grant_in(grant_in),
        .grant_out(grant_out),

        .bus_busy_out(bus_busy_out),
        .bus_busy_in(bus_busy_in)
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

        // read interface 
        rd_req_valid = 0;
        rd_req_address = 0;
        rd_dp_ready = 1;

        //  TLB
         phys_addr = 0;
         tlb_hit = 0;
         tlb_pcd = 0;
         tlb_rd_wr = 0;

        // write interface
         wr_req_valid = 0;
         wr_req_address = 0;
         wr_req_data = 0;
         wr_size_in = 1;

        // Arbiter Interface
         grant_in = 0;
         bus_busy_in = 0;

        mem_data_valid = 1;

        #20
        reset = 0;

        #20
        #20
        rd_req_valid = 0;
        rd_req_address = 32'h05000019;

        wr_req_address = 32'h02000FFE;

        #20

        wr_req_valid = 1;
        wr_req_data = 64'h12345678deadbeef;
    
        #20 
        wr_req_valid = 0;

        
        #20 
        grant_in = 1;
        #20
        

        $display("==========\n End Test \n==========");
    end


    initial #1000 $finish;



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

