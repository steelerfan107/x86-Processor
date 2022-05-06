// tb_template.v
// 

// Testbench for ...

module TOP;
    // wires and regs

    reg clk;
    reg reset;
    reg [4:0] index;
    reg wr_en;
    reg [127:0] wr_data;
    wire [127:0] out_data;

    idataRAM uut (
        clk,
        reset,
        index,
        wr_en,
        wr_data,
        out_data 
    );

    initial begin
        $display("============ \n Begin Test \n============");
        reset = 1;

        clk = 0;

        index = 5'b0;
        wr_en = 0;
        wr_data = 0;

        #50
        reset = 0;

        #50
        index = 5'b01100;
        wr_data = 128'habcdffffffffffff;

        #5
        wr_en = 1;

        #20
        wr_en = 0;

        #10
        index = 5'b10100;
         

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
