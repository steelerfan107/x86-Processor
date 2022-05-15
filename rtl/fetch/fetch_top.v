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
   seg_limit_int, 

   // Set EIP
   eip,
   set_eip,		  

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
   parameter IDATAW = 128;
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
   output                seg_limit_int;

   output [31:0] 	 eip;
   output                set_eip;	

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
   output [6:0]          f_valid_bytes;
   output [255:0]        f_instruction;
   output [IADDRW-1:0]   f_pc;
   output                f_branch_taken;


   wire 		 flush_not;

   // ----------------------
   //
   //  Segment Limit Check
   //

   segment_limit_check i_seg_check (
        seg_limit_int,
        imem_address,
        imem_v ,

        3'b001,

        cs_register,
        16'b0,
        16'b0,
        16'b0,
        16'b0,
        16'b0,

        3'd5
    );
   
   wire [127:0] 	 imem_dp_read_data_endian_corrected;

   assign imem_dp_read_data_endian_corrected = {imem_dp_read_data[31:0],
                                                imem_dp_read_data[63:32],
                                                imem_dp_read_data[95:64],
                                                imem_dp_read_data[127:96]};

   wire 		 internal_reset;

   wire 		 iq_valid, nc0;
   wire 		 iq_ready;
   wire [3:0]		 bytes_read_o;  
	
   or2$ ir (internal_reset, flush, reset);
   
   wire 		 outstanding, outstanding_in, drop, drop_in, n_drop;
   wire                  masked_dp_valid;
   
   // EIP Logic
   wire 		 out_accept;
   wire [31:0] 		 minus_cs;
   wire [31:0] 		 pc_in, pc_out, n_pc_out, pc_p_bytes_read;

   assign set_eip = load;
   assign eip = load_address;

   //assign minus_cs = load_address - cs_register;
  // subtract #(.WIDTH(32)) (
//	load_address,
   //     {cs_register,16'b0},
   //     minus_cs	 
   //);
   
   and2$ out_acc ( out_accept, f_valid, f_ready);

   slow_addr #(.WIDTH(32)) ({26'b0,f_bytes_read},pc_out,pc_p_bytes_read,nc0); 
   
   mux  #(.WIDTH(32),.INPUTS(2)) idt_select ( {load_address, pc_p_bytes_read}, pc_in, load);

   wire 		 out_accept_or_load;

   or2$ (out_accept_or_load, out_accept, load);
   
   register #(.WIDTH(32)) pc_reg (
               clk,
               reset,
               pc_in,
               pc_out,
               n_pc_out,
               out_accept_or_load				    
           );

   // Logic to drop outstanding response if flush occurs
   wire 		 memory_accept;
   wire                  outstanding_a_flush;
   wire                  not_outstanding;
   wire                  not_data_accept__and__outstanding;
   wire                  not_cmd_accept;
   wire                  not_cmd_accept_and_load;
   wire 		 load_hold, load_hold_in;
   
   
   inv1$ ( not_outstanding, outstanding);
  
   
   and2$( memory_accept, imem_valid, imem_ready);
   nand2$( not_data_accept, imem_dp_valid, imem_dp_ready);
   nand2$( not_cmd_accept, imem_valid, imem_ready);
   
   and2$ (not_data_accept__and__outstanding,  not_data_accept, outstanding);

   
   mux2$ ( outstanding_in , memory_accept, not_data_accept, outstanding);
   and2$ ( outstanding_a_flush, outstanding, flush);
   mux2$ ( drop_in , outstanding_a_flush, not_data_accept__and__outstanding, drop);

   and2$ ( not_cmd_accept_and_load, not_cmd_accept, load);
   mux2$ ( load_hold_in , not_cmd_accept_and_load, not_cmd_accept, load_hold);

   register #(.WIDTH(1)) outstanding_reg (
               clk,
               reset,
               outstanding_in,
               outstanding,
               nc0,
               1'b1				    
           );   
 
   register #(.WIDTH(1)) drop_reg (
               clk,
               reset,
               drop_in,
               drop,
               n_drop,	
               1'b1			    
           );

   register #(.WIDTH(1)) load_hold_reg (
               clk,
               reset,
               load_hold_in,
               load_hold,
               ,	
               1'b1			    
           );    

   and2$ ( masked_dp_valid,  n_drop, imem_dp_valid);
  
   // Instruction Queue
   instruction_queue iq (
      .clk(clk),
      .reset(reset),  
      .load_address(load_address[5:0]),
      .load(load),
      .flush(flush),			 
      .valid_i(masked_dp_valid),
      .ready_i(imem_dp_ready),		  
      .data_i(imem_dp_read_data_endian_corrected),
      .valid_o(f_valid),
      .ready_o(f_ready),
      .bytes_read_o(f_bytes_read[3:0]),
      .valid_bytes_o(f_valid_bytes),
      .intruction_o(f_instruction)   
   );

   //assign f_valid_bytes[5:4] = 'h0;

   // Address Generation
   address_generation ag (
       .clk(clk),
       .reset(reset),
       .load_address(load_address),
       .load(load),
       .cs_register(cs_register), 
       .imem_valid(imem_valid),
       .imem_ready(imem_ready),
       .imem_address(imem_address)				  
   );
   
   // Wrapper Tieoffs
   inv1$ finv (flush_not, flush);
   or3$ imem_vo (imem_v, flush_not, load, load_hold);   

   wire 		 not_ex;
   inv1$ (not_ex, seg_limit_int);
   and2$ (imem_valid, imem_v, not_ex);
   
   //assign imem_valid = imem_v & ~;
   assign imem_wr_en = 'h0;
   assign imem_wr_data = 'h0;
   assign imem_wr_size = 'h0;
   
   assign bp_pc = 'h0;
   assign ras_pop = 'h0;
   assign f_pc = pc_p_bytes_read;
   assign f_branch_taken = 'h0;   
   
endmodule
   
