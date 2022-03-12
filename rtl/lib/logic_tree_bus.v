////////////////////////////////////////////
//
// Logic Tree Bus
//
// Can do a boolean operation over a Bus in a tree structure.
// So it takes in NINPUTS - WIDTH Vectors and outputs a WIDTH vector of the operation over each bit. 

module logic_tree_bus (
   in,
   out
);

   parameter WIDTH = 4;
   parameter NINPUTS = 4;   
   parameter OPERATION = 0; // 0 - Add, 1 - OR

   input [WIDTH*NINPUTS - 1:0] in;
   output [WIDTH-1:0] out;
   
   genvar 		       i, j;
   generate
      // Just Loop Over the Bus
      for ( i = 0; i < WIDTH; i=i+1) begin
	 wire [NINPUTS-1:0] temp;
         for ( j = 0; j < NINPUTS; j=j+1) begin
	    assign temp[j] = in[(j*WIDTH)+i];
         end
	 
	 logic_tree #(.WIDTH(NINPUTS),.OPERATION(OPERATION)) logic_tree_a (temp, out[i]);	 
      end	 
   endgenerate

endmodule
