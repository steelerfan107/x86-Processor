//-----------------------------------------------------------
// Library parts I
// ---------------
// EE382N-14945, Spring 2000.
// (Modified from those provided by Cascade Design Automation Corp).
// All module parts' name are appended with a "$" character.
// This part of the library consists of the following gates and flip flop:
//
// nand2$	-  2 inputs nand
// nand3$	-  3 inputs nand
// nand4$	-  4 inputs nand
// and2$	-  2 inputs and
// and3$	-  3 inputs and
// and4$	-  4 inputs and
// nor2$	-  2 inputs nor 
// nor3$	-  3 inputs nor 
// nor4$	-  4 inputs nor 
// or2$		-  2 inputs or 
// or3$		-  3 inputs or 
// or4$		-  4 inputs or 
// xor2$	-  2 inputs xor 
// xnor2$	-  2 inputs xnor 
// inv1$	-  1 input inverter 
// dff$		-  edge-triggered D-ff with set/reset
//
// Timing specs are taken from page 1-47.
//-----------------------------------------------------------
`celldefine
module  nand2$(out, in0, in1);
	input	in0, in1;
	output	out;

	nand (out, in0, in1);

	specify
            (in0 *> out) = (0.18:0.2:0.22, 0.18:0.2:0.22);
            (in1 *> out) = (0.18:0.2:0.22, 0.18:0.2:0.22);
	endspecify
endmodule
`endcelldefine

`celldefine
module  nand3$(out, in0, in1, in2);
	input	in0, in1, in2;
	output	out;

	nand (out, in0, in1, in2);

	specify
            (in0 *> out) = (0.18:0.2:0.22, 0.18:0.2:0.22);
            (in1 *> out) = (0.18:0.2:0.22, 0.18:0.2:0.22);
            (in2 *> out) = (0.18:0.2:0.22, 0.18:0.2:0.22);
	endspecify
endmodule
`endcelldefine

`celldefine
module  nand4$(out, in0, in1, in2, in3);
	input in0, in1, in2, in3;
	output out;

	nand (out, in0, in1, in2, in3);

	specify
            (in0 *> out) = (0.22:0.25:0.28, 0.22:0.25:0.28);
            (in1 *> out) = (0.22:0.25:0.28, 0.22:0.25:0.28);
            (in2 *> out) = (0.22:0.25:0.28, 0.22:0.25:0.28);
            (in3 *> out) = (0.22:0.25:0.28, 0.22:0.25:0.28);
	endspecify
endmodule
`endcelldefine



//-----------------------------------------------------------
`celldefine
module  and2$(out, in0, in1);
	input in0, in1;
	output out;

	and (out, in0, in1);

	specify
            (in0 *> out) = (0.32:0.35:0.38, 0.32:0.35:0.38);
            (in1 *> out) = (0.32:0.35:0.38, 0.32:0.35:0.38);
	endspecify
endmodule
`endcelldefine

`celldefine
module  and3$(out, in0, in1, in2);
	input	in0, in1, in2;
	output	out;

	and (out, in0, in1, in2);

	specify
            (in0 *> out) = (0.32:0.35:0.38, 0.32:0.35:0.38);
            (in1 *> out) = (0.32:0.35:0.38, 0.32:0.35:0.38);
            (in2 *> out) = (0.32:0.35:0.38, 0.32:0.35:0.38);
	endspecify
endmodule
`endcelldefine

`celldefine
module  and4$(out, in0, in1, in2, in3);
	input in0, in1, in2, in3;
	output out;

	and (out, in0, in1, in2, in3);

	specify
            (in0 *> out) = (0.36:0.40:0.44, 0.36:0.40:0.44);
            (in1 *> out) = (0.36:0.40:0.44, 0.36:0.40:0.44);
            (in2 *> out) = (0.36:0.40:0.44, 0.36:0.40:0.44);
            (in3 *> out) = (0.36:0.40:0.44, 0.36:0.40:0.44);
	endspecify
endmodule
`endcelldefine

`celldefine
module  and5$(out, in0, in1, in2, in3, in4);
	input in0, in1, in2, in3, in4;
	output out;

       logic_tree #(.WIDTH(5)) lt ({in0, in1, in2, in3, in4},out);   
endmodule
`endcelldefine   

`celldefine
module  and14$(out, in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13);
	input in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13;
	output out;

       logic_tree #(.WIDTH(14)) lt ({in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13},out);   
endmodule
`endcelldefine  

 `celldefine
module  and15$(out, in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14);
	input in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14;
	output out;

       logic_tree #(.WIDTH(15)) lt ({in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14},out);   
endmodule
`endcelldefine

`celldefine
module  and16$(out, in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15);
	input in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15;
	output out;

       logic_tree #(.WIDTH(16)) lt ({in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15},out);   
endmodule
`endcelldefine

`celldefine
module  and6$(out, in0, in1, in2, in3, in4, in5);
	input in0, in1, in2, in3, in4, in5;
	output out;

       logic_tree #(.WIDTH(6)) lt ({in0, in1, in2, in3, in4, in5},out);   
endmodule
`endcelldefine   

  `celldefine
module  and7$(out, in0, in1, in2, in3, in4, in5, in6);
	input in0, in1, in2, in3, in4, in5, in6;
	output out;

       logic_tree #(.WIDTH(7)) lt ({in0, in1, in2, in3, in4, in5, in6},out);   
endmodule
`endcelldefine   

   `celldefine
module  and8$(out, in0, in1, in2, in3, in4, in5, in6, in7);
	input in0, in1, in2, in3, in4, in5, in6, in7;
	output out;

       logic_tree #(.WIDTH(8)) lt ({in0, in1, in2, in3, in4, in5, in6, in7},out);   
endmodule
`endcelldefine 

   `celldefine
module  and9$(out, in0, in1, in2, in3, in4, in5, in6, in7, in8);
	input in0, in1, in2, in3, in4, in5, in6, in7, in8;
	output out;

       logic_tree #(.WIDTH(9)) lt ({in0, in1, in2, in3, in4, in5, in6, in7, in8},out);   
endmodule
`endcelldefine 

`celldefine
module  and10$(out, in0, in1, in2, in3, in4, in5, in6, in7, in8, in9);
	input in0, in1, in2, in3, in4, in5, in6, in7, in8, in9;
	output out;

       logic_tree #(.WIDTH(10)) lt ({in0, in1, in2, in3, in4, in5, in6, in7, in8, in9},out);   
endmodule
`endcelldefine

`celldefine
module  and11$(out, in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10);
	input in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10;
	output out;

       logic_tree #(.WIDTH(11)) lt ({in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10},out);   
endmodule
`endcelldefine
  
`celldefine
module  and17$(out, in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16);
	input in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16;
	output out;

       logic_tree #(.WIDTH(17)) lt ({in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16},out);   
endmodule
`endcelldefine
  
`celldefine
module  and18$(out, in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17);
	input in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17;
	output out;

       logic_tree #(.WIDTH(18)) lt ({in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17},out);   
endmodule
`endcelldefine

`celldefine
module  and12$(out, in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11);
	input in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11;
	output out;

       logic_tree #(.WIDTH(12)) lt ({in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11},out);   
endmodule
`endcelldefine

`celldefine
module  and13$(out, in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12);
	input in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12;
	output out;

       logic_tree #(.WIDTH(13)) lt ({in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12},out);   
endmodule
`endcelldefine
  
`celldefine
module  and19$(out, in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18);
	input in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18;
	output out;

       logic_tree #(.WIDTH(19)) lt ({in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18},out);   
endmodule
`endcelldefine  

`celldefine
module  and20$(out, in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19);
	input in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19;
	output out;

       logic_tree #(.WIDTH(20)) lt ({in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19},out);   
endmodule
`endcelldefine
  
`celldefine
module  and24$(out, in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23);
	input in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23;
	output out;

       logic_tree #(.WIDTH(24)) lt ({in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23},out);   
endmodule
`endcelldefine
  
`celldefine
module  and23$(out, in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22);
	input in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22;
	output out;

       logic_tree #(.WIDTH(23)) lt ({in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22},out);   
endmodule
`endcelldefine

`celldefine
module  and22$(out, in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21);
	input in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21;
	output out;

       logic_tree #(.WIDTH(22)) lt ({in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21},out);   
endmodule
`endcelldefine

`celldefine
module  and21$(out, in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20);
	input in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20;
	output out;

       logic_tree #(.WIDTH(21)) lt ({in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20},out);   
endmodule
`endcelldefine  
//-----------------------------------------------------------
`celldefine
module  nor2$(out, in0, in1);
	input in0, in1;
	output out;

	nor (out, in0, in1);

	specify
            (in0 *> out) = (0.18:0.2:0.22, 0.18:0.2:0.22);
            (in1 *> out) = (0.18:0.2:0.22, 0.18:0.2:0.22);
	endspecify
endmodule
`endcelldefine

`celldefine
module  nor3$(out, in0, in1, in2);
	input in0, in1, in2;
	output out;

	nor (out, in0, in1, in2);

	specify
            (in0 *> out) = (0.22:0.25:0.28, 0.22:0.25:0.28);
            (in1 *> out) = (0.22:0.25:0.28, 0.22:0.25:0.28);
            (in2 *> out) = (0.22:0.25:0.28, 0.22:0.25:0.28);
	endspecify
endmodule
`endcelldefine

`celldefine
module  nor4$(out, in0, in1, in2, in3);
	input in0, in1, in2, in3;
	output out;

	nor (out, in0, in1, in2, in3);

	specify
            (in0 *> out) = (0.32:0.35:0.38, 0.32:0.35:0.38);
            (in1 *> out) = (0.32:0.35:0.38, 0.32:0.35:0.38);
            (in2 *> out) = (0.32:0.35:0.38, 0.32:0.35:0.38);
            (in3 *> out) = (0.32:0.35:0.38, 0.32:0.35:0.38);
	endspecify
endmodule
`endcelldefine

                                             
`celldefine
module  or2$(out, in0, in1);
	input in0, in1;
	output out;

	or (out, in0, in1);

	specify
            (in0 *> out) = (0.32:0.35:0.38, 0.32:0.35:0.38);
            (in1 *> out) = (0.32:0.35:0.38, 0.32:0.35:0.38);
	endspecify
endmodule
`endcelldefine

`celldefine
module or3$(out,in0, in1, in2);
 input in0, in1, in2;
 output out;

 logic_tree #(.WIDTH(3),.OPERATION(1)) lt ({in0, in1, in2}, out);
endmodule
`endcelldefine
`celldefine
module or4$(out,in0, in1, in2, in3);
 input in0, in1, in2, in3;
 output out;

 logic_tree #(.WIDTH(4),.OPERATION(1)) lt ({in0, in1, in2, in3}, out);
endmodule
`endcelldefine
`celldefine
module or5$(out,in0, in1, in2, in3, in4);
 input in0, in1, in2, in3, in4;
 output out;

 logic_tree #(.WIDTH(5),.OPERATION(1)) lt ({in0, in1, in2, in3, in4}, out);
endmodule
`endcelldefine
`celldefine
module or6$(out,in0, in1, in2, in3, in4, in5);
 input in0, in1, in2, in3, in4, in5;
 output out;

 logic_tree #(.WIDTH(6),.OPERATION(1)) lt ({in0, in1, in2, in3, in4, in5}, out);
endmodule
`endcelldefine
`celldefine
module or7$(out,in0, in1, in2, in3, in4, in5, in6);
 input in0, in1, in2, in3, in4, in5, in6;
 output out;

 logic_tree #(.WIDTH(7),.OPERATION(1)) lt ({in0, in1, in2, in3, in4, in5, in6}, out);
endmodule
`endcelldefine
`celldefine
module or8$(out,in0, in1, in2, in3, in4, in5, in6, in7);
 input in0, in1, in2, in3, in4, in5, in6, in7;
 output out;

 logic_tree #(.WIDTH(8),.OPERATION(1)) lt ({in0, in1, in2, in3, in4, in5, in6, in7}, out);
endmodule
`endcelldefine
`celldefine
module or9$(out,in0, in1, in2, in3, in4, in5, in6, in7, in8);
 input in0, in1, in2, in3, in4, in5, in6, in7, in8;
 output out;

 logic_tree #(.WIDTH(9),.OPERATION(1)) lt ({in0, in1, in2, in3, in4, in5, in6, in7, in8}, out);
endmodule
`endcelldefine
`celldefine
module or10$(out,in0, in1, in2, in3, in4, in5, in6, in7, in8, in9);
 input in0, in1, in2, in3, in4, in5, in6, in7, in8, in9;
 output out;

 logic_tree #(.WIDTH(10),.OPERATION(1)) lt ({in0, in1, in2, in3, in4, in5, in6, in7, in8, in9}, out);
endmodule
`endcelldefine
`celldefine
module or11$(out,in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10);
 input in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10;
 output out;

 logic_tree #(.WIDTH(11),.OPERATION(1)) lt ({in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10}, out);
endmodule
`endcelldefine
`celldefine
module or12$(out,in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11);
 input in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11;
 output out;

 logic_tree #(.WIDTH(12),.OPERATION(1)) lt ({in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11}, out);
endmodule
`endcelldefine
`celldefine
module or13$(out,in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12);
 input in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12;
 output out;

 logic_tree #(.WIDTH(13),.OPERATION(1)) lt ({in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12}, out);
endmodule
`endcelldefine
`celldefine
module or14$(out,in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13);
 input in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13;
 output out;

 logic_tree #(.WIDTH(14),.OPERATION(1)) lt ({in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13}, out);
endmodule
`endcelldefine
`celldefine
module or15$(out,in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14);
 input in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14;
 output out;

 logic_tree #(.WIDTH(15),.OPERATION(1)) lt ({in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14}, out);
endmodule
`endcelldefine
`celldefine
module or16$(out,in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15);
 input in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15;
 output out;

 logic_tree #(.WIDTH(16),.OPERATION(1)) lt ({in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15}, out);
endmodule
`endcelldefine
`celldefine
module or17$(out,in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16);
 input in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16;
 output out;

 logic_tree #(.WIDTH(17),.OPERATION(1)) lt ({in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16}, out);
endmodule
`endcelldefine
`celldefine
module or18$(out,in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17);
 input in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17;
 output out;

 logic_tree #(.WIDTH(18),.OPERATION(1)) lt ({in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17}, out);
endmodule
`endcelldefine
`celldefine
module or19$(out,in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18);
 input in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18;
 output out;

 logic_tree #(.WIDTH(19),.OPERATION(1)) lt ({in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18}, out);
endmodule
`endcelldefine
`celldefine
module or20$(out,in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19);
 input in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19;
 output out;

 logic_tree #(.WIDTH(20),.OPERATION(1)) lt ({in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19}, out);
endmodule
`endcelldefine
`celldefine
module or21$(out,in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20);
 input in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20;
 output out;

 logic_tree #(.WIDTH(21),.OPERATION(1)) lt ({in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20}, out);
endmodule
`endcelldefine
`celldefine
module or22$(out,in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21);
 input in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21;
 output out;

 logic_tree #(.WIDTH(22),.OPERATION(1)) lt ({in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21}, out);
endmodule
`endcelldefine
`celldefine
module or23$(out,in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22);
 input in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22;
 output out;

 logic_tree #(.WIDTH(23),.OPERATION(1)) lt ({in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22}, out);
endmodule
`endcelldefine
`celldefine
module or24$(out,in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23);
 input in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23;
 output out;

 logic_tree #(.WIDTH(24),.OPERATION(1)) lt ({in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23}, out);
endmodule
`endcelldefine
`celldefine
module or25$(out,in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24);
 input in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24;
 output out;

 logic_tree #(.WIDTH(25),.OPERATION(1)) lt ({in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24}, out);
endmodule
`endcelldefine
`celldefine
module or26$(out,in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25);
 input in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25;
 output out;

 logic_tree #(.WIDTH(26),.OPERATION(1)) lt ({in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25}, out);
endmodule
`endcelldefine
`celldefine
module or27$(out,in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26);
 input in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26;
 output out;

 logic_tree #(.WIDTH(27),.OPERATION(1)) lt ({in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26}, out);
endmodule
`endcelldefine
`celldefine
module or28$(out,in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27);
 input in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27;
 output out;

 logic_tree #(.WIDTH(28),.OPERATION(1)) lt ({in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27}, out);
endmodule
`endcelldefine
`celldefine
module or29$(out,in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, in28);
 input in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, in28;
 output out;

 logic_tree #(.WIDTH(29),.OPERATION(1)) lt ({in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, in28}, out);
endmodule
`endcelldefine
`celldefine
module or30$(out,in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, in28, in29);
 input in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, in28, in29;
 output out;

 logic_tree #(.WIDTH(30),.OPERATION(1)) lt ({in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, in28, in29}, out);
endmodule
`endcelldefine
`celldefine
module or31$(out,in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, in28, in29, in30);
 input in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, in28, in29, in30;
 output out;

 logic_tree #(.WIDTH(31),.OPERATION(1)) lt ({in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, in28, in29, in30}, out);
endmodule
`endcelldefine
`celldefine
module or32$(out,in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31);
 input in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31;
 output out;

 logic_tree #(.WIDTH(32),.OPERATION(1)) lt ({in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31}, out);
endmodule
`endcelldefine
`celldefine
module or33$(out,in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31, in32);
 input in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31, in32;
 output out;

 logic_tree #(.WIDTH(33),.OPERATION(1)) lt ({in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31, in32}, out);
endmodule
`endcelldefine
`celldefine
module or34$(out,in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31, in32, in33);
 input in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31, in32, in33;
 output out;

 logic_tree #(.WIDTH(34),.OPERATION(1)) lt ({in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31, in32, in33}, out);
endmodule
`endcelldefine
`celldefine
module or35$(out,in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31, in32, in33, in34);
 input in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31, in32, in33, in34;
 output out;

 logic_tree #(.WIDTH(35),.OPERATION(1)) lt ({in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31, in32, in33, in34}, out);
endmodule
`endcelldefine
`celldefine
module or36$(out,in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31, in32, in33, in34, in35);
 input in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31, in32, in33, in34, in35;
 output out;

 logic_tree #(.WIDTH(36),.OPERATION(1)) lt ({in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31, in32, in33, in34, in35}, out);
endmodule
`endcelldefine
`celldefine
module or37$(out,in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31, in32, in33, in34, in35, in36);
 input in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31, in32, in33, in34, in35, in36;
 output out;

 logic_tree #(.WIDTH(37),.OPERATION(1)) lt ({in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31, in32, in33, in34, in35, in36}, out);
endmodule
`endcelldefine
`celldefine
module or38$(out,in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31, in32, in33, in34, in35, in36, in37);
 input in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31, in32, in33, in34, in35, in36, in37;
 output out;

 logic_tree #(.WIDTH(38),.OPERATION(1)) lt ({in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31, in32, in33, in34, in35, in36, in37}, out);
endmodule
`endcelldefine
`celldefine
module or39$(out,in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31, in32, in33, in34, in35, in36, in37, in38);
 input in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31, in32, in33, in34, in35, in36, in37, in38;
 output out;

 logic_tree #(.WIDTH(39),.OPERATION(1)) lt ({in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31, in32, in33, in34, in35, in36, in37, in38}, out);
endmodule
`endcelldefine  
    
//-----------------------------------------------------------
`celldefine
module  or3$(out, in0, in1, in2);
	input in0, in1, in2;
	output out;

	or (out, in0, in1, in2);

	specify
            (in0 *> out) = (0.36:0.40:0.44, 0.36:0.40:0.44);
            (in1 *> out) = (0.36:0.40:0.44, 0.36:0.40:0.44);
            (in2 *> out) = (0.36:0.40:0.44, 0.36:0.40:0.44);
	endspecify
endmodule
`endcelldefine

`celldefine
module  or4$(out, in0, in1, in2, in3);
	input in0, in1, in2, in3;
	output out;

	or (out, in0, in1, in2, in3);

	specify
            (in0 *> out) = (0.46:0.50:0.54, 0.46:0.50:0.54);
            (in1 *> out) = (0.46:0.50:0.54, 0.46:0.50:0.54);
            (in2 *> out) = (0.46:0.50:0.54, 0.46:0.50:0.54);
            (in3 *> out) = (0.46:0.50:0.54, 0.46:0.50:0.54);
	endspecify
endmodule
`endcelldefine



//-----------------------------------------------------------
`celldefine
module  xor2$ (out, in0, in1);
	input in0, in1;
	output out;

	xor (out, in0, in1);

	specify
            (in0 *> out) = (0.27:0.30:0.33, 0.27:0.30:0.33);
            (in1 *> out) = (0.27:0.30:0.33, 0.27:0.30:0.33);
	endspecify
endmodule
`endcelldefine


//-----------------------------------------------------------
`celldefine
module  xnor2$ (out, in0, in1);
	input in0, in1;
	output out;

	xnor (out, in0, in1);

	specify
            (in0 *> out) = (0.22:0.25:0.28, 0.22:0.25:0.28);
            (in1 *> out) = (0.22:0.25:0.28, 0.22:0.25:0.28);
	endspecify
endmodule
`endcelldefine


//-----------------------------------------------------------
// Timing specs taken from page 1-47.
`celldefine
module  inv1$ (out, in);
	input in;
	output out;

	not (out, in);

	specify
            (in *> out) = (0.13:0.15:0.17, 0.13:0.15:0.17);
	endspecify
endmodule
`endcelldefine


//-----------------------------------------------------------
// Edge-Triggered D-ff
// Timing specs taken from page 1-10.
primitive table_dffq(q, d, clk, s, r);
    input d, clk, s, r;
    output q;
    reg q;

    table
    //  d  clk  s  r : q  : q+
	?   ?   0  0 : ?  : x;

	?   ?   1  0 : ?  : 0; //clear logic
	?   ?   1  * : 0  : 0;

	?   ?   0  1 : ?  : 1; //preset logic
	?   ?   *  1 : 1  : 1;

        1   r   1  1 : ?  : 1; //normal clocking
        0   r   1  1 : ?  : 0;
	?   f   1  1 : ?  : -; //ignore negative edge of clock
	*   ?   1  1 : ?  : -; //ignore data changes on a steady clock
    endtable
endprimitive

`celldefine
module  dff$(clk, d, q, qbar, r, s);
	input  s, d, r, clk;
	output qbar, q;

	table_dffq(q, d, clk, s, r);
	not(qbar, q);

	specify
            (clk *> q)    = (0.06:0.08:0.10);
	    // assume t_plh(Q) = t_plh(QBAR)
	    //        t_phl(Q) = t_phl(QBAR)
            (clk *> qbar) = (0.06:0.08:0.10);
            (s *> q)      = (0.36:0.40:0.44);
            (s *> qbar)   = (0.36:0.40:0.44);
            (r *> q)      = (0.32:0.35:0.38);
            (r *> qbar)   = (0.32:0.35:0.38);
            $setup(d, edge[01,x1] clk,0.18:0.2:0.22);
            $width(edge[01,x1] s,     0.32:0.35:0.38);
            $width(edge[01,x1] r,     0.32:0.35:0.38);
            $width(edge[01,x1] clk,   0.32:0.35:0.38);
	endspecify
endmodule
`endcelldefine

