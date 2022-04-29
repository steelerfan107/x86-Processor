//32 kB disk

module disk();
input clk;
input reset;
input [12:0] disk_address;
input disk_start;
input disk_stop;
output disk_ready;
output reg [31:0] disk_data;

reg [31:0] disk_storage[8191:0];
reg [15:0] count;

localparam CYCLES = 100; //equivalent to 750ns 
integer i;
always @(posedge d_disk_start) begin
  for(i=0; i<8192; i=i+1) begin: disk_data_init
    disk_storage[i] <= $random();
  end 
end

always @(*) begin
  disk_data = disk_storage[disk_address];
end

always @(posedge clk, negedge reset) begin
  if(!reset)
    count <= 16'd0;
  else if(disk_start)
    count <= 16'd1;
  else if(disk_stop)
    count <= 16'd0;
  else if((count != 16'd0) && (count != CYCLES))
    count <= count + 16'd1;
  else
    count <= count;
end

assign disk_ready = (count == CYCLES);

endmodule