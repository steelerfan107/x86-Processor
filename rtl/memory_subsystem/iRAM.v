/// 
// Modules:
//  idataRAM
//  itagRAM
//  ivalidRAM

module idataRAM(
    clk,
    reset,
    index_in,
    wr_en_inn,
    wr_data,
    out_data
);

    input clk;
    input reset;

    input [4:0] index_in;
    wire [4:0] index;
    input wr_en_inn;

    
    // buffers to prevent timing violations
    genvar i;
    wire [4:0] tmp [0:10];
    assign tmp[0] = index_in;
    generate
        for(i=1; i<11; i=i+1) begin
            buffer8$ buffer(tmp[i], tmp[i-1]);
        end
    endgenerate
    assign index = tmp[10];

    wire wr_en_in;
    //and2$ andd(wr_en_in, wr_en_inn, clk);
    assign wr_en_in = wr_en_inn;

    input [127:0] wr_data;

    output [127:0] out_data;



    wire [3:0] n_chip_select;
    decoder2_4$ d1(index[4:3], n_chip_select, );

    wire [3:0] chip_select;

    wire [3:0] wr_en;
    genvar i;
    generate 
        for (i=0; i<4; i=i+1) begin
            wire n_wr_en;
            and2$ and1(n_wr_en, n_chip_select[i], wr_en_in); 
            wire masked;
            and2$ mask(masked, n_wr_en, ~clk);
            inv1$ inv1(wr_en[i], masked);

            inv1$ inv2(chip_select[i], n_chip_select[i]);
        end
    endgenerate


    //wire [127:0] ram_out [0:3];
    wire [127:0] ram_out;

    genvar i;

    generate
        for (i = 0; i<4; i=i+1) begin
            wire [15:0] ram1_out;
            wire [15:0] ram2_out;
            wire [15:0] ram3_out;
            wire [15:0] ram4_out;
            wire [15:0] ram5_out;
            wire [15:0] ram6_out;
            wire [15:0] ram7_out;
            wire [15:0] ram8_out;

            ram16b8w$ 
                ram1(index[2:0], wr_data[127:112], chip_select[i], wr_en[i], wr_en[i], ram1_out),
                ram2(index[2:0], wr_data[111:96],  chip_select[i], wr_en[i], wr_en[i], ram2_out),
                ram3(index[2:0], wr_data[95:80],   chip_select[i], wr_en[i], wr_en[i], ram3_out),
                ram4(index[2:0], wr_data[79:64],   chip_select[i], wr_en[i], wr_en[i], ram4_out),
                ram5(index[2:0], wr_data[63:48],   chip_select[i], wr_en[i], wr_en[i], ram5_out),
                ram6(index[2:0], wr_data[47:32],   chip_select[i], wr_en[i], wr_en[i], ram6_out),
                ram7(index[2:0], wr_data[31:16],   chip_select[i], wr_en[i], wr_en[i], ram7_out),
                ram8(index[2:0], wr_data[15:0],    chip_select[i], wr_en[i], wr_en[i], ram8_out);


            //assign ram_out[i] = {ram1_out, ram2_out, ram3_out, ram4_out, ram5_out, ram6_out, ram7_out, ram8_out};
            assign ram_out = {ram1_out, ram2_out, ram3_out, ram4_out, ram5_out, ram6_out, ram7_out, ram8_out};
        end
    endgenerate

// 4x16B mux

    //wire [15:0] mux1_out;
    //wire [15:0] mux2_out;
    //wire [15:0] mux3_out;
    //wire [15:0] mux4_out;
    //wire [15:0] mux5_out;
    //wire [15:0] mux6_out;
    //wire [15:0] mux7_out;
    //wire [15:0] mux8_out;

    //mux4_16$
    //    mux1(mux1_out, ram_out[0][127:112], ram_out[1][127:112], ram_out[2][127:112], ram_out[3][127:112], index[3], index[4]),
    //    mux2(mux2_out, ram_out[0][111:96],  ram_out[1][111:96],  ram_out[2][111:96],  ram_out[3][111:96] , index[3], index[4]),
    //    mux3(mux3_out, ram_out[0][95:80],   ram_out[1][95:80],   ram_out[2][95:80],   ram_out[3][95:80]  , index[3], index[4]),
    //    mux4(mux4_out, ram_out[0][79:64],   ram_out[1][79:64],   ram_out[2][79:64],   ram_out[3][79:64]  , index[3], index[4]),
    //    mux5(mux5_out, ram_out[0][63:48],   ram_out[1][63:48],   ram_out[2][63:48],   ram_out[3][63:48]  , index[3], index[4]),
    //    mux6(mux6_out, ram_out[0][47:32],   ram_out[1][47:32],   ram_out[2][47:32],   ram_out[3][47:32]  , index[3], index[4]),
    //    mux7(mux7_out, ram_out[0][31:16],   ram_out[1][31:16],   ram_out[2][31:16],   ram_out[3][31:16]  , index[3], index[4]),
    //    mux8(mux8_out, ram_out[0][15:0],    ram_out[1][15:0],    ram_out[2][15:0],    ram_out[3][15:0]   , index[3], index[4]);

    assign out_data = ram_out;
    //assign out_data = {
    //    mux1_out,
    //    mux2_out,
    //    mux3_out,
    //    mux4_out,
    //    mux5_out,
    //    mux6_out,
    //    mux7_out,
    //    mux8_out
    //};

endmodule



module itagRAM(
    clk,
    reset,
    index_in,
    wr_en_inn,
    wr_data,
    out_data
);
    input clk;
    input reset;

    input [4:0] index_in;
    wire [4:0] index;
    input wr_en_inn;
    wire wr_en_in;
    //and2$ andd(wr_en_in, wr_en_inn, clk);
    assign wr_en_in = wr_en_inn;

    // buffers to prevent timing violations
    genvar i;
    wire [4:0] tmp [0:10];
    assign tmp[0] = index_in;
    generate
        for(i=1; i<11; i=i+1) begin
            buffer8$ buffer(tmp[i], tmp[i-1]);
        end
    endgenerate
    assign index = tmp[10];


    input [22:0] wr_data;

    output [22:0] out_data;

    wire [23:0] wr_data_filled = {1'b0, wr_data};

    wire [3:0] n_chip_select;
    decoder2_4$ d1(index[4:3], n_chip_select, );

    wire [3:0] chip_select; 

    wire [3:0] wr_en;
    genvar i;
    generate
        for (i=0; i<4; i=i+1) begin
            wire n_wr_en;
            and2$ and1(n_wr_en, n_chip_select[i], wr_en_in);
            wire masked;
            and2$ mask(masked, n_wr_en, ~clk);
            inv1$ inv1(wr_en[i], masked);

            inv1$ inv2(chip_select[i], n_chip_select[i]);
        end
    endgenerate
    

    wire [23:0] ram_out;

    genvar i;

    generate
        for (i = 0; i<4; i=i+1) begin
            wire [7:0] ram1_out;
            wire [15:0] ram2_out;

            ram8b8w$  ram1(index[2:0], wr_data_filled[23:16], chip_select[i], wr_en[i], ram1_out);
            ram16b8w$ ram2(index[2:0], wr_data_filled[15:0] , chip_select[i], wr_en[i], wr_en[i], ram2_out);

            assign ram_out = {ram1_out, ram2_out};

        end
    endgenerate

    assign out_data = ram_out[22:0];
endmodule

module ivalidRAM(
    clk,
    reset,
    index,
    wr_en,
    wr_data,
    out_data
);

    input clk;
    input reset;
    
    input [4:0] index;
    input wr_en;
    input wr_data;
    output out_data;

    wire [31:0] sel;
    wire [31:0] mux_sel;

    decoder5_32$ dec1(index, sel);

    wire [31:0] n_sel;
    genvar i;
    generate
        for (i=0; i<32;i=i+1) begin
            wire tmp;
            and2$ and2(mux_sel[i], sel[i], wr_en);
            inv1$ inv1(n_sel[i], sel[i]);
        end
    endgenerate

    wire n_reset;
    inv1$ inv(n_reset, reset);

    generate
        for (i=0; i<32; i=i+1) begin
            // 1-bit register
            wire mux_out;
            wire q_out;
            mux2$ mux(mux_out, q_out, wr_data, mux_sel[i]);
            dff$ dff(clk, mux_out, q_out, , n_reset , 1'b1); 
            tristateH$ ts(n_sel[i], q_out, out_data);
        end
    endgenerate

endmodule
