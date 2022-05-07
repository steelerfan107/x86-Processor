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
      rom_control,
      eflags_reg,
      eip_reg,
      dec_imm,
      handle_int_done
);

   localparam [4:0]  PROGRAM0_OFFSET = 0;
   localparam [4:0]  PROGRAM1_OFFSET = 6;
   localparam [4:0]  PROGRAM2_OFFSET = 7;
   localparam [4:0]  PROGRAM3_OFFSET = 18;
   localparam [4:0]  PROGRAM4_OFFSET = 4;
   localparam [4:0]  PROGRAM5_OFFSET = 4;
   localparam [4:0]  PROGRAM6_OFFSET = 4;
   localparam [4:0]  PROGRAM7_OFFSET = 4;
   localparam [4:0]  PROGRAM8_OFFSET = 10;
   localparam [4:0]  PROGRAM9_OFFSET = 12;
   localparam [4:0]  PROGRAM10_OFFSET = 14;
   localparam [4:0]  PROGRAM11_OFFSET = 16;
   localparam [4:0]  PROGRAM12_OFFSET = 4;
   localparam [4:0]  PROGRAM13_OFFSET = 4;
   localparam [4:0]  PROGRAM14_OFFSET = 4;
   localparam [4:0]  PROGRAM15_OFFSET = 4;
   
   localparam [4:0]  PROGRAM0_LENGTH = 4-1;
   localparam [4:0]  PROGRAM1_LENGTH = 6-1;
   localparam [4:0]  PROGRAM2_LENGTH = 3-1;
   localparam [4:0]  PROGRAM3_LENGTH = 2-1;
   localparam [4:0]  PROGRAM4_LENGTH = 5-1;
   localparam [4:0]  PROGRAM5_LENGTH = 3-1;
   localparam [4:0]  PROGRAM6_LENGTH = 3-1;
   localparam [4:0]  PROGRAM7_LENGTH = 5-1;
   localparam [4:0]  PROGRAM8_LENGTH = 2-1;
   localparam [4:0]  PROGRAM9_LENGTH = 2-1;
   localparam [4:0]  PROGRAM10_LENGTH = 2-1;
   localparam [4:0]  PROGRAM11_LENGTH = 2-1;
   localparam [4:0]  PROGRAM12_LENGTH = 5-1;
   localparam [4:0]  PROGRAM13_LENGTH = 3-1;
   localparam [4:0]  PROGRAM14_LENGTH = 3-1;
   localparam [4:0]  PROGRAM15_LENGTH = 5-1;
   
   parameter IADDRW = 64;
   
   localparam ROM_WIDTH = 3+1+1+3+3+5+5+8+8+4+3+3+2+1+1+2;

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
   input     [3:0]        rom_control;
   input [31:0] 	  eflags_reg;
   input [31:0] 	  eip_reg;
   input [47:0] 	  dec_imm;
   output                 handle_int_done;
   
   wire [2:0] 		  from_rom_size;
   wire  		  from_rom_set_d_flag;
   wire  		  from_rom_clear_d_flag;
   wire [2:0] 		  from_rom_op0;
   wire [2:0] 		  from_rom_op1;
   wire [4:0] 		  from_rom_op0_reg;
   wire [4:0] 		  from_rom_op1_reg;
   wire [7:0] 		  from_rom_modrm;
   wire [7:0] 		  from_rom_sib;
   wire [3:0] 		  from_rom_alu_op;
   wire [2:0] 		  from_rom_flag_0;
   wire [2:0] 		  from_rom_flag_1;
   wire [1:0] 		  from_rom_stack_op;
   wire  		  from_rom_seg_override;
   wire  		  from_rom_seg_override_valid;  
   wire [1:0] 		  from_rom_imm_select;

   wire 		  in_accept, out_accept;
   wire 		  state, rom_control_or;
   wire 		  next_state;
   wire [4:0] 		  micro_count,micro_count_not, micro_count_next;
   wire                   nc0;

   wire [4:0] 		  micro_length;
   wire [4:0] 		  micro_offset;
   wire [4:0] 		  micro_address;

   wire [127:0] 	  rom_data;

   wire                   rom_control_is_six;

   // Int Program Done
   compare #(.WIDTH(4)) control_compare (rom_control, 4'd6, rom_control_is_six); 

   and2$ int_done_and (handle_int_done, rom_control_is_six, rom_ready);

   // Accept Signaling
   and3$ inaa (in_accept,  s0_ready, s0_valid, rom_in_control);
   and3$ onaa (out_accept, s1_ready, s1_valid, rom_in_control);

   // ROM in Control Logic
   logic_tree #(.WIDTH(4), .OPERATION(1)) rcr (rom_control, rom_control_or);

   // State Machine
   wire state_not;
   mux #(.WIDTH(1),.INPUTS(2)) ns_mux ({in_accept,rom_control_or}, next_state, state);
   register  #(.WIDTH(1)) state_reg (clk, reset, next_state, state, state_not, 1'b1);

   // Micro Count
   wire [4:0] micro_count_next_p1;
   
   slow_addr #(.WIDTH(5)) sac (5'd1, micro_count, micro_count_next_p1, nc0);
   mux #(.WIDTH(5),.INPUTS(2)) mc_mux ({5'd0,micro_count_next_p1}, micro_count_next, (out_accept & rom_ready));  
 
   register  #(.WIDTH(5)) micro_reg (clk, reset, micro_count_next, micro_count, micro_count_not, out_accept);

   // Control Select
   mux #(.WIDTH(5),.INPUTS(16)) cs_mux ( {
                                   PROGRAM15_LENGTH,
                                   PROGRAM14_LENGTH,
                                   PROGRAM13_LENGTH,
                                   PROGRAM12_LENGTH,
                                   PROGRAM11_LENGTH,
                                   PROGRAM10_LENGTH,
                                   PROGRAM9_LENGTH,
                                   PROGRAM8_LENGTH,					  
                                   PROGRAM7_LENGTH,
                                   PROGRAM6_LENGTH,
                                   PROGRAM5_LENGTH,
                                   PROGRAM4_LENGTH,
                                   PROGRAM3_LENGTH,
                                   PROGRAM2_LENGTH,
                                   PROGRAM1_LENGTH,
                                   PROGRAM0_LENGTH
                                  }, micro_length, rom_control);
   
   mux #(.WIDTH(5),.INPUTS(16)) mo_mux ( {
                                   PROGRAM15_OFFSET,
                                   PROGRAM14_OFFSET,
                                   PROGRAM13_OFFSET,
                                   PROGRAM12_OFFSET,
                                   PROGRAM11_OFFSET,
                                   PROGRAM10_OFFSET,
                                   PROGRAM9_OFFSET,
                                   PROGRAM8_OFFSET,					  
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
   rom64b32w$ b0 (micro_address, 1'b1, rom_data[127:64]);
   rom64b32w$ b1 (micro_address, 1'b1, rom_data[63:0]);
   
   mux #(.WIDTH(48),.INPUTS(4)) rom_imm_mux ( {
                                   48'h0,
                                   {16'b0,eflags_reg},
                                   {16'b0,eip_reg},
                                   dec_imm
			           }, rom_imm, from_rom_imm_select); 
   
   // Assign Outputs from ROM Data
   assign     rom_valid = 1'b1;
   assign     rom_size = from_rom_size;
   assign     rom_set_d_flag = from_rom_set_d_flag;
   assign     rom_clear_d_flag = from_rom_clear_d_flag;  
   assign     rom_op0 = from_rom_op0;   
   assign     rom_op1 = from_rom_op1;  
   assign     rom_op0_reg = from_rom_op0_reg[2:0];  
   assign     rom_op1_reg = from_rom_op1_reg[2:0];   
   assign     rom_modrm = from_rom_modrm;  
   assign     rom_sib = from_rom_sib;  
   assign     rom_disp = 'h0;  
   assign     rom_alu_op = from_rom_alu_op;   
   assign     rom_flag_0 = from_rom_flag_0;   
   assign     rom_flag_1 = from_rom_flag_1;   
   assign     rom_stack_op = from_rom_stack_op;   
   assign     rom_seg_override = from_rom_seg_override; 
   assign     rom_seg_override_valid = from_rom_seg_override_valid;
   
   assign {
             from_rom_size,
             from_rom_set_d_flag,
             from_rom_clear_d_flag,
             from_rom_op0,
             from_rom_op1,
             from_rom_op0_reg,
             from_rom_op1_reg,
             from_rom_modrm,
             from_rom_sib,
             from_rom_alu_op,
             from_rom_flag_0,
             from_rom_flag_1,
             from_rom_stack_op,
             from_rom_seg_override,
             from_rom_seg_override_valid,  
             from_rom_imm_select	   
   } = rom_data[127:127-(ROM_WIDTH-1)];
      
endmodule   
   
