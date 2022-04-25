//////////////////////////////////////
//
//  Top Execute Stage Module
//

module execute_top (
    // Clock Interface
    clk,
    reset,

    // Control Interface
    flush,

    // Pipestage Interface
    e_valid,
    e_ready,
    e_mmr,
    e_op_a,
    e_op_b,
    e_stack_ptr,
    e_op,
    e_opsize,
    e_size_of_txn,
    e_branch_taken,

    // Writeback Interface
    wb_ready,
    wb_dest_address,
    wb_dest_reg,
    wb_result,
    wb_opsize,
    wb_mem_or_reg,
    wb_valid,
    wb_branch_taken
);
    // Clock Interface
    input clk;
    input reset;

    // Control Interface
    input flush;

    // Pipestage Interface
    input e_valid;
    output e_ready;
    input e_mmr;
    input [63:0] e_op_a;
    input [63:0] e_op_b;
    input [31:0] e_stack_ptr;
    input [3:0] e_op;
    input [1:0] e_opsize;
    input e_size_of_txn;
    input e_branch_taken;

    // Writeback Interface
    input wb_ready;
    output [31:0] wb_dest_address;
    output [31:0] wb_dest_reg;
    output [63:0] wb_result;
    output [1:0] wb_opsize;
    output wb_mem_or_reg;
    output wb_valid;
    output wb_branch_taken;

   

    wire [63:0] a;
    wire [63:0] b;
    wire [15:0] sext16_b;
    wire [31:0] sext32_b;
    wire [31:0] e_alu_out;
    wire [5:0] e_alu_set_eflags; 
    wire [5:0] e_alu_eflags_out; 
    wire [63:0] e_simd_out;
    wire [5:0] e_eflags_out;
    wire [31:0] e_cmovc_out;
    wire [31:0] e_cmpxchg_out;
    wire [63:0] e_xchg_out;

    // -------   //
    // Pipestage //
    // -------   //
    // Some Temp Logic
   
    localparam PIPEWIDTH = 32+32+64+2+1+1;

    wire [31:0] p_dest_address;
    wire [31:0] p_dest_reg;
    wire [63:0] p_result;
    wire [1:0] p_opsize;
    wire p_mem_or_reg;
    wire p_branch_taken;
   
    wire [PIPEWIDTH-1:0] pipe_in_data, pipe_out_data;   

    assign p_dest_address = 'h0;   
    assign p_dest_reg = 'h0;
    assign p_result = (~|e_op) ? e_op_b : e_op_a + e_op_b;
    assign p_opsize = 'h0;
    assign p_mem_or_reg = 'h0;
    assign p_branch_taken = 'h0;

    assign pipe_in_data = {
        p_dest_address,
        p_dest_reg,
        p_result,
        p_opsize,
        p_mem_or_reg,
        p_branch_taken		    
    };

    assign {
        wb_dest_address,
        wb_dest_reg,
        wb_result,
        wb_opsize,
        wb_mem_or_reg,
        wb_branch_taken		    
    } = pipe_out_data; 

    pipestage #(.WIDTH(PIPEWIDTH)) stage ( clk, (reset | flush), e_valid, e_ready, pipe_in_data, wb_valid, wb_ready, pipe_out_data);

    genvar i;
    generate
    for(i = 0; i < 64; i = i+1) begin : opa_buffer_block
        bufferH64$ instance(.out(a[i]), .in(e_op_a[i]));
    end
    endgenerate

    generate
    for(i = 0; i < 64; i = i+1) begin : opb_buffer_block
        bufferH64$ instance(.out(b[i]), .in(e_op_b[i]));
    end
    endgenerate

    SEXT16 sext16(.in(b[7:0]), .out(sext16_b), .en(e_opsize[0]));
    SEXT32 sext32(.in(b[7:0]), .out(sext32_b), .en(e_opsize[1]));

    ALU alu(.a(a[31:0]), .b(b[31:0]), .opsize(e_opsize), .alu_op(e_op), .set_eflags(e_alu_set_eflags), .eflags_out(e_alu_eflags_out));

    SIMD simd_unit(.mm(a), .mm64(b), .simd_op(e_op[2:0]), .out(e_simd_out));

    eflags eflags(.eflags_in(), .set_eflags(), .eflags_out(e_eflags_out));

    CMOVC cmovc(.a(a[31:0]), .b(b[31:0]), .CF(eflags_out[1]), .out(e_cmovc_out));
    CMPXCHG cmpxchg();
    DAA daa(.CF(e_eflags_out[1]), .AF(e_eflags_out[2]), .CF_out(), .AF_out()); //need EAX/AX/AL
    XCHG xchg(.dest(a), .src(b), .out(e_xchg_out));
endmodule
