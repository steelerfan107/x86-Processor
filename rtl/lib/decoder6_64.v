module decoder6_64(in, out);
    input [5:0] in;
    output [63:0] out;


    wire [7:0] out_pre;

    decoder3_8$ sel_decoder(in[5:3], out_pre);


    wire [2:0] in_low_buffered;

    bufferH16$
        b1(in_low_buffered[2], in[2]),
        b2(in_low_buffered[1], in[1]),
        b3(in_low_buffered[0], in[0]);

    wire [63:0] out_post;

    decoder3_8$
        d1(in_low_buffered, out_post[7:0]),
        d2(in_low_buffered, out_post[15:8]),
        d3(in_low_buffered, out_post[23:16]),
        d4(in_low_buffered, out_post[31:24]),
        d5(in_low_buffered, out_post[39:32]),
        d6(in_low_buffered, out_post[47:40]),
        d7(in_low_buffered, out_post[55:48]),
        d8(in_low_buffered, out_post[63:56]);
   
    
    genvar i;
    genvar j;
    generate
        for (i=0; i<8; i=i+1) begin
            for (j=0; j<8; j=j+1) begin
                and2$ and1(out[i*8+j], out_pre[i], out_post[i*8+j]);
            end
        end
    endgenerate
 

endmodule
