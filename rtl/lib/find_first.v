////////////////////////////////////////////
//
// Find First (Left to right or right to left)
//
// Outputs the input bit vector with all bits masked but the first (on left or right)
//

module find_first (
    in,
    out	       
);

   parameter WIDTH     = 4;
   parameter OPERATION = 0; // 0 - Left to right. 1 - Right to left    

   input [WIDTH-1:0]   in;
   output [WIDTH-1:0]  out;

   wire [WIDTH-1:0]    or_of_the_before;
   wire [WIDTH-1:0]    mask;

   genvar 		      i,j;
   generate
      // Right to left
      if (OPERATION) begin	
         // Go through each bit of the output and indicate if anything is 1 before it.
	 // If so tie that bit to 0. If not that bit is its own value. 			
         for( i = 0; i < WIDTH; i = i+1) begin
	    if(i == 0) begin
	       assign out[0] = 1'b0;	       
	    end else begin
              logic_tree #(.WIDTH(i),.OPERATION(1)) compare_vec (in[i-1:0], or_of_the_before[i]);
	    end
         end	
      end else begin // if (OPERATION)
         for( i = WIDTH-1; i >= 0; i = i-1) begin
	    if(i == WIDTH-1) begin
	       assign out[WIDTH-1] = 1'b0;	       
	    end else begin
              logic_tree #(.WIDTH((WIDTH-1)-i),.OPERATION(1)) compare_vec (in[(WIDTH-1):(i+1)], or_of_the_before[i]);
	    end
         end	 
      end

      for( i = 0; i < WIDTH; i = i+1) begin
	  inv1$ n_or_of_before (mask[i],  or_of_the_before[i]);	 
 	  and2$ mask_in (out[i], in[i], mask[i]);	  
      end			
   endgenerate
       			   
endmodule  
