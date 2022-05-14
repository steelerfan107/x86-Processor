
//////////////////////////////////////
//
//  Top Memory Read Stage Module
//

module memory_read_top (
    // Clock Interface
    clk,
    reset,

    // Control Interface
    flush,

    // Write Back Interface (To Pop Addr Dependency)
    wb_valid,
    wb_ready,
    wb_to_memory, 			

    // Memory Read Interface
    a_valid,
    a_ready,
    a_size,
    a_set_d_flag,
    a_clear_d_flag,
    a_op0,
    a_op1,
    a_op0_reg,
    a_op1_reg,
    a_op0_is_address,
    a_op0_is_reg,
    a_op0_is_segment,
    a_op0_is_mmx,
    a_op1_is_reg,
    a_op1_is_address,
    a_imm,
    a_alu_op,
    a_flag_0,
    a_flag_1,
    a_stack_op,
    a_stack_address,
    a_pc,
    a_branch_taken,
    a_to_sys_controller,
    a_opcode,			

    // Pipestage interface
    e_valid,
    e_ready,
    e_size,
    e_set_d_flag,
    e_clear_d_flag,
    e_op_a,
    e_op_b,
    e_op_a_reg,
    e_op_a_address,
    e_op_a_is_address,
    e_op_a_is_reg,
    e_op_a_is_segment,
    e_op_a_is_mmx,
    e_op_b_reg,
    e_op_b_address,
    e_op_b_is_reg,
    e_op_b_is_address,
    e_stack_ptr,
    e_stack_op,
    e_imm,
    e_alu_op,
    e_flag_0,
    e_flag_1,
    e_pc,
    e_branch_taken,
    e_to_sys_controller,
    e_opcode,

    rmem_valid,
    rmem_ready,
    rmem_address,
    rmem_wr_en,
    rmem_wr_data,
    rmem_wr_size,
    rmem_dp_valid,
    rmem_dp_ready,
    rmem_dp_read_data				

);

    // Data Memory Interface Parameters
    parameter DDATAW = 64;
    parameter DSIZEW = 4;
    parameter DADDRW = 32;
   
    // Clock Interface
    input clk;
    input reset;

    // Control Interface
    input flush;

    // Write Back Interface (To Pop Addr Dependency)
    input wb_valid;
    input wb_ready;
    input wb_to_memory;

    // Memory Read Interface
    input a_valid;
    output a_ready;
    input [2:0] a_size;
    input a_set_d_flag;
    input a_clear_d_flag;
    input [63:0] a_op0;
    input [63:0] a_op1;
    input [2:0] a_op0_reg;
    input [2:0] a_op1_reg;
    input a_op0_is_address; 
    input a_op0_is_reg;   
    input a_op0_is_segment;  
    input a_op0_is_mmx;
    input a_op1_is_reg;
    input a_op1_is_address;
    input [47:0] a_imm;
    input [3:0] a_alu_op;
    input [2:0] a_flag_0;
    input [2:0] a_flag_1;
    input [1:0] a_stack_op;
    input [31:0] a_stack_address;   
    input [31:0] a_pc;
    input a_branch_taken;
    input a_to_sys_controller;
    input [15:0] a_opcode;

    // Pipestage interface
    output e_valid;
    input e_ready;
    output [2:0] e_size;            // size of operand, following size defined in #decode channel
    output e_set_d_flag;
    output e_clear_d_flag;
    output [63:0] e_op_a;           // value for operand a
    output [63:0] e_op_b;           // value for operand b
    output [2:0] e_op_a_reg;        // register number for operand a
    output [31:0] e_op_a_address;    // address for operand a
    output e_op_a_is_address;       // Flag showing if operand a is an address (1 for address, 0 for register)
    output e_op_a_is_reg;   
    output e_op_a_is_segment;  
    output e_op_a_is_mmx;   
    output [2:0] e_op_b_reg;
    output [31:0] e_op_b_address;
    output e_op_b_is_reg;
    output e_op_b_is_address;
    output [31:0] e_stack_ptr;      // stack pointer address
    output [1:0]   e_stack_op;
    output [47:0] e_imm;            // immediate
    output [3:0] e_alu_op;          // alu operation defined in #decode channel
    output [2:0] e_flag_0;
    output [2:0] e_flag_1;
    output [31:0] e_pc;
    output e_branch_taken;
    output e_to_sys_controller;
    output [15:0] e_opcode; 

    output                  rmem_valid;
    input   	            rmem_ready;
    output    [DADDRW-1:0]  rmem_address;
    output    	            rmem_wr_en;
    output   [DDATAW-1:0]   rmem_wr_data;
    output   [DSIZEW-1:0]   rmem_wr_size;
    input                   rmem_dp_valid;
    output                  rmem_dp_ready;
    input    [DDATAW-1:0]   rmem_dp_read_data;

    // buffers
    wire [63:0] a_op0_buf;
    buffH16 a_op0_16 (a_op0_buf, a_op0);

    wire [63:0] a_op1_buf;
    buffH16 a_op1_16 (a_op1_buf, a_op1);
   
    // --------- //
    // Pipestage //
    // --------- //

    // localparam PIPEWIDTH = 3+1+1+64+64+3+32+1+1+1+1+3+32+1+1+32+2+48+4+3+3+32+1+1;
    localparam PIPEWIDTH = 3+1+1+64+64+3+32+1+32+48+4+3+3+32+1+1+16+2+3+3+32+1+1;

    // Pipestage interface
    wire p_valid;
    wire p_ready;
    wire [2:0] p_size;            // size of operand, following size defined in #decode channel
    wire p_set_d_flag;
    wire p_clear_d_flag;
    wire [63:0] p_op_a;           // value for operand a
    wire [63:0] p_op_b;           // value for operand b
    wire [2:0] p_op_a_reg;        // register number for operand a
    wire [31:0] p_op_a_address;    // address for operand a
    wire p_op_a_is_address;       // Flag showing if operand a is an address (1 for address, 0 for register)
    wire p_op_a_is_reg;   
    wire p_op_a_is_segment;  
    wire p_op_a_is_mmx;   
    wire [2:0] p_op_b_reg = a_op1_reg;
    wire [31:0] p_op_b_address = a_op1;
    wire p_op_b_is_reg = a_op1_is_reg;
    wire p_op_b_is_address = a_op1_is_address;
    wire [31:0] p_stack_ptr;      // stack pointer address
    wire [1:0] 	p_stack_op;
    wire [47:0] p_imm;            // immediate
    wire [3:0] p_alu_op;          // alu operation defined in #decode channel
    wire [2:0] p_flag_0;
    wire [2:0] p_flag_1;
    wire [31:0] p_pc;
    wire p_branch_taken;
    wire p_to_sys_controller; 
   
    wire [PIPEWIDTH-1:0] pipe_in_data, pipe_out_data;

    assign {
       e_size,
       e_set_d_flag,
       e_clear_d_flag,
       e_op_a,
       e_op_b,
       e_op_a_reg,
       e_op_a_address,
       e_op_a_is_address,
       e_op_a_is_reg,   
       e_op_a_is_segment,  
       e_op_a_is_mmx,
       e_op_b_reg,
       e_op_b_address,
       e_op_b_is_reg,
       e_op_b_is_address,
       e_stack_ptr,
       e_stack_op,
       e_imm,
       e_alu_op,
       e_flag_0,
       e_flag_1,
       e_pc,
       e_branch_taken,
       e_to_sys_controller,
       e_opcode	
    } = pipe_out_data;

    assign pipe_in_data = {
       p_size,
       p_set_d_flag,
       p_clear_d_flag,
       p_op_a,
       p_op_b,
       p_op_a_reg,
       p_op_a_address,
       p_op_a_is_address,
       p_op_a_is_reg,   
       p_op_a_is_segment,  
       p_op_a_is_mmx,
       p_op_b_reg,
       p_op_b_address,
       p_op_b_is_reg,
       p_op_b_is_address,
       p_stack_ptr,
       p_stack_op,
       p_imm,
       p_alu_op,
       p_flag_0,
       p_flag_1,
       p_pc,
       p_branch_taken,
       p_to_sys_controller,
       a_opcode     
    };
   
    // assign p_valid = a_valid;    // decided by ready logic below
    // assign a_ready = p_ready;
    assign p_size = a_size;            
    assign p_set_d_flag = a_set_d_flag;
    assign p_clear_d_flag = a_clear_d_flag;
    // assign p_op_a = a_op0;      // decided by logic below
    // assign p_op_b = a_op1;           
    assign p_op_a_reg = a_op0_reg;
    assign p_stack_op = a_stack_op;

    // If push force in stack address as destination   
    //assign p_op_a_address = (a_stack_op[0]) ? a_stack_address : 'h0;
    wire 		 stack_select;
    and2$ ( stack_select, ~a_stack_op[1], a_stack_op[0]);
   
    mux #(.INPUTS(2),.WIDTH(32)) pop_sel  ({a_stack_address , a_op0_buf[31:0]} ,  p_op_a_address, stack_select);
   
    //assign p_op_a_is_address = a_op0_is_address | (a_stack_op[0]);
   //   
    or2$ ( p_op_a_is_address, a_op0_is_address, stack_select);


    assign p_op_a_is_reg = a_op0_is_reg;
    assign p_op_a_is_segment = a_op0_is_segment;
    assign p_op_a_is_mmx = a_op0_is_mmx;
   
      
    assign p_stack_ptr = a_stack_address;  
    assign p_imm = a_imm;        
    assign p_alu_op = a_alu_op;          
    assign p_flag_0 = a_flag_0;
    assign p_flag_1 = a_flag_1;
    assign p_pc = a_pc;
    assign p_branch_taken = a_branch_taken;
    assign p_to_sys_controller = a_to_sys_controller; 

   
    wire pipestage_reset;
    or2$ or_pipestage (pipestage_reset, reset, flush);

    pipestage #(.WIDTH(PIPEWIDTH)) stage0 ( clk, pipestage_reset, p_valid, p_ready, pipe_in_data, e_valid, e_ready, pipe_out_data);
   
    wire    pop_address_dependency;
    wire    push_address_dependency;   
    wire    addr0_match;
    wire    addr1_match;
    wire    halt, halt0, halt1;

    // ---------------- //
    // DCache Interface //
    // ---------------- //

    wire [63:0] dcache_data_out;

    wire dcache_ready;
    wire dcache_valid;

    wire  read_transaction = a_op0_is_address | a_op1_is_address;

   // wire   read_mask = (~read_transaction) | (rmem_dp_valid & rmem_dp_ready);
   wire   read_mask = (~read_transaction) | (dcache_valid);

   // delay the dcache interface state machine
   
    dcache_interface dcache_interface0 (
        clk,
        reset,

        dcache_data_out,

        (a_valid & ~halt),   // valid in
        e_ready,

        dcache_ready,   // ready out
        dcache_valid,   // valid out

        a_op0_buf,
        a_op0_is_address,
        a_op1_buf,
        a_op1_is_address,

        rmem_valid,
        rmem_ready,
        rmem_address,
        rmem_dp_valid,
        rmem_dp_ready,
        rmem_dp_read_data
    );

    wire [63:0] dcache_out_resized;
    // Mask out any data that is not needed since dcache outputs 64 bits
    memory_read_data_mask memory_read_data_mask0 (
        dcache_out_resized,

        rmem_dp_read_data, //dcache_data_out,
        a_size
    );

    // mux value to op a and op b
    mux #(.WIDTH(64), .INPUTS(2)) op_a_mux (
        {
            dcache_out_resized,
            a_op0_buf
        },
        p_op_a,
        a_op0_is_address
    );

    mux #(.WIDTH(64), .INPUTS(2)) op_b_mux (
        {
            dcache_out_resized,
            a_op1_buf
        },
        p_op_b,
        a_op1_is_address
    );

    // ------------------ //
    // Addredd Dependency //
    // ------------------ //

    and3$ ( pop_address_dependency , wb_valid, wb_ready, wb_to_memory);
    and3$ ( push_address_dependency, e_valid, e_ready, p_op_a_is_address);   // changed from and2 to and3 - brandon

    address_dependency_table (
     // Clock Interface
     .clk(clk),
     .reset(reset),  

     // Control Interface
     .flush(flush),

     // Address Interface In	
     .push(push_address_dependency),		  
     .push_address(p_op_a_address),
     .push_size(p_size),

     // Address Compare Interface
     .compare_address_0(p_op_a_address),
     .compare_address_0_size(p_size),			  
     .compare_address_0_hit(addr0_match),			  

     .compare_address_1(a_op1_buf),
     .compare_address_1_size(p_size),			  
     .compare_address_1_hit(addr1_match),
		  
     // Address Interface Out
     .pop(pop_address_dependency)
   );

   and2$ (halt0, addr0_match, p_op_a_is_address);
   and2$ (halt1, addr1_match, a_op1_is_address);
   or2$  (halt, halt0, halt1);

   //assign halt = 1'b0;

   // Use halt signal to hold tranaction until dependency is cleared

   // ----- //
   // Valid //
   // ----- //

   // valid when address generation is valid and memory read is complete
   and2$ valid_and (p_valid, a_valid, read_mask);

   // ----- //
   // Stall //
   // ----- //
   
   // stall (set ready to 0) if halt is 1, or dcache ready is 0, or e_ready is 0
   // ready if halt is 0 and dcache ready is 1 and e_ready is 1
   // a_ready = ~halt & dcache_ready & e_ready

    wire halt_not;
    inv1$ halt_inv (halt_not, halt);
   
    //and3$ a_ready_and (a_ready, halt_not, dcache_ready, p_ready);
    and3$ a_ready_and (a_ready, halt_not, read_mask, p_ready);
endmodule

// Masks out undesired data since dcache returns 64 bits of data
module memory_read_data_mask (
    out,

    data,
    size
);

    output [63:0] out;

    input [63:0] data;
    input [2:0] size;

    // size_map = 
    // '0'  : "0",
    // '8'  : "1",
    // '16' : "2",
    // '32' : "3",
    // '48' : "4",
    // '64' : "5"

    mux #(.WIDTH(64), .INPUTS(8)) size_mux (
        {
            64'h0,  // 7
            64'h0,  // 6
            data,  // 64
            {16'h0, data[47:0]},  // 48
            {32'h0, data[31:0]},  // 32
            {48'h0, data[15:0]},  // 16
            {56'h0, data[7:0]},  // 8
            64'h0  // 0

        },
        out,
        size
    );


endmodule
