

//////////////////////////////////////
//
//  Instruction Queue Module
//

module instruction_queue (
   // Clock Interface
   clk,
   reset,  

   // Control Interface
   load_address,
   load,
   flush,

   // Data Interface In	
   valid_i,
   ready_i,		  
   data_i,
		  
   // Instruction Interface Out
   valid_o,
   ready_o,
   bytes_read_o,
   valid_bytes_o,
   intruction_o
);

   // Clock Interface
   input          clk;
   input          reset; 

   // Control Interface
   input [5:0]    load_address;
   input          load;
   input          flush;

   // Data Interface In	
   input          valid_i;
   output         ready_i;		  
   input [127:0]  data_i;
   		  
   // Instruction Interface Out
   output         valid_o;
   input          ready_o;
   input [3:0]    bytes_read_o;
   output [6:0]   valid_bytes_o;
   output [255:0] intruction_o;

   wire 	  in_accept;
   wire           out_accept;

   wire 	  set0;
   wire 	  set1;
   wire 	  set2;
   wire 	  set3;
   
   wire 	  clear0;
   wire 	  clear1;
   wire 	  clear2;
   wire 	  clear3;

   wire 	  valid0, invalid0;
   wire 	  valid1, invalid1;
   wire 	  valid2, invalid2;
   wire 	  valid3, invalid3;
 
   wire 	  eq_i0, eq_o0;
   wire 	  eq_i1, eq_o1;
   wire 	  eq_i2, eq_o2;
   wire 	  eq_i3, eq_o3;

   wire [3:0] 	  tail, tail_in, tail_b;
   wire [6:0] 	  head, head_in, head_b;

   wire [255:0]   full_data;
   wire [127:0]   data_upper, data_lower;
   wire [127:0]   data0, data1, data2, data3;
   wire [127:0]   data0_b, data1_b, data2_b, data3_b;

   wire [6:0] 	  head_p16;
   wire [6:0] 	  head_p_br;
   wire [3:0] 	  tail_p1;

   wire           vb_select;

   wire 	  nc0, nc1, nc2, nc3, nc4, nc5, nc6;

   wire 	  int_reset; // = reset | flush;

   or2$ ( int_reset, reset, flush);
   
   // Signals indicating data has been accepted or read.
   and2$ vr_i_and(in_accept, valid_i, ready_i);
   and2$ vr_o_and(out_accept, valid_o, ready_o);

   // Valid Out if any entry is valid
   or4$ valid_o_or(valid_o, valid0, valid1, valid2, valid3);
   
   // Ready Out if any entry is open
   nand4$ ready_o_nand(ready_i, valid0, valid1, valid2, valid3);
 /*
   mux #(.WIDTH(1), .INPUTS(16)) (
	{
	    //1111
	    //1111
	    //1111
	    //1111
	    //1111
	    //1111
	    //1111
	    //1111
	    //1111
	    //1111
	    //1111
	    //01
	    //0011
	    //0010
	    //0001
	    //0000
        }			  
        ,
        ,
				  
  );*/
   
   // Set indications of each entry
   and2$ s0_and(set0,in_accept,eq_i0);
   and2$ s1_and(set1,in_accept,eq_i1);
   and2$ s2_and(set2,in_accept,eq_i2);
   and2$ s3_and(set3,in_accept,eq_i3);

   // Clear indications of each entry
   wire 	  head_eq_0, head_in_eq_0;
   wire 	  head_eq_1, head_in_eq_1;
   wire 	  head_eq_1, head_in_eq_2;
   wire 	  head_eq_3, head_in_eq_3;
   
   compare #(.WIDTH(2)) (2'd0,head[5:4],head_eq_0);
   compare #(.WIDTH(2)) (2'd1,head[5:4],head_eq_1);
   compare #(.WIDTH(2)) (2'd2,head[5:4],head_eq_2);
   compare #(.WIDTH(2)) (2'd3,head[5:4],head_eq_3);

   compare #(.WIDTH(2)) (2'd0,head_in[5:4],head_in_eq_0);
   compare #(.WIDTH(2)) (2'd1,head_in[5:4],head_in_eq_1);
   compare #(.WIDTH(2)) (2'd2,head_in[5:4],head_in_eq_2);
   compare #(.WIDTH(2)) (2'd3,head_in[5:4],head_in_eq_3);

   and2$ (c0, head_eq_0, head_in_eq_1);
   and2$ (c1, head_eq_1, head_in_eq_2);
   and2$ (c2, head_eq_2, head_in_eq_3);
   and2$ (c3, head_eq_3, head_in_eq_0);
   
   //wire  c0 = (head[5:4] == 0) && (head_in[5:4] == 1);
   //wire  c1 = (head[5:4] == 1) && (head_in[5:4] == 2);
   //wire  c2 = (head[5:4] == 2) && (head_in[5:4] == 3);
   //wire  c3 = (head[5:4] == 3) && (head_in[5:4] == 0);
     
   and2$ c0_and(clear0,out_accept,c0);
   and2$ c1_and(clear1,out_accept,c1);
   and2$ c2_and(clear2,out_accept,c2);
   and2$ c3_and(clear3,out_accept,c3);

   // clk, reset, din, q, q_bar, en
   // The head and tail pointers
   wire 	  accept_or_load;
   or2$ (accept_or_load, out_accept, load);
     
   register #(.WIDTH(4)) tail_r (clk, int_reset, tail_p1, tail, tail_b, in_accept);
   register #(.WIDTH(7)) head_r (clk, reset, head_in, head, head_b, accept_or_load);

   // Registers to hold each entries data

   // Generate F4 Mask to Mask Bad Data to 00
   /* wire [15:0] 	  f4_detect;
   wire [15:0] 	  f4_ffo;
   wire [15:0] 	  f4_mask;
   wire [15:0] 	  inv_f4_mask;
   wire [127:0]   full_inv_f4_mask;

   genvar 	  i;
   generate
   for ( i = 0; i < 16; i=i+1) begin
      compare #(.WIDTH(8)) (data_i[((i+1)*8)-1:i*8], 8'hF4, f4_detect[i]);
      inv1$ (inv_f4_mask[i], f4_mask[i]);    
   end
   endgenerate

    find_first #(.WIDTH(16)) (f4_detect, f4_ffo);
   
    subtract #(.WIDTH(16),.OPERATION(1)) (
	f4_ffo,
        16'd1,
        f4_mask	 
    );

   assign full_inv_f4_mask = {{8{inv_f4_mask[15]}}, {8{inv_f4_mask[14]}}, {8{inv_f4_mask[13]}}, {8{inv_f4_mask[12]}},
                              {8{inv_f4_mask[11]}}, {8{inv_f4_mask[10]}}, {8{inv_f4_mask[9]}} , {8{inv_f4_mask[8]}},
                              {8{inv_f4_mask[7]}} , {8{inv_f4_mask[6]}} , {8{inv_f4_mask[5]}} , {8{inv_f4_mask[4]}},
                              {8{inv_f4_mask[3]}} , {8{inv_f4_mask[2]}} , {8{inv_f4_mask[1]}} , {8{inv_f4_mask[0]}}};*/
   
   
   register #(.WIDTH(128)) entry_0_r (clk, int_reset, data_i, data0, data0_b, set0);
   register #(.WIDTH(128)) entry_1_r (clk, int_reset, data_i, data1, data1_b, set1);
   register #(.WIDTH(128)) entry_2_r (clk, int_reset, data_i, data2, data2_b, set2);
   register #(.WIDTH(128)) entry_3_r (clk, int_reset, data_i, data3, data3_b, set3);
   
   // Registers to hold each entries valid
   wire 	  nclear0;
   wire 	  nclear1;
   wire 	  nclear2;
   wire 	  nclear3;

   wire 	  sclear0;
   wire 	  sclear1;
   wire 	  sclear2;
   wire 	  sclear3;

   inv1$ (   nclear0, clear0);
   inv1$ (   nclear1, clear1);
   inv1$ (   nclear2, clear2);
   inv1$ (   nclear3, clear3);

   or2$ ( sclear0, set0, clear0);
   or2$ ( sclear1, set1, clear1);  
   or2$ ( sclear2, set2, clear2);
   or2$ ( sclear3, set3, clear3);
   
   register #(.WIDTH(1)) entry_0_v_r (clk, int_reset, nclear0, valid0, invalid0, sclear0);
   register #(.WIDTH(1)) entry_1_v_r (clk, int_reset, nclear1, valid1, invalid1, sclear1);
   register #(.WIDTH(1)) entry_2_v_r (clk, int_reset, nclear2, valid2, invalid2, sclear2);
   register #(.WIDTH(1)) entry_3_v_r (clk, int_reset, nclear3, valid3, invalid3, sclear3);

   // Compare to select which entry to set.
   compare #(.WIDTH(2)) set_0_comp (2'd0,tail[1:0],eq_i0);
   compare #(.WIDTH(2)) set_1_comp (2'd1,tail[1:0],eq_i1);
   compare #(.WIDTH(2)) set_2_comp (2'd2,tail[1:0],eq_i2);
   compare #(.WIDTH(2)) set_3_comp (2'd3,tail[1:0],eq_i3);

   // Compare to select which entry to clear
   compare #(.WIDTH(2)) clear_0_comp (2'd1,head[5:4],eq_o0);
   compare #(.WIDTH(2)) clear_1_comp (2'd2,head[5:4],eq_o1);
   compare #(.WIDTH(2)) clear_2_comp (2'd3,head[5:4],eq_o2);
   compare #(.WIDTH(2)) clear_3_comp (2'd0,head[5:4],eq_o3);

   // Muxes to select Upper and Lower halves of the shifter
   mux #(.INPUTS(4),.WIDTH(128)) data_mux_lower ({data3, data2, data1, data0}, full_data[255:128], head[5:4]);
   mux #(.INPUTS(4),.WIDTH(128)) data_mux_upper ({data3, data2, data1, data0}, full_data[127:0], head_p16[5:4]);

   // Mux to select what to load into head pointer
   mux #(.INPUTS(2),.WIDTH(7))   head_mux ({{3'b0,load_address[3:0]},head_p_br},head_in,load);

   // Mux to select how valid bytes is driven
   wire [6:0] 	 head_inv;
   wire [3:0]    tail_inv;
  
   wire [6:0] 	 head_m_tail;
   wire [6:0]    tail_m_head;

   wire [6:0] 	 head_m_tail_p1;
   wire [6:0]    tail_m_head_p1;
   
   wire 	 inv_tail_3;
   inv1$ t3_inv (inv_tail_3, tail[3]);
   and2$ vb_and (vb_select,inv_tail_3,head[6]);

   genvar 	 i;
   generate
      for(i = 0; i < 7; i = i+1) begin
         inv1$ head_inv (head_inv[i], head[i]);	 
      end

      for(i = 0; i < 4; i = i+1) begin
         inv1$ tail_inv (tail_inv[i], tail[i]);	 
      end     
   endgenerate

   slow_addr #(.WIDTH(7)) sub0 (head       ,{tail_inv,3'b111},head_m_tail, nc3);
   slow_addr #(.WIDTH(7)) sub1 ({tail,3'b0},         head_inv,tail_m_head, nc4);

   slow_addr #(.WIDTH(7)) p10  (7'd1,head_m_tail,head_m_tail_p1, nc5);
   slow_addr #(.WIDTH(7)) p20  (7'd1,tail_m_head,tail_m_head_p1, nc6);

   wire [6:0] true_tail = {tail[2:0],4'b0};
   
   wire [6:0] behv_a;
   //wire [6:0] test_a = true_tail - head[6:0];
   subtract #(.WIDTH(7)) (
	true_tail,
        head[6:0],
        behv_a	 
   );   

   wire [6:0] behv_b;
   wire [6:0] behv_b_64;   
   //wire [6:0] test_b = 64 - head[6:0] - true_tail;
   subtract #(.WIDTH(7)) (
	7'd64,
        head[6:0],
        behv_b_64	 
   );

   subtract #(.WIDTH(7)) (
	behv_b_64,
        true_tail,
        behv_b	 
   );
   
   //mux #(.INPUTS(2),.WIDTH(7))   valid_bytes_mux ({behv_b,behv_a},valid_bytes_o,vb_select);
 
   wire [6:0] valid_bytes_i;
   wire [6:0] valid_bytes_p16;
   wire [6:0] valid_bytes_p16_mBR;
   wire [6:0] valid_bytes_mBR;

   assign valid_bytes_p16 = valid_bytes_o + 16;
   assign valid_bytes_p16_mBR = valid_bytes_o + 16 - bytes_read_o;
   assign valid_bytes_mBR = valid_bytes_o - bytes_read_o;
   
   assign valid_bytes_i = (in_accept & out_accept) ? valid_bytes_p16_mBR :
			  (in_accept)  ? valid_bytes_p16 :
			  (out_accept) ? valid_bytes_mBR : valid_bytes_o;
   
   register #(.WIDTH(7)) vnc (clk, int_reset, valid_bytes_i, valid_bytes_o, , (in_accept | out_accept));

   
   // Head Ptr Plus 8
   slow_addr #(.WIDTH(7)) hp1 (7'd16,head,head_p16, nc0);
   
   // Head Ptr Plus Bytes Read
   slow_addr #(.WIDTH(7)) hpbr ({3'b0,bytes_read_o},head,head_p_br, nc1);

   // Tail Ptr Plus 1
   slow_addr #(.WIDTH(4)) tp1 (4'd1,tail,tail_p1, nc2);

   // Byte Shifter
   wire [255:0] shifter_o;

   byte_shifter_32B shifter (full_data ,shifter_o, {1'b0,head[3:0]});

   assign intruction_o = shifter_o;
   
endmodule
   
