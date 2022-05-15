module dma(
    input clk,
    input reset,
    
    input en,
    inout [31:0] addr,
    inout [31:0] data,
    input grant_in,
    output grant_out,
    input mem_ready,
    input busy_in,
    output busy_out,
    output mem_en,
    output [1:0] wr_size, 
    output dma_int,
    inout rd_wr
);
    parameter IDLE = 3'b000;
    parameter BUFFER = 3'b001;
    parameter BUS_WAIT_WR = 3'b010;
    parameter WRITE = 3'b011;
    parameter INTERRUPT = 3'b100;

    reg [31:0] src;
    reg [31:0] dst;
    reg [31:0] addr_temp;
    reg [11:0] size;
    reg [2:0] state;
    reg [11:0] bytes_left;
    reg [11:0] offset;
   
    wire write_done;
 
    reg start;
    wire [32767:0] disk_data;
    reg [7:0] buffer [0:4095];
    genvar i;
    generate
        for (i = 0; i <4096; i=i+1) begin
            always@(*) begin
                buffer[i] = disk_data[(i*8)+7:i*8];
            end
        end
    endgenerate

    wire disk_ready;
    reg dma_flag;
    wire bus_en;
    wire disk_start = (state == IDLE) & start;
    disk Disk(
        clk,
        reset,
        src[19:12],
        disk_start, 
        1'b0,
        disk_ready,
        disk_data
    );


    always @(posedge clk, reset) begin
        if (reset) begin
            src <= 32'h0;
            dst <= 32'h0;
            size <= 13'h0;
            start <= 0;
            state <= IDLE;
        end 
        else if(clk) begin
            case (state) 
                IDLE: begin 
                    if(start)begin 
                        bytes_left <= size;
                        offset <= 12'd0;
                        addr_temp <= dst;
                        state <= BUFFER;
                    end
                end
                BUFFER: begin 
                    if(!disk_ready)
                        state <= BUFFER;
                    else if(disk_ready)begin 
                        state <= BUS_WAIT_WR;
                    end
                end
                BUS_WAIT_WR: begin 
                    if(!grant_in || busy_in)
                        state <= BUS_WAIT_WR;
                    else if(grant_in && !busy_in)
                        state <= WRITE;
                end
                WRITE: begin   
                    if(!mem_ready)
                        state <= WRITE;
                    else if(mem_ready && ~write_done && grant_in) begin 
                        addr_temp <= addr_temp + 4;
                        bytes_left <= bytes_left - 4;
                        offset <= offset + 4;
                        state <= WRITE;
                    end
                    else if(mem_ready && ~write_done && !grant_in) begin 
                        addr_temp <= addr_temp + 4;
                        bytes_left <= bytes_left - 4;
                        offset <= offset + 4;
                        state <= BUS_WAIT_WR;
                    end 
                    else if(mem_ready && write_done) begin 
                        state <= INTERRUPT;
                    end
                end
                INTERRUPT: begin 
                    dma_flag <= 1'b1;
                    state <= IDLE;
                end
                default: 
                    state <= IDLE;
            endcase
        end
    end

//reg [31:0] buffer_32b;
//integer i;
//always @(*)begin
//for(i = (addr-dst-4)*8; i < (addr-dst)*8; i=i+1)
//    buffer_32b[i] <= buffer[i];
//end

assign bus_en = (state == WRITE);
assign rd_wr = bus_en ? 1'b1 : 1'bz;
assign addr = (bus_en) ? addr_temp : 32'bz;
assign data = (bus_en) ? {buffer[offset], buffer[offset+1], buffer[offset+2], buffer[offset+3]} : 32'bz;
assign dma_int = dma_flag;
assign busy_out = bus_en;
//assign mem_en = bus_en ? 1'b1 : 1'bz;
assign mem_en = bus_en;
assign wr_size = (bytes_left < 4) ? bytes_left[1:0] : 2'b00;
assign write_done = wr_size != 0;

endmodule
