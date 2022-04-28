// tested and comforms to fanout reqs

module decoder5_32$(in, out);
    input [4:0] in;   
    output [31:0] out;

    wire [3:0] out_pre;
    wire [7:0] out_pre_buffered;

    decoder2_4$ d1(in[4:3], out_pre, );

    buffer$ 
        b1(out_pre_buffered[0], out_pre[0]),
        b2(out_pre_buffered[1], out_pre[0]),
        b3(out_pre_buffered[2], out_pre[1]),
        b4(out_pre_buffered[3], out_pre[1]),
        b5(out_pre_buffered[4], out_pre[2]),
        b6(out_pre_buffered[5], out_pre[2]),
        b7(out_pre_buffered[6], out_pre[3]),
        b8(out_pre_buffered[7], out_pre[3]);

    wire [31:0] out_post;

    decoder3_8$ 
        d2(in[2:0], out_post[7:0],),
        d3(in[2:0], out_post[15:8],),
        d4(in[2:0], out_post[23:16],),
        d5(in[2:0], out_post[31:24],);
 
    wire [16:0] out_final;

    genvar i;
    genvar j;
    generate
        for (i=0; i<8; i=i+1) begin
            for (j=0; j<4; j=j+1) begin
                and2$ and1(out[i*4+j], out_pre_buffered[i], out_post[i*4+j]);
            end
        end
    endgenerate    
endmodule


