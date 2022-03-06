lib1
====

module  nand2$(out, in0, in1);

module  nand3$(out, in0, in1, in2);

module  nand4$(out, in0, in1, in2, in3);

module  and2$(out, in0, in1);

module  and3$(out, in0, in1, in2);

module  and4$(out, in0, in1, in2, in3);

module  nor2$(out, in0, in1);

module  nor3$(out, in0, in1, in2);

module  nor4$(out, in0, in1, in2, in3);

module  or2$(out, in0, in1);

module  or3$(out, in0, in1, in2);

module  or4$(out, in0, in1, in2, in3);

module  xor2$ (out, in0, in1);

module  xnor2$ (out, in0, in1);

module  inv1$ (out, in);

module  dff$(clk, d, q, qbar, r, s);

lib2
====

module dff8$(CLK, D, Q, QBAR, CLR, PRE);

module dff16$(CLK, D, Q, QBAR, CLR, PRE);

module jkff8$(CLK,CLR,J,K,PRE,Q,QBAR);

module jkff16$(CLK,CLR,J,K,PRE,Q,QBAR);

module  buffer$(out, in);

module  buffer8$(out, in);

module  buffer16$(out, in);

module  latch$(d, en, q, qbar, r, s);

module latch8$(CLR,D,EN,PRE,Q);

module latch16$(CLR,D,EN,PRE,Q);

module  tristateL$(enbar, in, out);

module  tristate8L$(enbar, in, out);

module  tristate16L$(enbar, in, out);

module  tristateH$(enbar, in, out);

module  tristate8H$(enbar, in, out);

module  tristate16H$(enbar, in, out);

module  tristate_bus_driver1$(enbar, in, out);

module  tristate_bus_driver8$(enbar, in, out);

module  tristate_bus_driver16$(enbar, in, out);

module dff16b$(CLK, D, Q, QBAR, CLR, PRE, A);

module dff32b$(CLK, D, Q, QBAR, CLR, PRE, A);

module reg64e$(CLK, Din, Q, QBAR, CLR, PRE,en);

module reg32e$(CLK, Din, Q, QBAR, CLR, PRE,en);

module ioreg8$(CLK, D, Q, QBAR, CLR, PRE);

module ioreg16$(CLK, D, Q, QBAR, CLR, PRE);

lib3
====
module regfile$(IN0,R1,R2,RE1,RE2,W,WE,OUT1,OUT2,CLOCK);

module regfile8x8$(IN0,R1,R2,RE1,RE2,W,WE,OUT1,OUT2,CLOCK);

module  ram8b8w$ (A,DIN,OE,WR, DOUT);

module	ram16b8w$ (A, DIN, OE, WRH, WRL, DOUT);

module  ram8b4w$ (A,DIN,OE,WR, DOUT);

module rom4b32w$(A,OE,DOUT);

module rom32b32w$(A,OE,DOUT);

module rom64b32w$(A,OE,DOUT);

lib4
====

module  mux2$(outb, in0, in1, s0);

module  mux3$(outb, in0, in1, in2, s0, s1);

module  mux4$(outb, in0, in1, in2, in3, s0, s1);

module mux2_8$(Y,IN0,IN1,S0);

module mux2_16$(Y,IN0,IN1,S0);

module mux3_8$(Y,IN0,IN1,IN2,S0,S1);

module mux3_16$(Y,IN0,IN1,IN2,S0,S1);

module mux4_8$(Y,IN0,IN1,IN2,IN3,S0,S1);

module mux4_16$(Y,IN0,IN1,IN2,IN3,S0,S1);

lib5
====

module decoder2_4$(SEL,Y,YBAR);

module decoder3_8$(SEL,Y,YBAR);

module syn_cntr8$(CLK,CLR,D,EN,PRE,PL,UP,COUT,Q);

module syn_cntr(CLK,CLR,D,EN,PRE,PL,UP,COUT,Q);

module pencoder8_3v$(enbar,X,Y,valid);

module pencoder8_3$(enbar,X,Y);

module mag_comp8$(A, B, AGB, BGA);

module mag_comp4$(A, B, AGB, BGA);

module alu4$(a,b,cin,m,s,cout,out);

lib6
====

module  sram128x8$ (A,DIO,OE,WR, CE);

module  sram32x8$ (A,DIO,OE,WR, CE);

module	sram32x16$(A,DIO,OE,WRH,WRL,CE);

module sram_test;

module  sram32x32$ (A,DIO,OE,WR, CE);


time
====

module timeunit;
