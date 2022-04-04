module register (
  clk,
  reset,
  din,
  q,
  q_bar,
  en	    
);

   parameter WIDTH = 8;
  
   input              clk;
   input              reset;
   input  [WIDTH-1:0] din;
   output [WIDTH-1:0] q;
   output [WIDTH-1:0] q_bar;   
   input              en;

   wire               clk_en;

   and2$ clk_gate(clk_en, clk, en);
   inv1$ inv_reset(reset_n, reset);
   
   genvar 	     i;
   generate
      for (i = 0; i < WIDTH; i=i+1) begin
	    dff$(clk_en,
		 din[i],
                 q[i],
                 q_bar[i], 
                 reset_n, 
                 1'b1);
      end
   endgenerate

endmodule
   
module register_16 (
  clk,
  reset,
  din,
  q,
  q_bar,
  en	    
);

   parameter WIDTH = 16;
  
   input              clk;
   input              reset;
   input  [WIDTH-1:0] din;
   output [WIDTH-1:0] q;
   output [WIDTH-1:0] q_bar;   
   input              en;

   wire               clk_en;

   and2$ clk_gate(clk_en, clk, en);
   inv1$ inv_reset(reset_n, reset);
   
   genvar 	     i;
   generate
      for (i = 0; i < WIDTH; i=i+1) begin
	    dff$(clk_en,
		 din[i],
                 q[i],
                 q_bar[i], 
                 reset_n, 
                 1'b1);
      end
   endgenerate

endmodule
