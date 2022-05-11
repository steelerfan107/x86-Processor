// tb_dcache_interface.v
// 

// Testbench for ...

module TOP;
    // wires and regs
    reg clk;
    reg reset;

    wire [63:0] data_out;

    reg a_valid;
    reg e_ready;

    wire a_ready;
    wire e_valid;

    reg [31:0] op0_address;
    reg op0_address_is_valid;
    reg [31:0] op1_address;
    reg op1_address_is_valid;

    // interface to dcache
    wire rd_req_valid;
    reg rd_req_ready;
    wire [31:0] rd_req_address;
    reg rd_dp_valid;
    wire rd_dp_ready;
    reg [63:0] rd_dp_read_data;

    dcache_interface uut (
        clk,
        reset,

        data_out,

        a_valid,
        e_ready,

        a_ready,
        e_valid,

        op0_address,
        op0_address_is_valid,
        op1_address,
        op1_address_is_valid,

        rd_req_valid,
        rd_req_ready,
        rd_req_address,
        rd_dp_valid,
        rd_dp_ready,
        rd_dp_read_data
    );

    initial $readmemb("../../../rtl/memory_read/dcache_interface_rom.bit", uut.rom.mem);

    initial begin
        $display("============ \n Begin Test \n============");
        clk = 0;
        reset = 1;

        a_valid = 0;
        e_ready = 0;

        op0_address = 0;
        op0_address_is_valid = 0;
        op1_address = 0;
        op1_address_is_valid = 0;

        // interface to dcache
        rd_req_ready = 0;
        rd_dp_valid = 0;
        rd_dp_read_data = 0;

        #10
        // state 0

        reset = 0;

        a_valid = 1;
        e_ready = 1;
        op0_address_is_valid = 1;
        
        #10
        // state 2

        op0_address_is_valid = 0;
        rd_req_ready = 0;

        #20
        // state 2

        rd_req_ready = 1;

        #10
        // state 6

        rd_req_ready = 0;

        #10
        // state 6

        rd_dp_valid = 1;

        #10
        // state 7

        rd_dp_valid = 0;


        #20
        // state 3 then state 0

        op0_address_is_valid = 1;

        // try and reset
        #10
        op0_address_is_valid = 0;

        reset = 1;

        #10

        reset = 0;

        // state 0

        // #10
        // // state 2

        // op0_address_is_valid = 0;

        // reset = 1;

        // #10

        // reset = 0;
        // // state 0






        

        


        $display("==========\n End Test \n==========");
    end


    initial #200 $finish;

    always #5 clk = ~clk;

    initial begin
        $vcdplusfile("dcache_interface.dump.vpd");
        $vcdpluson(0, TOP);
    end


endmodule