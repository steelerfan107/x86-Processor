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
wire [31:0]    dec_disp_masked;   

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
byte_shifter_right_8B (end_swap_s0_displace_n_imm, imm, s0_displacement_bytes[2:0]);

byte_shifter_right_4B (32'hFFFFFFFF, disp_mask, sub4_disp_bytes[1:0]); 
byte_shifter_right_8B (end_swap_s0_displace_n_imm, disp, 0);   

// TODO - Make Case
//assign imm_mask  = (48'hFFFFFFFFFFFF >> 8*(6-s0_immediete_bytes));
//assign disp_mask = (32'hFFFFFFFF     >> 8*(4-s0_displacement_bytes));

//assign imm  = (s0_displace_n_imm >> 8*(8-(s0_immediete_bytes+s0_displacement_bytes)));
//assign disp = (s0_displace_n_imm >> 8*(8-s0_displacement_bytes));

// Create Extend OR Vector   
wire    [31:0] sign_extend_4B_disp = {{24{end_swap_s0_displace_n_imm[7]}},8'b0};
  
wire    [47:0] sign_extend_4B_imm = {16'b0, {24{imm[7]}}, 8'b0};
wire    [47:0] sign_extend_2B_imm = {32'b0, {8{imm[7]}}, 8'b0};

wire [47:0] sign_extend_imm; 
wire [31:0] sign_extend_disp;
wire [47:0] dec_disp_masked; 
wire [31:0] dec_imm_masked;   
wire [2:0]    masked_size;

compare #(.WIDTH(4)) (4'd1, s0_immediete_bytes,  imm_byte_one);
compare #(.WIDTH(4)) (4'd1, s0_displacement_bytes,  disp_byte_one);   

logic_tree_bus #(.WIDTH(3),.NINPUTS(2))  ({{3{imm_byte_one}},dec_size},masked_size);

mux #(.WIDTH(32),.INPUTS(2)) ({sign_extend_disp,32'b0}, sign_extend_disp, disp_byte_one);
mux #(.WIDTH(48),.INPUTS(2)) ({sign_extend_4B_imm,sign_extend_2B_imm,32'b0,32'b0}, sign_extend_imm, masked_size);

wire [31:0] dec_disp_extend;
   
logic_tree_bus #(.WIDTH(32),.NINPUTS(2)) disp_maskb ({disp_mask,end_swap_s0_displace_n_imm[31:0]},dec_disp_masked);
logic_tree_bus #(.WIDTH(48),.NINPUTS(2)) imm_maskb  ({imm_mask,imm},dec_imm_masked);

logic_tree_bus #(.WIDTH(32),.NINPUTS(2),.OPERATION(1)) disp_ext ({sign_extend_disp,dec_disp_masked},dec_disp_extend);
logic_tree_bus #(.WIDTH(48),.NINPUTS(2),.OPERATION(1)) imm_ext  ({sign_extend_imm,dec_imm_masked},dec_imm);   

// Possibly Zero out DISP		      
mux #(.WIDTH(32),.INPUTS(2)) ({32'h0,dec_disp_extend}, dec_disp, disp_byte_zero);

nor3$ (disp_byte_zero, s0_displacement_bytes[2], s0_displacement_bytes[1], s0_displacement_bytes[0]);
	  
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
