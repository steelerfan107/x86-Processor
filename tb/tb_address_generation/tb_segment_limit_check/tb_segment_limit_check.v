// tb_segment_limit_check.v
// 

// Testbench for Segment Limit Check

module TOP;
    // wires and regs
    wire cause_exception;

    reg [31:0] address;
    reg address_is_valid;

    reg [2:0] segment;

    reg [2:0] size;


    segment_limit_check uut (
        cause_exception,

        address,
        address_is_valid,

        segment,

        size
    );

    initial begin
        $display("============ \n Begin Test \n============");
        address = 0;
        address_is_valid = 0;
        segment = 0;
        size = 0;

        #10

        address = 32'h04ffefff;
        segment = 0;
        size = 1;

        #10
        if (cause_exception != 0) $display("Fail when address not valid");

        address_is_valid = 1;

        #10
        if (cause_exception != 0) $display("Fail when size is 1");

        size = 2;

        #20
        if (cause_exception != 1) $display("Fail when there should be exception");








        $display("==========\n End Test \n==========");
    end


    initial #200 $finish;

    initial begin
        $vcdplusfile("name.dump.vpd");
        $vcdpluson(0, TOP);
    end


endmodule