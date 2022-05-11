
module main_memory_top(
    clk,
    reset,
    en,
    rd_wr,
    wr_size,
    addr,
    data,
    ready
);

    input clk;
    input reset;

    input [31:0] addr;
    input en;
    output ready;
    inout [31:0] data;
    input rd_wr;
    input [1:0] wr_size;


    wire [31:0] dec_out;
    decoder5_32 dec(addr[11:7], dec_out);


    wire [31:0] dio_internal;

    wire ctrl_we;
    wire ctrl_ce;
    wire ctrl_oe;

    wire ctrl_rd;
    wire ctrl_wr;

    wire ctrl_rd_n;
    inv1$ crn(ctrl_rd_n, ctrl_rd);
    tristate_bus_driver16$ rd_driver0(ctrl_rd_n, dio_internal[15:0], data[15:0]);
    tristate_bus_driver16$ rd_driver1(ctrl_rd_n, dio_internal[31:16], data[31:16]);


    genvar i;
    generate
        for (i =0; i < 32; i=i+1) begin
            wire ce;
            wire oe;
            wire wr;

            and2$ ceand(ce, dec_out[i], ctrl_ce);
            and2$ oeand(oe, dec_out[i], ctrl_oe);
            and2$ wrand(wr, dec_out[i], ctrl_wr);

            wire ce_n;
            wire oe_n;
            wire wr_n;

            inv1$ ceinv(ce_n, ce);
            inv1$ oeinv(oe_n, oe);
            inv1$ wrinv(wr_n, wr);

            sram32x32$ (
                .A(addr[6:2]),
                .DIO(dio_internal),
                .OE(oe_n),
                .WR(wr_n),
                .CE(ce_n)
            );
        end
    endgenerate

    wire [31:0] reg_out;
    register #(.WIDTH(32)) staging_reg(clk, reset, dio_internal, reg_out, , reg_wr);
    
    wire [31:0] aligned_wr_data;
    mem_align al(reg_out, wr_size, data, addr[1:0], aligned_wr_data);

    wire ctrl_wr_n;
    inv1$ cren(ctrl_wr_n, ctrl_wr);
    tristate_bus_driver16$ wr_driver0(ctrl_wr_n, aligned_wr_data[15:0], dio_internal[15:0]);
    tristate_bus_driver16$ wr_driver1(ctrl_wr_n, aligned_wr_data[31:16], dio_internal[31:16]);


endmodule


//module main_memory_top(
//    clk,
//    reset,
//    en,
//    rd_wr,
//    addr,
//    data,
//    valid
//);
//
//   input clk;
//    input reset;
//
//    input [31:0] addr;
//    input en;
//    output valid;
//    output [31:0] data;
//    input rd_wr;
//
//    reg [31:0] memory [0:1023];
//
//    reg [31:0] out_data;
//
//    wire [31:0] 		rom_data_0, rom_data_1, rom_data_2, rom_data_3;
//
//    wire [31:0]			rom_data;
//
//    assign rom_data = (addr[3:2] == 3) ? rom_data_0 : 
//                      (addr[3:2] == 2) ? rom_data_1 :    
//                      (addr[3:2] == 1) ? rom_data_2 : rom_data_3;
// 
//    rom32b32w$ test_rom_0 (
//     addr[8:4],
//     1'b1,
//     rom_data_0		      
//    );
//
//    rom32b32w$ test_rom_1 (
//     addr[8:4],
//     1'b1,
//     rom_data_1		      
//    );
//   
//    rom32b32w$ test_rom_2 (
//     addr[8:4],
//     1'b1,
//     rom_data_2		      
//    );
//   
//    rom32b32w$ test_rom_3 (
//     addr[8:4],
//     1'b1,
//     rom_data_3		      
//    );       
//
//    //always @(posedge clk, negedge reset) begin
//    //
//    //
//    //end
//
//    //always @(posedge clk) begin
//    //    out_data <= addr;
//    //end
//    //
//    always @(*) begin
//        out_data = rom_data;
//    end
//
//    assign valid = 1'b1;
//    assign data = en ? out_data : 32'dz;
//
//
//endmodule
