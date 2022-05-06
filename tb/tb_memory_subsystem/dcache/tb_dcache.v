// tb_icache.v
// 

// Testbench for ICache

module TOP;
    // wires and regs

    reg clk;
    reg reset;


    // TLB  
    // 

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
   
    reg [5:0] in;
    wire [63:0] out;
 
    dcache uut();

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


        in = 6'd0;
        #20
        #20
        #20 
        #20
        

        $display("==========\n End Test \n==========");
    end


    initial #1000 $finish;


    always @(posedge clk) begin
        in = in + 1;
    end

    always #10 clk = ~clk;

    initial begin
        $vcdplusfile("name.dump.vpd");
        $vcdpluson(0, TOP);
    end


endmodule
