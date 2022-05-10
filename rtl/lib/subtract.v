module subtract (
	a,
        b,
        result	 
);

   parameter WIDTH = 8;

   input [WIDTH-1:0] a;
   input [WIDTH-1:0] b;
   output [WIDTH-1:0] result;

   wire [WIDTH-1:0] inv_b;

   genvar 	    i;
   generate
      for(i = 0; i < WIDTH; i = i+1) begin
	 inv1$ (inv_b[i], b[i]);	
      end
   endgenerate

   slow_addr_cin #(.WIDTH(WIDTH)) (a, inv_b, result, nc, 1'b1);
   
endmodule

module slow_addr_cin (
  a,
  b,
  out,
  carry,
  cin	  
);

   parameter WIDTH = 64;

   input cin;
   input [WIDTH-1:0] a, b;
   output [WIDTH-1:0] out;
   output 	      carry;

   wire [WIDTH-1:0]   carry_vec;

   genvar 	      i;
   generate
      if (WIDTH == 1) begin
	 full_addr fa (a, b, out, 1'b0, carry);
      end else begin
         for(i = 0; i < WIDTH; i=i+1) begin
	    if ( i == 0 ) begin
	      full_addr fa (a[i], b[i], out[i], cin, carry_vec[i]);	       
	    end else begin
	      full_addr fa (a[i], b[i], out[i], carry_vec[i-1], carry_vec[i]);
	    end
         end
      end
   endgenerate

   assign carry = carry_vec[WIDTH-1];
endmodule // slow_addr
