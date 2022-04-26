module main_memory_top(
    clk,
    reset,
    en,
    rd_wr,
    addr,
    data,
    valid
);

    parameter BUSDATAW = 32;
    parameter BUSADDRW = 32; 

    input clk;
    input reset;

    input en;
    input rd_wr;
   
    input [BUSADDRW-1:0] addr;
    inout [BUSDATAW-1:0] data;
    inout                valid;

    // TODO implement


endmodule
