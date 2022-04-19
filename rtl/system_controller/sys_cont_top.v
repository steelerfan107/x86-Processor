module sys_cont_top (
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

           input      clk;
           input      reset;
           input      [3:0] int_vec;
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
    
           wire [1:0] int_serviced;
           wire [3:0] int_serviced_oh;
           wire       or_int_vec;
           wire       int_clear;

           wire [3:0] int_vec_r, n_int_vec_r;
           
           parameter IDT_ADDRESS0 = 32'h4000;
           parameter IDT_ADDRESS1 = 32'h8000;
           parameter IDT_ADDRESS2 = 32'hc000;
           parameter IDT_ADDRESS3 = 32'hf000;   

           ////////////////////////////////
           // 
           // Interrupt Handling
           //
   
           register #(.WIDTH(4)) int_reg (
               clk,
               reset,
               int_vec,
               int_vec_r,
               n_int_vec_r,
               1'b1				    
           );

           logic_tree #(.WIDTH(4),.OPERATION(1)) vec_or (int_vec_r, or_int_vec);

           mux  #(.WIDTH(32),.INPUTS(4)) idt_select ( {IDT_ADDRESS3, IDT_ADDRESS2, IDT_ADDRESS1, IDT_ADDRESS0}, mem_address, int_serviced);

           find_first #(.WIDTH(4),.OPERATION(1)) ff (int_vec_r, int_serviced_oh);

           pencoder8_3$ (1'b0, {4'b0, int_vec_r}, {nc0, int_serviced});

           assign  fetch_load_address = mem_dp_read_data;
   
           int_controller ic (
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
   
endmodule
   
