/// 
// Modules:
//  ddataRAM
//  dtagRAM
//  dvalidRAM

module ddataRAM(
    clk,
    reset,
    index_in,
    wr_en_inn,
    wr_data,
    out_data
);

    input clk;
    input reset;

    input [5:0] index_in;
    wire [5:0] index;
    input wr_en_inn;

    
    // buffers to prevent timing violations
    genvar i;
    wire [5:0] tmp [0:10];
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

    input [63:0] wr_data;

    output [63:0] out_data;

    wire [7:0] n_chip_select;
    // idiot
    //decoder6_64 d1(index, n_chip_select );
    decoder3_8$ d1(index[5:3], n_chip_select, );

    wire [7:0] chip_select;

    wire [7:0] wr_en;
    genvar i;
    generate 
        for (i=0; i<8; i=i+1) begin
            wire n_wr_en;
            and2$ and1(n_wr_en, n_chip_select[i], wr_en_in); 
            wire masked;
            and2$ mask(masked, n_wr_en, ~clk);
            inv1$ inv1(wr_en[i], masked);

            inv1$ inv2(chip_select[i], n_chip_select[i]);
        end
    endgenerate


    wire [63:0] ram_out;

    genvar i;

    generate
        for (i = 0; i<8; i=i+1) begin
            wire [15:0] ram5_out;
            wire [15:0] ram6_out;
            wire [15:0] ram7_out;
            wire [15:0] ram8_out;

            ram16b8w$ 
                ram5(index[2:0], wr_data[63:48],   chip_select[i], wr_en[i], wr_en[i], ram5_out),
                ram6(index[2:0], wr_data[47:32],   chip_select[i], wr_en[i], wr_en[i], ram6_out),
                ram7(index[2:0], wr_data[31:16],   chip_select[i], wr_en[i], wr_en[i], ram7_out),
                ram8(index[2:0], wr_data[15:0],    chip_select[i], wr_en[i], wr_en[i], ram8_out);


            //assign ram_out[i] = {ram1_out, ram2_out, ram3_out, ram4_out, ram5_out, ram6_out, ram7_out, ram8_out};
            assign ram_out = {ram5_out, ram6_out, ram7_out, ram8_out};
        end
    endgenerate

    assign out_data = ram_out;
endmodule


// TODO
module dtagRAM(
    clk,
    reset,
    index_in,
    wr_en_inn,
    wr_data,
    out_data
);
    input clk;
    input reset;

    input [5:0] index_in;
    wire [5:0] index;
    input wr_en_inn;
    wire wr_en_in;


    
    // buffers to prevent timing violations
    genvar i;
    wire [5:0] tmp [0:9];
    assign tmp[0] = index_in;
    generate
        for(i=1; i<10; i=i+1) begin
            buffer8$ buffer(tmp[i], tmp[i-1]);
        end
    endgenerate
    assign index = tmp[9];

    
    
    assign wr_en_in = wr_en_inn;

    input [22:0] wr_data;

    output [22:0] out_data;

    wire [23:0] wr_data_filled = {1'b0, wr_data};

    wire [7:0] n_chip_select;
    decoder3_8$ d1(index[5:3], n_chip_select, );

    wire [7:0] chip_select; 

    wire [7:0] wr_en;
    generate
        for (i=0; i<8; i=i+1) begin
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
        for (i = 0; i<8; i=i+1) begin
            wire [7:0] ram1_out;
            wire [15:0] ram2_out;

            ram8b8w$  ram1(index[2:0], wr_data_filled[23:16], chip_select[i], wr_en[i], ram1_out);
            ram16b8w$ ram2(index[2:0], wr_data_filled[15:0] , chip_select[i], wr_en[i], wr_en[i], ram2_out);

            assign ram_out = {ram1_out, ram2_out};

        end
    endgenerate

    assign out_data = ram_out[22:0];
endmodule

// TODO
module dvalidRAM(
    clk,
    reset,
    index,
    wr_en,
    wr_data,
    out_data
);

    input clk;
    input reset;
    
    input [5:0] index;
    input wr_en;
    input wr_data;
    output out_data;

    wire [63:0] sel;
    wire [63:0] mux_sel;

    decoder6_64 dec1(index, sel);

    wire [63:0] n_sel;
    genvar i;
    generate
        for (i=0; i<64;i=i+1) begin
            wire tmp;
            and2$ and2(mux_sel[i], sel[i], wr_en);
            inv1$ inv1(n_sel[i], sel[i]);
        end
    endgenerate

    wire n_reset;
    inv1$ inv(n_reset, reset);

    generate
        for (i=0; i<64; i=i+1) begin
            // 1-bit register
            wire mux_out;
            wire q_out;
            mux2$ mux(mux_out, q_out, wr_data, mux_sel[i]);
            dff$ dff(clk, mux_out, q_out, , n_reset , 1'b1); 
            tristateH$ ts(n_sel[i], q_out, out_data);
        end
    endgenerate

endmodule
