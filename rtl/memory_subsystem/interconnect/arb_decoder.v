module arb_decoder(
    clk,
    reset,

    bus_addr,
    
    rd_wr_in,
    rd_wr_out,
    en,
    dma_en,
    mem_en,
    io_en
);
    parameter BUSADDRW = 32;

    input clk;
    input reset;

    input [BUSADDRW-1:0] bus_addr; 

    input  rd_wr_in;
    output rd_wr_out;
    input  en;
    output dma_en;
    output mem_en;
    output io_en;

    assign rd_wr_out = rd_wr_in;

    // TODO implement

endmodule
