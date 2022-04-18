
//////////////////////////////////////
//
//  MMX Register Module
//
//  Holds components for mmx register file

module mmx_register_file (
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

    input clk;
    input reset;

    input [63:0] writeback_data;
    input [2:0] writeback_select;
    input writeback_enable;

    output [63:0] mm0_out;
    output [63:0] mm1_out;
    output [63:0] mm2_out;
    output [63:0] mm3_out;
    output [63:0] mm4_out;
    output [63:0] mm5_out;
    output [63:0] mm6_out;
    output [63:0] mm7_out;

    // decode writeback signal
    wire [7:0] wb_decoded;
    decoder3_8$ (writeback_select, wb_decoded, );

    wire [7:0] wb_decoded_enabled;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin
            and2$ wb_and (wb_decoded_enabled[i], wb_decoded[i], writeback_enable);
        end
    endgenerate

    // 8 registers
    register #(.WIDTH(64)) 
    mm0 (clk, reset, writeback_data, mm0_out, ,wb_decoded_enabled[0]),
    mm1 (clk, reset, writeback_data, mm1_out, ,wb_decoded_enabled[1]),
    mm2 (clk, reset, writeback_data, mm2_out, ,wb_decoded_enabled[2]),
    mm3 (clk, reset, writeback_data, mm3_out, ,wb_decoded_enabled[3]),
    mm4 (clk, reset, writeback_data, mm4_out, ,wb_decoded_enabled[4]),
    mm5 (clk, reset, writeback_data, mm5_out, ,wb_decoded_enabled[5]),
    mm6 (clk, reset, writeback_data, mm6_out, ,wb_decoded_enabled[6]),
    mm7 (clk, reset, writeback_data, mm7_out, ,wb_decoded_enabled[7]);
    

endmodule

