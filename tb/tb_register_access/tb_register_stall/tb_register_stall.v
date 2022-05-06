// tb_register_stall.v
// 

// Testbench for register stall

module TOP;
    // wires and regs
    wire is_stall;    // 1 if the stage should stall

    reg clk;
    reg reset;

    reg [1:0] register_size;

    reg [2:0] op0;
    reg [2:0] op0_reg;  

    reg [2:0] op1;
    reg [2:0] op1_reg;

    reg [7:0] mod_rm;

    reg [7:0] sib;
    reg sib_valid;

    reg [32:0] wb_data;
    reg [2:0] wb_reg;
    reg [1:0] wb_size;
    reg wb_enable;

    reg next_stage_ready;

    register_access_stall uut (
        is_stall,

        clk,
        reset,

        register_size,

        op0,
        op0_reg,

        op1,
        op1_reg,

        mod_rm,

        sib,
        sib_valid,

        wb_data,
        wb_reg,
        wb_size,
        wb_enable,

        next_stage_ready
    );

    initial begin
        $display("============ \n Begin Test \n============");
        clk = 0;
        reset = 1;

        register_size = 0;

        op0 = 0;
        op0_reg = 0;

        op1 = 0;
        op1_reg = 0;

        mod_rm = 0;

        sib = 0;
        sib_valid = 0;

        wb_data = 0;
        wb_reg = 0;
        wb_size = 0;
        wb_enable = 0;

        #12.5
        reset = 0;


        $display("==========\n End Test \n==========");
    end


    initial #1000 $finish;

    always #5 clk = ~clk;

    initial begin
        $vcdplusfile("register_stall.dump.vpd");
        $vcdpluson(0, TOP);
    end


endmodule