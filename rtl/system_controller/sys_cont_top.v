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
     reg_cs,
     iretd,
     iretd_halt,
     iretd_pop_valid,
     iretd_pop_data,
     reg_load_eflags,
     reg_eflags,
     reg_load_eip,
     reg_eip,
     pending_int,
     hold_int			     
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
           input      iretd;
           output     iretd_halt;
           input      iretd_pop_valid;
           input      [31:0] iretd_pop_data; 
  	   output     reg_load_eflags;  
	   output     [31:0] reg_eflags;
  	   output     reg_load_eip;  
	   output     [31:0] reg_eip;
           output     pending_int;
           input      hold_int;

           wire       not_hold_int;
   
  	   wire       reg_load_eflags_int;  
	   wire       [31:0] reg_eflags_int;
  	   wire       reg_load_eip_int;  
	   wire       [31:0] reg_eip_int;   
	   wire       reg_load_cs_int;  
	   wire       [15:0] reg_cs_int;
	   wire       fetch_load_int;  
	   wire       [31:0] fetch_load_address_int;  
	   wire       [31:0] fetch_load_address_nc;  

  	   wire       reg_load_eflags_iretd;  
	   wire       [31:0] reg_eflags_iretd;
  	   wire       reg_load_eip_iretd;  
	   wire       [31:0] reg_eip_iretd;   
	   wire       reg_load_cs_iretd;  
	   wire       [15:0] reg_cs_iretd;
	   wire       fetch_load_iretd;  
	   wire       [31:0] fetch_load_address_iretd; 
   
           wire       flush_fetch_int;
           wire       flush_decode_0_int;
           wire       flush_decode_1_int;
           wire       flush_register_int;
           wire       flush_address_int;
           wire       flush_execute_int;
           wire       flush_writeback_int;

           wire       flush_fetch_iretd;
           wire       flush_decode_0_iretd;
           wire       flush_decode_1_iretd;
           wire       flush_register_iretd;
           wire       flush_address_iretd;
           wire       flush_execute_iretd;
           wire       flush_writeback_iretd;  
   
           wire [1:0] int_serviced;
           wire [3:0] int_serviced_oh;
           wire       or_int_vec;
           wire       int_clear;

           wire [3:0] int_vec_r, n_int_vec_r, int_clear_vec, int_clear_mask, int_clear_mask_inv, int_vec_in, int_vec_or;

           wire [2:0] 	     curr_state_iretd, next_state_iretd,next_state_iretd_test, n_curr_state_iretd, curr_state_iretd_p1;
           wire              not_zero_state, zero_state, last_state;
           wire              iretd_nc0;
           wire              not_iretd_pop_valid;
           wire              curr_state_iretd_one, curr_state_iretd_two, curr_state_iretd_three;
           
           parameter IDT_ADDRESS0 = 32'h4000;
           parameter IDT_ADDRESS1 = 32'h8000;
           parameter IDT_ADDRESS2 = 32'hc000;
           parameter IDT_ADDRESS3 = 32'hf000;   

           ////////////////////////////////
           // 
           // Control Accumulation
           //

           or2$ off (flush_fetch,flush_fetch_int,flush_fetch_iretd);
           or2$ fd0 (flush_decode_0,flush_decode_0_int,flush_decode_0_iretd); 
           or2$ fd1 (flush_decode_1,flush_decode_1_int,flush_decode_1_iretd); 
           or2$ fr  (flush_register,flush_register_int,flush_register_iretd); 
           or2$ fa  (flush_address,flush_address_int,flush_address_iretd);
           or2$ fe  (flush_execute,flush_execute_int,flush_execute_iretd);
           or2$ fw  (flush_writeback,flush_writeback_int,flush_writeback_iretd);

           or2$ rleflags  (reg_load_eflags,reg_load_eflags_int,reg_load_eflags_iretd);
           or2$ rlcs      (reg_load_cs,reg_load_cs_int,reg_load_cs_iretd);
           or2$ rleip     (reg_load_eip,reg_load_eip_int,reg_load_eip_iretd);
           or2$ fla       (fetch_load,fetch_load_int,fetch_load_iretd);
         
           logic_tree_bus #(.WIDTH(32), .INPUTS(2), .OPERATION(1)) lbeflags ({reg_eflags_int,reg_eflags_iretd},reg_eflags);
           logic_tree_bus #(.WIDTH(16), .INPUTS(2), .OPERATION(1)) lbcs ({reg_cs_int,reg_cs_iretd},reg_cs);
           logic_tree_bus #(.WIDTH(32), .INPUTS(2), .OPERATION(1)) lbeip ({reg_eip_int,reg_eip_iretd},reg_eip);
           //logic_tree_bus #(.WIDTH(32), .INPUTS(2), .OPERATION(1)) lba ({fetch_load_address_int,fetch_load_address_iretd},fetch_load_address);
           ao_mux #(.WIDTH(32),.NINPUTS(2)) ({fetch_load_address_int,fetch_load_address_iretd}
                                            , fetch_load_address
                                            ,{or_int_vec, not_zero_state});   
   
           ////////////////////////////////
           // 
           // Interrupt Handling
           //

           wire 		     mask_int_vec;
   
           assign pending_int = or_int_vec;
   
  	   assign       reg_load_eflags_int = 'h0;  
	   assign       reg_eflags_int = 'h0;
  	   assign       reg_load_eip_int = 'h0;  
	   assign       reg_eip_int = 'h0;  
   
           assign int_clear_vec = {int_clear, int_clear, int_clear, int_clear};
   
           logic_tree_bus #(.WIDTH(4),.OPERATION(0),.NINPUTS(2)) ltb_mask ({int_clear_vec, int_serviced_oh}, int_clear_mask);

           inv1$ (int_clear_mask_inv[3], int_clear_mask[3]);
           inv1$ (int_clear_mask_inv[2], int_clear_mask[2]);
           inv1$ (int_clear_mask_inv[1], int_clear_mask[1]);
           inv1$ (int_clear_mask_inv[0], int_clear_mask[0]);

           logic_tree_bus #(.WIDTH(4),.OPERATION(1),.NINPUTS(2)) ltb_or  ({int_vec, int_vec_r}, int_vec_or);
           logic_tree_bus #(.WIDTH(4),.OPERATION(0),.NINPUTS(2)) ltb_in  ({int_clear_mask_inv, int_vec_or}, int_vec_in);   
      
           register #(.WIDTH(4)) int_reg (
               clk,
               reset,
               int_vec_in,
               int_vec_r,
               n_int_vec_r,
               1'b1				    
           );
   
           logic_tree #(.WIDTH(4),.OPERATION(1)) vec_or (int_vec_r, or_int_vec);

           inv1$ (not_hold_int, hold_int); 
           and2$ (mask_int_vec, not_hold_int, or_int_vec);

           mux  #(.WIDTH(32),.INPUTS(4)) idt_select ( {IDT_ADDRESS3, IDT_ADDRESS2, IDT_ADDRESS1, IDT_ADDRESS0}, mem_address, int_serviced);

           find_first #(.WIDTH(4),.OPERATION(1)) ff (int_vec_r, int_serviced_oh);

           pencoder8_3$ (1'b0, {4'b0, int_vec_r}, {nc0, int_serviced});

           assign  fetch_load_address_int = mem_dp_read_data;
           assign  reg_cs = 'h0;
   
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
                flush_fetch_int,
                flush_decode_0_int,
                flush_decode_1_int,
                flush_register_int,
                flush_address_int,
                flush_execute_int,
                flush_writeback_int,
     		fetch_load_int,
                fetch_load_address_nc,
                decode_start_int,
                decode_end_int,
                reg_load_cs_int,
                reg_cs_int,
                int_clear,
                mask_int_vec		       
           );

           ////////////////////////////////
           // 
           // Interrupt Return Handling
           //

           wire [15:0] 		     temp_cs, n_temp_cs;   
   
           register #(.WIDTH(16)) temp_cs_reg (
               clk,
               reset,
               iretd_pop_data[15:0],
               temp_cs,
               n_temp_cs,
               reg_load_cs_iretd				    
           );
   
   
           //assign       reg_load_eip_iretd = iretd_pop_valid & curr_state_iretd_one;
           and2$ load_eip_and (reg_load_eip_iretd, iretd_pop_valid, curr_state_iretd_one);
           assign       reg_eip_iretd = iretd_pop_data;
	     
           //assign       reg_load_cs_iretd = iretd_pop_valid & curr_state_iretd_two;
           and2$ load_cs_and (reg_load_cs_iretd, iretd_pop_valid, curr_state_iretd_two);
           assign       reg_cs_iretd = iretd_pop_data[15:0];

           //assign       fetch_load_iretd = iretd_pop_valid & curr_state_iretd_three;
           and2$ load_iretd_and (fetch_load_iretd, iretd_pop_valid, curr_state_iretd_three);
           slow_addr #(.WIDTH(32)) ({16'b0,temp_cs},iretd_pop_data,fetch_load_address_iretd,nc0);
           //assign       fetch_load_address_iretd = iretd_pop_data;  

           //assign       reg_load_eip_iretd = iretd_pop_valid & curr_state_iretd_three;
           and2$ load_eflags_and (reg_load_eflags_iretd, iretd_pop_valid, curr_state_iretd_three);
           assign       reg_eflags_iretd = iretd_pop_data;   
   
           assign       last_state = fetch_load_iretd;
       
           assign       flush_fetch_iretd = iretd_halt;
           assign       flush_decode_0_iretd = 'h0;
           assign       flush_decode_1_iretd = 'h0;
           assign       flush_register_iretd = 'h0;
           assign       flush_address_iretd = 'h0;
           assign       flush_execute_iretd = 'h0;
           assign       flush_writeback_iretd = 'h0;    

           assign       iretd_halt = not_zero_state;
   
           compare #(.WIDTH(3)) zero_state_comp  (curr_state_iretd, 0, zero_state);
           compare #(.WIDTH(3)) one_state_comp   (curr_state_iretd, 1, curr_state_iretd_one);
           compare #(.WIDTH(3)) two_state_comp   (curr_state_iretd, 2, curr_state_iretd_two);
           compare #(.WIDTH(3)) three_state_comp (curr_state_iretd, 3, curr_state_iretd_three);

           
           //assign next_state_iretd_test = (zero_state)  ? iretd :
	   //			     (last_state)       ? 0     :
	   //			     (iretd_pop_valid)  ? curr_state_iretd_p1 : curr_state_iretd;

           wire              select0,select0n;
           wire              select1,select1n;
           wire              select2,select2n;
           wire              select3,select3n;

           inv1$ s0i (select0n, select0);
           inv1$ s1i (select1n, select1);
           inv1$ s2i (select2n, select2);  

           assign select0 = zero_state;

           and2$ s1a (select1, select0n, last_state);
           and3$ s2a (select2, select0n, select1n, iretd_pop_valid);
           and3$ s3a (select3, select0n, select1n, select2n);

   
           ao_mux #(.WIDTH(3),.NINPUTS(4)) (  { curr_state_iretd, curr_state_iretd_p1, 3'd0, {2'b0,iretd} }
                                            , next_state_iretd
                                            , { select3, select2, select1, select0 });
				 
  
           inv1$ nzs (not_zero_state,zero_state);
           inv1$ npv (not_iretd_pop_valid,iretd_pop_valid);

           assign iretd_halt = not_zero_state;
	     
           slow_addr #(.WIDTH(3)) (curr_state_iretd,1,curr_state_iretd_p1,iretd_nc0);
         
           register #(.WIDTH(3)) state_reg (
              clk,
              reset,
              next_state_iretd,
              curr_state_iretd,
              n_curr_state_iretd,
              1'b1				    
            ); 
   
endmodule
   
