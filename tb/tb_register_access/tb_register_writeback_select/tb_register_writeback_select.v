// Tests writeback select

module TOP;
    wire [2:0] selected_reg;

    reg [2:0] reg_num;
    reg [1:0] reg_size;

    integer i;

    register_writeback_select uut (
        selected_reg,

        reg_num,
        reg_size
    );

    initial begin
        $strobe("============ \n Begin Test \n============");
        reg_num = 0;
        reg_size = 0;

        #5

        $display("Testing 32 bit selection");
        for (i = 0; i < 8; i = i + 1) begin
            // set input to i
            reg_num = i;

            #5
            // $display("reg_num = %d, selected_reg = %d", reg_num, selected_reg);

            if (selected_reg != i) $display("FAIL: reg_num = %d, selected_reg = %d", reg_num, selected_reg);
            
        end

        $display("Testing 16 bit selection");
        reg_size = 1;
        for (i = 0; i < 8; i = i + 1) begin
            reg_num = i;

            #5

            // $display("reg_num = %d, selected_reg = %d", reg_num, selected_reg);

            if (selected_reg != i) $display("FAIL: reg_num = %d, selected_reg = %d", reg_num, selected_reg);
        end

        $display("Testing 8 bit selection");
        reg_size = 2;
        for (i = 0; i < 8; i = i + 1) begin
            reg_num = i;

            #5

            // $display("reg_num = %d, selected_reg = %d", reg_num, selected_reg);

            if (selected_reg != i%4) $display("FAIL: reg_num = %d, selected_reg = %d", reg_num, selected_reg);
        end


        $display("==========\n End Test \n==========");
    end

    initial #200 $finish;

    initial begin
        $vcdplusfile("register_writeback_select.dump.vpd");
        $vcdpluson(0, TOP);
    end

endmodule