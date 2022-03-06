//-----------------------------------------------------------
// Library parts V
// ---------------
// EE382N-14945, Spring 2000.
// (Some are modified from those provided by Cascade Design Automation Corp).
// All module parts' name are appended with a "$" character.
// This part of the library consists of the following parts:
//
// decoder2_4$	- 2 to 4 decoder
// decoder3_8$	- 3 to 8 decoder
// syn_cntr8$	- synchronuous up/down counter with preset/parallel load
// pencoder8_3$ - priority encoder, 8-lines to 3-lines
// pencoder8_3v$- priority encoder with valid output, 8-lines to 3-lines
// mag_comp8$	- 8-bits magnitude comparator

//             IMPORTANT
//
//	The first four functions of the ALU will not work properly
// 	when cascading multiple ALU slices together. Also the implementation of
//	A minus B and A minus B minus 1 are interchanged here from the sheet
//	handed to you in class.
//
// alu4$	- 4-bit ALU slice
// 
//
//------------------------------------------------------
//   D  e  c  o  d  e  r :       2 select inputs
//
//       Timing specs taken from page 2-37
//------------------------------------------------------
module decoder2_4$(SEL,Y,YBAR);
  input [1:0] SEL;
  output [3:0] Y;
  output [3:0] YBAR;
  reg [3:0] Y_temp;
  reg [3:0] YBAR_temp;
  integer i;
  assign #(0.36:0.40:0.44) Y = Y_temp;
  assign #(0.36:0.40:0.44) YBAR = YBAR_temp;

  always
    @(SEL)
      begin
      for(i = 0;(i <= 3);i = (i + 1))
        if(i == SEL)
	begin
          Y_temp[i] = 1'b1;
          YBAR_temp[i] = 1'b0;
	end
        else
	begin
          Y_temp[i] = 1'b0;
          YBAR_temp[i] = 1'b1;
	end
      end
endmodule

//------------------------------------------------------
//   D  e  c  o  d  e  r :       3 select inputs
//
//       Timing specs taken from page 2-37
//------------------------------------------------------
module decoder3_8$(SEL,Y,YBAR);
  input [2:0] SEL;
  output [7:0] Y;
  output [7:0] YBAR;
  reg [7:0] Y_temp;
  reg [7:0] YBAR_temp;
  integer i;
  assign #(0.36:0.40:0.44) Y = Y_temp;
  assign #(0.36:0.40:0.44) YBAR = YBAR_temp;

  always
    @(SEL)
      begin
      for(i = 0;(i <= 7);i = (i + 1))
        if(i == SEL)
	begin
          Y_temp[i] = 1'b1;
          YBAR_temp[i] = 1'b0;
	end
        else
	begin
          Y_temp[i] = 1'b0;
          YBAR_temp[i] = 1'b1;
	end
      end
endmodule

//------------------------------------------------------
//  S y n c h r o n u o u s     C o u n t e r:   8-bits
//
//	   Timing specs taken from page 2-118.
//------------------------------------------------------
module syn_cntr8$(CLK,CLR,D,EN,PRE,PL,UP,COUT,Q);
  input  CLK;
  input  CLR;
  input [7:0] D;
  input  EN;
  input  PRE;
  input  PL;
  input  UP;
  output  COUT;
  output [7:0] Q;
  wire  COUT_temp;
  wire   [7:0] Q_temp;
  assign #(0.48:0.52:0.56, 0.42:0.46:0.50) Q = Q_temp;
  assign #(0.85:0.90:0.95)           COUT = COUT_temp;

  syn_cntr syn_cntr(CLK,CLR,D,EN,PRE,PL,UP,COUT_temp,Q_temp);

  specify
	$setup(EN, edge[01,x1] CLK, 0.40:0.44:0.48);
	$setup(PL, edge[01,x1] CLK, 0.32:0.36:0.40);
	$setup(UP, edge[01,x1] CLK, 0.42:0.46:0.50);
	$setup(D,  edge[01,x1] CLK, 0.34:0.38:0.42);
	$width(edge[01,x1] CLR, 0.10:0.12:0.14);
	$width(edge[01,x1] PRE, 0.10:0.12:0.14);
  endspecify
endmodule

module syn_cntr(CLK,CLR,D,EN,PRE,PL,UP,COUT,Q);
  input  CLK;
  input  CLR;
  input [7:0] D;
  input  EN;
  input  PRE;
  input  PL;
  input  UP;
  output  COUT;
  output [7:0] Q;
  wire  SCANIN = 'b0;
  wire  TEST = 'b0;
  reg  COUT_reg;
  reg [7:0] Q_reg;
  reg  couttemp;
  reg [7:0] temp;

  assign Q = Q_reg;
  assign COUT = COUT_reg;

  always
    @(PRE or CLR)
      begin
      if(((CLR == 1'b0) && (PRE == 1'b1)))
        begin
        temp = 'b0;
        Q_reg = temp;
        COUT_reg = 'b0;
        end
      else      if(((PRE == 1'b0) && (CLR == 1'b1)))
        begin
        temp = ( ~ 'b0);
        Q_reg = temp;
        COUT_reg = 'b0;
        end
      else      if(((CLR != 1'b1) || (PRE != 1'b1)))
        begin
        Q_reg = 'bx;
        COUT_reg = 'b0;
        end
      end
  always
    @(posedge CLK)
      if(((PRE == 1'b1) && (CLR == 1'b1)))
        begin
        temp = 'bx;
//        if(((( ^ Q) === 1'bx) && (EN == 1'b1)))
//          couttemp = 1'bx;
//        else
//          couttemp = 1'b0;
        if((TEST == 1'b0))
          begin
          if((PL == 1'b0))
            begin
            if((EN == 1'b1))
              begin
              if((UP == 1'b1))
                begin
//                if(( Q == 8'b11111110 ))
//                  couttemp = 1'b1;
                temp = (Q_reg + 1'b1);
                end
              else              if((UP == 1'b0))
                begin
//                if(( Q == 8'b00000001 ))
//                  couttemp = 1'b1;
                temp = (Q_reg - 1'b1);
                end

end
            else            if((EN == 1'b0))
              begin
              temp = Q_reg;
              end
            end
          else          if((PL == 1'b1))
            temp = D;
          end
        else        if((TEST == 1'b1))
          begin
          temp = Q_reg;
          temp = (temp << 1);
          temp[0] = SCANIN;
        end
        Q_reg = temp;
//        COUT = couttemp;
        end


  always @(EN or UP or Q)
      if(((PRE == 1'b1) && (CLR == 1'b1)))
        begin
        if(((( ^ Q_reg) === 1'bx) && (EN == 1'b1)))
          couttemp = 1'bx;
        else
          couttemp = 1'b0;
        if((TEST == 1'b0))
          begin
          if((PL == 1'b0))
            begin
            if((EN == 1'b1))
              begin
              if((UP == 1'b1))
                begin
                if((( ~ Q_reg ) == 1'b0 ))
                  couttemp = 1'b1;
                end
              else              if((UP == 1'b0))
                begin
                if(( Q_reg == 1'b0 ))
                  couttemp = 1'b1;
                end
              end
	    end	
	  end
        COUT_reg = couttemp;
	end

endmodule


//---------------------------------------------------------------------------
//      P r i o r i t y     E n c o d e r :  8-lines to 3-lines
//
//---------------------------------------------------------------------------
// Truth table for a 8-to-3 priority endcoder:
//
// enbar                    inputs                        outputs      valid
//         X[7] X[6] X[5] X[4] X[3] X[2] X[1] X[0]     Y[2] Y[1] Y[0] 
//---------------------------------------------------------------------------
//  H       x    x    x    x    x    x    x    x        z    z    z      z
//  L       L    L    L    L    L    L    L    H        L    L    L      H
//  L       L    L    L    L    L    L    H    x        L    L    H      H
//  L       L    L    L    L    L    L    x    x        L    H    L      H
//  L       L    L    L    L    H    x    x    x        L    H    H      H
//  L       L    L    L    H    x    x    x    x        H    L    L      H
//  L       L    L    H    x    x    x    x    x        H    L    H      H
//  L       L    H    x    x    x    x    x    x        H    H    L      H
//  L       H    x    x    x    x    x    x    x        H    H    H      H
//
//  L       L    L    L    L    L    L    L    L        L    L    L      L

module pencoder8_3v$(enbar,X,Y,valid);
  input enbar;
  input [7:0] X;
  output [2:0] Y;
  output valid;
  wire   valid;
  reg    valid_temp;
  reg [2:0] Y_temp;
  assign #(0.71:0.76:0.81) Y = Y_temp;
  assign #(0.71:0.76:0.81) valid = valid_temp;

  always @(enbar or X)
	begin
  	valid_temp = 1;
        if (enbar) begin Y_temp = 3'bz; valid_temp = 1'bz; end
        else if (X[7]==1'b1) Y_temp=7;
	else if (X[6]==1'b1) Y_temp=6;
	else if (X[5]==1'b1) Y_temp=5;
	else if (X[4]==1'b1) Y_temp=4;
	else if (X[3]==1'b1) Y_temp=3;
	else if (X[2]==1'b1) Y_temp=2;
	else if (X[1]==1'b1) Y_temp=1;
	else if (X[0]==1'b1) Y_temp=0;
	else if (X==0) begin Y_temp=0; valid_temp=0; end
	else begin Y_temp = 3'bx; valid_temp=1'bx; end
	end
endmodule

//--------------------------------------------------------------------
//      P r i o r i t y     E n c o d e r :  8-lines to 3-lines
//
//--------------------------------------------------------------------
// Truth table for a 8-to-3 priority endcoder:
//
// enbar                    inputs                        outputs
//         X[0] X[1] X[2] X[3] X[4] X[5] X[6] X[7]     Y[2] Y[1] Y[0] 
//--------------------------------------------------------------------
//  H       x    x    x    x    x    x    x    x        z    z    z
//  L       x    x    x    x    x    x    x    L        L    L    L 
//  L       x    x    x    x    x    x    L    H        L    L    H 
//  L       x    x    x    x    x    L    H    H        L    H    L 
//  L       x    x    x    x    L    H    H    H        L    H    H 
//  L       x    x    x    L    H    H    H    H        H    L    L 
//  L       x    x    L    H    H    H    H    H        H    L    H 
//  L       x    L    H    H    H    H    H    H        H    H    L
//  L       L    H    H    H    H    H    H    H        H    H    H 
//  L       H    H    H    H    H    H    H    H        z    z    z
//
module pencoder8_3$(enbar,X,Y);
  input enbar;
  input [7:0] X;
  output [2:0] Y;
  reg [2:0] Y_temp;
  assign #(0.71:0.76:0.81) Y = Y_temp;

  always @(enbar or X)
        if (enbar) Y_temp = 3'bz;
        else if (X[7]==1'b0) Y_temp=0;
	else if (X[6]==1'b0) Y_temp=1;
	else if (X[5]==1'b0) Y_temp=2;
	else if (X[4]==1'b0) Y_temp=3;
	else if (X[3]==1'b0) Y_temp=4;
	else if (X[2]==1'b0) Y_temp=5;
	else if (X[1]==1'b0) Y_temp=6;
	else if (X[0]==1'b0) Y_temp=7;
	else if (X==255)    Y_temp=3'bz;
	else Y_temp = 3'bx;
endmodule


//------------------------------------------------------
//   M a g n i t u d e     C o m p a r a t o r:   8-bits
//
//       Timing specs taken from page 2-29
//------------------------------------------------------
module mag_comp8$(A, B, AGB, BGA);
  input [7:0] A,B;
  output AGB,BGA;
  reg    AGB_temp,BGA_temp;

  assign #(1.4:1.46:1.52, 1.2:1.34:1.5) AGB = AGB_temp;
  assign #(1.4:1.46:1.52, 1.2:1.34:1.5) BGA = BGA_temp;

  always
    @(A or B)
      begin
	AGB_temp = (A>B)? 1:0;
	BGA_temp = (B>A)? 1:0;
      end
endmodule

//------------------------------------------------------
//   M a g n i t u d e     C o m p a r a t o r:   4-bits
//
//
//------------------------------------------------------
module mag_comp4$(A, B, AGB, BGA);
  input [3:0] A,B;
  output AGB,BGA;
  reg    AGB_temp,BGA_temp;

  assign #(1.1:1.16:1.22, 1.0:1.14:1.3) AGB = AGB_temp;
  assign #(1.1:1.16:1.22, 1.0:1.14:1.3) BGA = BGA_temp;

  always
    @(A or B)
      begin
	AGB_temp = (A>B)? 1:0;
	BGA_temp = (B>A)? 1:0;
      end
endmodule

//------------------------------------------------------
//    A    L   U     S l i c e:     4-bits
//
//       Timing specs taken from page 2-7
//------------------------------------------------------
module alu4$(a,b,cin,m,s,cout,out);
  input [3:0] a;
  input [3:0] b;
  input  cin;
  input  m;
  input [3:0] s;
  output  cout;
  output [3:0] out;
  reg  cout;
  reg [3:0] out;
  reg [3:0] logic;
  reg [4:0] pr;
  reg [3:0] pr1;
  reg [4:0] arith;
  reg  cinbar;
  wire [3:0] #(0.68:0.72:0.76, 0.9:0.94:1.0) s_temp = s;//Let t_p(S-COUT)=t_p(S-F)
  wire [3:0] #(0.68:0.72:0.76, 0.9:0.94:1.0) m_temp = m;//   =t_p(M-COUT)=t_p(M-F)
  wire [3:0] #(0.9:1.0:1.1) a_temp = a;    //Let t_p(AB-COUT)=t_p(AB-F)
  wire [3:0] #(0.9:1.0:1.1) b_temp = b;    //Let t_p(AB-COUT)=t_p(AB-F)
  wire #(0.55:0.6:0.65, 0.62:0.68:0.74)cin_temp = cin;//t_p(Cin-COUT)=t_p(Cin-F)

  always
    @(a_temp or b_temp or cin_temp or s_temp or m_temp)
      begin
      cinbar = ( ~ cin_temp);
      if((s_temp == 4'd0))
        begin
        logic = ( ~ a_temp);
        arith = ({1'b0,a_temp} - cinbar);
        end
      else      if((s_temp == 4'd1))
        begin
        logic = ( ~ (a_temp & b_temp));
        pr = (a_temp & b_temp);
        arith = ({1'b0,pr} - cinbar);
        end
      else      if((s_temp == 4'd2))
        begin
        logic = (( ~ a_temp) | b_temp);
        pr = ( ~ logic);
        arith = ({1'b0,pr} - cinbar);
        end
      else      if((s_temp == 4'd3))
        begin
        logic = ( ~ 'b0);
        arith = ({1'b0,logic} + cin_temp);
        end
      else      if((s_temp == 4'd4))
        begin
        logic = ( ~ (a_temp | b_temp));
        pr = (a_temp | ( ~ b_temp));
        arith = (a_temp + ({1'b0,pr} + cin_temp));
        end
      else      if((s_temp == 4'd5))
        begin
        logic = ( ~ b_temp);
        pr = (a_temp & b_temp);
        pr1 = (a_temp | ( ~ b_temp));
        arith = (pr + ({1'b0,pr1} + cin_temp));
        end
      else      if((s_temp == 4'd6))
        begin
        logic = ( ~ (a_temp ^ b_temp));
        //pr = (( ~ (b_temp + cinbar)) + 1'b1);
        //arith = ({1'b0,a_temp} + pr);
        arith = a - b - cin;
        cout = arith[4];
        end
      else      if((s_temp == 4'd7))
        begin
        logic = (a_temp | ( ~ b_temp));
        arith = ({1'b0,logic} + cin_temp);
        end
      else      if((s_temp == 4'd8))
        begin
        logic = (( ~ a_temp) & b_temp);
        pr = (a_temp | b_temp);
        arith = (a_temp + ({1'b0,pr} + cin_temp));
        end
      else      if((s_temp == 4'd9))
        begin
        logic = (a_temp ^ b_temp);
        arith = (a_temp + ({1'b0,b_temp} + cin_temp));
        end
      else      if((s_temp == 4'd10))
        begin
        logic = b_temp;
        pr = (a_temp & ( ~ b_temp));
        pr1 = (a_temp | b_temp);
        arith = (pr + ({1'b0,pr1} + cin_temp));
        end
      else      if((s_temp == 4'd11))
        begin
        logic = (a_temp | b_temp);
        arith = ({1'b0,logic} + cin_temp);
        end
      else      if((s_temp == 4'd12))
        begin
        logic = 'b0;
        arith = (a_temp + ({1'b0,a_temp} + cin_temp));
        end
      else      if((s_temp == 4'd13))
        begin
        logic = (a_temp & ( ~ b_temp));
        pr = (a_temp & b_temp);
        arith = (pr + ({1'b0,a_temp} + cin_temp));
        end
      else      if((s_temp == 4'd14))
        begin
        logic = (a_temp & b_temp);
        pr = (a_temp & ( ~ b_temp));
        arith = (pr + ({1'b0,a_temp} + cin_temp));
        end
      else      if((s_temp == 4'd15))
        begin
        logic = a_temp;
        arith = ({1'b0,a_temp} + cin_temp);
        end
      else
        begin
        logic = 'bX;
        arith = 'bX;
        end
      if((m_temp == 1'b0))
        begin
        cout = 1'b0;
        out = logic;
        end
      else      if((m_temp == 1'b1))
        begin
        cout = arith[4];
        out = arith[3:0];
        end
      else
        begin
        cout = 1'bX;
        out = 'bX;
        end
      end
endmodule

