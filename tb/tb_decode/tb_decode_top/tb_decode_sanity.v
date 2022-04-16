// tb_register_file.v
// Eric Taylor

// Testbench for testing the fetch stage seperately from everything else

module TOP;
   // Instruction Memory Interface Parameters
   parameter IDATAW = 128;
   parameter ISIZEW = 8;
   parameter IADDRW = 32;

   // Clock Interface
   reg                 clk;
   reg                 reset;

   // Control Interface
   reg 	               flush;
   reg                 handle_int;
   wire                halt;

   // Return Address Stack Interface
   wire [IADDRW-1:0] 	ras_address;
   wire                 ras_push;
	   
   // Fetch Interface  
   reg                  f_valid;
   wire                 f_ready;
   wire [5:0]           f_bytes_read;
   reg [5:0]            f_valid_bytes;
   reg [255:0]          f_instruction;
   reg [IADDRW-1:0]     f_pc;
   reg                  f_branch_taken;

   // Pipestage Interface
   wire 		d_valid;   
   reg 		        d_ready;	       
   wire [2:0]		d_size;   
   wire 		d_set_d_flag;  
   wire 		d_clear_d_flag;   
   wire [2:0]           d_op0;   
   wire [2:0]           d_op1;   
   wire [2:0]           d_op0_reg;   
   wire [2:0]           d_op1_reg;   
   wire [7:0]	        d_modrm;  
   wire [7:0]           d_sib;   
   wire [47:0]          d_imm;   
   wire [31:0]          d_disp;   
   wire [3:0]		d_alu_op;   
   wire [2:0]           d_flag_0;   
   wire [2:0]           d_flag_1;   
   wire [1:0]           d_stack_op;   
   wire [2:0]		d_seg_override;   
   wire  		d_seg_override_valid;
   wire  [IADDRW-1:0]   d_pc;
   wire                 d_branch_taken;
   
   //reg [2047:0]        MEMORY[127:0];
   
   decode_top uut (
     clk,
     reset,
     flush,
     handle_int,
     halt,
     ras_address,
     ras_push,    
     f_valid,
     f_ready,
     f_bytes_read,		   
     f_valid_bytes,
     f_instruction,
     f_pc,
     f_branch_taken,
     d_valid,
     d_ready,		       
     d_size,
     d_set_d_flag,
     d_clear_d_flag,
     d_op0,
     d_op1,
     d_op0_reg,
     d_op1_reg,
     d_modrm,
     d_sib,
     d_imm,
     d_disp,
     d_alu_op,
     d_flag_0,
     d_flag_1,
     d_stack_op,
     d_seg_override,
     d_seg_override_valid,
     d_pc,
     d_branch_taken      	  		  		  
   );
   
    initial begin
        $strobe("============ \n Begin Test \n============");
        reset = 1;
        clk = 0;

        flush = 'h0;
        handle_int = 'h0;
        f_valid_bytes = 9;
        f_instruction = 256'h26814411EEAABBCCDD0000000000000000000000000000000000000000000000;
        f_pc = 'h0;
        f_branch_taken = 'h0;
        d_ready = 'h1;
   
        #55

        reset = 0;

        #20

        $display("==========\n End Test \n==========");
    end

    initial #2000 $finish;

   always @(posedge clk) begin
      if (reset) begin
	 f_valid <= 1'b1;
      end else begin
	 f_valid <= (f_valid) ? ~f_ready : 1'b0;
      end
   end
   
   always #10  clk          = ~clk;
   
    initial begin
        $vcdplusfile("fetch_seq.dump.vpd");
        $vcdpluson(0, TOP);
    end

endmodule
