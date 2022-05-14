////////////////////////////////////////////
//
// Buffer capable of driving 64 outputs
//
//

module bufferH64 (
    out,
    in
);
    parameter WIDTH = 64;

    output  [WIDTH-1:0] out;
    input   [WIDTH-1:0] in;

    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin
            bufferH64$ buff_64 (out[i], in[i]);
        end
    endgenerate

endmodule