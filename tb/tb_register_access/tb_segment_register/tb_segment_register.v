// tb_segment_register.v
// Test segment register file

module TOP;
    reg clk;
    reg reset;

    reg [2:0] write_select;
    reg [15:0] write_data;
    reg write_enable;

    wire [15:0] cs_out;
    wire [15:0] ds_out;
    wire [15:0] es_out;
    wire [15:0] fs_out;
    wire [15:0] gs_out;
    wire [15:0] ss_out;

    segment_register_file uut (
        clk,
        reset,

        write_select,
        write_data,
        write_enable,

        cs_out,
        ds_out,
        es_out,
        fs_out,
        gs_out,
        ss_out

    );

    integer cs_data = 16'ha123;
    integer ds_data = 16'hb234;
    integer es_data = 16'hc345;
    integer fs_data = 16'hd456;
    integer gs_data = 16'he567;
    integer ss_data = 16'hf678;

    initial begin
        $display("============ \n Begin Test \n============");
        reset = 1;

        clk = 0;
        write_select = 0;
        write_data = 0;
        write_enable = 0;

        #12.5

        reset = 0;
        write_enable = 1;


        write_data = cs_data;
        write_select = 1;
        #10
        if (cs_out != cs_data) $display("FAIL: Write CS");

        write_data = ds_data;
        write_select = 3;
        #10
        if (ds_out != ds_data) $display("FAIL: Write DS");

        write_data = es_data;
        write_select = 0;
        #10
        if (es_out != es_data) $display("FAIL: Write ES");

        write_data = fs_data;
        write_select = 4;
        #10
        if (fs_out != fs_data) $display("FAIL: Write FS");

        write_data = gs_data;
        write_select = 5;
        #10
        if (gs_out != gs_data) $display("FAIL: Write GS");

        write_data = ss_data;
        write_select = 2;
        #10
        if (ss_out != ss_data) $display("FAIL: Write SS");

        write_data = 16'hFFFF;
        write_enable = 0;
        write_select = 0;

        #10
        if (cs_out != cs_data) $display("FAIL: CS written at wrong time");
        if (ds_out != ds_data) $display("FAIL: DS written at wrong time");
        if (es_out != es_data) $display("FAIL: ES written at wrong time");
        if (fs_out != fs_data) $display("FAIL: FS written at wrong time");
        if (gs_out != gs_data) $display("FAIL: GS written at wrong time");
        if (ss_out != ss_data) $display("FAIL: SS written at wrong time");






        $display("==========\n End Test \n==========");
    end

    initial #100 $finish;

    always #5 clk = ~clk;

    initial begin
        $vcdplusfile("segment_register.dump.vpd");
        $vcdpluson(0, TOP);
    end

endmodule