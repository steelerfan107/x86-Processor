// tb_mmx_register.v
// 

// Testbench for MMX Register file

module TOP;
    reg clk;
    reg reset;

    reg [63:0] writeback_data;
    reg [2:0] writeback_select;
    reg writeback_enable;

    wire [63:0] mm0_out;
    wire [63:0] mm1_out;
    wire [63:0] mm2_out;
    wire [63:0] mm3_out;
    wire [63:0] mm4_out;
    wire [63:0] mm5_out;
    wire [63:0] mm6_out;
    wire [63:0] mm7_out;

    mmx_register_file uut (
        clk,
        reset,

        writeback_data,
        writeback_select,
        writeback_enable,

        mm0_out,
        mm1_out,
        mm2_out,
        mm3_out,
        mm4_out,
        mm5_out,
        mm6_out,
        mm7_out
    );

    initial begin
        $display("============ \n Begin Test \n============");
        clk = 0;
        reset = 1;

        writeback_data = 0;
        writeback_select = 0;
        writeback_enable = 0;

        #12.5

        reset = 0;

        #10

        $display("Writing value to each register");
        writeback_enable = 1;

        writeback_select = 0;
        writeback_data = 64'h1234_5678_9abc_def0;
        #10
        if (mm0_out != writeback_data) $display("MM%d FAIL | In = 0x%X | Out = 0x%X", writeback_select, writeback_data, mm0_out);
        
        writeback_select = 1;
        writeback_data = writeback_data[63:60] + (writeback_data << 4);
        #10
        if (mm1_out != writeback_data) $display("MM%d FAIL | In = 0x%X | Out = 0x%X", writeback_select, writeback_data, mm1_out);
        
        writeback_select = 2;
        writeback_data = writeback_data[63:60] + (writeback_data << 4);
        #10
        if (mm2_out != writeback_data) $display("MM%d FAIL | In = 0x%X | Out = 0x%X", writeback_select, writeback_data, mm2_out);
        
        writeback_select = 3;
        writeback_data = writeback_data[63:60] + (writeback_data << 4);
        #10
        if (mm3_out != writeback_data) $display("MM%d FAIL | In = 0x%X | Out = 0x%X", writeback_select, writeback_data, mm3_out);
        
        writeback_select = 4;
        writeback_data = writeback_data[63:60] + (writeback_data << 4);
        #10
        if (mm4_out != writeback_data) $display("MM%d FAIL | In = 0x%X | Out = 0x%X", writeback_select, writeback_data, mm4_out);
        
        writeback_select = 5;
        writeback_data = writeback_data[63:60] + (writeback_data << 4);
        #10
        if (mm5_out != writeback_data) $display("MM%d FAIL | In = 0x%X | Out = 0x%X", writeback_select, writeback_data, mm5_out);
        
        writeback_select = 6;
        writeback_data = writeback_data[63:60] + (writeback_data << 4);
        #10
        if (mm6_out != writeback_data) $display("MM%d FAIL | In = 0x%X | Out = 0x%X", writeback_select, writeback_data, mm6_out);
        
        writeback_select = 7;
        writeback_data = writeback_data[63:60] + (writeback_data << 4);
        #10
        if (mm7_out != writeback_data) $display("MM%d FAIL | In = 0x%X | Out = 0x%X", writeback_select, writeback_data, mm7_out);
        

        $display("==========\n End Test \n==========");
    end


    initial #500 $finish;

    always #5 clk = ~clk;

    initial begin
        $vcdplusfile("mmx_register.dump.vpd");
        $vcdpluson(0, TOP);
    end


endmodule