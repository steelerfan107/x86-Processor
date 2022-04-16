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
      end else if (INPUTS == 8) begin
            wire [WIDTH-1:0] l,u;
	 
	    for(i = 0; i < WIDTH; i=i+1) begin	 	 	
	       mux4$ mux_l(l[i],in[        i] ,in[  WIDTH+i] ,in[2*WIDTH+i] ,in[3*WIDTH+i] ,select[0], select[1]);  	
	       mux4$ mux_u(u[i],in[4*WIDTH+i] ,in[5*WIDTH+i] ,in[6*WIDTH+i] ,in[7*WIDTH+i] ,select[0], select[1]);

	       mux2$ mux(out[i],l[i],u[i],select[2]);	       
	    end
      end else if (INPUTS == 32) begin
            wire [WIDTH-1:0] lll, llu,lul,luu,ull,ulu,uul,uuu,u,l;
	 
	    for(i = 0; i < WIDTH; i=i+1) begin	 	 	
	       mux4$ mux_lll(lll[i],in[        i] ,in[  WIDTH+i] ,in[2*WIDTH+i] ,in[3*WIDTH+i] ,select[0], select[1]);	
	       mux4$ mux_llu(llu[i],in[4*WIDTH+i] ,in[5*WIDTH+i] ,in[6*WIDTH+i] ,in[7*WIDTH+i] ,select[0], select[1]);	
	       mux4$ mux_lul(lul[i],in[8*WIDTH+i] ,in[9*WIDTH+i] ,in[10*WIDTH+i],in[11*WIDTH+i],select[0], select[1]);	
	       mux4$ mux_luu(luu[i],in[12*WIDTH+i],in[13*WIDTH+i],in[14*WIDTH+i],in[15*WIDTH+i],select[0], select[1]);
	
	       mux4$ mux_ull(ull[i],in[16*WIDTH+i],in[17*WIDTH+i],in[18*WIDTH+i],in[19*WIDTH+i],select[0], select[1]);	
	       mux4$ mux_ulu(ulu[i],in[20*WIDTH+i],in[21*WIDTH+i],in[22*WIDTH+i],in[23*WIDTH+i],select[0], select[1]);	
	       mux4$ mux_uul(uul[i],in[24*WIDTH+i],in[25*WIDTH+i],in[26*WIDTH+i],in[27*WIDTH+i],select[0], select[1]);	
	       mux4$ mux_uuu(uuu[i],in[28*WIDTH+i],in[29*WIDTH+i],in[30*WIDTH+i],in[31*WIDTH+i],select[0], select[1]);

	       mux4$ mux_u(u[i],ull[i],ulu[i],uul[i],uuu[i],select[2], select[3]);
	       mux4$ mux_l(l[i],lll[i],llu[i],lul[i],luu[i],select[2], select[3]);

	       mux2$ mux(out[i],l[i],u[i],select[4]);	       
	    end
      end    
   endgenerate 
   
endmodule
