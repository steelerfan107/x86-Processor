// tb_icache.v
// 

// Testbench for ICache

module TOP;
    // wires and regs

    reg clk;
    reg reset;
  
    // Fetch Stage Interface  
    reg               req_valid;
    wire              req_ready;
    reg  [32-1:0] req_address;
    wire              dp_valid;
    reg               dp_ready;
    wire [128-1:0] dp_read_data;

    
    // Interface to Interconnect
    wire [32-1:0]  mem_addr;
    wire                 mem_req;
    wire                  mem_data_valid;
    wire  [32-1:0]  mem_data;
    wire                 mem_rd_wr;
    wire                 mem_en;

    // Arbitration Signals
    reg  grant_in;
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

  
    test_memory mem(clk, reset, mem_addr, mem_en, mem_data_valid, mem_data, mem_rd_wr); 

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
        req_address,
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
    
    icache uut (
    .clk            (clk            ),
    .reset          (reset          ),
    .req_valid      (req_valid      ),
    .req_ready      (req_ready      ),
    .req_address    (req_address    ),
    .dp_valid       (dp_valid       ),
    .dp_ready       (dp_ready       ),
    .dp_read_data   (dp_read_data   ),
    .phys_addr      (i_pa_out       ),
    .tlb_hit        (i_hit         ),
    .tlb_pcd        (i_PCD_out      ),
    .mem_addr       (mem_addr       ),
    .mem_req        (mem_req        ),
    .mem_data_valid (mem_data_valid ),
    .mem_data       (mem_data       ),
    .mem_rd_wr      (mem_rd_wr      ),
    .mem_en         (mem_en         ),
    .grant_in       (grant_in       ),
    .grant_out      (grant_out      ),
    .bus_busy_out   (bus_busy_out   ),
    .bus_busy_in    (bus_busy_in    )
    );

    initial begin
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

        req_valid = 0;
        req_address = 32'h0;
        bus_busy_in = 0;
        grant_in = 0;
        bus_busy_in = 0;


        dp_ready = 1;

        #20
        reset = 0;
        #20
        req_address = 32'h0a000210;
        req_valid = 1;

        #20
        #20
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
