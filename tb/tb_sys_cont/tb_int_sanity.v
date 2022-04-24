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
   reg      [3:0] int_vec;
   wire     mem_valid;
   reg      mem_ready;  
   wire     [31:0] mem_address; 
   wire     mem_wr_en;  
   wire     [31:0] mem_wr_data;  
   wire     [3:0] mem_wr_size;  
   reg      mem_dp_valid;  
   wire     mem_dp_ready;   
   reg      [31:0] mem_dp_read_data;   
   wire     flush_fetch;   
   wire     flush_decode_0;   
   wire     flush_decode_1;   
   wire     flush_register;   
   wire     flush_address;   
   wire     flush_execute;   
   wire     flush_writeback;   
   wire     fetch_load;  
   wire     [31:0] fetch_load_address;  
   wire     decode_start_int;   
   reg      decode_end_int;  
   wire     reg_load_cs;  
   wire     [15:0] reg_cs;

   sys_cont_top uut (
     clk,
     reset,
     int_vec,		     
     mem_valid,
     mem_ready,
     mem_address,
     mem_wr_en,
     mem_wr_data,
     mem_wr_size,
     mem_dp_valid,
     mem_dp_ready,
     mem_dp_read_data,
     flush_fetch,
     flush_decode_0,
     flush_decode_1,
     flush_register,
     flush_address,
     flush_execute,
     flush_writeback,
     fetch_load,
     fetch_load_address,
     decode_start_int,
     decode_end_int,
     reg_load_cs,
     reg_cs	  		  		  
   );
   
    initial begin
        $strobe("============ \n Begin Test \n============");
        reset = 1;
        clk = 0;
        int_vec = 0;             	  
        #55
        reset = 0;
        #20
        int_vec = 1;
        #20        
        int_vec = 0;	 
        $display("==========\n End Test \n==========");
    end

    initial #2000 $finish;

   always @(posedge clk) begin
      if (reset) begin
	 //f_valid <= 1'b1;
	 mem_ready <= 0;
	 mem_dp_valid  <= 0;
	 decode_end_int <= 0;	 
      end else begin
	 //f_valid <= (f_valid) ? ~f_ready : 1'b0;
	 mem_ready <= (mem_ready) ? 1 : mem_valid;
	 mem_dp_valid  <= (mem_dp_valid) ? 1 : mem_ready;
	 decode_end_int <= (decode_end_int) ? 1 : decode_start_int;
      end
   end
   
   always #10  clk          = ~clk;
   
    initial begin
        $vcdplusfile("sys_cont_seq.dump.vpd");
        $vcdpluson(0, TOP);
    end

endmodule
