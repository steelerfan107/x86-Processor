// switched to always granted. don't see why this would be incorrect
module arbiter(
    clk,
    reset,
    req,
    //done,
    grant,
    busy
);
    input clk;
    input reset;

    input req;
    //input done;

    output grant;
    input busy;

    // 1-bit state 
    wire cur_state;
    wire new_state;

    wire n_reset;
    wire n_cur_state;
    wire n_done;
    inv1$ inv1(n_reset, reset);
    inv1$ inv2(n_cur_state, cur_state);
    inv1$ inv3(n_done, done);
    

    //dff$ dff(clk, new_state, cur_state, , n_reset, 1'b1);

    //// FIXME behavioral
    ////assign grant = cur_state || (req & ~cur_state);
    ////assign new_state = (cur_state & ~done) || (~cur_state & req);

    //wire req_ncurstate;
    //and2$ and1(req_ncurstate, req, n_cur_state);
    //or2$ or1(grant, cur_state, req_ncurstate);

    //wire curstate_ndone;
    //and2$ and2(curstate_ndone, cur_state, n_done);
    //or2$ or2(new_state, curstate_ndone, req_ncurstate);
    //
    assign grant = 1'b1;

endmodule
