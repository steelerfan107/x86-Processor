////////////////////////////////////////////
//
// And Or Mux (ao_mux)
//
// A mux which can select an entry based off a one hot signal. Better timing wise than a mux that uses an encoded value
// 

module ao_mux (
    in,
    out,
    sel	       
);

   parameter WIDTH   = 4;
   parameter NINPUTS = 4;    

   input [WIDTH*NINPUTS - 1:0] in;
   input [NINPUTS-1:0] 	       sel;
   output [WIDTH-1:0]          out;

   wire [WIDTH*NINPUTS - 1:0] masked_in;

   genvar 		      i,j;
   generate
      // Generate Masked array to OR together				
      for( i = 0; i < NINPUTS; i = i+1) begin
	 for(j = 0; j < WIDTH; j = j+1) begin
            and2$ mask_and (masked_in[(i*WIDTH)+j], in[(i*WIDTH)+j], sel[i]);
	 end
      end				
   endgenerate
   
   logic_tree_bus #(.WIDTH(WIDTH),.NINPUTS(NINPUTS),.OPERATION(1)) (masked_in, out);	
			   
endmodule  
