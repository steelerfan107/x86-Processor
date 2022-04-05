// tb_register_file.v
// Eric Taylor

// Testbench for testing the fetch stage seperately from everything else

module TOP;
   // Instruction Memory Interface Parameters
   parameter IDATAW = 128;
   parameter ISIZEW = 8;
   parameter IADDRW = 32;
   
   reg clk;
   reg reset;
   
   // Control Interface
   reg 	               flush;
   reg [IADDRW-1:0]    load_address;
   reg 	               load;
 
   // Code Segment
   reg [15:0] 	       cs_register;	

   // Instruction Memory Interface
   wire 	       imem_valid;
   reg 	               imem_ready;
   wire [IADDRW-1:0]   imem_address;
   wire 	       imem_wr_en;
   wire [IDATAW-1:0]   imem_wr_data;
   wire [ISIZEW-1:0]   imem_wr_size;
   reg                 imem_dp_valid;
   wire                imem_dp_ready;
   reg [IDATAW-1:0]    imem_dp_read_data;

   // Branch Predictor Interface
   wire [IADDRW-1:0]   bp_pc;
   reg [IADDRW-1:0]    bp_target;
   reg                 bp_taken;
		  
   // Return Address Stack Interface
   wire                ras_pop;
   reg [IADDRW-1:0]    ras_target;

   // Pipestage Interface  
   wire                f_valid;
   reg                 f_ready;
   reg [5:0]           f_bytes_read;
   wire [6:0]          f_valid_bytes;
   wire [255:0]        f_instruction;
   wire [IADDRW-1:0]   f_pc;
   wire                f_branch_taken;

   reg [127:0]         memory_data;
   reg 		       memory_valid;
   
   //reg [2047:0]        MEMORY[127:0];
   
   fetch_top uut (
      clk,
      reset,
      flush,
      load_address,
      load,
      cs_register,
      imem_valid,
      imem_ready,
      imem_address,
      imem_wr_en,
      imem_wr_data,
      imem_wr_size,
      imem_dp_valid,
      imem_dp_ready,
      imem_dp_read_data,
      bp_pc,
      bp_target,
      bp_taken,
      ras_pop,
      ras_target, 
      f_valid,
      f_ready,
      f_bytes_read,		   
      f_valid_bytes,
      f_instruction,
      f_pc,
      f_branch_taken         
    );

    initial begin
        $strobe("============ \n Begin Test \n============");
        reset = 1;
        clk = 0;

        //for ( i = 0; i < 2048; i = i+ 1) begin
	//   MEMORY[i] = (2048 - i);
	//end

        flush = 0;
        load_address= 0;
        load = 0;
 
        // Code Segment
        cs_register = 16'hF000; 

        // Branch Predictor Interface
        bp_target = 0;
        bp_taken = 0;
		  
        // Return Address Stack Interface
        ras_target = 0;

        // Pipestage Interface  
        f_ready = 1;
        f_bytes_read = 4;     

        #25

        reset = 0;

        #10

        
        #10


        $display("==========\n End Test \n==========");
    end

    initial #2000 $finish;

    always @ (posedge clk or posedge reset) begin
       if (reset) begin
	  memory_data  <= 0;
          memory_valid <= 0;	  
       end else begin
	  memory_data  <= {32'h78787878, 32'h56565656, 32'h34343434, 32'h12121212};	
          memory_valid <= (memory_valid) ? ~(imem_dp_ready) : imem_valid;	  
       end     
    end

    always @ (*) begin
       imem_dp_valid     =  memory_valid;       
       imem_dp_read_data =  memory_data;	
       imem_ready        = ~memory_valid;	      
    end
   
   always #10  clk           = ~clk;
   //always #20  f_ready       = ($random%2);

   reg [3:0] random_int;
   
   always @ (f_valid_bytes) begin
      random_int = ($random%15) + 1;
      
      if (random_int > f_valid_bytes)  begin
         f_ready  = 0;
      end else begin
         f_ready  = 1;	 
      end
      
      f_bytes_read  = random_int;
   end // always @ begin
   
   //always #20  f_bytes_read  = ($random%15)+1;

    initial begin
        $vcdplusfile("fetch_seq.dump.vpd");
        $vcdpluson(0, TOP);
    end

endmodule
