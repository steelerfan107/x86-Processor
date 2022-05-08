
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
    write_enable,

    write_cs,
    write_cs_enable,

    cs_out,
    ds_out,
    es_out,
    fs_out,
    gs_out,
    ss_out
);

    input clk;
    input reset;

    input [2:0] write_select;
    input [15:0] write_data;
    input write_enable;

    input [15:0] write_cs;
    input write_cs_enable;

    output [15:0] cs_out;
    output [15:0] ds_out;
    output [15:0] es_out;
    output [15:0] fs_out;
    output [15:0] gs_out;
    output [15:0] ss_out;

    // wire [15:0] cs_in;
    // wire [15:0] ds_in;
    // wire [15:0] es_in;
    // wire [15:0] fs_in;
    // wire [15:0] gs_in;
    // wire [15:0] ss_in;

    // wire cs_en = write_select[0];
    // wire ds_en = write_select[1];
    // wire es_en = write_select[2];
    // wire fs_en = write_select[3];
    // wire gs_en = write_select[4];
    // wire ss_en = write_select[5];

    wire [7:0] write_register;

    // decode incoming write select into one hot
    wire [7:0] write_select_decoded;
    decoder3_8$ ws_decoder (write_select, write_select_decoded, );

    // write_register = write enable and write_select
    // set write register as enable for registers

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin
            and2$ and_write_reg (write_register[i], write_select_decoded[i], write_enable);
        end
    endgenerate

    // cs can be forciblly written
    // if cs_en is 1, set its input to cs_in and set its write to 1
    // if cs_en is 0, set its input to write_data and its write to write_register[1]

    wire [15:0] cs_write_data;

    mux #(.WIDTH(16), .INPUTS(2)) cs_in_mux (
        {write_cs, write_data},
        cs_write_data,
        write_cs_enable
    );

    wire cs_we;

    mux #(.WIDTH(1), .INPUTS(2)) cs_we_mux (
        {1'b1, write_register[1]},
        cs_we,
        write_cs_enable
    );

    // 6 registers
    register #(.WIDTH(16)) 
    es (clk, reset, write_data, es_out, ,write_register[0]),
    cs (clk, reset, cs_write_data, cs_out, ,cs_we),
    ss (clk, reset, write_data, ss_out, ,write_register[2]),
    ds (clk, reset, write_data, ds_out, ,write_register[3]),
    fs (clk, reset, write_data, fs_out, ,write_register[4]),
    gs (clk, reset, write_data, gs_out, ,write_register[5]);

    


endmodule
