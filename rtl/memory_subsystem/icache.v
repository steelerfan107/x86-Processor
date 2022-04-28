module icache(
    clk,
    reset,
    
    valid,
    ready,
    address,
    dp_valid,
    dp_ready,
    dp_read_data,

    // from the TLB
    phys_addr,
    tlb_hit,
    
    // interface to interconnect
    mem_addr,
    mem_req,
    mem_data_valid,
    mem_data,
    mem_rd_wr,
    mem_en,
    mem_done,

    // Arbiter Interface
    grant_in,
    grant_out,

    bus_busy_out,
    bus_busy_in
    
);

    // Instruction Memory Interface Parameters
    parameter IDATAW = 128;
    parameter ISIZEW = 8;
    parameter IADDRW = 32;

    parameter BUSDATAW = 32;
    parameter BUSADDRW = 32; 

    input clk;
    input reset;
  
    // Fetch Stage Interface  
    input               valid;
    output              ready;
    input  [IADDRW-1:0] address;
    output              dp_valid;
    input               dp_ready;
    output [IDATAW-1:0] dp_read_data;

    // from the TLB
    input [31:0] phys_addr;
    input tlb_hit;
    
    // Interface to Interconnect
    output [BUSADDRW-1:0]  mem_addr;
    output                 mem_req;
    input                  mem_data_valid;
    input  [BUSDATAW-1:0]  mem_data;
    output                 mem_rd_wr;
    output                 mem_en;
    output                 mem_done;

    // Arbitration Signals
    input  grant_in;
    output grant_out;

    output bus_busy_out;
    input bus_busy_in;


    wire [4:0] index = address[31:27];
    wire [22:0] tag = phys_addr[26:4];

    // this should always be 0 for 16B-aligned requests
    wire [3:0] byte_offset = address[3:0]

    itagRAM tagram();
    ivalidRAM validram();

    // 23-bit compare
    // TODO
    wire tag_hit;
    compare #(.WIDTH(23)) comp( , ,tag_hit);

    icache_control control();

    decoder2_4$ accum_decoder();
    // 16B accumulation register here

    idataRAM dataram();

endmodule
