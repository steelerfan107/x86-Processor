module arb_decoder(
    bus_addr,
    
    rd_wr_in,
    rd_wr_out,
    en,
    dma_en,
    mem_en,
    io_en
);
    parameter DMA_FRAME = 20'h00001;
    parameter DISK_FRAME = 20'h00003;

    parameter BUSADDRW = 32;

    input [BUSADDRW-1:0] bus_addr; 

    input  rd_wr_in;
    output rd_wr_out;
    input  en;
    output dma_en;
    output mem_en;
    output io_en;

    assign rd_wr_out = rd_wr_in;

    // TODO implement
    
    wire dma_sel;
    wire disk_sel;
    wire mem_sel;

    wire [19:0] phys_frame;

    compare #(.WIDTH(20)) (phys_frame, DMA_FRAME, dma_sel );
    compare #(.WIDTH(20)) (phys_frame, DISK_FRAME, disk_sel );

    nor2$ mem_nor(mem_sel, dma_sel, disk_sel);


    wire dma_en;
    wire disk_en;
    wire mem_en;

    and2$ dma_and(dma_en, en, dma_sel);
    and2$ disk_and(io_en, en, disk_sel);
    and2$ mem_and(mem_en, en, mem_sel);
   

endmodule
