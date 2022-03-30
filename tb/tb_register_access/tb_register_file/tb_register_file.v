// tb_register_file.v
// Brandon Zupan

// Testbench for testing the register file seperately from everything else

module TOP;
    reg clk;
    reg reset;

    reg [1:0] register_size;

    reg [2:0] op_1;
    wire [31:0] op_1_value;

    reg [2:0] op_2;
    wire [31:0] op_2_value;

    reg [2:0] sib_base_reg;
    wire [31:0] sib_base_value;
    reg [2:0] sib_index_reg;
    wire [31:0] sib_index_value;

    reg [2:0] wb_num;
    reg writeback_en;
    reg [1:0] writeback_size;
    reg [31:0] writeback_data;

    wire [31:0] eax_out;
    wire [31:0] ecx_out;
    wire [31:0] edx_out;
    wire [31:0] ebx_out;
    wire [31:0] esp_out;
    wire [31:0] ebp_out;
    wire [31:0] esi_out;
    wire [31:0] edi_out;

    register_file uut (
        clk,
        reset,

        register_size,

        op_1,
        op_1_value,

        op_2,
        op_2_value,

        sib_base_reg,
        sib_base_value,
        sib_index_reg,
        sib_index_value,
        
        wb_num,
        writeback_en,
        writeback_size,
        writeback_data,

        eax_out,
        ecx_out,
        edx_out,
        ebx_out,
        esp_out,
        ebp_out,
        esi_out,
        edi_out
    );

    initial begin
        reset = 1;

        clk = 0;
        register_size = 0;
        op_1 = 0;
        op_2 = 0;
        sib_base_reg = 0;
        sib_index_reg = 0;
        wb_num = 0;
        writeback_en = 0;
        writeback_size = 0;
        writeback_data = 0;

        #15

        reset = 0;

    end

    initial #100 $finish;

    always #10 clk = ~clk;

    initial begin
        $vcdplusfile("register_file.dump.vpd");
        $vcdpluson(0, TOP);
    end

endmodule
