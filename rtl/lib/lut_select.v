////////////////////////////////////////////
//
// Lookup Table Select
//
// Compares a Vector to a set of vectors.
// Provides match vector.
//

module lut_select (
    tble,
    vector, 
    out,

    match	       
);

   parameter WIDTH     = 4;
   parameter TABLESIZE = 4;    

   input [WIDTH*TABLESIZE - 1:0] tble;
   input [WIDTH - 1:0] vector;
   output [TABLESIZE-1:0]  out;
   output                  match;

   wire [WIDTH-1:0]  table_match_vector[TABLESIZE-1:0];
   
   genvar 		      i,j;
   generate				
      for( i = 0; i < TABLESIZE; i = i+1) begin
         for( j = 0; j < WIDTH; j = j+1) begin
	    xnor2$ match(table_match_vector[i][j],tble[(i*WIDTH)+j],vector[j]);	    
         end

         logic_tree #(.WIDTH(WIDTH),.OPERATION(1)) compare_vec (table_match_vector[i], out[i]); 
      end				
   endgenerate
  	
   logic_tree #(.WIDTH(TABLESIZE),.OPERATION(1)) match_tree (out, match);
			   
endmodule  
