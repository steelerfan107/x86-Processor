//--------------------------------------------------------
// Library parts IV
// -----------------
// EE382N-14945, Spring 2000.
// (Some are modified from those provided by Cascade Design Automation Corp).
// All module parts' name are appended with a "$" character.
// This part of the library consists of the following parts:
//
// mux2$	-  1-bit 2-1 multiplexer
// mux3$	-  1-bit 3-1 multiplexer
// mux4$	-  1-bit 4-1 multiplexer
//
// mux2_8$	-  8-bits 2-1 multiplexer
// mux2_16$	-  16-bits 2-1 multiplexer
// mux3_8$	-  8-bits 3-1 multiplexer
// mux3_16$	-  16-bits 3-1 multiplexer
// mux4_8$	-  8-bits 4-1 multiplexer
// mux4_16$	-  16-bits 4-1 multiplexer
//
// Timing specs are taken from page 1-60.
//
//--------------------------------------------------------
primitive table_imux2(out, s0, in0, in1);
    input s0, in0, in1;
    output out;
    //  inverting 2:1 multiplexer

    table
    //  s0  in0 in1 : out
	 0   1   ?  :  0 ;
	 0   0   ?  :  1 ;
	 1   ?   1  :  0 ;
	 1   ?   0  :  1 ;

	 x   0   0  :  1 ;
	 x   1   1  :  0 ;
    endtable
endprimitive

primitive table_imux3(out, s1, s0, in0, in1, in2);
    input s1, s0, in0, in1, in2;
    output out;

    // 3:1 inverting multiplexer
    table
    //  s1 s0 in0 in1 in2 : out
	0  0  1   ?   ?   : 0 ;
	0  0  0   ?   ?   : 1 ;
	0  1  ?   1   ?   : 0 ;
	0  1  ?   0   ?   : 1 ;
	1  ?  ?   ?   1   : 0 ;
	1  ?  ?   ?   0   : 1 ;

	x  x  1   1   1   : 0 ;
	x  x  0   0   0   : 1 ;
	0  x  1   1   ?   : 0 ;
	0  x  0   0   ?   : 1 ;
	x  0  1   ?   1   : 0 ;
	x  0  0   ?   0   : 1 ;
	x  1  ?   1   1   : 0 ;
	x  1  ?   0   0   : 1 ;
	
    endtable
endprimitive

primitive table_imux4(out, s1, s0, in0, in1, in2, in3);
    input s1, s0, in0, in1, in2, in3;
    output out;

    // 4:1 inverting multiplexer
    table
    //  s1 s0 in0 in1 in2 in3 : out
	0  0  1   ?   ?   ?   : 0 ;
	0  0  0   ?   ?   ?   : 1 ;
	0  1  ?   1   ?   ?   : 0 ;
	0  1  ?   0   ?   ?   : 1 ;
	1  0  ?   ?   1   ?   : 0 ;
	1  0  ?   ?   0   ?   : 1 ;
	1  1  ?   ?   ?   1   : 0 ;
	1  1  ?   ?   ?   0   : 1 ;

	x  x  1   1   1   1   : 0 ;
	x  x  0   0   0   0   : 1 ;
	0  x  1   1   ?   ?   : 0 ;
	0  x  0   0   ?   ?   : 1 ;
	1  x  ?   ?   1   1   : 0 ;
	1  x  ?   ?   0   0   : 1 ;
	x  0  1   ?   1   ?   : 0 ;
	x  0  0   ?   0   ?   : 1 ;
	x  1  ?   1   ?   1   : 0 ;
	x  1  ?   0   ?   0   : 1 ;
	
    endtable
endprimitive

`celldefine
module  mux2$(outb, in0, in1, s0);
	input in0, in1, s0;
	output outb;

	table_imux2(temp, s0, in0, in1);
	not (outb, temp);

	specify
	    (s0  *> outb) = (0.27:0.3:0.33);
	    (in0 *> outb) = (0.18:0.2:0.22);
	    (in1 *> outb) = (0.18:0.2:0.22);
	endspecify
endmodule
`endcelldefine

`celldefine
module  mux3$(outb, in0, in1, in2, s0, s1);
	input in0, in1, in2, s0, s1;
	output outb;

	table_imux3(temp, s1, s0, in0, in1, in2);
	not(outb, temp);

	specify
	    (s0  *> outb) = (0.46:0.5:0.54);
	    (s1  *> outb) = (0.46:0.5:0.54);
	    (in0 *> outb) = (0.20:0.22:0.24);
	    (in1 *> outb) = (0.20:0.22:0.24);
	    (in2 *> outb) = (0.20:0.22:0.24);
	endspecify
endmodule
`endcelldefine

`celldefine
module  mux4$(outb, in0, in1, in2, in3, s0, s1);
	input in0, in1, in2, in3, s0, s1;
	output outb;

	table_imux4(temp, s1, s0, in0, in1, in2, in3);
	not(outb, temp);

	specify
	    (s0  *> outb) = (0.46:0.5:0.54);
	    (s1  *> outb) = (0.46:0.5:0.54);
	    (in0 *> outb) = (0.20:0.22:0.24);
	    (in1 *> outb) = (0.20:0.22:0.24);
	    (in2 *> outb) = (0.20:0.22:0.24);
	    (in3 *> outb) = (0.20:0.22:0.24);
	endspecify
endmodule
`endcelldefine

//--------------------  2 - i n p u t     M U X   --------------------
// 
module mux2_8$(Y,IN0,IN1,S0);
  input [7:0] IN0;
  input [7:0] IN1;
  input  S0;
  output [7:0] Y;
  reg    [7:0] Y;
  wire [7:0] IN0_temp;
  wire [7:0] IN1_temp;
  wire  S0_temp;
  assign #(0.18:0.2:0.22) IN0_temp = IN0;
  assign #(0.18:0.2:0.22) IN1_temp = IN1;
  assign #(0.27:0.3:0.33) S0_temp = S0;
  always
    @(IN0_temp or IN1_temp or S0_temp)
      begin
      if((S0_temp == 1'b0))
        Y = IN0_temp;
      else  if((S0_temp == 1'b1))
        Y = IN1_temp;
      else
        Y = 'bx;
      end
endmodule

module mux2_16$(Y,IN0,IN1,S0);
  input [15:0] IN0;
  input [15:0] IN1;
  input  S0;
  output [15:0] Y;
  reg    [15:0] Y;
  wire [15:0] IN0_temp;
  wire [15:0] IN1_temp;
  wire  S0_temp;
  assign #(0.18:0.2:0.22) IN0_temp = IN0;
  assign #(0.18:0.2:0.22) IN1_temp = IN1;
  assign #(0.27:0.3:0.33) S0_temp = S0;
  always
    @(IN0_temp or IN1_temp or S0_temp)
      begin
      if((S0_temp == 1'b0))
        Y = IN0_temp;
      else  if((S0_temp == 1'b1))
        Y = IN1_temp;
      else
        Y = 'bx;
      end
endmodule


//--------------------  3 - i n p u t     M U X   --------------------
module mux3_8$(Y,IN0,IN1,IN2,S0,S1);
  input [7:0] IN0;
  input [7:0] IN1;
  input [7:0] IN2;
  input  S0;
  input  S1;
  output [7:0] Y;
  reg    [7:0] Y;
  wire [7:0] IN0_temp;
  wire [7:0] IN1_temp;
  wire [7:0] IN2_temp;
  wire  S0_temp;
  wire  S1_temp;
  assign #(0.46:0.5:0.54) S0_temp = S0;
  assign #(0.46:0.5:0.54) S1_temp = S1;
  assign #(0.20:0.22:0.24) IN0_temp = IN0;
  assign #(0.20:0.22:0.24) IN1_temp = IN1;
  assign #(0.20:0.22:0.24) IN2_temp = IN2;
  always
    @(IN0_temp or IN1_temp or IN2_temp or S0_temp or S1_temp)
      begin
      if(((S1_temp == 1'b0) && (S0_temp == 1'b0)))
        Y = IN0_temp;
      else      if(((S1_temp == 1'b0) && (S0_temp == 1'b1)))
        Y = IN1_temp;
      else      if((S1_temp == 1'b1))
        Y = IN2_temp;
      else
        Y = 'bx;
      end
endmodule

module mux3_16$(Y,IN0,IN1,IN2,S0,S1);
  input [15:0] IN0;
  input [15:0] IN1;
  input [15:0] IN2;
  input  S0;
  input  S1;
  output [15:0] Y;
  reg    [15:0] Y;
  wire [15:0] IN0_temp;
  wire [15:0] IN1_temp;
  wire [15:0] IN2_temp;
  wire  S0_temp;
  wire  S1_temp;
  assign #(0.46:0.5:0.54) S0_temp = S0;
  assign #(0.46:0.5:0.54) S1_temp = S1;
  assign #(0.20:0.22:0.24) IN0_temp = IN0;
  assign #(0.20:0.22:0.24) IN1_temp = IN1;
  assign #(0.20:0.22:0.24) IN2_temp = IN2;
  always
    @(IN0_temp or IN1_temp or IN2_temp or S0_temp or S1_temp)
      begin
      if(((S1_temp == 1'b0) && (S0_temp == 1'b0)))
        Y = IN0_temp;
      else      if(((S1_temp == 1'b0) && (S0_temp == 1'b1)))
        Y = IN1_temp;
      else      if((S1_temp == 1'b1))
        Y = IN2_temp;
      else
        Y = 'bx;
      end
endmodule

//--------------------  4 - i n p u t     M U X   --------------------
module mux4_8$(Y,IN0,IN1,IN2,IN3,S0,S1);
  input [7:0] IN0;
  input [7:0] IN1;
  input [7:0] IN2;
  input [7:0] IN3;
  input  S0;
  input  S1;
  output [7:0] Y;
  reg    [7:0] Y;
  wire [7:0] IN0_temp;
  wire [7:0] IN1_temp;
  wire [7:0] IN2_temp;
  wire [7:0] IN3_temp;
  wire  S0_temp;
  wire  S1_temp;
  assign #(0.20:0.22:0.24) IN0_temp = IN0;
  assign #(0.20:0.22:0.24) IN1_temp = IN1;
  assign #(0.20:0.22:0.24) IN2_temp = IN2;
  assign #(0.20:0.22:0.24) IN3_temp = IN3;
  assign #(0.46:0.5:0.54) S0_temp = S0;
  assign #(0.46:0.5:0.54) S1_temp = S1;
  always
    @(IN0_temp or IN1_temp or IN2_temp or IN3_temp or S0_temp or S1_temp)
      begin
      if(((S1_temp == 1'b0) && (S0_temp == 1'b0)))
        Y = IN0_temp;
      else      if(((S1_temp == 1'b0) && (S0_temp == 1'b1)))
        Y = IN1_temp;
      else      if(((S1_temp == 1'b1) && (S0_temp == 1'b0)))
        Y = IN2_temp;
      else      if(((S1_temp == 1'b1) && (S0_temp == 1'b1)))
        Y = IN3_temp;
      else
        Y = 'bx;
      end
endmodule

module mux4_16$(Y,IN0,IN1,IN2,IN3,S0,S1);
  input [15:0] IN0;
  input [15:0] IN1;
  input [15:0] IN2;
  input [15:0] IN3;
  input  S0;
  input  S1;
  output [15:0] Y;
  reg    [15:0] Y;
  wire [15:0] IN0_temp;
  wire [15:0] IN1_temp;
  wire [15:0] IN2_temp;
  wire [15:0] IN3_temp;
  wire  S0_temp;
  wire  S1_temp;
  assign #(0.20:0.22:0.24) IN0_temp = IN0;
  assign #(0.20:0.22:0.24) IN1_temp = IN1;
  assign #(0.20:0.22:0.24) IN2_temp = IN2;
  assign #(0.20:0.22:0.24) IN3_temp = IN3;
  assign #(0.46:0.5:0.54) S0_temp = S0;
  assign #(0.46:0.5:0.54) S1_temp = S1;
  always
    @(IN0_temp or IN1_temp or IN2_temp or IN3_temp or S0_temp or S1_temp)
      begin
      if(((S1_temp == 1'b0) && (S0_temp == 1'b0)))
        Y = IN0_temp;
      else      if(((S1_temp == 1'b0) && (S0_temp == 1'b1)))
        Y = IN1_temp;
      else      if(((S1_temp == 1'b1) && (S0_temp == 1'b0)))
        Y = IN2_temp;
      else      if(((S1_temp == 1'b1) && (S0_temp == 1'b1)))
        Y = IN3_temp;
      else
        Y = 'bx;
      end
endmodule


