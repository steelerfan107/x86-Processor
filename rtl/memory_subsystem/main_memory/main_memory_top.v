module main_memory_top(
    clk,
    reset,
    en,
    rd_wr,
    addr,
    data,
    valid
);

   input clk;
    input reset;

    input [31:0] addr;
    input en;
    output valid;
    output [31:0] data;
    input rd_wr;

    reg [31:0] memory [0:1023];

    reg [31:0] out_data;

    wire [31:0] 		rom_data_0, rom_data_1, rom_data_2, rom_data_3;

    wire [31:0]			rom_data;

    assign rom_data = (addr[3:2] == 3) ? rom_data_0 : 
                      (addr[3:2] == 2) ? rom_data_1 :    
                      (addr[3:2] == 1) ? rom_data_2 : rom_data_3;
 
    rom32b32w$ test_rom_0 (
     addr[8:4],
     1'b1,
     rom_data_0		      
    );

    rom32b32w$ test_rom_1 (
     addr[8:4],
     1'b1,
     rom_data_1		      
    );
   
    rom32b32w$ test_rom_2 (
     addr[8:4],
     1'b1,
     rom_data_2		      
    );
   
    rom32b32w$ test_rom_3 (
     addr[8:4],
     1'b1,
     rom_data_3		      
    );       

    //always @(posedge clk, negedge reset) begin
    //
    //
    //end

    //always @(posedge clk) begin
    //    out_data <= addr;
    //end
    //
    always @(*) begin
        out_data = rom_data;
    end

    assign valid = 1'b1;
    assign data = en ? out_data : 32'dz;


endmodule
