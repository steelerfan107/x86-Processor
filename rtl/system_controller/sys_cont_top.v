module sys_cont_top (
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

           output     mem_valid;
	   input      mem_ready;  
	   output     [31:0] mem_address; 
	   output     mem_wr_en;  
	   output     [31:0] mem_wr_data;  
	   output     [3:0] mem_wr_size;  
	   input      mem_dp_valid;  
           output     mem_dp_ready;   
	   input      [31:0] mem_dp_read_data;   
	   output     flush_fetch;   
	   output     flush_decode_0;   
	   output     flush_decode_1;   
	   output     flush_register;   
	   output     flush_address;   
	   output     flush_execute;   
	   output     flush_writeback;   
	   output     fetch_load;  
	   output     [31:0] fetch_load_address;  
	   output     decode_start_int;   
	   input      decode_end_int;  
	   output     reg_load_cs;  
	   output     [15:0] reg_cs;
    
           assign mem_valid = 'h0;
	   assign mem_ready = 'h0;  
	   assign mem_wr_en = 'h0;  
	   assign mem_wr_data = 'h0;  
	   assign mem_wr_size = 'h0;  
	   assign mem_dp_valid = 'h0;  
           assign mem_dp_ready = 'h0;     
	   assign flush_fetch = 'h0;   
	   assign flush_decode_0 = 'h0;   
	   assign flush_decode_1 = 'h0;   
	   assign flush_register = 'h0;   
	   assign flush_address = 'h0;   
	   assign flush_execute = 'h0;   
	   assign flush_writeback = 'h0;   
	   assign fetch_load = 'h0;  
	   assign fetch_load_address = 'h0;  
	   assign decode_start_int = 'h0;   
	   assign reg_load_cs = 'h0;  
	   assign reg_cs = 'h0;
endmodule
   
