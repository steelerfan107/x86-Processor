// tb_dataRAM.v
// 

// Testbench for ...

module TOP;
    // wires and regs

    reg clk;
    reg reset;
    reg [5:0] index;
    reg wr_en;
    reg [63:0] wr_data;
    wire [63:0] out_data;

    dvalidRAM uut (
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

        index = 6'b0;
        wr_en = 0;
        wr_data = 0;

        #50
        reset = 0;

        #50
        index = 6'b001100;
        wr_data = 64'habcdffffffffffff;

        #10
        wr_en = 1;

        #20
        wr_en = 0;

        #10
        index = 6'b110100;
        wr_data = 64'hdeadbeef;         
        wr_en = 1;

        #20

        wr_en = 0;

        #20
        index = 6'b001100;
        


        $display("==========\n End Test \n==========");
    end


    initial #1000 $finish;


    always #10 clk = ~clk;

    initial begin
        $vcdplusfile("name.dump.vpd");
        $vcdpluson(0, TOP);
    end


endmodule
