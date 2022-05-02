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

    // from the TLB
    reg [31:0] phys_addr;
    reg tlb_hit;
    
    // Interface to Interconnect
    wire [32-1:0]  mem_addr;
    wire                 mem_req;
    reg                  mem_data_valid;
    reg  [32-1:0]  mem_data;
    wire                 mem_rd_wr;
    wire                 mem_en;
    wire                 mem_done;

    // Arbitration Signals
    reg  grant_in;
    wire grant_out;

    wire bus_busy_out;
    reg bus_busy_in;
    
    icache uut (
    .clk            (clk            ),
    .reset          (reset          ),
    .req_valid      (req_valid      ),
    .req_ready      (req_ready      ),
    .req_address    (req_address    ),
    .dp_valid       (dp_valid       ),
    .dp_ready       (dp_ready       ),
    .dp_read_data   (dp_read_data   ),
    .phys_addr      (phys_addr      ),
    .tlb_hit        (tlb_hit        ),
    .mem_addr       (mem_addr       ),
    .mem_req        (mem_req        ),
    .mem_data_valid (mem_data_valid ),
    .mem_data       (mem_data       ),
    .mem_rd_wr      (mem_rd_wr      ),
    .mem_en         (mem_en         ),
    .mem_done       (mem_done       ),
    .grant_in       (grant_in       ),
    .grant_out      (grant_out      ),
    .bus_busy_out   (bus_busy_out   ),
    .bus_busy_in    (bus_busy_in    )
    );

    initial begin
        $display("============ \n Begin Test \n============");
        clk = 0;
        reset = 1;

        req_valid = 0;
        req_address = 32'h0;
        bus_busy_in = 0;
        tlb_hit = 1;
        phys_addr = 32'habcdabc0;
        grant_in = 0;
        bus_busy_in = 0;

        mem_data_valid = 0;
        mem_data = 32'h0;

        dp_ready = 1;

        #20
        reset = 0;
        #20
        req_address = 32'h0f0f0f00;
        req_valid = 1;

        #20

        #20 
        grant_in = 1;

        #20
        #20 
        #20 
        #20 
        mem_data = 32'hdeadbeef;
        mem_data_valid = 1;
        #20
        mem_data_valid = 0;
        #20
        mem_data = 32'habdcabcd;
        mem_data_valid = 1;
        #20
        mem_data_valid = 0;
        #20
        grant_in = 0;
        #20
        mem_data_valid = 1;
        
        #20
        mem_data_valid = 0;
        #20

        #20
        grant_in = 1;

        #20
        mem_data_valid = 1;
        
        

        $display("==========\n End Test \n==========");
    end


    initial #1000 $finish;


    always #10 clk = ~clk;

    initial begin
        $vcdplusfile("name.dump.vpd");
        $vcdpluson(0, TOP);
    end


endmodule
