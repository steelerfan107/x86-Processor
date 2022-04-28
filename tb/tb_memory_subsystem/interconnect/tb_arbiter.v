// tb_template.v
// 

// Testbench for ...

module TOP;
    // wires and regs

    reg clk;
    reg reset;
    
    reg req; 
    reg done;

    wire grant;
    wire busy;

    arbiter uut (
        clk,
        reset,
        req,
        done,
        grant,
        busy 
    );

    initial begin
        $display("============ \n Begin Test \n============");
        reset = 1;
        clk = 0;

        req = 0;
        done = 1'b0;


        #50
        reset = 0;

        #50

        req = 1;

        #20
        req = 0;
        done = 1;
        


        $display("==========\n End Test \n==========");
    end


    initial #1000 $finish;


    always #10 clk = ~clk;

    initial begin
        $vcdplusfile("name.dump.vpd");
        $vcdpluson(0, TOP);
    end


endmodule
