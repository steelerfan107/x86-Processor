module mux (
   in,
   out,
   select
);

   parameter WIDTH = 8;
   parameter INPUTS = 8;
   parameter WSEL = $clog2(INPUTS);
   
   input [WIDTH*INPUTS-1:0] in;
   output [WIDTH-1:0] 	   out;
   input [WSEL-1:0] 	   select;
   
   genvar 		  i;
   generate
      if(INPUTS == 2) begin
	 for(i = 0; i < WIDTH; i=i+1) begin
	    mux2$ mux(out[i],in[i],in[WIDTH+i],select);
	 end
      end else if (INPUTS == 3) begin
	 for(i = 0; i < WIDTH; i=i+1) begin	 
	    mux3$ mux(out[i],in[i],in[WIDTH+i],in[2*WIDTH+i],select[0], select[1]);	
         end	 
      end else if (INPUTS == 4) begin
	 for(i = 0; i < WIDTH; i=i+1) begin	 	 
	    mux4$ mux(out[i],in[i],in[WIDTH+i],in[2*WIDTH+i],in[3*WIDTH+i],select[0], select[1]);	
         end	 	 
      end else begin
	 
      end    
   endgenerate 
   
endmodule
