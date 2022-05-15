module keyboard(
    input clk,
    input reset,
    input [31:0] data_in,
    input [7:0] ASCII,
    input LD_ASCII,
    input LD_KBSR,
    output [31:0] KBSR,
    input RD_KBDR,
    output [31:0] KBDR,
    output KB_INT
);
    reg [31:0] KBSR_reg;
    reg [31:0] KBDR_reg;

    always@(posedge clk or posedge reset) begin 
        if(reset)begin 
            KBSR_reg <= 32'b0;
            KBDR_reg <= 32'b0; 
        end
        else begin 
            if(LD_ASCII) begin 
                KBDR_reg <= {24'b0, ASCII};
                KBSR_reg[31] <= 1'b1;
            end
            else if(RD_KBDR) begin 
                KBSR_reg[31] <= 1'b0;
            end
            if(LD_KBSR) begin 
                KBSR_reg[30:0] <= data_in[30:0];
            end
        end
    end

    assign KBSR = KBSR_reg;
    assign KBDR = KBDR_reg;

    assign KB_INT = KBSR_reg[15] & KBSR_reg[14];
endmodule