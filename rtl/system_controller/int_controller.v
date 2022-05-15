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
     or_int_vec,
     capture_bottom_eip,
     addr_p1	       
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
   output     capture_bottom_eip;
   output     addr_p1;
   

   assign mem_dp_ready = 1'b1;
   
   wire [2:0] 	     curr_state, next_state, n_curr_state;

   assign reg_load_cs = (curr_state == 4) & mem_dp_valid;

   wire [2:0] 	     next_state_c;

   assign next_state = (curr_state == 5 && mem_ready) ? 6 : next_state_c;

   /*
   wire 	     curr_state_is_five;
   wire 	     curr_state_is_five_and_ready;   
   wire 	     curr_state_is_four;
    wire 	     curr_state_is_four_and_valid;  

   compare #(.WIDTH(3)) (curr_state, 3'd4, curr_state_is_four);
   compare #(.WIDTH(3)) (curr_state, 3'd5, curr_state_is_five);

   and2$ (reg_load_cs, mem_dp_valid, curr_state_is_four);
   and2$ (curr_state_is_five_and_ready, curr_state_is_five, mem_ready);

   mux #(.WIDTH(3),.INPUTS(2)) (
	{
	   3'd6,
	   next_state_c
        },
        next_state ,
        curr_state_is_five_and_ready			
   );*/
       
   register #(.WIDTH(3)) state_reg (
       clk,
       reset,
       next_state,
       curr_state,
       n_curr_state,
       1'b1				    
   );
   
   int_comb_output_cloud coc (
       1'b0,
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
       ,//reg_load_cs,
       int_clear,
       capture_bottom_eip,
       addr_p1
   );

   int_next_state_cloud nsc (
       curr_state[2],
       curr_state[1],
       curr_state[0],
       or_int_vec,
       decode_end_int,
       mem_ready,
       mem_dp_valid,	     
       next_state_c[2],
       next_state_c[1],
       next_state_c[0]			     
   );   

endmodule  
   
