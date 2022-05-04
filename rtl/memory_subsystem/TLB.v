module TLB(
    contents,
    
    // icache port
    i_addr_in,
    i_hit,
    i_rd_wr_out,
    i_pa_out,
    i_PCD_out,

    // dcache port
    d_addr_in,
    d_hit,
    d_rd_wr_out,
    d_pa_out,
    d_PCD_out
);

    input [351:0] contents;
    
    // icache port
    input [31:0] i_addr_in;
    output i_hit;
    output i_rd_wr_out;
    output i_PCD_out;
    output [31:0] i_pa_out;

    // dcache port
    input [31:0] d_addr_in;
    output d_hit;
    output d_rd_wr_out;
    output d_PCD_out;
    output [31:0] d_pa_out;


    TLB_port icache_port(
        .contents_full(contents),
        .addr_in(i_addr_in),
        .hit(i_hit),
        .rd_wr_out(i_rd_wr_out),
        .pa_out(i_pa_out),
        .PCD_out(i_PCD_out)
    );
    TLB_port dcache_port(
        .contents_full(contents),
        .addr_in(d_addr_in),
        .hit(d_hit),
        .rd_wr_out(d_rd_wr_out),
        .pa_out(d_pa_out),
        .PCD_out(d_PCD_out)
    );


endmodule
