// tb_segment_register_stall.v
// 

// Testbench for segment register stall

module TOP;
    // wires and regs
    reg clk;
    reg reset;

    wire is_stall;

    reg [2:0] write_select;
    reg write_enable;

    reg [2:0] op0;
    reg [2:0] op0_reg;

    reg [2:0] op1;
    reg [2:0] op1_reg;

    segment_register_stall uut (
        clk,
        reset,

        is_stall,

        write_select,
        write_enable,

        op0,
        op0_reg,

        op1,
        op1_reg
    );

    initial begin
        $display("============ \n Begin Test \n============");
        clk = 0;
        reset = 1;


        write_select = 0;
        write_enable = 0;

        op0 = 0;
        op0_reg = 0;

        op1 = 0;
        op1_reg = 0;

        #12.5
        reset = 0;

        op0 = 2;
        op0_reg = 0;

        #10

        op0 = 2;
        op0_reg = 0;

        #10

        op0 = 0;

        #10

        write_select = 0;
        write_enable = 1;

        #10

        write_enable = 1;

        #10

        write_enable = 0;



        $display("==========\n End Test \n==========");
    end

    always #5 clk = ~clk;


    initial #1000 $finish;

    initial begin
        $vcdplusfile("segment_register_stall.dump.vpd");
        $vcdpluson(0, TOP);
    end


endmodule