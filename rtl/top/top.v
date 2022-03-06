
//////////////////////////////////////
//
//  Top Module
//

module top (
   clk,
   reset,
   interrupt
);

   // Instruction Memory Interface Parameters
   parameter IDATAW = 64;
   parameter ISIZEW = 8;
   parameter IADDRW = 32;
   parameter NEXTINT = 8;
   
   // CLock Interface
   input                clk;
   input                reset;
   
   // Interrupt Parameters
   input [NEXTINT-1:0]  interrupt;

   // Fetch Control Wires
   wire 	        f_flush;
   wire [IADDRW-1:0]    f_load_address;
   wire 	        f_load;
   
   wire                 d_flush;
   wire                 d_handle_int;
   wire                 d_halt;
   
   // Segment Register Wires
   wire [15:0] 	        cs_register;	

   // Instruction Memory Interface
   wire 	        imem_valid;
   wire 	        imem_ready;
   wire [IADDRW-1:0]    imem_address;
   wire 	        imem_wr_en;
   wire [IDATAW-1:0]	imem_wr_data;
   wire [ISIZEW-1:0] 	imem_wr_size;
   wire                 imem_dp_valid;
   wire                 imem_dp_ready;
   wire [IDATAW-1:0] 	imem_dp_read_data;

   // Branch Predictor Interface
   wire  [IADDRW-1:0] 	bp_pc;
   wire  [IADDRW-1:0] 	bp_target;
   wire                 bp_taken;
		  
   // Return Address Stack Interface
   wire                 ras_pop;
   wire  [IADDRW-1:0] 	ras_target;
   wire                 ras_push;
   wire  [IADDRW-1:0]   ras_address;
   
   // Fetch Interface  
   wire                 f_valid;
   wire                 f_ready;
   wire  [5:0]          f_bytes_read;
   wire  [5:0]          f_valid_bytes;
   wire  [255:0]        f_instruction;
   wire  [IADDRW-1:0]   f_pc;
   wire                 f_branch_taken;

   // Decode Interface
   wire                 d_valid;
   wire                 d_ready;
   wire                 d_mmr;
   wire [2:0] 	        d_rega;
   wire [2:0] 	        d_regb;
   wire [31:0] 	        d_imm;
   wire [31:0] 	        d_disp;
   wire [5:0] 	        d_seg_ov; // One Hot {CS, SS, DS, ES, FS, GS}
   wire [7:0] 	        d_sib;
   wire [3:0] 	        d_op;
   wire                 d_opsize;
   wire [5:0] 	        d_alu;
   wire                 d_repeat;
   wire [3:0]           d_size_of_txn;
   wire                 d_branch_taken;   
   
   fetch_top  #(
     .IDATAW(IDATAW),
     .ISIZEW(ISIZEW),
     .IADDRW(IADDRW)	
   ) fetch_top (
      .clk (clk),
      .reset (reset),
      .flush(f_flush),
      .load_address(f_load_address),
      .load(f_load),
      .cs_register(cs_register),
      .imem_valid(imem_valid),
      .imem_ready(imem_ready),
      .imem_address(imem_address),
      .imem_wr_en(imem_wr_en),
      .imem_wr_data(imem_wr_data),
      .imem_wr_size(imem_wr_size),
      .imem_dp_valid(imem_dp_valid),
      .imem_dp_ready(imem_dp_ready),
      .imem_dp_read_data(imem_dp_read_data),
      .bp_pc(bp_pc),
      .bp_target(bp_target),
      .bp_taken(bp_taken),
      .ras_pop(ras_pop),
      .ras_target(ras_target),
      .f_valid(f_valid),
      .f_ready(f_ready),
      .f_bytes_read(f_bytes_read),
      .f_valid_bytes(f_valid_bytes),
      .f_instruction(f_instruction),
      .f_pc(f_pc),
      .f_branch_taken(f_branch_taken)	
   );

   decode_top  #(
     .ISIZEW(ISIZEW)	
   ) decode_top (
      .clk (clk),
      .reset (reset),		 
      .flush(d_flush),
      .handle_int(d_handle_int),
      .halt(d_halt),	
      .ras_address(ras_address),
      .ras_push(ras_push),	 
      .f_valid(f_valid),
      .f_ready(f_ready),
      .f_bytes_read(f_bytes_read),
      .f_valid_bytes(f_valid_bytes),
      .f_instruction(f_instruction),
      .f_pc(f_pc),
      .f_branch_taken(f_branch_taken),
      .d_valid(d_valid),
      .d_ready(d_ready),		  
      .d_mmr(d_mmr),
      .d_rega(d_rega),
      .d_regb(d_regb),
      .d_imm(d_imm),
      .d_disp(d_disp),
      .d_seg_ov(d_seg_ov),
      .d_sib(d_sib),
      .d_op(d_op),
      .d_opsize(d_opsize),
      .d_alu(d_alu),
      .d_repeat(d_repeat),
      .d_size_of_txn(d_size_of_txn),
      .d_branch_taken(d_branch_taken)	
   );   

endmodule
   
