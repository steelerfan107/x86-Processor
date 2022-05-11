// tb_memory_read_top.v
// 

// Testbench for memory read 

module TOP;
    parameter DDATAW = 64;
    parameter DSIZEW = 4;
    parameter DADDRW = 32;

   // Clock Interface
    reg clk;
    reg reset;

    // Control Interface
    reg flush;

    // Write Back Interface (To Pop Addr Dependency)
    reg wb_valid;
    reg wb_ready;
    reg wb_to_memory;

    // Memory Read Interface
    reg a_valid;
    wire a_ready;
    reg [2:0] a_size;
    reg a_set_d_flag;
    reg a_clear_d_flag;
    reg [63:0] a_op0;
    reg [63:0] a_op1;
    reg [2:0] a_op0_reg;
    reg [2:0] a_op1_reg;
    reg a_op0_is_address; 
    reg a_op0_is_reg;   
    reg a_op0_is_segment;  
    reg a_op0_is_mmx;
    reg a_op1_is_address;
    reg [47:0] a_imm;
    reg [3:0] a_alu_op;
    reg [2:0] a_flag_0;
    reg [2:0] a_flag_1;
    reg [1:0] a_stack_op;
    reg [31:0] a_stack_address;   
    reg [31:0] a_pc;
    reg a_branch_taken;
    reg a_to_sys_controller;
    reg [15:0] a_opcode;

    // Pipestage interface
    wire e_valid;
    reg e_ready;
    wire [2:0] e_size;            // size of operand, following size defined in #decode channel
    wire e_set_d_flag;
    wire e_clear_d_flag;
    wire [63:0] e_op_a;           // value for operand a
    wire [63:0] e_op_b;           // value for operand b
    wire [2:0] e_op_a_reg;        // register number for operand a
    wire [31:0] e_op_a_address;    // address for operand a
    wire e_op_a_is_address;       // Flag showing if operand a is an address (1 for address, 0 for register)
    wire e_op_a_is_reg;   
    wire e_op_a_is_segment;  
    wire e_op_a_is_mmx;   
    wire [31:0] e_stack_ptr;      // stack pointer address
    wire [1:0]   e_stack_op;
    wire [47:0] e_imm;            // immediate
    wire [3:0] e_alu_op;          // alu operation defined in #decode channel
    wire [2:0] e_flag_0;
    wire [2:0] e_flag_1;
    wire [31:0] e_pc;
    wire e_branch_taken;
    wire e_to_sys_controller;
    wire [15:0] e_opcode; 

    wire                  rmem_valid;
    reg   	            rmem_ready;
    wire    [DADDRW-1:0]  rmem_address;
    wire    	            rmem_wr_en;
    wire   [DDATAW-1:0]   rmem_wr_data;
    wire   [DSIZEW-1:0]   rmem_wr_size;
    reg                   rmem_dp_valid;
    wire                  rmem_dp_ready;
    reg    [DDATAW-1:0]   rmem_dp_read_data;

    memory_read_top uut (
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

    initial begin
        $display("============ \n Begin Test \n============");
        // Clock Interface
        clk = 0;
        reset = 1;

        // Control Interface
        flush = 0;

        // Write Back Interface (To Pop Addr Dependency)
        wb_valid = 0;
        wb_ready = 0;
        wb_to_memory = 0;

        // Memory Read Interface
        a_valid = 1;
        a_size = 0;
        a_set_d_flag = 0;
        a_clear_d_flag = 0;
        a_op0 = 0;
        a_op1 = 0;
        a_op0_reg = 0;
        a_op1_reg = 0;
        a_op0_is_address = 0; 
        a_op0_is_reg = 0;   
        a_op0_is_segment = 0;  
        a_op0_is_mmx = 0;
        a_op1_is_address = 0;
        a_imm = 0;
        a_alu_op = 0;
        a_flag_0 = 0;
        a_flag_1 = 0;
        a_stack_op = 0;
        a_stack_address = 0;   
        a_pc = 0;
        a_branch_taken = 0;
        a_to_sys_controller = 0;
        a_opcode = 0;

        // Pipestage interface
        e_ready = 1;

        rmem_ready = 0;
        rmem_dp_valid = 0;
        rmem_dp_read_data = 0;                  

        #10

        $display("==========\n End Test \n==========");
    end

    always #5 clk = ~clk;


    initial #1000 $finish;

    initial begin
        $vcdplusfile("memory_read_top.dump.vpd");
        $vcdpluson(0, TOP);
    end


endmodule