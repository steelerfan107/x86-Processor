////////////////////////////////////////////
//
// Byte Shifter 8B
//
// Shifter which can shift on a byte granularity. 8B Wide
//

module byte_shifter_8B (
   in,
   out,
   shift_amount
);

   input [63:0] in;
   output [63:0] out;
   input [2:0] 	  shift_amount;

   genvar 	  i;
   generate
      for(i = 0; i < 8; i=i+1) begin
	 wire [2:0] sel;
	 wire 	    nc;	 
	 //slow_addr #(.WIDTH(3)) shft_add (i, shift_amount, sel, nc);
	 //assign sel = i - shift_amount; 
	 subtract #(.WIDTH(3)) (
	   i,
           shift_amount,
           sel	 
         );	 	 
         mux #(.WIDTH(8), .INPUTS(8)) byte_mux (in, out[((i+1)*8)-1:(i*8)],sel);	 
      end
   endgenerate
   
endmodule 
   
			 
