// tb_template.v
// 

// Testbench for ...

module TOP;
    // wires and regs

    reg clk;
    reg reset;
    reg [4:0] index;
    reg wr_signal;
    reg [22:0] wr_data;
    wire [22:0] out_data;

    reg [4:0] in;
    wire [31:0] out;

    reg val_wr;
    reg val_data;
    wire val_out;


    itagRAM uut (
        clk,
        reset,
        index,
        wr_signal,
        wr_data,
        out_data 
    );

    ivalidRAM uut2 (
        clk,
        reset,
        index,
        val_wr,
        val_data,
        val_out
    );

    

    initial begin
        $display("============ \n Begin Test \n============");
        reset = 1;

        clk = 0;

        index = 5'b0;
        wr_signal = 0;
        wr_data = 0;

        val_wr = 0;
        val_data = 0;

        #50
        reset = 0;

        #50
        index = 5'b01100;
        wr_data = 23'habc;

        val_data = 1;
        //#5
        //wr_signal = 1;
        val_wr = 1;

        #20
        wr_signal = 0;

        #20
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
