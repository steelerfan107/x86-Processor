module TLB_port(
    contents_full,

    addr_in,
    hit,
    rd_wr_out,
    pa_out,
    PCD_out
);

    input [351:0] contents_full;

    wire [43:0] contents [0:7];

    assign contents[7] = contents_full[351:308];
    assign contents[6] = contents_full[307:264];
    assign contents[5] = contents_full[263:220];
    assign contents[4] = contents_full[219:176];
    assign contents[3] = contents_full[175:132];
    assign contents[2] = contents_full[131:88];
    assign contents[1] = contents_full[87:44];
    assign contents[0] = contents_full[43:0];
    
    // icache port
    input [31:0] addr_in;
    output hit;
    output rd_wr_out;
    output PCD_out;
    output [31:0] pa_out;


    wire enc_valid;


    wire [7:0] comp_outputs;

    genvar i;
    generate
        for (i = 0; i < 8; i=i+1) begin
            compare #(.WIDTH(20)) comp(contents[i][43:24], addr_in[31:12], comp_outputs[i] );
        end
    endgenerate

    wire [2:0] pte_entry_id;

    pencoder8_3v$ enc(1'b0, comp_outputs, pte_entry_id, enc_valid);

    // this is a behavioral mux but I think it is ok per the spec
    wire [23:0] mux_out = contents[pte_entry_id][23:0];

    wire [19:0] phys_page = mux_out[23:4];


    wire v = mux_out[3];
    wire pr = mux_out[2];
    wire rd_wr = mux_out[1];
    wire pcd = mux_out[0];

    assign pa_out = {phys_page, addr_in[11:0]};

    wire v_pr;
    and2$ v_pr_and(v_pr, v, pr);

    and2$ hit_and(hit, v_pr, enc_valid);

    assign PCD_out = pcd;
    assign rd_wr_out = rd_wr;



endmodule
