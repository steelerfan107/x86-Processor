module d_align(
    in_high,
    in_low,
    offset,
    out
);

    input [63:0] in_high;
    input [63:0] in_low;
    input [2:0] offset;
    output [63:0] out;
   
    // FIXME this is a lot of gates
    // could use tristates instead
    
    mux #(.WIDTH(64), .INPUTS(8)) mux1(
        {{in_high[55:0], in_low[63:56]},
        {in_high[47:0], in_low[63:48]},
        {in_high[39:0], in_low[63:40]},
        {in_high[31:0], in_low[63:32]},
        {in_high[23:0], in_low[63:24]},
        {in_high[15:0], in_low[63:16]},
        {in_high[7:0], in_low[63:8]},
        in_low
        },
        out,
        offset
    );
 
endmodule
