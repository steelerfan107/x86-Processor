
//////////////////////////////////////
//
//  Segment Register Module
//
//  Holds components for Segment Register

module segment_register_file (
    clk,
    reset,

    write_select,
    write_data,

    cs_out,
    ds_out,
    es_out,
    fs_out,
    gs_out,
    ss_out
);

    input clk;
    input reset;

    input [5:0] write_select;
    input [15:0] write_data;

    output [15:0] cs_out;
    output [15:0] ds_out;
    output [15:0] es_out;
    output [15:0] fs_out;
    output [15:0] gs_out;
    output [15:0] ss_out;

    wire [15:0] cs_in;
    wire [15:0] ds_in;
    wire [15:0] es_in;
    wire [15:0] fs_in;
    wire [15:0] gs_in;
    wire [15:0] ss_in;

    wire cs_en = write_select[0];
    wire ds_en = write_select[1];
    wire es_en = write_select[2];
    wire fs_en = write_select[3];
    wire gs_en = write_select[4];
    wire ss_en = write_select[5];

    // 6 registers
    register_16 
    cs (clk, reset, write_data, cs_out, ,cs_en),
    ds (clk, reset, write_data, ds_out, ,ds_en),
    es (clk, reset, write_data, es_out, ,es_en),
    fs (clk, reset, write_data, fs_out, ,fs_en),
    gs (clk, reset, write_data, gs_out, ,gs_en),
    ss (clk, reset, write_data, ss_out, ,ss_en);


endmodule
