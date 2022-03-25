////////////////////////////////////////////
//
// Compare
//
// Can compare two vectors for equality
//

module compare (		
  a,
  b,
  out			       		
);

   parameter WIDTH = 64;

   wire [WIDTH-1:0] out_vec; 
   
   genvar i;
   generate
      for(i = 0; i < WIDTH; i=i+1) begin
	 wire xor_comp;
         xnor2$(out_vec[i], a[i], b[i]);	 	 
      end
   endgenerate

   logic_tree #(.WIDTH(WIDTH)) out_tree(out_vec, out);
   
endmodule   
   
