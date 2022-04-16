module rom_block (
      clk,
      reset,
      s0_ready,
      s0_valid,
      s1_valid,
      s1_ready,
      rom_valid,   
      rom_ready,	       
      rom_size,   
      rom_set_d_flag,  
      rom_clear_d_flag,   
      rom_op0,   
      rom_op1,   
      rom_op0_reg,   
      rom_op1_reg,   
      rom_modrm,  
      rom_sib,   
      rom_imm,   
      rom_disp,   
      rom_alu_op,   
      rom_flag_0,   
      rom_flag_1,   
      rom_stack_op,   
      rom_seg_override,   
      rom_seg_override_valid,
      rom_pc,
      rom_branch_taken,  
      rom_in_control,
      rom_control
);

   localparam [4:0]  PROGRAM0_OFFSET = 0;
   localparam [4:0]  PROGRAM1_OFFSET = 6;
   localparam [4:0]  PROGRAM2_OFFSET = 14;
   localparam [4:0]  PROGRAM3_OFFSET = 24;
   localparam [4:0]  PROGRAM4_OFFSET = 24;
   localparam [4:0]  PROGRAM5_OFFSET = 24;
   localparam [4:0]  PROGRAM6_OFFSET = 24;
   localparam [4:0]  PROGRAM7_OFFSET = 24;

   localparam [4:0]  PROGRAM0_LENGTH = 4;
   localparam [4:0]  PROGRAM1_LENGTH = 6;
   localparam [4:0]  PROGRAM2_LENGTH = 8;
   localparam [4:0]  PROGRAM3_LENGTH = 5;
   localparam [4:0]  PROGRAM4_LENGTH = 5;
   localparam [4:0]  PROGRAM5_LENGTH = 5;
   localparam [4:0]  PROGRAM6_LENGTH = 5;
   localparam [4:0]  PROGRAM7_LENGTH = 5;

   parameter IADDRW = 64;
   
   localparam ROM_WIDTH = 129;

   input                  clk;
   input                  reset;
   input                  s0_ready;
   input                  s0_valid;
   input                  s1_valid;
   input                  s1_ready;    
   output		  rom_valid;   
   output 	          rom_ready;	       
   output    [2:0]	  rom_size;   
   output    	          rom_set_d_flag;  
   output    		  rom_clear_d_flag;   
   output    [2:0]        rom_op0;   
   output    [2:0]        rom_op1;   
   output    [2:0]        rom_op0_reg;   
   output    [2:0]        rom_op1_reg;   
   output    [7:0]	  rom_modrm;  
   output    [7:0]        rom_sib;   
   output    [47:0]       rom_imm;   
   output    [31:0]       rom_disp;   
   output    [3:0]        rom_alu_op;   
   output    [2:0]        rom_flag_0;   
   output    [2:0]        rom_flag_1;   
   output    [1:0]        rom_stack_op;   
   output    [2:0]        rom_seg_override;   
   output    		  rom_seg_override_valid;
   output    [IADDRW-1:0] rom_pc;
   output                 rom_branch_taken; 
   input 		  rom_in_control;
   input     [2:0]        rom_control; 

   wire 		  in_accept, out_accept;
   wire 		  state, rom_control_or;
   wire 		  next_state;
   wire [4:0] 		  micro_count,micro_count_not, micro_count_next;
   wire                   nc0;

   wire [4:0] 		  micro_length;
   wire [4:0] 		  micro_offset;
   wire [4:0] 		  micro_address;

   wire [191:0] 	  rom_data;

   // Accept Signaling
   and2$ inaa (in_accept,  s0_ready, s0_valid);
   and2$ onaa (out_accept, s1_ready, s1_valid);

   // ROM in Control Logic
   logic_tree #(.WIDTH(3), .OPERATION(1)) rcr (rom_control, rom_control_or);
   or2$ ric (rom_in_control, state, rom_control_or);

   // State Machine
   wire state_not;
   mux #(.WIDTH(1),.INPUTS(2)) ns_mux ({in_accept,rom_control_or}, next_state, state);
   register  #(.WIDTH(1)) state_reg (clk, reset, next_state, state, state_not, 1'b1);

   // Micro Count
   slow_addr #(.WIDTH(5)) sac (5'd1, micro_count, micro_count_next, nc0);
   register  #(.WIDTH(5)) micro_reg (clk, reset, micro_count_next, micro_count, micro_count_not,out_accept);

   // Control Select
   mux #(.WIDTH(5),.INPUTS(8)) cs_mux ( {
                                   PROGRAM7_LENGTH,
                                   PROGRAM6_LENGTH,
                                   PROGRAM5_LENGTH,
                                   PROGRAM4_LENGTH,
                                   PROGRAM3_LENGTH,
                                   PROGRAM2_LENGTH,
                                   PROGRAM1_LENGTH,
                                   PROGRAM0_LENGTH
                                  }, micro_length, rom_control);
   
   mux #(.WIDTH(5),.INPUTS(8)) mo_mux ( {
                                   PROGRAM7_OFFSET,
                                   PROGRAM6_OFFSET,
                                   PROGRAM5_OFFSET,
                                   PROGRAM4_OFFSET,
                                   PROGRAM3_OFFSET,
                                   PROGRAM2_OFFSET,
                                   PROGRAM1_OFFSET,
                                   PROGRAM0_OFFSET
                                  },
                                  micro_offset, rom_control);

   // Address Generation
   slow_addr #(.WIDTH(5)) offset_add (micro_offset, micro_count, micro_address, nc0);

   // Micro Program Complete
   compare #(.WIDTH(5)) count_compare (micro_count, micro_length, rom_ready);

   // ROM Blocks
   rom64b32w$ b0 (micro_address, 1'b1, rom_data[63:0]);
   rom64b32w$ b1 (micro_address, 1'b1, rom_data[127:64]);
   rom64b32w$ b2 (micro_address, 1'b1, rom_data[191:128]);
      
   // Assign Outputs from ROM Data
   assign rom_valid = 1'b1;
   assign {
              rom_size,   
              rom_set_d_flag,  
              rom_clear_d_flag,   
              rom_op0,   
              rom_op1,   
              rom_op0_reg,   
              rom_op1_reg,   
              rom_modrm,  
              rom_sib,   
              rom_imm,   
              rom_disp,   
              rom_alu_op,   
              rom_flag_0,   
              rom_flag_1,   
              rom_stack_op,   
              rom_seg_override,  
              rom_seg_override_valid
	   } = rom_data[ROM_WIDTH-1:0];
      
endmodule   
   
