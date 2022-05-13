
//////////////////////////////////////
//
//  MMX Register Module
//
//  Holds components for mmx register file

module mmx_register_file (      // fanout good
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

    genvar i;

    // buffers
    wire [63:0] writeback_data_buf;
    
    generate
        for (i = 0; i < 64; i = i + 1) begin
            bufferH16$ wb_data_16 (writeback_data_buf[i], writeback_data[i]);
        end
    endgenerate

    wire writeback_enable_buf;
    generate
        for (i = 0; i < 8; i = i + 1) begin
            bufferH16$ wb_en_16 (writeback_enable_buf, writeback_enable);
        end
    endgenerate

    // decode writeback signal
    wire [7:0] wb_decoded;
    decoder3_8$ wb_decoder (writeback_select, wb_decoded, );

    wire [7:0] wb_decoded_enabled;

    
    generate
        for (i = 0; i < 8; i = i + 1) begin
            and2$ wb_and (wb_decoded_enabled[i], wb_decoded[i], writeback_enable_buf);
        end
    endgenerate

    // 16 32 bit registers that are initialized to Z when reset
    register_32_reset 
    mm0_high (mm0_out[63:32], writeback_data_buf[63:32], , wb_decoded_enabled[0], clk, reset), 
    mm1_high (mm1_out[63:32], writeback_data_buf[63:32], , wb_decoded_enabled[1], clk, reset), 
    mm2_high (mm2_out[63:32], writeback_data_buf[63:32], , wb_decoded_enabled[2], clk, reset), 
    mm3_high (mm3_out[63:32], writeback_data_buf[63:32], , wb_decoded_enabled[3], clk, reset), 
    mm4_high (mm4_out[63:32], writeback_data_buf[63:32], , wb_decoded_enabled[4], clk, reset), 
    mm5_high (mm5_out[63:32], writeback_data_buf[63:32], , wb_decoded_enabled[5], clk, reset), 
    mm6_high (mm6_out[63:32], writeback_data_buf[63:32], , wb_decoded_enabled[6], clk, reset), 
    mm7_high (mm7_out[63:32], writeback_data_buf[63:32], , wb_decoded_enabled[7], clk, reset), 
    mm0_low (mm0_out[31:0], writeback_data_buf[31:0], , wb_decoded_enabled[0], clk, reset), 
    mm1_low (mm1_out[31:0], writeback_data_buf[31:0], , wb_decoded_enabled[1], clk, reset), 
    mm2_low (mm2_out[31:0], writeback_data_buf[31:0], , wb_decoded_enabled[2], clk, reset), 
    mm3_low (mm3_out[31:0], writeback_data_buf[31:0], , wb_decoded_enabled[3], clk, reset), 
    mm4_low (mm4_out[31:0], writeback_data_buf[31:0], , wb_decoded_enabled[4], clk, reset), 
    mm5_low (mm5_out[31:0], writeback_data_buf[31:0], , wb_decoded_enabled[5], clk, reset), 
    mm6_low (mm6_out[31:0], writeback_data_buf[31:0], , wb_decoded_enabled[6], clk, reset), 
    mm7_low (mm7_out[31:0], writeback_data_buf[31:0], , wb_decoded_enabled[7], clk, reset);

    

endmodule

