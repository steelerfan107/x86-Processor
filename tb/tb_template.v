// tb_template.v
// 

// Testbench for ...

module TOP;
    // wires and regs

    ... uut (


    );

    initial begin
        $display("============ \n Begin Test \n============");


        $display("==========\n End Test \n==========");
    end


    initial #1000 $finish;

    initial begin
        $vcdplusfile("name.dump.vpd");
        $vcdpluson(0, TOP);
    end


endmodule