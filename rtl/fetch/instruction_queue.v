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

   // Data Interface In	
   input          valid_i;
   output         ready_i;		  
   input [127:0]  data_i;
   		  
   // Instruction Interface Out
   output         valid_o;
   input          ready_o;
   input [3:0]    bytes_read_o;
   output [5:0]   valid_bytes_o;
   output [127:0] intruction_o;

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

   // Signals indicating data has been accepted or read.
   and2$ vr_i_and(in_accept, );
   and2$ vr_o_and(out_accept, );

   // Valid Out if any entry is valid
   or4$ valid_o_or();
   
   // Ready Out if any entry is open
   nand4$ ready_o_nand();
   
   // Set indications of each entry
   and2$ s0_and(set0,);
   and2$ s1_and(set1,);
   and2$ s2_and(set2,);
   and2$ s3_and(set3,);

   // Clear indications of each entry
   and2$ c0_and(clear0,);
   and2$ c1_and(clear1,);
   and2$ c2_and(clear2,);
   and2$ c3_and(clear3,);

   // The head and tail pointers
   register #(.WIDTH(3)) tail_r ();
   register #(.WIDTH(7)) head_r ();

   // Registers to hold each entries data
   register #(.WIDTH(128)) entry_0_r ();
   register #(.WIDTH(128)) entry_1_r ();
   register #(.WIDTH(128)) entry_2_r ();
   register #(.WIDTH(128)) entry_3_r ();
   
   // Registers to hold each entries valid
   register #(.WIDTH(1)) entry_0_v_r ();
   register #(.WIDTH(1)) entry_1_v_r ();
   register #(.WIDTH(1)) entry_2_v_r ();
   register #(.WIDTH(1)) entry_3_v_r ();

   // Compare to select which entry to set.
   compare #(.WIDTH(2)) set_0_comp ();
   compare #(.WIDTH(2)) set_1_comp ();
   compare #(.WIDTH(2)) set_2_comp ();
   compare #(.WIDTH(2)) set_3_comp ();

   // Compare to select which entry to clear
   compare #(.WIDTH(2)) clear_0_comp ();
   compare #(.WIDTH(2)) clear_1_comp ();
   compare #(.WIDTH(2)) clear_2_comp ();
   compare #(.WIDTH(2)) clear_3_comp ();

   // Muxes to select Upper and Lower halves of the shifter
   mux #(.INPUTS(4),.WIDTH(128)) data_mux_lower ();
   mux #(.INPUTS(4),.WIDTH(128)) data_mux_upper ();

   // Mux to select what to load into head pointer
   mux #(.INPUTS(2),.WIDTH(7))   head_mux ();

   // Mux to select how valid bytes is driven
   mux #(.INPUTS(2),.WIDTH(6))   valid_bytes_mux ();

   // Head Ptr Plus 1
   slow_addr #(.WIDTH(7)) ();
   
   // Head Ptr Plus Bytes Read
   slow_addr #(.WIDTH(7)) ();

   // Tail Ptr Plus 1
   slow_addr #(.WIDTH(4)) ();

   // Byte Shifter 
   byte_shifter #(.WIDTH(256)) ();
   
endmodule
   
