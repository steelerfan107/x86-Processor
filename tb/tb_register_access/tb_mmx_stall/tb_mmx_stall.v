// tb_mmx_stall.v
// 

// Testbench for mmx stall

module TOP;
    // wires and regs
    reg clk;
    reg reset;

    // reg [2:0] size;

    wire is_stall;

    reg [2:0] write_select;
    reg write_enable;

    reg [7:0] mod_rm;

    reg [2:0] op0;
    reg [2:0] op0_reg;

    reg [2:0] op1;
    reg [2:0] op1_reg;

    reg next_stage_ready;

    mmx_stall uut (
        clk,
        reset,

        // size,

        is_stall,

        write_select,
        write_enable,

        mod_rm,

        op0,
        op0_reg,

        op1,
        op1_reg,

        next_stage_ready
    );

    initial begin
        $display("============ \n Begin Test \n============");
        clk = 0;
        reset = 1;

        // todo: shouldn't add to reg if we are actively stalling

        // size = 0;

        write_select = 0;
        write_enable = 0;

        mod_rm = 0;

        op0 = 0;
        op0_reg = 0;

        op1 = 0;
        op1_reg = 0;

        next_stage_ready = 1;

        #10

        reset = 0;

        // start a write
        op0 = 3'd3;
        op0_reg = 0;

        #10

        // test doing nothing
        op0 = 3'd0;

        #10
        
        // read mod_rm with op1
        op1 = 3'd4;
        mod_rm = 8'hc0;

        #10

        // read mod_rm but with no dependency
        mod_rm = 8'hc1;

        #10

        // normal reg read
        op1 = 3'd3;
        op1_reg = 3'd0;

        #10

        // writeback
        write_select = 3'd0;
        write_enable = 1;

        #10

        write_enable = 0;

        




        $display("==========\n End Test \n==========");
    end

    always #5 clk = ~clk;

    initial #1000 $finish;

    initial begin
        $vcdplusfile("mmx_stall.dump.vpd");
        $vcdpluson(0, TOP);
    end


endmodule