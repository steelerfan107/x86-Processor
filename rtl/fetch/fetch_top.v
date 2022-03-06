//////////////////////////////////////
//
//  Top Fetch Stage Module
//

module fetch_top (
   // Clock Interface
   clk,
   reset,
		  
   // Control Interface
   flush,
   load_address,
   load,
   
   // Code Segment
   cs_register,		  

   // Instruction Memory Interface
   imem_valid,
   imem_ready,
   imem_address,
   imem_wr_en,
   imem_wr_data,
   imem_wr_size,
   imem_dp_valid,
   imem_dp_ready,
   imem_dp_read_data,

   // Branch Predictor Interface
   bp_pc,
   bp_target,
   bp_taken,
		  
   // Return Address Stack Interface
   ras_pop,
   ras_target,
	  
   // Pipestage Interface  
   f_valid,
   f_ready,
   f_bytes_read,		   
   f_valid_bytes,
   f_instruction,
   f_pc,
   f_branch_taken	  		  
		  
);
   // Instruction Memory Interface Parameters
   parameter IDATAW = 64;
   parameter ISIZEW = 8;
   parameter IADDRW = 32;

   // Clock Interface
   input                 clk;
   input                 reset;
   
   // Control Interface
   input 	         flush;
   input [IADDRW-1:0]    load_address;
   input 	         load;
 
   // Code Segment
   input [15:0] 	 cs_register;	

   // Instruction Memory Interface
   output 	         imem_valid;
   input 	         imem_ready;
   output [IADDRW-1:0]   imem_address;
   output 	         imem_wr_en;
   output [IDATAW-1:0]	 imem_wr_data;
   output [ISIZEW-1:0] 	 imem_wr_size;
   input                 imem_dp_valid;
   output                imem_dp_ready;
   input [IDATAW-1:0] 	 imem_dp_read_data;

   // Branch Predictor Interface
   output [IADDRW-1:0] 	 bp_pc;
   input [IADDRW-1:0] 	 bp_target;
   input                 bp_taken;
		  
   // Return Address Stack Interface
   output                ras_pop;
   input [IADDRW-1:0] 	 ras_target;

   // Pipestage Interface  
   output                f_valid;
   input                 f_ready;
   input [5:0]           f_bytes_read;
   output [5:0]          f_valid_bytes;
   output [255:0]        f_instruction;
   output [IADDRW-1:0]   f_pc;
   output                f_branch_taken;
   
   // Wrapper Tieoffs 
   assign imem_valid = 'h0;
   assign imem_address = 'h0;
   assign imem_wr_en = 'h0;
   assign imem_wr_data = 'h0;
   assign imem_wr_size = 'h0;
   assign imem_dp_ready = 'h0;
   assign bp_pc = 'h0;
   assign ras_pop = 'h0;
   assign f_valid = 'h0;
   assign f_valid_bytes = 'h0;
   assign f_instruction = 'h0;
   assign f_pc = 'h0;
   assign f_branch_taken = 'h0;   
   
endmodule
   
