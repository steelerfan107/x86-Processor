module arbiter(
    clk,
    reset,
    req,
    done,
    grant
);
    input clk;
    input reset;

    input req;
    input done;

    output grant;


    // TODO implement
    assign grant = 1'b0;
    
endmodule
