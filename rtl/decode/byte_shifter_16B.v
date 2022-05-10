////////////////////////////////////////////
//
// Byte Shifter 16B
//
// Shifter which can shift on a byte granularity. 16B Wide
//

module byte_shifter_16B (
   in,
   out,
   shift_amount
);

   input [127:0] in;
   output [127:0] out;
   input [3:0] 	  shift_amount;

   genvar 	  i;
   generate
      for(i = 0; i < 16; i=i+1) begin
	 wire [3:0] sel;
	 wire 	    nc;	 
	 //slow_addr #(.WIDTH(4)) shft_add (i, shift_amount, sel, nc);
         //assign sel = i - shift_amount;
	 subtract #(.WIDTH(4)) (
	   i,
           shift_amount,
           sel	 
         );
         mux #(.WIDTH(8), .INPUTS(16)) byte_mux (in, out[((i+1)*8)-1:(i*8)],sel);	 
      end
   endgenerate
   
endmodule 
   
			 
