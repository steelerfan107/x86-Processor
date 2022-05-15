module sys_cont_top (
     clk,
     reset,
     int_vec,	
     cs_register,	     
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
     ret_near,
     ret_far,
     iretd,
     iretd_halt,
     iretd_pop_valid,
     iretd_pop_data,
     reg_load_eflags,
     reg_eflags,
     reg_load_eip,
     reg_eip,
     pending_int,
     hold_int,
     jump_load,
     jump_load_address,
     jump_load_cs,
     jump_cs			     
);

           input      clk;
           input      reset;
           input      [15:0] int_vec;
           input      [15:0] cs_register;
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
           input      ret_near;
           input      ret_far;
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
           input      jump_load;
           input      [31:0] jump_load_address;
           input      jump_load_cs;
           input      [15:0] jump_cs;
   
           wire       r_jump_load;
           wire       [31:0] r_jump_load_address;
           wire       r_jump_load_cs;
           wire       [15:0] r_jump_cs;
   
           wire [2:0] 	      start_state;

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

  	   wire       reg_load_eflags_jmp;  
	   wire       [31:0] reg_eflags_jmp;
  	   wire       reg_load_eip_jmp;  
	   wire       [31:0] reg_eip_jmp;   
	   wire       reg_load_cs_jmp;  
	   wire       [15:0] reg_cs_jmp;
	   wire       fetch_load_jmp;  
	   wire       [31:0] fetch_load_address_jmp;    
   
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

           wire       flush_fetch_jmp;
           wire       flush_decode_0_jmp;
           wire       flush_decode_1_jmp;
           wire       flush_register_jmp;
           wire       flush_address_jmp;
           wire       flush_execute_jmp;
           wire       flush_writeback_jmp;    
   
           wire [3:0] int_serviced;
           wire [2:0] int_serviced_low;
           wire [2:0] int_serviced_high;
   
           wire [15:0] int_serviced_oh;
           wire        or_int_vec;
           wire        int_clear;

           wire [15:0] int_vec_r, n_int_vec_r, int_clear_vec, int_clear_mask, int_clear_mask_inv, int_vec_in, int_vec_or;

           wire [2:0] 	     curr_state_iretd, next_state_iretd,next_state_iretd_test, n_curr_state_iretd, curr_state_iretd_p1;
           wire              not_zero_state, zero_state, last_state;
           wire              iretd_nc0;
           wire              not_iretd_pop_valid;
           wire              curr_state_iretd_one, curr_state_iretd_two, curr_state_iretd_three;

           wire 		     iretd_hold;
   
   
           parameter IDT_ADDRESS0 = 32'h4000;
           parameter IDT_ADDRESS1 = 32'h8000;
           parameter IDT_ADDRESS2 = 32'hc000;
           parameter IDT_ADDRESS3 = 32'hf000;   
           parameter IDT_ADDRESS4 = 32'hf000;   
           parameter IDT_ADDRESS5 = 32'hf000;   
           parameter IDT_ADDRESS6 = 32'hf000;   
           parameter IDT_ADDRESS7 = 32'hf000;   
           parameter IDT_ADDRESS8 = 32'h4000;
           parameter IDT_ADDRESS9 = 32'h8000;
           parameter IDT_ADDRESS10 = 32'hc000;
           parameter IDT_ADDRESS11 = 32'hf000;   
           parameter IDT_ADDRESS12 = 32'h0100;   
           parameter IDT_ADDRESS13 = 32'h2068;   
           parameter IDT_ADDRESS14 = 32'h2070;   
           parameter IDT_ADDRESS15 = 32'hf000;

           ////////////////////////////////
           // 
           // Control Accumulation
           //

           or3$ off (flush_fetch,flush_fetch_int,flush_fetch_iretd,flush_fetch_jmp);
           or3$ fd0 (flush_decode_0,flush_decode_0_int,flush_decode_0_iretd,flush_decode_0_jmp); 
           or3$ fd1 (flush_decode_1,flush_decode_1_int,flush_decode_1_iretd,flush_decode_1_jmp); 
           or3$ fr  (flush_register,flush_register_int,flush_register_iretd,flush_register_jmp); 
           or3$ fa  (flush_address,flush_address_int,flush_address_iretd,flush_address_jmp);
           or3$ fe  (flush_execute,flush_execute_int,flush_execute_iretd,flush_execute_jmp);
           or3$ fw  (flush_writeback,flush_writeback_int,flush_writeback_iretd,flush_writeback_jmp);

           or3$ rleflags  (reg_load_eflags,reg_load_eflags_int,reg_load_eflags_iretd,reg_load_eflags_jmp);
           or3$ rlcs      (reg_load_cs,reg_load_cs_int,reg_load_cs_iretd,reg_load_cs_jmp);
           or3$ rleip     (reg_load_eip,reg_load_eip_int,reg_load_eip_iretd,reg_load_eip_jmp);
           or3$ fla       (fetch_load,fetch_load_int,fetch_load_iretd,fetch_load_jmp);
         
           logic_tree_bus #(.WIDTH(32), .INPUTS(3), .OPERATION(1)) lbeflags ({reg_eflags_int,
                                                                              reg_eflags_iretd,
                                                                              reg_eflags_jmp},reg_eflags);
   
           //logic_tree_bus #(.WIDTH(16), .INPUTS(3), .OPERATION(1)) lbcs ({reg_cs_int,
           //                                                               reg_cs_iretd,
           //                                                               reg_cs_jmp},reg_cs);
           ao_mux #(.WIDTH(16),.NINPUTS(3)) ({reg_cs_int, reg_cs_iretd, reg_cs_jmp}
                                            , reg_cs
                                            ,{or_int_vec, not_zero_state,jump_load});           
   
           logic_tree_bus #(.WIDTH(32), .INPUTS(3), .OPERATION(1)) lbeip ({reg_eip_int,
                                                                           reg_eip_iretd,
                                                                           reg_eip_jmp},reg_eip);
           
           ao_mux #(.WIDTH(32),.NINPUTS(3)) ({fetch_load_address_int,fetch_load_address_iretd,fetch_load_address_jmp}
                                            , fetch_load_address
                                            ,{or_int_vec, not_zero_state,r_jump_load});   

           ////////////////////////////////
           // 
           // JUMP Handling
           //
           //

           wire [49:0] 		     nc50;
   
           register #(.WIDTH(50)) jmp_reg (
               clk,
               reset,
               {jump_load  , jump_load_address  , jump_cs  , jump_load_cs},
               {r_jump_load, r_jump_load_address, r_jump_cs, r_jump_load_cs},
               nc50,
               1'b1				    
           );
		  
           assign flush_fetch_jmp = r_jump_load;
           assign flush_decode_0_jmp = r_jump_load;
           assign flush_decode_1_jmp = r_jump_load;
           assign flush_register_jmp = r_jump_load;
           assign flush_address_jmp = r_jump_load;
           assign flush_execute_jmp = r_jump_load;
           assign flush_writeback_jmp = 'h0; 

  	   assign reg_load_eflags_jmp  = 'h0;  
	   assign reg_eflags_jmp  = 'h0;
  	   assign reg_load_eip_jmp  = 'h0;  
	   assign reg_eip_jmp  = 'h0;   
	   assign reg_load_cs_jmp = jump_load_cs;  
	   assign reg_cs_jmp = jump_cs;
	   assign fetch_load_jmp = r_jump_load;  
	   assign fetch_load_address_jmp = r_jump_load_address;   
   
           ////////////////////////////////
           // 
           // Interrupt Handling
           //

           wire 		     mask_int_vec;
           wire [31:0] 	             mem_address_p4;
           wire [31:0] 	             mem_address_p0;
           wire [31:0]               bottom_entry;
           wire [31:0] 	             comb_adddress;
           wire capture_bottom_eip;
           wire [31:0] 	fixed_end_bus;
   
   
           assign pending_int = or_int_vec;
   
  	   assign       reg_load_eflags_int = 'h0;  
	   assign       reg_eflags_int = 'h0;
  	   assign       reg_load_eip_int = 'h0;  
	   assign       reg_eip_int = 'h0;  
   
           assign int_clear_vec = {16{int_clear}};
   
           logic_tree_bus #(.WIDTH(16),.OPERATION(0),.NINPUTS(2)) ltb_mask ({int_clear_vec, int_serviced_oh}, int_clear_mask);

           inv1$ (int_clear_mask_inv[15], int_clear_mask[15]);
           inv1$ (int_clear_mask_inv[14], int_clear_mask[14]);
           inv1$ (int_clear_mask_inv[13], int_clear_mask[13]);
           inv1$ (int_clear_mask_inv[12], int_clear_mask[12]);   
           inv1$ (int_clear_mask_inv[11], int_clear_mask[11]);
           inv1$ (int_clear_mask_inv[10], int_clear_mask[10]);
           inv1$ (int_clear_mask_inv[9], int_clear_mask[9]);
           inv1$ (int_clear_mask_inv[8], int_clear_mask[8]);   
           inv1$ (int_clear_mask_inv[7], int_clear_mask[7]);
           inv1$ (int_clear_mask_inv[6], int_clear_mask[6]);
           inv1$ (int_clear_mask_inv[5], int_clear_mask[5]);
           inv1$ (int_clear_mask_inv[4], int_clear_mask[4]);   
           inv1$ (int_clear_mask_inv[3], int_clear_mask[3]);
           inv1$ (int_clear_mask_inv[2], int_clear_mask[2]);
           inv1$ (int_clear_mask_inv[1], int_clear_mask[1]);
           inv1$ (int_clear_mask_inv[0], int_clear_mask[0]);

           logic_tree_bus #(.WIDTH(16),.OPERATION(1),.NINPUTS(2)) ltb_or  ({int_vec, int_vec_r}, int_vec_or);
           logic_tree_bus #(.WIDTH(16),.OPERATION(0),.NINPUTS(2)) ltb_in  ({int_clear_mask_inv, int_vec_or}, int_vec_in);   
      
           register #(.WIDTH(16)) int_reg (
               clk,
               reset,
               int_vec_in,
               int_vec_r,
               n_int_vec_r,
               1'b1				    
           );
   
           logic_tree #(.WIDTH(16),.OPERATION(1)) vec_or (int_vec_r, or_int_vec);

           inv1$ (not_hold_int, hold_int); 
           and2$ (mask_int_vec, not_hold_int, or_int_vec);

           slow_addr #(.WIDTH(32)) ( mem_address_p0, 32'd4 , mem_address_p4,);

           wire 			     addr_p1;
              
           mux  #(.WIDTH(32),.INPUTS(16)) idt_select ( {IDT_ADDRESS15,
                                                        IDT_ADDRESS14, 
                                                        IDT_ADDRESS13, 
                                                        IDT_ADDRESS12,
                                                        IDT_ADDRESS11,
                                                        IDT_ADDRESS10, 
                                                        IDT_ADDRESS9, 
                                                        IDT_ADDRESS8, 
                                                        IDT_ADDRESS7,
                                                        IDT_ADDRESS6,
                                                        IDT_ADDRESS5, 
                                                        IDT_ADDRESS4,
                                                        IDT_ADDRESS3,
                                                        IDT_ADDRESS2, 
                                                        IDT_ADDRESS1,
                                                        IDT_ADDRESS0
           }, mem_address_p0, int_serviced);

          

           mux  #(.WIDTH(32),.INPUTS(16)) addr_select ( {mem_address_p4, mem_address_p0}, mem_address, addr_p1);

           assign int_serviced_oh = int_vec_r;
           //find_first #(.WIDTH(4),.OPERATION(1)) ff (int_vec_r[15:12], int_serviced_oh[15:12]);
           /*
           mux  #(.WIDTH(4),.INPUTS(16)) idt_select ( { ,
                                                        , 
                                                        , 
                                                        ,
                                                        ,
                                                        , // 0000 
                                                        , // 0000 
                                                        , // 0000 
                                                        , // 0000
                                                        , // 0000
                                                        , // 0000 
                                                        , // 0000
                                                        , // 0000
                                                        , // 0000
                                                        , // 0000
                                                          // 0000
           }, int_serviced_oh[15:12], int_vec_r[15:12]);      */    
   
           wire low_is_one;
           logic_tree #(.WIDTH(8),.OPERATION(1)) vec_low (int_vec_r[7:0], low_is_one);
           
           //pencoder8_3$ lp (.enbar(~or_int_vec), .X(int_serviced_oh[7:0]) , .Y(int_serviced_low));
           //pencoder8_3$ hp (.enbar(~or_int_vec), .X(int_serviced_oh[15:8]) , .Y(int_serviced_high));

           ao_mux #(.NINPUTS(16),.WIDTH(4)) (
					    {
					       4'd15,
					       4'd14,
					       4'd13,
					       4'd12,
					       4'd11,
					       4'd10,
					       4'd9,
					       4'd8,
					       4'd7,
					       4'd6,
					       4'd5,
					       4'd4,
					       4'd3,
					       4'd2,
					       4'd1,
					       4'd0
                                            },
					    int_serviced,
					    int_serviced_oh
	     );
   

           //mux  #(.WIDTH(4),.INPUTS(2)) serv_sel ( {
	  //	  {1'b0,int_serviced_low},
           //       {1'b1,int_serviced_high}
           //}, int_serviced , low_is_one);   

          assign fixed_end_bus[31:24] = mem_dp_read_data[7:0];
          assign fixed_end_bus[23:16] = mem_dp_read_data[15:8];
          assign fixed_end_bus[15:8] = mem_dp_read_data[23:16];   
          assign fixed_end_bus[7:0] = mem_dp_read_data[31:24];
   
          slow_addr #(.WIDTH(32)) ( {bottom_entry[31:16],16'b0}, {fixed_end_bus[31:16],bottom_entry[15:0]},comb_adddress,);

          wire [15:0] 	masked_fixed_end_bus_top;
          and2$ (masked_fixed_end_bus_top[15], fixed_end_bus[31], mem_dp_valid);
          and2$ (masked_fixed_end_bus_top[14], fixed_end_bus[30], mem_dp_valid);
          and2$ (masked_fixed_end_bus_top[13], fixed_end_bus[29], mem_dp_valid);
          and2$ (masked_fixed_end_bus_top[12], fixed_end_bus[28], mem_dp_valid);
          and2$ (masked_fixed_end_bus_top[11], fixed_end_bus[27], mem_dp_valid);
          and2$ (masked_fixed_end_bus_top[10], fixed_end_bus[26], mem_dp_valid);
          and2$ (masked_fixed_end_bus_top[9], fixed_end_bus[25], mem_dp_valid);
          and2$ (masked_fixed_end_bus_top[8], fixed_end_bus[24], mem_dp_valid);
          and2$ (masked_fixed_end_bus_top[7], fixed_end_bus[23], mem_dp_valid);
          and2$ (masked_fixed_end_bus_top[6], fixed_end_bus[22], mem_dp_valid);
          and2$ (masked_fixed_end_bus_top[5], fixed_end_bus[21], mem_dp_valid);
          and2$ (masked_fixed_end_bus_top[4], fixed_end_bus[20], mem_dp_valid);
          and2$ (masked_fixed_end_bus_top[3], fixed_end_bus[19], mem_dp_valid);
          and2$ (masked_fixed_end_bus_top[2], fixed_end_bus[18], mem_dp_valid);
          and2$ (masked_fixed_end_bus_top[1], fixed_end_bus[17], mem_dp_valid);
          and2$ (masked_fixed_end_bus_top[0], fixed_end_bus[16], mem_dp_valid);
    
          assign fetch_load_address_int = {16'd0,bottom_entry[15:0]};
          assign reg_cs_int = mem_dp_valid ? fixed_end_bus[31:16] : 'h0;

          always @ (posedge or_int_vec) begin
              if (or_int_vec) begin
	         $display("=================== ");	 		 
	         $display("=================== Approx Timing == Seen Interrupt");
	         $display("=================== ");	 	 
              end   
          end
   
          register #(.WIDTH(32)) top_eip (
            clk,
            reset,
            fixed_end_bus,
            bottom_entry,
            ,
            capture_bottom_eip					    
           );
      
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
                mask_int_vec,
                capture_bottom_eip,
                addr_p1		       
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

           wire 		  commit_eip, commit_eflags, commit_cs; 
           wire [31:0] 			  captured_eip, captured_cs;   
   
           and2$ load_eip_and (reg_load_eip_iretd, iretd_pop_valid, commit_eip);
           assign       reg_eip_iretd = iretd_hold ?  captured_eip : iretd_pop_data;
	     
           and2$ load_cs_and (reg_load_cs_iretd, iretd_pop_valid, commit_cs);
           assign       reg_cs_iretd = iretd_hold ?  captured_cs : iretd_pop_data[15:0];

           wire           not_ret_near;
           wire [15:0]    used_cs;
           inv1$ (not_ret_near,  ret_near);      
	     
           ao_mux #(.WIDTH(16),.NINPUTS(2)) (  { cs_register , temp_cs }
                                            , used_cs
                                            ,  {  ret_near , not_ret_near});
   
           and2$ load_iretd_and (fetch_load_iretd, iretd_pop_valid, curr_state_iretd_three);

           assign fetch_load_address_iretd = iretd_hold ? captured_eip : iretd_pop_data;

           and2$ load_eflags_and (reg_load_eflags_iretd, iretd_pop_valid, commit_eflags);
           assign       reg_eflags_iretd = iretd_pop_data;   
   
           assign       last_state = fetch_load_iretd;
   
           assign       flush_fetch_iretd = iretd_halt;
           assign       flush_decode_0_iretd = fetch_load_iretd;
           assign       flush_decode_1_iretd = fetch_load_iretd;
           assign       flush_register_iretd = fetch_load_iretd;
           assign       flush_address_iretd = fetch_load_iretd;
           assign       flush_execute_iretd = 'h0;
           assign       flush_writeback_iretd = 'h0;    

           assign       iretd_halt = not_zero_state;

           assign commit_eip    = iretd_hold ? curr_state_iretd_three : curr_state_iretd_three;
           assign commit_eflags = iretd_hold ? curr_state_iretd_three : curr_state_iretd_one;
           assign commit_cs     = iretd_hold ? curr_state_iretd_three : curr_state_iretd_two;
           

           register #(.WIDTH(32)) EIP (
              clk,
              reset,
              iretd_pop_data[31:0],
              captured_eip,
              ,
              curr_state_iretd_one & iretd_pop_valid		    
            ); 

            register #(.WIDTH(32)) CS (
              clk,
              reset,
              iretd_pop_data[15:0],
              captured_cs,
              ,
              curr_state_iretd_two & iretd_pop_valid				    
            );

            assign iretd_hold_in = (iretd_hold) ? ~zero_state : (iretd & not_zero_state);
   
            register #(.WIDTH()) iretd_hold_reg (
              clk,
              reset,
              iretd_hold_in,
              iretd_hold,
              ,
              1'b1				    
            ); 
   
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

           ao_mux #(.WIDTH(3),.NINPUTS(3)) (  {  3'd1, 3'd2, 3'd3 }
                                            , start_state
                                            , {  iretd, ret_far, ret_near });
   
           ao_mux #(.WIDTH(3),.NINPUTS(4)) (  { curr_state_iretd, curr_state_iretd_p1, 3'd0, start_state }
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
   
