//-----------------------------------------------------------
// Library parts II
// ----------------
// EE382N-14945, Spring 2000.
// (Some are modified from those provided by Cascade Design Automation Corp).
// All module parts' name are appended with a "$" character.
// This part of the library consists of the following gates and flip flop:
//
// dff8$			-  8-bits D-flip flop
// dff16$			-  16-bits D-flip flop
//
// jkff8$			-  8-bits JK-flip flop
// jkff16$			-  16-bits JK-flip flop
//
// buffer$			   -  1-bit  buffer to drive upto 4 gates
// bufferH16$		   -  High load 1-bit non-inv buffer to drive upto 16 gates
// bufferH64$		   -  High load 1-bit non-inv buffer to drive upto 64 gates
// bufferH256$		   -  High load 1-bit non-inv buffer to drive upto 256 gates
// bufferH1024$	   -  High load 1-bit non-inv buffer to drive upto 1024 gates
// bufferHInv16$		-  High load 1-bit inv buffer to drive upto 16 gates
// bufferHInv64$		-  High load 1-bit inv buffer to drive upto 64 gates
// bufferHInv256$		-  High load 1-bit inv buffer to drive upto 256 gates
// bufferHInv1024$	-  High load 1-bit inv buffer to drive upto 1024 gates
//
// buffer8$			-  8-bits buffer
// buffer16$			-  16-bits buffer
//
// latch$			-  1-bit  "transparent" latch
// latch8$			-  8-bits "transparent" latch
// latch16$			-  16-bits "transparent" latch
//
// tristateL$			-  1-bit   lightly loaded tristate buffer
// tristate8L$			-  8-bits  lightly loaded tristate buffer
// tristate16L$			-  16-bits lightly loaded tristate buffer
//
// tristateH$			-  1-bit   heavily loaded tristate buffer
// tristate8H$			-  8-bits  heavily loaded tristate buffer
// tristate16H$			-  16-bits heavily loaded tristate buffer
//
// tristate_bus_driver1$	- 1-bit tristate external bus driver
// tristate_bus_driver8$	- 8-bit tristate external bus driver
// tristate_bus_driver16$	- 16-bits tristate external bus driver
//
// tristatexL$ and tristatexH$ are used to modelthe same tristate logic.
// tristatexL$ are used to model tristate buffers under light loading 
// conditions (less than five receivers).  If the output of the buffer 
// has more than five receivers, then tristatexH$ should be used.
//
// dff16b$			-  16-bits D-flip flop with bit addressable
// dff32b$			-  32-bits D-flip flop with bit addressable
//
// reg64e$			-  64-bits registers with write enable
// reg32e$			-  32-bits register with write enable
// ioreg8$			- 8-bit IO register (D-flip flop)
// ioreg16$			- 16-bits IO register (D-flip flop)
//
//-------------------------------------------------------------
//      Edge triggered   D  flip flip:   8-bits
//
// 	 Timing specs are taken from page 1-10.
//-------------------------------------------------------------
module dff8$(CLK, D, Q, QBAR, CLR, PRE);
  input  CLK;
  input  CLR;
  input [7:0] D;
  input  PRE;
  output [7:0] Q;
  output [7:0] QBAR;
  reg    [7:0] Q;
  reg    [7:0] D_temp;
  wire  CLK_temp;
  wire  CLR_temp;
  wire  PRE_temp;

  assign #(0.28:0.32:0.36) CLK_temp = CLK; //t_plh = t_phl 
	//assuming: t_plh(Q) = t_plh(QBAR) = t_phl(Q) = t_phl(QBAR)
  assign #(0.50:0.54:0.58) PRE_temp = PRE; //t_p(PRE)
  assign #(0.42:0.46:0.50) CLR_temp = CLR; //t_p(CLR)
  assign QBAR = ~Q;
  always@(posedge CLK) D_temp = D;

  always
    @(PRE_temp or CLR_temp)
      begin
      if(((CLR_temp == 1'b0) && (PRE_temp == 1'b1)))
        begin
        Q = 'b0;
        end
      else      if(((PRE_temp == 1'b0) && (CLR_temp == 1'b1)))
        begin
        Q = ( ~ 'b0);
        end
      else      if(((CLR_temp != 1'b1) || (PRE_temp != 1'b1)))
        begin
        Q = 'bx;
        end
      end

  always 
    @(posedge CLK_temp) if (((PRE_temp == 1'b1) && (CLR_temp == 1'b1))) Q = D_temp;

  specify
    specparam
      //t_hold_D = 0,
      t_setup_D   = (0.12:0.14:0.16),
      //t_width_CLK = (0.21:0.24:0.27),
      t_width_PRE = (0.21:0.24:0.27),
      t_width_CLR = (0.21:0.24:0.27);
    //$hold(posedge CLK , D , t_hold_D);
    $setup(D , posedge CLK , t_setup_D);
    //$width(negedge CLK , t_width_CLK);
    $width(negedge PRE , t_width_PRE);
    $width(negedge CLR , t_width_CLR);
  endspecify
endmodule

//-------------------------------------------------------------
//      Edge triggered   D  flip flip:   16-bits
//
// 	 Timing specs are taken from page 1-10.
//-------------------------------------------------------------

module dff16$(CLK, D, Q, QBAR, CLR, PRE);
  input  CLK;
  input  CLR;
  input [15:0] D;
  input  PRE;
  output [15:0] Q;
  output [15:0] QBAR;
  reg    [15:0] Q;
  reg    [15:0] D_temp;
  wire  CLK_temp;
  wire  CLR_temp;
  wire  PRE_temp;

  assign #(0.28:0.32:0.36) CLK_temp = CLK; //t_plh = t_phl 
	//assuming: t_plh(Q) = t_plh(QBAR) = t_phl(Q) = t_phl(QBAR)
  assign #(0.50:0.54:0.58) PRE_temp = PRE; //t_p(PRE)
  assign #(0.42:0.46:0.50) CLR_temp = CLR; //t_p(CLR)
  assign QBAR = ~Q;
  always@(posedge CLK) D_temp = D;

  always
    @(PRE_temp or CLR_temp)
      begin
      if(((CLR_temp == 1'b0) && (PRE_temp == 1'b1)))
        begin
        Q = 'b0;
        end
      else      if(((PRE_temp == 1'b0) && (CLR_temp == 1'b1)))
        begin
        Q = ( ~ 'b0);
        end
      else      if(((CLR_temp != 1'b1) || (PRE_temp != 1'b1)))
        begin
        Q = 'bx;
        end
      end

  always
    @(posedge CLK_temp) if (((PRE_temp == 1'b1) && (CLR_temp == 1'b1))) Q = D_temp;

  specify
    specparam
      //t_hold_D = 0,
      t_setup_D   = (0.12:0.14:0.16),
      //t_width_CLK = (0.21:0.24:0.27),
      t_width_PRE = (0.21:0.24:0.27),
      t_width_CLR = (0.21:0.24:0.27);
    //$hold(posedge CLK , D , t_hold_D);
    $setup(D , posedge CLK , t_setup_D);
    //$width(negedge CLK , t_width_CLK);
    $width(negedge PRE , t_width_PRE);
    $width(negedge CLR , t_width_CLR);
  endspecify
endmodule

//-------------------------------------------------------------
//	J   K      F l i p   F l o p:   8-bits
//
// 	  Timing specs taken from page 1-52.
//-------------------------------------------------------------
module jkff8$(CLK,CLR,J,K,PRE,Q,QBAR);
  input  CLK;
  input  CLR;
  input [7:0] J;
  input [7:0] K;
  input  PRE;
  output [7:0] Q;
  output [7:0] QBAR;
  reg    [7:0] Q;
  reg    [7:0] temp;
  wire  CLK_temp;
  wire  CLR_temp;
  wire  PRE_temp;

  assign #(0.28:0.32:0.36, 0.46:0.50:0.54) 	CLK_temp = CLK;
  assign #(0.23:0.26:0.29) 		PRE_temp = PRE;
  assign #(0.48:0.52:0.56) 		CLR_temp = CLR;
  assign QBAR = ~Q;


  always
    @(PRE_temp or CLR_temp)
      begin
      if(((CLR_temp == 1'b0) && (PRE_temp == 1'b1)))
        Q    = 'b0;
      else      if(((PRE_temp == 1'b0) && (CLR_temp == 1'b1)))
        Q    = ( ~ 'b0);
      else      if(((CLR_temp != 1'b1) || (PRE_temp != 1'b1)))
        Q = 'bx;
      end

  always 
    @(posedge CLK_temp)
      if(((PRE_temp == 1'b1) && (CLR_temp == 1'b1)))
	begin	temp = ((( ~ K) & (J | Q)) | (J & ( ~ Q)));
		Q = temp;
	end

  specify
    specparam
      //t_hold_J = 0,
      t_setup_J = (0.46:0.50:0.54),
      //t_hold_K = 0,
      t_setup_K = (0.44:0.48:0.52),
      //t_width_CLK = (0.16:0.18:0.20),
      t_width_PRE = (0.16:0.18:0.20),
      t_width_CLR = (0.16:0.18:0.20);
    //$hold(posedge CLK , J , t_hold_J);
    $setup(J , posedge CLK , t_setup_J);
    //$hold(posedge CLK , K , t_hold_K);
    $setup(K , posedge CLK , t_setup_K);
    //$width(negedge CLK , t_width_CLK);
    $width(negedge PRE , t_width_PRE);
    $width(negedge CLR , t_width_CLR);
  endspecify
endmodule


//-------------------------------------------------------------
//	J   K      F l i p   F l o p:   16-bits
//
// 	  Timing specs taken from page 1-52.
//-------------------------------------------------------------
module jkff16$(CLK,CLR,J,K,PRE,Q,QBAR);
  input  CLK;
  input  CLR;
  input [15:0] J;
  input [15:0] K;
  input  PRE;
  output [15:0] Q;
  output [15:0] QBAR;
  reg    [15:0] Q;
  reg    [15:0] temp;
  wire  CLK_temp;
  wire  CLR_temp;
  wire  PRE_temp;

  assign #(0.28:0.32:0.36, 0.46:0.50:0.54) 	CLK_temp = CLK;
  assign #(0.23:0.26:0.29) 		PRE_temp = PRE;
  assign #(0.48:0.52:0.56) 		CLR_temp = CLR;
  assign QBAR = ~Q;


  always
    @(PRE_temp or CLR_temp)
      begin
      if(((CLR_temp == 1'b0) && (PRE_temp == 1'b1)))
        Q    = 'b0;
      else      if(((PRE_temp == 1'b0) && (CLR_temp == 1'b1)))
        Q    = ( ~ 'b0);
      else      if(((CLR_temp != 1'b1) || (PRE_temp != 1'b1)))
        Q = 'bx;
      end

  always 
    @(posedge CLK_temp)
      if(((PRE_temp == 1'b1) && (CLR_temp == 1'b1)))
	begin	temp = ((( ~ K) & (J | Q)) | (J & ( ~ Q)));
		Q = temp;
	end

  specify
    specparam
      //t_hold_J = 0,
      t_setup_J = (0.46:0.50:0.54),
      //t_hold_K = 0,
      t_setup_K = (0.44:0.48:0.52),
      //t_width_CLK = (0.16:0.18:0.20),
      t_width_PRE = (0.16:0.18:0.20),
      t_width_CLR = (0.16:0.18:0.20);
    //$hold(posedge CLK , J , t_hold_J);
    $setup(J , posedge CLK , t_setup_J);
    //$hold(posedge CLK , K , t_hold_K);
    $setup(K , posedge CLK , t_setup_K);
    //$width(negedge CLK , t_width_CLK);
    $width(negedge PRE , t_width_PRE);
    $width(negedge CLR , t_width_CLR);
  endspecify
endmodule


//--------------------------------------------------------------------
//	N o n i n v e r t i n g    B u f f e r:   1, 8 and 16 bits
//
//		Timing specs are taken from page 1-6.
//--------------------------------------------------------------------
`celldefine
module  buffer$(out, in);
  input  in;
  output out;
  buf (strong0, strong1) (out, in);
  specify
	(in *> out) = (0.21:0.24:0.27, 0.21:0.24:0.27);
  endspecify
endmodule
`endcelldefine

module  buffer8$(out, in);
 	input  [7:0] in;
	output [7:0] out;
	assign (strong0, strong1) #(0.21:0.24:0.27, 0.21:0.24:0.27) out = in;
endmodule

module  buffer16$(out, in);
 	input  [15:0] in;
	output [15:0] out;
	assign (strong0, strong1) #(0.21:0.24:0.27, 0.21:0.24:0.27) out = in;
endmodule

//--------------------------------------------------------------------
//	H i g h l o a d    N o n i n v e r t i n g    B u f f e r s
//            See top of file for their descriptions
//		
//--------------------------------------------------------------------

`celldefine
module  bufferH16$(out, in);
  input  in;
  output out;
  buf (strong0, strong1) (out, in);
  specify
	(in *> out) = (0.21:0.24:0.27, 0.21:0.24:0.27);
  endspecify
endmodule
`endcelldefine

`celldefine
module  bufferH64$(out, in);
  input  in;
  output out;
  buf (strong0, strong1) (out, in);
  specify
	(in *> out) = (0.26:0.30:0.34, 0.26:0.30:0.34);
  endspecify
endmodule
`endcelldefine

`celldefine
module  bufferH256$(out, in);
  input  in;
  output out;
  buf (strong0, strong1) (out, in);
  specify
	(in *> out) = (0.47:0.54:0.61, 0.47:0.54:0.61);
  endspecify
endmodule
`endcelldefine

`celldefine
module  bufferH1024$(out, in);
  input  in;
  output out;
  buf (strong0, strong1) (out, in);
  specify
	(in *> out) = (0.52:0.60:0.68, 0.52:0.60:0.68);
  endspecify
endmodule
`endcelldefine

//--------------------------------------------------------------------
//	H i g h l o a d    I n v e r t i n g    B u f f e r s
//            See top of file for their descriptions
//		
//--------------------------------------------------------------------

`celldefine
module  bufferHInv16$(out, in);
  input  in;
  output out;
  not (strong0, strong1) (out, in);
  specify
	(in *> out) = (0.13:0.15:0.17, 0.13:0.15:0.17);
  endspecify
endmodule
`endcelldefine

`celldefine
module  bufferHInv64$(out, in);
  input  in;
  output out;
  not (strong0, strong1) (out, in);
  specify
	(in *> out) = (0.34:0.39:0.44, 0.34:0.39:0.44);
  endspecify
endmodule
`endcelldefine

`celldefine
module  bufferHInv256$(out, in);
  input  in;
  output out;
  not (strong0, strong1) (out, in);
  specify
	(in *> out) = (0.39:0.45:0.51, 0.39:0.45:0.51);
  endspecify
endmodule
`endcelldefine

`celldefine
module  bufferHInv1024$(out, in);
  input  in;
  output out;
  not (strong0, strong1) (out, in);
  specify
	(in *> out) = (0.60:0.69:0.78, 0.60:0.69:0.78);
  endspecify
endmodule
`endcelldefine



//----------------------------------------------------------------------
//		L  a  t  c  h :      1, 8 and 16 bits.
//
// 		Timing specs taken from page 1-56.
//----------------------------------------------------------------------

primitive latch_sr(q,d,en,s,r);
  input   d,en,s,r;
  output  q;
  reg     q;
  table
//  d  en s  r   state  q
    ?  ?  0  0  :  ?  : x ;
    ?  ?  1  0  :  ?  : 0 ;
    ?  ?  0  1  :  ?  : 1 ;
    ?  ?  1  *  :  0  : 0 ;
    ?  ?  *  1  :  1  : 1 ;

    ?  0  1  1  :  ?  : - ;
    1  1  1  1  :  ?  : 1 ;
    0  1  1  1  :  ?  : 0 ;
    0  x  1  1  :  0  : - ;
    1  x  1  1  :  1  : - ;
  endtable
endprimitive

`celldefine
module  latch$(d, en, q, qbar, r, s);
  input   d, en, s, r;
  output  q, qbar;

  latch_sr(q, d, en, s, r);
  not(qbar, q);

    specify
	(d   *> q)    = (0.44:0.48:0.52,0.46:0.50:0.54);
	(d   *> qbar) = (0.44:0.48:0.52,0.46:0.50:0.54);
	(en  *> q)    = (0.42:0.46:0.50,0.50:0.54:0.58);
	(en  *> qbar) = (0.42:0.46:0.50,0.50:0.54:0.58);
	(s   *> q)    = (0.32:0.36:0.40);
	(s   *> qbar) = (0.32:0.36:0.40);
	(r   *> q)    = (0.32:0.36:0.40);
	(r   *> qbar) = (0.32:0.36:0.40);
        $setup(d, edge[10,1x] en, 0.16:0.18:0.20);
        $width(edge[01,x1] s,     0.16:0.18:0.20);
        $width(edge[01,x1] r,     0.16:0.18:0.20);
        $width(edge[01,x1] en,    0.16:0.18:0.20);
    endspecify
endmodule
`endcelldefine

module latch8$(CLR,D,EN,PRE,Q);
  input  CLR;
  input [7:0] D;
  input  EN;
  input  PRE;
  output [7:0] Q;
  reg    [7:0] Q;
  wire  CLR_temp;
  wire [7:0] D_temp;
  wire  EN_temp;
  wire  PRE_temp;
  assign #(0.44:0.48:0.52, 0.46:0.50:0.54) D_temp = D;
  assign #(0.42:0.46:0.50, 0.50:0.54:0.58) EN_temp = EN;
  assign #(0.32:0.36:0.40) PRE_temp = PRE;
  assign #(0.32:0.36:0.40) CLR_temp = CLR;
  always
    @(CLR_temp or PRE_temp or EN_temp or D_temp)
      begin
      if(((CLR_temp == 1'b0) && (PRE_temp == 1'b1)))
        Q = 'b0;
      else      if(((PRE_temp == 1'b0) && (CLR_temp == 1'b1)))
        Q = ( ~ 'b0);
      else      if(((CLR_temp != 1'b1) || (PRE_temp != 1'b1)))
        Q = 'bx;
      else      if((EN_temp == 1'b1))
        Q = D_temp;
//      else      if((EN_temp != 1'b0))
//      Q = 'bx;
      end
  specify
    specparam
      t_hold_D = 0,
      t_setup_D   = (0.16:0.18:0.20),
      t_width_PRE = (0.16:0.18:0.20),
      t_width_CLR = (0.16:0.18:0.20),
      t_width_EN  = (0.16:0.18:0.20);
    //$hold(negedge EN , D , t_hold_D);
    $setup(D , negedge EN , t_setup_D);
    $width(posedge EN  , t_width_EN);
    $width(negedge CLR , t_width_CLR);
    $width(negedge PRE , t_width_PRE);
  endspecify
endmodule

module latch16$(CLR,D,EN,PRE,Q);
  input  CLR;
  input [15:0] D;
  input  EN;
  input  PRE;
  output [15:0] Q;
  reg    [15:0] Q;
  wire  CLR_temp;
  wire [15:0] D_temp;
  wire  EN_temp;
  wire  PRE_temp;
  assign #(0.44:0.48:0.52, 0.46:0.50:0.54) D_temp = D;
  assign #(0.42:0.46:0.50, 0.50:0.54:0.58) EN_temp = EN;
  assign #(0.32:0.36:0.40) PRE_temp = PRE;
  assign #(0.32:0.36:0.40) CLR_temp = CLR;
  always
    @(CLR_temp or PRE_temp or EN_temp or D_temp)
      begin
      if(((CLR_temp == 1'b0) && (PRE_temp == 1'b1)))
        Q = 'b0;
      else      if(((PRE_temp == 1'b0) && (CLR_temp == 1'b1)))
        Q = ( ~ 'b0);
      else      if(((CLR_temp != 1'b1) || (PRE_temp != 1'b1)))
        Q = 'bx;
      else      if((EN_temp == 1'b1))
        Q = D_temp;
//      else      if((EN_temp != 1'b0))
//        Q = 'bx;
      end
  specify
    specparam
      t_hold_D = 0,
      t_setup_D   = (0.16:0.18:0.20),
      t_width_PRE = (0.16:0.18:0.20),
      t_width_CLR = (0.16:0.18:0.20),
      t_width_EN  = (0.16:0.18:0.20);
    //$hold(negedge EN , D , t_hold_D);
    $setup(D , negedge EN , t_setup_D);
    $width(posedge EN  , t_width_EN);
    $width(negedge CLR , t_width_CLR);
    $width(negedge PRE , t_width_PRE);
  endspecify
endmodule


//---------------------------------------------------------------------
//    T r i s t a t e    N o n i n v e r t i n g   B u f f e r 
//		 (light load): 1, 8 and 16-bits
//
// 		Timing specs taken from page 1-62.
//----------------------------------------------------------------------
`celldefine
module  tristateL$(enbar, in, out);
	input  in, enbar;
	output out;
	supply1 vdd;

	bufif0(outi, in, enbar);
	nmos (out, outi, vdd);

	specify
	    (in    *> out) = (0.23:0.26:0.29, 0.23:0.26:0.29);
	    (enbar *> out) = (0.23:0.26:0.29, 0.23:0.26:0.29);
	endspecify
endmodule
`endcelldefine

module  tristate8L$(enbar, in, out);
	input enbar;
	wire  enbar_temp;
 	input  [7:0] in;
 	wire   [7:0] in_temp;
	output [7:0] out;

	assign(strong0,strong1)#(0.23:0.26:0.29, 0.23:0.26:0.29) in_temp = in;
	assign #(0.23:0.26:0.29, 0.23:0.26:0.29) enbar_temp = enbar;
	assign out = (enbar_temp)? 64'bz:in_temp;
endmodule

module  tristate16L$(enbar, in, out);
	input enbar;
	wire  enbar_temp;
 	input  [15:0] in;
 	wire   [15:0] in_temp;
	output [15:0] out;

	assign(strong0,strong1)#(0.23:0.26:0.29, 0.23:0.26:0.29) in_temp = in;
	assign #(0.23:0.26:0.29, 0.23:0.26:0.29) enbar_temp = enbar;
	assign out = (enbar_temp)? 64'bz:in_temp;
endmodule


//---------------------------------------------------------------------
//    T r i s t a t e    N o n i n v e r t i n g   B u f f e r 
//		   (heavy load): 1, 8, and 16-bits
//
//---------------------------------------------------------------------
`celldefine
module  tristateH$(enbar, in, out);
	input  in, enbar;
	output out;
	supply1 vdd;

	bufif0(out, in, enbar);

	specify
	    (in    *> out) = (0.42:0.46:0.50, 0.42:0.46:0.50);
	    (enbar *> out) = (0.42:0.46:0.50, 0.42:0.46:0.50);
	endspecify
endmodule
`endcelldefine

module  tristate8H$(enbar, in, out);
	input enbar;
	wire  enbar_temp;
 	input  [7:0] in;
 	wire   [7:0] in_temp;
	output [7:0] out;

	assign(strong0,strong1)#(0.42:0.46:0.50, 0.42:0.46:0.50) in_temp = in;
	assign #(0.42:0.46:0.50, 0.42:0.46:0.50) enbar_temp = enbar;
	assign out = (enbar_temp)? 8'bz:in_temp;
endmodule

module  tristate16H$(enbar, in, out);
	input enbar;
	wire  enbar_temp;
 	input  [15:0] in;
 	wire   [15:0] in_temp;
	output [15:0] out;

	assign(strong0,strong1)#(0.42:0.46:0.50, 0.42:0.46:0.50) in_temp = in;
	assign #(0.42:0.46:0.50, 0.42:0.46:0.50) enbar_temp = enbar;
	assign out = (enbar_temp)? 16'bz:in_temp;
endmodule

module  tristate_bus_driver1$(enbar, in, out);
	input enbar;
	wire  enbar_temp;
 	input  in;
 	wire   in_temp;
	output out;

	assign(strong0,strong1)#5 in_temp = in;
	assign #5 enbar_temp = enbar;
	assign out = (enbar_temp)? 1'bz:in_temp;
endmodule

module  tristate_bus_driver8$(enbar, in, out);
	input enbar;
	wire  enbar_temp;
 	input  [7:0] in;
 	wire   [7:0] in_temp;
	output [7:0] out;

	assign(strong0,strong1)#5 in_temp = in;
	assign #5 enbar_temp = enbar;
	assign out = (enbar_temp)? 8'bz:in_temp;
endmodule

module  tristate_bus_driver16$(enbar, in, out);
	input enbar;
	wire  enbar_temp;
 	input  [15:0] in;
 	wire   [15:0] in_temp;
	output [15:0] out;

	assign(strong0,strong1)#5 in_temp = in;
	assign #5 enbar_temp = enbar;
	assign out = (enbar_temp)? 16'bz:in_temp;
endmodule


//-------------------------------------------------------------
// Edge triggered   D  flip flip:   16-bits with individual bit addressable
//
// 	 Timing specs are taken from page 1-10.
//-------------------------------------------------------------

module dff16b$(CLK, D, Q, QBAR, CLR, PRE, A);
  input  CLK;
  input  CLR;
  input [15:0] D;
  input  PRE;
  output [15:0] Q;
  output [15:0] QBAR;
  input [3:0] A;
  reg    [15:0] Q;
  reg    [15:0] D_temp;
  wire  CLK_temp;
  wire  CLR_temp;
  wire  PRE_temp;

  assign #(0.28:0.32:0.36) CLK_temp = CLK; //t_plh = t_phl 
	//assuming: t_plh(Q) = t_plh(QBAR) = t_phl(Q) = t_phl(QBAR)
  assign #(0.50:0.54:0.58) PRE_temp = PRE; //t_p(PRE)
  assign #(0.42:0.46:0.50) CLR_temp = CLR; //t_p(CLR)
  assign QBAR = ~Q;
  always@(posedge CLK) D_temp = D;

  always
    @(PRE_temp or CLR_temp)
      begin
      if(((CLR_temp == 1'b0) && (PRE_temp == 1'b1)))
        begin
        Q = 'b0;
        end
      else      if(((PRE_temp == 1'b0) && (CLR_temp == 1'b1)))
        begin
        Q = ( ~ 'b0);
        end
      else      if(((CLR_temp != 1'b1) || (PRE_temp != 1'b1)))
        begin
        Q = 'bx;
        end
      end

  always
    @(posedge CLK_temp) if (((PRE_temp == 1'b1) && (CLR_temp == 1'b1))) Q[A] = D_temp[A];

  specify
    specparam
      //t_hold_D = 0,
      t_setup_D   = (0.12:0.14:0.16),
      //t_width_CLK = (0.21:0.24:0.27),
      t_width_PRE = (0.21:0.24:0.27),
      t_width_CLR = (0.21:0.24:0.27);
    //$hold(posedge CLK , D , t_hold_D);
    $setup(D , posedge CLK , t_setup_D);
    //$width(negedge CLK , t_width_CLK);
    $width(negedge PRE , t_width_PRE);
    $width(negedge CLR , t_width_CLR);
  endspecify
endmodule

//-------------------------------------------------------------
// Edge triggered   D  flip flip:   32-bits with individual bit addressable
//
// 	 Timing specs are taken from page 1-10.
//-------------------------------------------------------------

module dff32b$(CLK, D, Q, QBAR, CLR, PRE, A);
  input  CLK;
  input  CLR;
  input [31:0] D;
  input  PRE;
  output [31:0] Q;
  output [31:0] QBAR;
  input [4:0] A;
  reg    [31:0] Q;
  reg    [31:0] D_temp;
  wire  CLK_temp;
  wire  CLR_temp;
  wire  PRE_temp;

  assign #(0.28:0.32:0.36) CLK_temp = CLK; //t_plh = t_phl 
	//assuming: t_plh(Q) = t_plh(QBAR) = t_phl(Q) = t_phl(QBAR)
  assign #(0.50:0.54:0.58) PRE_temp = PRE; //t_p(PRE)
  assign #(0.42:0.46:0.50) CLR_temp = CLR; //t_p(CLR)
  assign QBAR = ~Q;
  always@(posedge CLK) D_temp = D;

  always
    @(PRE_temp or CLR_temp)
      begin
      if(((CLR_temp == 1'b0) && (PRE_temp == 1'b1)))
        begin
        Q = 'b0;
        end
      else      if(((PRE_temp == 1'b0) && (CLR_temp == 1'b1)))
        begin
        Q = ( ~ 'b0);
        end
      else      if(((CLR_temp != 1'b1) || (PRE_temp != 1'b1)))
        begin
        Q = 'bx;
        end
      end

  always
    @(posedge CLK_temp) if (((PRE_temp == 1'b1) && (CLR_temp == 1'b1))) Q[A] = D_temp[A];
 
 specify
    specparam
      //t_hold_D = 0,
      t_setup_D   = (0.12:0.14:0.16),
      //t_width_CLK = (0.21:0.24:0.27),
      t_width_PRE = (0.21:0.24:0.27),
      t_width_CLR = (0.21:0.24:0.27);
    //$hold(posedge CLK , D , t_hold_D);
    $setup(D , posedge CLK , t_setup_D);
    //$width(negedge CLK , t_width_CLK);
    $width(negedge PRE , t_width_PRE);
    $width(negedge CLR , t_width_CLR);
  endspecify
endmodule

//-------------------------------------------------------------
// R e g i s t e r s :   64-bits register with enable
//
// 	 Timing specs are taken from page 1-10.
//-------------------------------------------------------------
module reg64e$(CLK, Din, Q, QBAR, CLR, PRE,en);
  input  CLK;
  input  CLR;
  input [63:0] Din;
  wire  [63:0] D;
  input  PRE;
  input  en;
  output [63:0] Q;
  output [63:0] QBAR;
  reg    [63:0] Q;
  reg    [63:0] D_temp;
  wire  CLK_temp;
  wire  CLR_temp;
  wire  PRE_temp;
  assign #0.34 D = (en==1'b1)? Din:Q;

  assign #(0.28:0.32:0.36) CLK_temp = CLK; //t_plh = t_phl 
	//assuming: t_plh(Q) = t_plh(QBAR) = t_phl(Q) = t_phl(QBAR)
  assign #(0.50:0.54:0.58) PRE_temp = PRE; //t_p(PRE)
  assign #(0.42:0.46:0.50) CLR_temp = CLR; //t_p(CLR)
  assign QBAR = ~Q;
  always@(posedge CLK) D_temp = D;

  always
    @(PRE_temp or CLR_temp)
      begin
      if(((CLR_temp == 1'b0) && (PRE_temp == 1'b1)))
        begin
        Q = 'b0;
        end
      else      if(((PRE_temp == 1'b0) && (CLR_temp == 1'b1)))
        begin
        Q = ( ~ 'b0);
        end
      else      if(((CLR_temp != 1'b1) || (PRE_temp != 1'b1)))
        begin
        Q = 'bx;
        end
      end

  always
    @(posedge CLK_temp) if (((PRE_temp == 1'b1) && (CLR_temp == 1'b1))) Q = D_temp;

  specify
    specparam
      //t_hold_D = 0,
      t_setup_D   = (0.12:0.14:0.16),
      //t_width_CLK = (0.21:0.24:0.27),
      t_width_PRE = (0.21:0.24:0.27),
      t_width_CLR = (0.21:0.24:0.27);
    //$hold(posedge CLK , D , t_hold_D);
    $setup(D , posedge CLK , t_setup_D);
    //$width(negedge CLK , t_width_CLK);
    $width(negedge PRE , t_width_PRE);
    $width(negedge CLR , t_width_CLR);
  endspecify
endmodule

//-------------------------------------------------------------
// R e g i s t e r s :   32-bits register with enable
//
// 	 Timing specs are taken from page 1-10.
//-------------------------------------------------------------
module reg32e$(CLK, Din, Q, QBAR, CLR, PRE,en);
  input  CLK;
  input  CLR;
  input [31:0] Din;
  wire  [31:0] D;
  input  PRE;
  input  en;
  output [31:0] Q;
  output [31:0] QBAR;
  reg    [31:0] Q;
  reg    [31:0] D_temp;
  wire  CLK_temp;
  wire  CLR_temp;
  wire  PRE_temp;
  assign #0.34 D = (en==1'b1)? Din:Q;

  assign #(0.28:0.32:0.36) CLK_temp = CLK; //t_plh = t_phl 
	//assuming: t_plh(Q) = t_plh(QBAR) = t_phl(Q) = t_phl(QBAR)
  assign #(0.50:0.54:0.58) PRE_temp = PRE; //t_p(PRE)
  assign #(0.42:0.46:0.50) CLR_temp = CLR; //t_p(CLR)
  assign QBAR = ~Q;
  always@(posedge CLK) D_temp = D;

  always
    @(PRE_temp or CLR_temp)
      begin
      if(((CLR_temp == 1'b0) && (PRE_temp == 1'b1)))
        begin
        Q = 'b0;
        end
      else      if(((PRE_temp == 1'b0) && (CLR_temp == 1'b1)))
        begin
        Q = ( ~ 'b0);
        end
      else      if(((CLR_temp != 1'b1) || (PRE_temp != 1'b1)))
        begin
        Q = 'bx;
        end
      end

  always
    @(posedge CLK_temp) if (((PRE_temp == 1'b1) && (CLR_temp == 1'b1))) Q = D_temp;

  specify
    specparam
      //t_hold_D = 0,
      t_setup_D   = (0.12:0.14:0.16),
      //t_width_CLK = (0.21:0.24:0.27),
      t_width_PRE = (0.21:0.24:0.27),
      t_width_CLR = (0.21:0.24:0.27);
    //$hold(posedge CLK , D , t_hold_D);
    $setup(D , posedge CLK , t_setup_D);
    //$width(negedge CLK , t_width_CLK);
    $width(negedge PRE , t_width_PRE);
    $width(negedge CLR , t_width_CLR);
  endspecify
endmodule

//-------------------------------------------------------------
//      I O    R e g i s t e r (D-flip flop):   8-bits
//
// 	 Timing specs are taken from page 1-10.
//-------------------------------------------------------------
module ioreg8$(CLK, D, Q, QBAR, CLR, PRE);
  input  CLK;
  input  CLR;
  input [7:0] D;
  input  PRE;
  output [7:0] Q;
  output [7:0] QBAR;
  reg    [7:0] Q;
  reg    [7:0] D_temp;
  wire  CLK_temp;
  wire  CLR_temp;
  wire  PRE_temp;

  assign #5 CLK_temp = CLK; //t_plh = t_phl 
	//assuming: t_plh(Q) = t_plh(QBAR) = t_phl(Q) = t_phl(QBAR)
  assign #5 PRE_temp = PRE; //t_p(PRE)
  assign #5 CLR_temp = CLR; //t_p(CLR)
  assign QBAR = ~Q;
  always@(posedge CLK) D_temp = D;

  always
    @(PRE_temp or CLR_temp)
      begin
      if(((CLR_temp == 1'b0) && (PRE_temp == 1'b1)))
        begin
        Q = 'b0;
        end
      else      if(((PRE_temp == 1'b0) && (CLR_temp == 1'b1)))
        begin
        Q = ( ~ 'b0);
        end
      else      if(((CLR_temp != 1'b1) || (PRE_temp != 1'b1)))
        begin
        Q = 'bx;
        end
      end

  always 
    @(posedge CLK_temp) if (((PRE_temp == 1'b1) && (CLR_temp == 1'b1))) Q = D_temp;

  specify
    specparam
      t_setup_D   = 10,
      t_width_CLK = 5,
      t_width_PRE = 5,
      t_width_CLR = 5;
    $setup(D , posedge CLK , t_setup_D);
    $width(negedge CLK , t_width_CLK);
    $width(negedge PRE , t_width_PRE);
    $width(negedge CLR , t_width_CLR);
  endspecify
endmodule

//-------------------------------------------------------------
//      I O    R e g i s t e r (D-flip flop):   16-bits
//
// 	 Timing specs are taken from page 1-10.
//-------------------------------------------------------------

module ioreg16$(CLK, D, Q, QBAR, CLR, PRE);
  input  CLK;
  input  CLR;
  input [15:0] D;
  input  PRE;
  output [15:0] Q;
  output [15:0] QBAR;
  reg    [15:0] Q;
  reg    [15:0] D_temp;
  wire  CLK_temp;
  wire  CLR_temp;
  wire  PRE_temp;

  assign #5 CLK_temp = CLK; //t_plh = t_phl 
	//assuming: t_plh(Q) = t_plh(QBAR) = t_phl(Q) = t_phl(QBAR)
  assign #5 PRE_temp = PRE; //t_p(PRE)
  assign #5 CLR_temp = CLR; //t_p(CLR)
  assign QBAR = ~Q;
  always@(posedge CLK) D_temp = D;

  always
    @(PRE_temp or CLR_temp)
      begin
      if(((CLR_temp == 1'b0) && (PRE_temp == 1'b1)))
        begin
        Q = 'b0;
        end
      else      if(((PRE_temp == 1'b0) && (CLR_temp == 1'b1)))
        begin
        Q = ( ~ 'b0);
        end
      else      if(((CLR_temp != 1'b1) || (PRE_temp != 1'b1)))
        begin
        Q = 'bx;
        end
      end

  always
    @(posedge CLK_temp) if (((PRE_temp == 1'b1) && (CLR_temp == 1'b1))) Q = D_temp;

  specify
    specparam
      t_setup_D   = 10,
      t_width_CLK = 5,
      t_width_PRE = 5,
      t_width_CLR = 5;
    $setup(D , posedge CLK , t_setup_D);
    $width(negedge CLK , t_width_CLK);
    $width(negedge PRE , t_width_PRE);
    $width(negedge CLR , t_width_CLR);
  endspecify
endmodule

