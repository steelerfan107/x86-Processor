////////////////////////////////////////////
//
// Buffer capable of driving 16 outputs
//
//

module bufferH16 (
    out,
    in
);
    parameter WIDTH = 64;

    output  [WIDTH-1:0] out;
    input   [WIDTH-1:0] in;

    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin
            bufferH16$ buff_16 (out[i], in[i]);
        end
    endgenerate

endmodule