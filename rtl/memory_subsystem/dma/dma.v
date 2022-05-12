module dma(
    input clk,
    input reset,
    
    input en,
    input addr,
    inout data,
    input ready_in,
    output ready_out
    output [1:0] wr_size, 
    output rd_wr
);


    reg [31:0] src;
    reg [31:0] dst;

    reg [11:0] size;
    reg start;


    always @(posedge clk, reset) begin
        if (reset) begin
            src <= 32'h0;
            dst <= 32'h0;
            size <= 12'h0;
            start <= 0;

        end else
        if begin

        end
    end



endmodule
