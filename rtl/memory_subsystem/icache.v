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
    grant_out
    
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
    input phys_addr;
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
 

    // TODO implement
    // must use tristate_bus_driver for all tristates 
    // assign mem_rd_wr =  state==reading ? 1'b0 : 1'bZ;


endmodule
