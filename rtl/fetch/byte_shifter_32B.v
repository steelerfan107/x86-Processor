////////////////////////////////////////////
//
// Byte Shifter 32B
//
// Shifter which can shift on a byte granularity. 32B Wide
//

module byte_shifter_32B (
   in,
   out,
   shift_amount
);

   input [255:0] in;
   output [255:0] out;
   input [4:0] 	  shift_amount;

   genvar 	  i;
   generate
      for(i = 0; i < 32; i=i+1) begin
	 wire [4:0] sel;
	 wire 	    nc;	 
	 slow_addr #(.WIDTH(5)) shft_add (i, shift_amount, sel, nc);	 
         mux #(.WIDTH(8), .INPUTS(32)) byte_mux (in, out[((i+1)*8)-1:(i*8)],sel);	 
      end
   endgenerate
   
endmodule 
   
			 
