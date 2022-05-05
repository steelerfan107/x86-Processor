module test_memory(
    clk,
    reset,
    addr,
    en,
    data_valid,
    data,
    rd_wr
);
    input clk;
    input reset;

    input [31:0] addr;
    input en;
    output data_valid;
    output [31:0] data;
    input rd_wr;

    reg [31:0] memory [0:1023];

    reg [31:0] out_data;
   
    //always @(posedge clk, negedge reset) begin
    //        
    //
    //end 

    //always @(posedge clk) begin
    //    out_data <= addr;
    //end
    //
    always @(*) begin
        out_data = addr;
    end

    assign data_valid = 1'b1;
    assign data = en ? out_data : 32'dz;
    

endmodule
