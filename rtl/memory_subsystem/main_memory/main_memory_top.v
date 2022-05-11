
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
    decoder5_32$ dec(addr[11:7], dec_out);


    wire [31:0] dio_internal;

    wire ctrl_we;
    wire ctrl_ce;
    wire ctrl_oe;

    wire ctrl_rd;
    wire ctrl_wr;

    wire ctrl_drive_rd_tri;

    wire ctrl_rd_n;
    inv1$ crn(sram_rd, ctrl_drive_rd_tri);
    tristate_bus_driver16$ rd_driver0(ctrl_rd_n, dio_internal[15:0], data[15:0]);
    tristate_bus_driver16$ rd_driver1(ctrl_rd_n, dio_internal[31:16], data[31:16]);
   
    wire sram_done;
    wire reg_wr;

    wire direct;
 
    main_mem_controller mem_control(
        clk,
        reset,

        en,
        rd_wr,
        sram_done,
        direct,
        
        ready,
        ctrl_rd,
        ctrl_wr,
        reg_wr,
        ctrl_drive_rd_tri
    );

    sram_controller sram_control(
        clk,
        reset,
        ctrl_rd,
        ctrl_wr,
        
        ctrl_ce,
        ctrl_we,
        ctrl_oe,
        
        sram_done
    );


    genvar i;
    generate
        for (i =0; i < 32; i=i+1) begin
            wire ce;
            wire oe;
            wire wr;

            
            wire ce_n;
            wire oe_n;
            wire wr_n;

            inv1$ cein(ctrl_ce_n, ctrl_ce);
            inv1$ oein(ctrl_oe_n, ctrl_oe);
            inv1$ wrin(ctrl_wr_n, ctrl_we);

            and2$ ceand(ce, dec_out[i], ctrl_ce_n);
            and2$ oeand(oe, dec_out[i], ctrl_oe_n);
            and2$ wrand(wr, dec_out[i], ctrl_wr_n);

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


    // direct write
    assign direct = (addr[1:0] == 0) & (wr_size == 0);


    wire [31:0] reg_out;
    register #(.WIDTH(32)) staging_reg(clk, reset, dio_internal, reg_out, , reg_wr);
    
    wire [31:0] aligned_wr_data;
    mem_align al(reg_out, wr_size, data, addr[1:0], aligned_wr_data);

    wire ctrl_wr_n;
    inv1$ cren(ctrl_wr_n, ctrl_wr);
    tristate_bus_driver16$ wr_driver0(ctrl_wr_n, aligned_wr_data[15:0], dio_internal[15:0]);
    tristate_bus_driver16$ wr_driver1(ctrl_wr_n, aligned_wr_data[31:16], dio_internal[31:16]);

endmodule
