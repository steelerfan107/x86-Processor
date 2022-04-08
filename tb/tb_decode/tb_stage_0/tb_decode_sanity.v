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
   wire                 d_valid;
   reg                  d_ready;
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
      d_mmr,
      d_rega,
      d_regb,
      d_imm,
      d_disp,
      d_seg_ov,
      d_sib,
      d_op,
      d_opsize,
      d_alu,
      d_repeat,
      d_size_of_txn,
      d_branch_taken	  		  		  
   );
   
    initial begin
        $strobe("============ \n Begin Test \n============");
        reset = 1;
        clk = 0;

        flush = 'h0;
        handle_int = 'h0;
        f_valid = 'h0;
        f_valid_bytes = 'h0;
        f_instruction = 'h0;
        f_pc = 'h0;
        f_branch_taken = 'h0;
        d_ready = 'h0;
   
        #25

        reset = 0;

        #10

        $display("==========\n End Test \n==========");
    end

    initial #2000 $finish;

   
   always #10  clk          = ~clk;
   
    initial begin
        $vcdplusfile("fetch_seq.dump.vpd");
        $vcdpluson(0, TOP);
    end

endmodule
