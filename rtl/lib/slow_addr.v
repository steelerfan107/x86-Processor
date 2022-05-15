//////////////////////////////////////
//
//  Slow Adder
//

module slow_addr (
  a,
  b,
  out,
  carry		  
);

   parameter WIDTH = 64;

   input [WIDTH-1:0] a, b;
   output [WIDTH-1:0] out;
   output 	      carry;

   wire [WIDTH-1:0]   carry_vec;

   genvar 	      i;
   generate
      if (WIDTH == 1) begin
	 full_addr fa (a, b, out, 1'b0, carry_vec[WIDTH-1]);
      end else if (WIDTH == 32) begin
	 CLA32(
               a,  // input [31:0] a, 
               b,   //input [31:0] b, 
               1'b0,  // input Cin, 
               out,   //output [31:0] s, 
               carry_vec[WIDTH-1], //  output Cout,
                     //output overflow 
               );	
      /*end else if (WIDTH == 2) begin
	 CLA2(
               a,  // input [31:0] a, 
               b,   //input [31:0] b, 
               1'b0,  // input Cin, 
               out,   //output [31:0] s, 
               carry_vec[WIDTH-1], //  output Cout,
                     //output overflow 
               ) ;    
      end else if (WIDTH == 8) begin
	 CLA8(
               a,  // input [31:0] a, 
               b,   //input [31:0] b, 
               1'b0,  // input Cin, 
               out,   //output [31:0] s, 
               carry_vec[WIDTH-1], //  output Cout,
                     //output overflow 
               ) ;	 
      end else if (WIDTH == 4) begin
	 CLA4(
               a,  // input [31:0] a, 
               b,   //input [31:0] b, 
               1'b0,  // input Cin, 
               out,   //output [31:0] s, 
               carry_vec[WIDTH-1], //  output Cout,
                     //output overflow 
               ) ;	*/ 
      end else begin     
         for(i = 0; i < WIDTH; i=i+1) begin
	    if ( i == 0 ) begin
	      full_addr fa (a[i], b[i], out[i], 1'b0, carry_vec[i]);	       
	    end else begin
	      full_addr fa (a[i], b[i], out[i], carry_vec[i-1], carry_vec[i]);
	    end
         end
      end
   endgenerate

   assign carry = carry_vec[WIDTH-1];

   
endmodule // slow_addr

module half_addr (
  a,
  b,
  out,		 
  carry		 
);
   input a, b;
   output out, carry;
   
   xor2$ add_x ( out, a, b);   
   and2$ carry_a ( carry, a, b);   
endmodule

module full_addr (
  a,
  b,
  out,	
  cin,	 
  cout		 
);
   input a, b, cin;
   output out, cout;
  
   wire   overflow, overflow2, out_m;
   
   half_addr ha0 (a, b, out_m, overflow);
   half_addr ha1 (out_m, cin, out, overflow2);

   or2$ carry_o (cout, overflow, overflow2);
endmodule
