module mem_align(
    input [31:0] reg_out,
    input [1:0] wr_size,
    input [31:0] mem_data,
    input [1:0] off,
    output reg [31:0] out
);

    //assign out = mem_data; 

    // TODO behavioral
    always@(*) begin
        case({off, wr_size})
            4'b0000: out <= mem_data;
            4'b0001: out <= {reg_out[31:8], mem_data[7:0]};
            4'b0010: out <= {reg_out[31:16], mem_data[15:0]};
            4'b0011: out <= {reg_out[31:24], mem_data[23:0]};

            4'b0100: out <= {mem_data[23:0], reg_out[7:0]};
            4'b0111: out <= {mem_data[23:0], reg_out[7:0]};
            4'b0110: out <= {reg_out[31:24], mem_data[15:0], reg_out[7:0]};
            4'b0101: out <= {reg_out[31:16], mem_data[7:0], reg_out[7:0]};
    
            4'b1000: out <= {mem_data[15:0], reg_out[15:0]};
            4'b1010: out <= {mem_data[15:0], reg_out[15:0]};
            4'b1011: out <= {mem_data[15:0], reg_out[15:0]};
            4'b1001: out <= {reg_out[31:24], mem_data[7:0], reg_out[15:0]};

            4'b1100: out <= {mem_data[7:0], reg_out[23:0]};
            4'b1101: out <= {mem_data[7:0], reg_out[23:0]};
            4'b1110: out <= {mem_data[7:0], reg_out[23:0]};
            4'b1111: out <= {mem_data[7:0], reg_out[23:0]};
        endcase
    end

endmodule
