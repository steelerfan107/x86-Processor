////////////////////////////////////////////
//
// Logic Tree
//
// Can do a boolean operation over a wire in a tree structure.
//

module logic_tree (
   in,
   out
);

   parameter WIDTH = 4;
   parameter OPERATION = 0; // 0 - Add, 1 - OR

   localparam isOdd  = ((WIDTH % 2) != 0);
   localparam levels = $clog2(WIDTH);

   input [WIDTH - 1:0] in;
   output out;

   wire [WIDTH-1:0]  level_result[levels-1:0];
   
   genvar 		       i, j;
   generate
      // Setup first level of the tree to handle whatever width input
      for ( i = 0; i < (2**(levels-1)); i=i+1) begin
	  if ( i < (WIDTH/2) ) begin
	     if( OPERATION ) begin
	            or2$  op_or   (level_result[levels-1][i], in[2*i], in[2*i+1]);
	     end else begin
	            and2$ op_and  (level_result[levels-1][i], in[2*i], in[2*i+1]);
	     end
	  end else if (isOdd && (i == (WIDTH/2))) begin
	     assign level_result[levels-1][i] = in[2*i]; 
	  end else begin
	     if( OPERATION ) begin
	          assign level_result[levels-1][i] = 1'b0;	     	            	    
	     end else begin
	          assign level_result[levels-1][i] = 1'b1;	     	            	    	            	      
	     end	     
	  end
      end

      // Do rest of the tree assuming its full WIDTH
      for ( i = levels-2; i >= 0; i=i-1) begin
         for ( j = 0; j < 2**i; j=j+1) begin
	      if( OPERATION ) begin
	            or2$  op_or  (level_result[i][j], level_result[i+1][2*j], level_result[i+1][2*j+1]);		    
	      end else begin
	            and2$ op_and (level_result[i][j], level_result[i+1][2*j], level_result[i+1][2*j+1]);	      
	      end
	 end
      end
   endgenerate

   assign out = level_result[0][0];
     
endmodule
   
