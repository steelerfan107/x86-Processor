module int_controller (
     clk,
     reset,
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
     reg_cs,
     int_clear,
     or_int_vec		       
);

   input      clk;
   input      reset;
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
   input      or_int_vec;
   output     int_clear;

   assign mem_dp_ready = 1'b1;
   
   wire [2:0] 	     curr_state, next_state, n_curr_state;

   register #(.WIDTH(3)) state_reg (
       clk,
       reset,
       next_state,
       curr_state,
       n_curr_state,
       1'b1				    
   );
   
   int_comb_output_cloud coc (
       curr_state[2],
       curr_state[1],
       curr_state[0],
       flush_fetch,
       flush_decode_0,
       flush_decode_1,
       flush_register,
       flush_address,
       flush_execute,
       flush_writeback,			      
       decode_start_int,
       mem_valid,
       fetch_load,
       reg_load_cs,
       int_clear
   );

   int_next_state_cloud nsc (
       curr_state[2],
       curr_state[1],
       curr_state[0],
       or_int_vec,
       decode_end_int,
       mem_ready,
       mem_dp_valid,	     
       next_state[2],
       next_state[1],
       next_state[0]			     
   );   

endmodule  
   
