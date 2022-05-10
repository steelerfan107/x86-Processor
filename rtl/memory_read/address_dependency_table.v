//////////////////////////////////////
//
//  Address Dependency Module
//

module address_dependency_table (
   // Clock Interface
   clk,
   reset,  

   // Control Interface
   flush,

   // Address Interface In	
   push,		  
   push_address,
   push_size,

   // Address Compare Interface
   compare_address_0,
   compare_address_0_size,			  
   compare_address_0_hit,			  

   compare_address_1,
   compare_address_1_size,			  
   compare_address_1_hit,
		  
   // Address Interface Out
   pop,
);

   // Clock Interface
   input          clk;
   input          reset; 

   // Control Interface
   input          flush;
   
   // Address Interface In	
   input          push;
   input [31:0]   push_address;
   input [2:0]    push_size;

   // Address Compare Interface
   input [31:0]   compare_address_0;
   input [2:0] 	  compare_address_0_size;
   output         compare_address_0_hit;			  

   input [31:0]   compare_address_1;
   input [2:0] 	  compare_address_1_size;   
   output         compare_address_1_hit;	
		  
   // Address Interface Out
   input          pop;

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
 
   wire 	  eq_0_0_64, eq_1_0_64;
   wire 	  eq_0_1_64, eq_1_1_64;
   wire 	  eq_0_2_64, eq_1_2_64;
   wire 	  eq_0_3_64, eq_1_3_64;

   wire 	  eq_0_0_32, eq_1_0_32;
   wire 	  eq_0_1_32, eq_1_1_32;
   wire 	  eq_0_2_32, eq_1_2_32;
   wire 	  eq_0_3_32, eq_1_3_32;

   wire 	  eq_0_0_16, eq_1_0_16;
   wire 	  eq_0_1_16, eq_1_1_16;
   wire 	  eq_0_2_16, eq_1_2_16;
   wire 	  eq_0_3_16, eq_1_3_16;

   wire 	  eq_0_0, eq_1_0;
   wire 	  eq_0_1, eq_1_1;
   wire 	  eq_0_2, eq_1_2;
   wire 	  eq_0_3, eq_1_3;
   
   wire           addr0_aligned_64, addr1_aligned_64;   
   wire           addr0_aligned_32, addr1_aligned_32;
   wire           addr0_aligned_16, addr1_aligned_16;

   wire           in_aligned_64;
   wire           in_aligned_32;
   wire           in_aligned_16;

   wire [2:0] 	  bits_i, bits0, bits1, bits2, bits3, bits_from_size, bits_i_unaligned;
   wire 	  inaligned, inunaligned;

   inv1$ (in_aligned_16,push_address[0]);
   nor2$ (in_aligned_32,push_address[0],push_address[1]); 
   nor3$ (in_aligned_64,push_address[0],push_address[1], push_address[2]);

   mux #(.WIDTH(1), .INPUTS(8)) (
				   {
				    3'b0,
				    in_aligned_64,
				    in_aligned_32,
				    in_aligned_16,
				    1'b1,
				    1'b0
				   },
				   inaligned,
				   push_size
				 );

   inv1$ (inunaligned, inaligned);
   
   mux #(.WIDTH(3), .INPUTS(8)) (
				   {
				    3'd0,
				    3'd0,
				    3'd0,
				    3'd3,
				    3'd2,
				    3'd1,
				    3'd0,				    
				    3'd0
				   },
				   bits_from_size,
				   push_size
				 );
   
   
   slow_addr #(.WIDTH(3)) biu (3'd1, bits_from_size, bits_i_unaligned, nc2);

   mux #(.WIDTH(3), .INPUTS(2)) (
				   {
				     bits_i_unaligned,
				     bits_from_size
				   },
				   bits_i,
				   inunaligned
				 );
   
   wire 	  qual_0_0, qual_1_0;
   wire 	  qual_0_1, qual_1_1;
   wire 	  qual_0_2, qual_1_2;
   wire 	  qual_0_3, qual_1_3;   
   
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

   wire 	  int_reset = reset | flush;

   // Signals indicating data has been accepted or read.
   //and2$ vr_i_and(in_accept, valid_i, ready_i);
   //and2$ vr_o_and(out_accept, valid_o, ready_o);
   assign in_accept  = push;
   assign out_accept = pop;   

   // Valid Out if any entry is valid
   or4$ valid_o_or(valid_o, valid0, valid1, valid2, valid3);
   
   // Ready Out if any entry is open
   nand4$ ready_o_nand(ready_i, valid0, valid1, valid2, valid3);
   
   // Set indications of each entry
   and2$ s0_and(set0,in_accept,eq_i0);
   and2$ s1_and(set1,in_accept,eq_i1);
   and2$ s2_and(set2,in_accept,eq_i2);
   and2$ s3_and(set3,in_accept,eq_i3);

   // Clear indications of each entry
   wire  c0 = (head[5:4] == 0) && (head_p16[5:4] == 1);
   wire  c1 = (head[5:4] == 1) && (head_p16[5:4] == 2);
   wire  c2 = (head[5:4] == 2) && (head_p16[5:4] == 3);
   wire  c3 = (head[5:4] == 3) && (head_p16[5:4] == 0);
     
   and2$ c0_and(clear0,out_accept,c0);
   and2$ c1_and(clear1,out_accept,c1);
   and2$ c2_and(clear2,out_accept,c2);
   and2$ c3_and(clear3,out_accept,c3);

   // clk, reset, din, q, q_bar, en
   // The head and tail pointers
   register #(.WIDTH(4)) tail_r (clk, int_reset, tail_p1, tail, tail_b, in_accept);
   register #(.WIDTH(7)) head_r (clk, reset, head_p16, head, head_b, out_accept);

   // Tail Ptr Plus 1
   slow_addr #(.WIDTH(4)) tp1 (4'd1,tail,tail_p1, nc2);
   slow_addr #(.WIDTH(7)) hp1 (7'd16,head,head_p16, nc0);
   
   // Registers to hold each entries data
   register #(.WIDTH(32)) entry_0_r (clk, int_reset, data_i, data0, data0_b, set0);
   register #(.WIDTH(32)) entry_1_r (clk, int_reset, data_i, data1, data1_b, set1);
   register #(.WIDTH(32)) entry_2_r (clk, int_reset, data_i, data2, data2_b, set2);
   register #(.WIDTH(32)) entry_3_r (clk, int_reset, data_i, data3, data3_b, set3);

   // Registers to hold each entries data
   register #(.WIDTH(3)) entry_0_bits (clk, int_reset, bits_i, bits0, data0_b, set0);
   register #(.WIDTH(3)) entry_1_bits (clk, int_reset, bits_i, bits1, data1_b, set1);
   register #(.WIDTH(3)) entry_2_bits (clk, int_reset, bits_i, bits2, data2_b, set2);
   register #(.WIDTH(3)) entry_3_bits (clk, int_reset, bits_i, bits3, data3_b, set3);
   
   // Registers to hold each entries valid
   register #(.WIDTH(1)) entry_0_v_r (clk, int_reset, ~clear0, valid0, invalid0, (set0 | clear0));
   register #(.WIDTH(1)) entry_1_v_r (clk, int_reset, ~clear1, valid1, invalid1, (set1 | clear1));
   register #(.WIDTH(1)) entry_2_v_r (clk, int_reset, ~clear2, valid2, invalid2, (set2 | clear2));
   register #(.WIDTH(1)) entry_3_v_r (clk, int_reset, ~clear3, valid3, invalid3, (set3 | clear3));

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

   wire  eq_0_0_4,  eq_0_1_4, eq_0_2_4, eq_0_3_4;
   wire  eq_1_0_4,  eq_1_1_4, eq_1_2_4, eq_1_3_4;

   wire  eq_0_0_3,  eq_0_1_3, eq_0_2_3, eq_0_3_3;
   wire  eq_1_0_3,  eq_1_1_3, eq_1_2_3, eq_1_3_3;   
 
   wire  eq_0_0_2,  eq_0_1_2, eq_0_2_2, eq_0_3_2;
   wire  eq_1_0_2,  eq_1_1_2, eq_1_2_2, eq_1_3_2;

   wire  eq_0_0_1,  eq_0_1_1, eq_0_2_1, eq_0_3_1;
   wire  eq_1_0_1,  eq_1_1_1, eq_1_2_1, eq_1_3_1;

   wire  eq_0_0_0,  eq_0_1_0, eq_0_2_0, eq_0_3_0;
   wire  eq_1_0_0,  eq_1_1_0, eq_1_2_0, eq_1_3_0;

   // Check Alignemnt of incoming Compare Addresses
   inv1$ (addr0_aligned_16,compare_address_0[0]);
   nor2$ (addr0_aligned_32,compare_address_0[0],compare_address_0[1]); 
   nor3$ (addr0_aligned_64,compare_address_0[0],compare_address_0[1], compare_address_0[2]); 

   inv1$ (addr1_aligned_16,compare_address_1[0]);
   nor2$ (addr1_aligned_32,compare_address_1[0],compare_address_1[1]); 
   nor3$ (addr1_aligned_64,compare_address_1[0],compare_address_1[1], compare_address_1[2]);

   // Address 0 Bits Generation
   wire  addr0_aligned;
   wire [2:0] addr0_bits_from_size, addr0_bits_unaligned, addr0_bits;
   
   mux #(.WIDTH(1), .INPUTS(8)) (
				   {
				    3'b0,
				    addr0_aligned_64,
				    addr0_aligned_32,
				    addr0_aligned_16,
				    1'b1,
				    1'b0
				   },
				   addr0_aligned,
				   compare_address_0_size
				 );

   inv1$ (addr0_unaligned, addr0_aligned);
   
   mux #(.WIDTH(3), .INPUTS(8)) (
				   {
				    3'd0,
				    3'd0,
				    3'd0,
				    3'd3,
				    3'd2,
				    3'd1,
				    3'd0,				    
				    3'd0
				   },
				   addr0_bits_from_size,
				   compare_address_0_size
				 );
   
   
   slow_addr #(.WIDTH(3)) ba0u (3'd1, addr0_bits_from_size, addr0_bits_unaligned, nc2);

   mux #(.WIDTH(3), .INPUTS(2)) (
				   {
				     addr0_bits_unaligned,
				     addr0_bits_from_size
				   },
				   addr0_bits,
				   addr0_unaligned
				 );

   mag_comp4$ (addr0_bits, bits0, use_addr0_bits_0, nc00);
   mag_comp4$ (addr0_bits, bits1, use_addr0_bits_1, nc00);
   mag_comp4$ (addr0_bits, bits2, use_addr0_bits_2, nc00);
   mag_comp4$ (addr0_bits, bits3, use_addr0_bits_3, nc00);

   wire       bits_for_data0_addr0_compare;
   wire       bits_for_data1_addr0_compare;
   wire       bits_for_data2_addr0_compare;
   wire       bits_for_data3_addr0_compare;

   mux2$ (bits_for_data0_addr0_compare, bits0, addr0_bits, use_addr0_bits_0);
   mux2$ (bits_for_data1_addr0_compare, bits1, addr0_bits, use_addr0_bits_1);
   mux2$ (bits_for_data2_addr0_compare, bits2, addr0_bits, use_addr0_bits_2);
   mux2$ (bits_for_data3_addr0_compare, bits3, addr0_bits, use_addr0_bits_3); 
  
   // Compare Address - 4 bit Alias
   compare #(.WIDTH(28)) addr_0_comp_0_4 (compare_address_0[31:4],data0[31:4],eq_0_0_4);
   compare #(.WIDTH(28)) addr_0_comp_1_4 (compare_address_0[31:4],data1[31:4],eq_0_1_4);
   compare #(.WIDTH(28)) addr_0_comp_2_4 (compare_address_0[31:4],data2[31:4],eq_0_2_4);
   compare #(.WIDTH(28)) addr_0_comp_3_4 (compare_address_0[31:4],data3[31:4],eq_0_3_4);   

   // Compare Address -3 bit Alias
   compare #(.WIDTH(29)) addr_0_comp_0_3 (compare_address_0[31:3],data0[31:3],eq_0_0_3);
   compare #(.WIDTH(29)) addr_0_comp_1_3 (compare_address_0[31:3],data1[31:3],eq_0_1_3);
   compare #(.WIDTH(29)) addr_0_comp_2_3 (compare_address_0[31:3],data2[31:3],eq_0_2_3);
   compare #(.WIDTH(29)) addr_0_comp_3_3 (compare_address_0[31:3],data3[31:3],eq_0_3_3);   

   // Compare Address - 2 bit Alias
   compare #(.WIDTH(30)) addr_0_comp_0_2 (compare_address_0[31:2],data0[31:2],eq_0_0_2);
   compare #(.WIDTH(30)) addr_0_comp_1_2 (compare_address_0[31:2],data1[31:2],eq_0_1_2);
   compare #(.WIDTH(30)) addr_0_comp_2_2 (compare_address_0[31:2],data2[31:2],eq_0_2_2);
   compare #(.WIDTH(30)) addr_0_comp_3_2 (compare_address_0[31:2],data3[31:2],eq_0_3_2);   

   // Compare Address - 1 bit Alias
   compare #(.WIDTH(31)) addr_0_comp_0_1 (compare_address_0[31:1],data0[31:1],eq_0_0_1);
   compare #(.WIDTH(31)) addr_0_comp_1_1 (compare_address_0[31:1],data1[31:1],eq_0_1_1);
   compare #(.WIDTH(31)) addr_0_comp_2_1 (compare_address_0[31:1],data2[31:1],eq_0_2_1);
   compare #(.WIDTH(31)) addr_0_comp_3_1 (compare_address_0[31:1],data3[31:1],eq_0_3_1);   

   // Compare Address - No Alias  
   compare #(.WIDTH(32)) addr_0_comp_0_0 (compare_address_0[31:0],data0[31:0],eq_0_0_0);
   compare #(.WIDTH(32)) addr_0_comp_1_0 (compare_address_0[31:0],data1[31:0],eq_0_1_0);
   compare #(.WIDTH(32)) addr_0_comp_2_0 (compare_address_0[31:0],data2[31:0],eq_0_2_0);
   compare #(.WIDTH(32)) addr_0_comp_3_0 (compare_address_0[31:0],data3[31:0],eq_0_3_0);      
   
   // Pick Comparison Point
   mux #(.WIDTH(1), .INPUTS(8)) (
	{3'b0,  eq_0_0_4, eq_0_0_3, eq_0_0_2, eq_0_0_1, eq_0_0_0},
	 eq_0_0,
         bits_for_data0_addr0_compare		         			 
   );

   mux #(.WIDTH(1), .INPUTS(8)) (
	{3'b0,  eq_0_1_4, eq_0_1_3, eq_0_1_2, eq_0_1_1, eq_0_1_0},
	 eq_0_1,
         bits_for_data1_addr0_compare		         			 
   );

   mux #(.WIDTH(1), .INPUTS(8)) (
	{3'b0,  eq_0_2_4, eq_0_2_3, eq_0_2_2, eq_0_2_1, eq_0_2_0},
	 eq_0_2,
         bits_for_data2_addr0_compare			         			 
   );
   
   mux #(.WIDTH(1), .INPUTS(8)) (
	{3'b0,  eq_0_3_4, eq_0_3_3, eq_0_3_2, eq_0_3_1, eq_0_3_0},
	 eq_0_3,
         bits_for_data3_addr0_compare		         			 
   );
 

   // Qualify Comparison  
   and2$ (qual_0_0, eq_0_0, valid0);
   and2$ (qual_0_1, eq_0_1, valid1);
   and2$ (qual_0_2, eq_0_2, valid2);
   and2$ (qual_0_3, eq_0_3, valid3);

   or4$ (compare_address_0_hit, qual_0_0, qual_0_1, qual_0_2, qual_0_3);

   // Address 1 Bits Generation
   wire  addr1_aligned;
   wire [2:0] addr1_bits_from_size, addr1_bits_unaligned, addr1_bits;
   
   mux #(.WIDTH(1), .INPUTS(8)) (
				   {
				    3'b0,
				    addr1_aligned_64,
				    addr1_aligned_32,
				    addr1_aligned_16,
				    1'b1,
				    1'b0
				   },
				   addr1_aligned,
				   compare_address_1_size
				 );

   inv1$ (addr1_unaligned, addr1_aligned);
   
   mux #(.WIDTH(3), .INPUTS(8)) (
				   {
				    3'd0,
				    3'd0,
				    3'd0,
				    3'd3,
				    3'd2,
				    3'd1,
				    3'd0,				    
				    3'd0
				   },
				   addr1_bits_from_size,
				   compare_address_1_size
				 );
   
   
   slow_addr #(.WIDTH(3)) ba1u (3'd1, addr1_bits_from_size, addr1_bits_unaligned, nc2);

   mux #(.WIDTH(3), .INPUTS(2)) (
				   {
				     addr1_bits_unaligned,
				     addr1_bits_from_size
				   },
				   addr1_bits,
				   addr1_unaligned
				 );

   mag_comp4$ (addr1_bits, bits0, use_addr1_bits_0, nc00);
   mag_comp4$ (addr1_bits, bits1, use_addr1_bits_1, nc00);
   mag_comp4$ (addr1_bits, bits2, use_addr1_bits_2, nc00);
   mag_comp4$ (addr1_bits, bits3, use_addr1_bits_3, nc00);

   wire       bits_for_data0_addr1_compare;
   wire       bits_for_data1_addr1_compare;
   wire       bits_for_data2_addr1_compare;
   wire       bits_for_data3_addr1_compare; 

   mux2$ (bits_for_data0_addr1_compare, bits0, addr1_bits, use_addr1_bits_0);
   mux2$ (bits_for_data1_addr1_compare, bits1, addr1_bits, use_addr1_bits_1);
   mux2$ (bits_for_data2_addr1_compare, bits2, addr1_bits, use_addr1_bits_2);
   mux2$ (bits_for_data3_addr1_compare, bits3, addr1_bits, use_addr1_bits_3); 
  
   // Compare Address - 4 bit Alias
   compare #(.WIDTH(28)) addr_1_comp_0_4 (compare_address_1[31:4],data0[31:4],eq_1_0_4);
   compare #(.WIDTH(28)) addr_1_comp_1_4 (compare_address_1[31:4],data1[31:4],eq_1_1_4);
   compare #(.WIDTH(28)) addr_1_comp_2_4 (compare_address_1[31:4],data2[31:4],eq_1_2_4);
   compare #(.WIDTH(28)) addr_1_comp_3_4 (compare_address_1[31:4],data3[31:4],eq_1_3_4);   

   // Compare Address -3 bit Alias
   compare #(.WIDTH(29)) addr_1_comp_0_3 (compare_address_1[31:3],data0[31:3],eq_1_0_3);
   compare #(.WIDTH(29)) addr_1_comp_1_3 (compare_address_1[31:3],data1[31:3],eq_1_1_3);
   compare #(.WIDTH(29)) addr_1_comp_2_3 (compare_address_1[31:3],data2[31:3],eq_1_2_3);
   compare #(.WIDTH(29)) addr_1_comp_3_3 (compare_address_1[31:3],data3[31:3],eq_1_3_3);   

   // Compare Address - 2 bit Alias
   compare #(.WIDTH(30)) addr_1_comp_0_2 (compare_address_1[31:2],data0[31:2],eq_1_0_2);
   compare #(.WIDTH(30)) addr_1_comp_1_2 (compare_address_1[31:2],data1[31:2],eq_1_1_2);
   compare #(.WIDTH(30)) addr_1_comp_2_2 (compare_address_1[31:2],data2[31:2],eq_1_2_2);
   compare #(.WIDTH(30)) addr_1_comp_3_2 (compare_address_1[31:2],data3[31:2],eq_1_3_2);   

   // Compare Address - 1 bit Alias
   compare #(.WIDTH(31)) addr_1_comp_0_1 (compare_address_1[31:1],data0[31:1],eq_1_0_1);
   compare #(.WIDTH(31)) addr_1_comp_1_1 (compare_address_1[31:1],data1[31:1],eq_1_1_1);
   compare #(.WIDTH(31)) addr_1_comp_2_1 (compare_address_1[31:1],data2[31:1],eq_1_2_1);
   compare #(.WIDTH(31)) addr_1_comp_3_1 (compare_address_1[31:1],data3[31:1],eq_1_3_1);   

   // Compare Address - No Alias  
   compare #(.WIDTH(32)) addr_1_comp_0_0 (compare_address_1[31:0],data0[31:0],eq_1_0_0);
   compare #(.WIDTH(32)) addr_1_comp_1_0 (compare_address_1[31:0],data1[31:0],eq_1_1_0);
   compare #(.WIDTH(32)) addr_1_comp_2_0 (compare_address_1[31:0],data2[31:0],eq_1_2_0);
   compare #(.WIDTH(32)) addr_1_comp_3_0 (compare_address_1[31:0],data3[31:0],eq_1_3_0);      
   
   // Pick Comparison Point
   mux #(.WIDTH(1), .INPUTS(8)) (
	{3'b0,  eq_1_0_4, eq_1_0_3, eq_1_0_2, eq_1_0_1, eq_1_0_0},
	 eq_1_0,
         bits_for_data0_addr1_compare		         			 
   );

   mux #(.WIDTH(1), .INPUTS(8)) (
	{3'b0,  eq_1_1_4, eq_1_1_3, eq_1_1_2, eq_1_1_1, eq_1_1_0},
	 eq_1_1,
         bits_for_data1_addr1_compare		         			 
   );

   mux #(.WIDTH(1), .INPUTS(8)) (
	{3'b0,  eq_1_2_4, eq_1_2_3, eq_1_2_2, eq_1_2_1, eq_1_2_0},
	 eq_1_2,
         bits_for_data2_addr1_compare			         			 
   );
   
   mux #(.WIDTH(1), .INPUTS(8)) (
	{3'b0,  eq_1_3_4, eq_1_3_3, eq_1_3_2, eq_1_3_1, eq_1_3_0},
	 eq_1_3,
         bits_for_data3_addr1_compare		         			 
   );
 

   // Qualify Comparison  
   and2$ (qual_1_0, eq_1_0, valid0);
   and2$ (qual_1_1, eq_1_1, valid1);
   and2$ (qual_1_2, eq_1_2, valid2);
   and2$ (qual_1_3, eq_1_3, valid3);

   or4$ (compare_address_1_hit, qual_1_0, qual_1_1, qual_1_2, qual_1_3);
   
endmodule
   
