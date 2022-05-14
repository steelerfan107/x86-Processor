//32 kB disk

module disk(
input clk,
input reset,
input [7:0] disk_page,
input disk_start,
input disk_stop,
output disk_ready,
output reg [32767:0] disk_data
);

reg [32767:0] disk_storage[0:255];
reg [15:0] count;

localparam CYCLES = 100; //equivalent to 750ns 
integer i;
integer j;

initial begin
  for(i=0; i<256; i=i+1) begin: disk_data_init
    for (j=0;j<32768;j=j+1) begin
        disk_storage[i][j] = $random();
    end
  end 
end

always @(*) begin
  disk_data = disk_storage[disk_page];
end
reg running;
//always @(posedge clk, negedge reset) begin
//  if(!reset) begin
//    count <= 16'd0;
//    running <= 0;
//  end
//  else if(disk_start)
//    running <= 1;
//  else if(disk_stop)
//    running <= 0;
//  else if ((count == CYCLES)) begin
//    count <= 16'd0;
//    running <= 0;
//  end
//  else if((running && (count != CYCLES)))
//    count <= count + 16'd1;
//  else
//    count <= count;
//end

always @(posedge clk, posedge reset) begin
    if(reset) begin
        running = 0;
    end
    else if (running & !(count == CYCLES)) begin
        count <= count + 1;
    end
    else if (running & (count == CYCLES)) begin
        count <= 0;
        running <= 0;
    end
    else if (!running & disk_start) begin
        count<= 0;
        running <= 1;
    end
end

assign disk_ready = (count == CYCLES);

endmodule
