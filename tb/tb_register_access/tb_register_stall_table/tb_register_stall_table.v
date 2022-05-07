// tb_register_stall_table.v
// 

// Testbench for register_stall_table

module TOP;
    // wires and regs
    reg clk;
    reg reset;

    wire is_stall;

    reg [2:0] wb_reg;
    reg wb_is_valid;

    reg [2:0] op0_reg;
    reg op0_reg_is_valid;

    reg [2:0] op0_r0;
    reg op0_r0_is_valid;
    
    reg [2:0] op0_r1;
    reg op0_r1_is_valid;

    reg [2:0] op1_r0;
    reg op1_r0_is_valid;
    
    reg [2:0] op1_r1;
    reg op1_r1_is_valid;


    reg next_stage_ready;


    register_stall_table uut (
        clk,
        reset,

        is_stall,

        wb_reg,
        wb_is_valid,

        op0_reg,
        op0_reg_is_valid,

        op0_r0,
        op0_r0_is_valid,

        op0_r1,
        op0_r1_is_valid,

        op1_r0,
        op1_r0_is_valid,

        op1_r1,
        op1_r1_is_valid,


        next_stage_ready
    );

    initial begin
        $display("============ \n Begin Test \n============");
        clk = 0;
        reset = 1;

        wb_reg = 0;
        wb_is_valid = 0;

        op0_reg = 0;
        op0_reg_is_valid = 0;

        op0_r0 = 0;
        op0_r0_is_valid = 0;

        op0_r1 = 0;
        op0_r1_is_valid = 0;

        op1_r0 = 0;
        op1_r0_is_valid = 0;

        op1_r1 = 0;
        op1_r1_is_valid = 0;


        next_stage_ready = 0;

        #12.5

        reset = 0;
        next_stage_ready = 1;
        
        op0_reg = 0;
        op0_reg_is_valid = 1;

        #10

        op0_reg_is_valid = 0;

        op0_r0 = 0;
        op0_r0_is_valid = 1;

        #10

        op0_r0_is_valid = 0;

        op0_r1 = 0;
        op0_r1_is_valid = 1;

        #10

        op0_r1_is_valid = 0;

        op1_r0 = 0;
        op1_r0_is_valid = 1;

        #10

        op1_r0_is_valid = 0;

        op1_r1 = 0;
        op1_r1_is_valid = 1;

        #10

        op1_r1_is_valid = 0;

        // simulate doing writeback
        wb_reg = 0;
        wb_is_valid = 1;

        #10 
        wb_is_valid = 0;

        op0_r0 = 0;
        op0_r0_is_valid = 1;


        $display("==========\n End Test \n==========");
    end


    initial #1000 $finish;

    always #5 clk = ~clk;

    initial begin
        $vcdplusfile("name.dump.vpd");
        $vcdpluson(0, TOP);
    end


endmodule