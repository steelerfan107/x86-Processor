module imm_disp_seperate (
	s0_displace_n_imm,
        s0_immediete_bytes,
        s0_displacement_bytes,	    
       	dec_imm,
        dec_disp,
        dec_size			  
);
     
input [63:0]	s0_displace_n_imm;
input [3:0]     s0_immediete_bytes;  // 6, 4, 2, 1
input [3:0]     s0_displacement_bytes;	// 4, 1, 0    
output [47:0]   dec_imm;
output [31:0]   dec_disp;
   input [2:0] 	dec_size;
   

wire [47:0] 	imm_mask;
wire [31:0] disp_mask;

wire [47:0] 	imm;
wire [31:0]    disp;
   
wire [47:0] 	imm_clean;
wire [31:0]    disp_clean; 
   
  wire [47:0] 	imm_unextended;
wire [31:0]    disp_unextended; 

wire [63:0] s0_displace_n_imm_shift;

byte_shifter_8B bs8 (
   s0_displace_n_imm,
   s0_displace_n_imm_shift,
   s0_displacement_bytes
);

 wire [6:0] imm_mask_shift_factor;
wire [6:0] disp_mask_shift_factor;
 
wire [6:0] imm_shift_factor;
wire [6:0] disp_shift_factor;
   
wire [3:0] imm_plus_disp_bytes;

wire [63:0] end_swap_s0_displace_n_imm;

   assign end_swap_s0_displace_n_imm[7:0] = s0_displace_n_imm[63:56];
   assign end_swap_s0_displace_n_imm[15:8] = s0_displace_n_imm[55:48];
   assign end_swap_s0_displace_n_imm[23:16] = s0_displace_n_imm[47:40];
   assign end_swap_s0_displace_n_imm[31:24] = s0_displace_n_imm[39:32];
   assign end_swap_s0_displace_n_imm[39:32] = s0_displace_n_imm[31:24];
   assign end_swap_s0_displace_n_imm[47:40] = s0_displace_n_imm[23:16];
   assign end_swap_s0_displace_n_imm[55:48] = s0_displace_n_imm[15:8];
   assign end_swap_s0_displace_n_imm[63:56] = s0_displace_n_imm[7:0]; 
   
slow_addr #(.WIDTH(4)) (s0_displacement_bytes,s0_immediete_bytes,imm_plus_disp_bytes,nc0); 

wire [3:0] sub6_imm_bytes;
wire [3:0] sub4_disp_bytes;
wire [3:0] sub8_disp_bytes;
wire [3:0] sub8_disp_p_imm_bytes;

subtract #(.WIDTH(4)) (
	4'd6,
        s0_immediete_bytes,
        sub6_imm_bytes	 
   );

subtract #(.WIDTH(4)) (
	4'd4,
        s0_displacement_bytes,
        sub4_disp_bytes	 
   );
   
subtract #(.WIDTH(4)) (
	4'd8,
        s0_displacement_bytes,
        sub8_disp_bytes	 
   );

subtract #(.WIDTH(4)) (
	4'd8,
        imm_plus_disp_bytes,
        sub8_disp_p_imm_bytes	 
   ); 

  
byte_shifter_right_6B (48'hFFFFFFFFFFFF, imm_mask, sub6_imm_bytes[2:0]); 
byte_shifter_right_8B (end_swap_s0_displace_n_imm, imm_unextended, s0_displacement_bytes[2:0]);

byte_shifter_right_4B (32'hFFFFFFFF, disp_mask, sub4_disp_bytes[1:0]); 
//byte_shifter_right_8B (end_swap_s0_displace_n_imm, disp, 0);   

// TODO - Make Case
//assign imm_mask  = (48'hFFFFFFFFFFFF >> 8*(6-s0_immediete_bytes));
//assign disp_mask = (32'hFFFFFFFF     >> 8*(4-s0_displacement_bytes));

//assign imm  = (s0_displace_n_imm >> 8*(8-(s0_immediete_bytes+s0_displacement_bytes)));
//assign disp = (s0_displace_n_imm >> 8*(8-s0_displacement_bytes));

assign disp_unextended = end_swap_s0_displace_n_imm[31:0];

//mux #(.WIDTH(48),.INPUTS(2)) ({{{40{imm_unextended[7]}},imm_unextended[7:0]},imm_unextended},  imm  ,one_byte_imm);
//mux #(.WIDTH(32),.INPUTS(2)) ({{{24{disp_unextended[7]}},disp_unextended[7:0]},disp_unextended},  disp  ,one_byte_imm);  
   
logic_tree_bus #(.WIDTH(32),.NINPUTS(2)) disp_maskb ({disp_mask,disp_unextended},dec_disp_clean);
logic_tree_bus #(.WIDTH(48),.NINPUTS(2)) imm_maskb  ({imm_mask,imm_unextended},dec_imm_clean);

// Sign Extend

wire        one_byte_imm, one_byte_disp, size_is_16, size_is_32, extend_to_32, extend_to_16;
wire        extend_imm;
wire        extend_disp;
  
   
compare #(.WIDTH(4)) (s0_immediete_bytes, 4'd1, one_byte_imm);
compare #(.WIDTH(4)) (s0_displacement_bytes, 4'd1, one_byte_disp);
   
compare #(.WIDTH(3)) (dec_size, 3'd2, size_is_16);
compare #(.WIDTH(3)) (dec_size, 3'd3, size_is_32);

and2$ (extend_to_32, size_is_32, one_byte_imm);
and2$ (extend_to_16, size_is_16, one_byte_imm);

or2$ (extend_imm, extend_to_32, extend_to_16);

assign dec_4B_extended = {{24{disp_unextended[7]}},disp_unextended[7:0]};
assign imm_4B_extended = {16'b0,{24{imm_unextended[7]}},imm_unextended[7:0]};
assign imm_2B_extended = {32'b0,{8{imm_unextended[7]}},imm_unextended[7:0]};

assign dec_disp = (one_byte_disp) ? dec_4B_extended : dec_disp_clean;
assign dec_imm = (extend_to_32) ? imm_4B_extended :
		 (extend_to_16) ? imm_2B_extended :
                                  dec_imm_clean;

   	  
endmodule

////////////////////////////////////////////
//
// Byte Shifter 8B
//
// Shifter which can shift on a byte granularity. 8B Wide
//
module byte_shifter_right_8B (
   in,
   out,
   shift_amount
);

   input [63:0] in;
   output [63:0] out;
   wire [63:0] out_pre;   
   input [2:0]    shift_amount;

   genvar         i;
   generate
      for(i = 0; i < 8; i=i+1) begin
         wire [2:0] sel;
         wire       nc;
         slow_addr #(.WIDTH(3)) shft_add (i, shift_amount, sel, nc);        
         mux #(.WIDTH(8), .INPUTS(8)) byte_mux (in, out_pre[((i+1)*8)-1:(i*8)],sel);
         mux #(.WIDTH(8), .INPUTS(2)) byte_mux_mask ({8'b0, out_pre[((i+1)*8)-1:(i*8)]}, out[((i+1)*8)-1:(i*8)],nc);	 	 
      end
   endgenerate

endmodule // byte_shifter_right_6B

module byte_shifter_right_6B (
   in,
   out,
   shift_amount
);

   input [47:0] in;
   output [47:0] out;
   wire [47:0] out_pre;   
   input [2:0]    shift_amount;

   genvar         i;
   generate
      for(i = 0; i < 6; i=i+1) begin
         wire [2:0] sel;
         wire       nc;
         slow_addr #(.WIDTH(3)) shft_add (i, shift_amount, sel, nc);        
         mux #(.WIDTH(8), .INPUTS(8)) byte_mux (in, out_pre[((i+1)*8)-1:(i*8)],sel);
         mux #(.WIDTH(8), .INPUTS(2)) byte_mux_mask ({8'b0, out_pre[((i+1)*8)-1:(i*8)]}, out[((i+1)*8)-1:(i*8)],nc);	 	 
      end
   endgenerate

endmodule // byte_shifter_right_6B

module byte_shifter_right_4B (
   in,
   out,
   shift_amount
);

   input [31:0] in;
   output [31:0] out;
   wire [31:0] out_pre;   
   input [1:0]    shift_amount;

   genvar         i;
   generate
      for(i = 0; i < 4; i=i+1) begin
         wire [1:0] sel;
         wire       nc;
         slow_addr #(.WIDTH(2)) shft_add (i, shift_amount, sel, nc);        
         mux #(.WIDTH(8), .INPUTS(4)) byte_mux (in, out_pre[((i+1)*8)-1:(i*8)],sel);
         mux #(.WIDTH(8), .INPUTS(2)) byte_mux_mask ({8'b0, out_pre[((i+1)*8)-1:(i*8)]}, out[((i+1)*8)-1:(i*8)],nc);	 
      end
   endgenerate

endmodule
