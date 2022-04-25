`timescale 1ns / 1ps
module LBSHF(in, s, out, c);
input [31:0] in;
input [7:0] s;
output [31:0] out;
output c; //carry

//stage 1 wires
wire s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7,
s1_8, s1_9, s1_10, s1_11, s1_12, s1_13, s1_14, s1_15,
s1_16, s1_17, s1_18, s1_19, s1_20, s1_21, s1_22, s1_23,
s1_24, s1_25, s1_26, s1_27, s1_28, s1_29, s1_30, s1_31, s1_c;
//stage 2 wires
wire s2_0, s2_1, s2_2, s2_3, s2_4, s2_5, s2_6, s2_7,
s2_8, s2_9, s2_10, s2_11, s2_12, s2_13, s2_14, s2_15,
s2_16, s2_17, s2_18, s2_19, s2_20, s2_21, s2_22, s2_23,
s2_24, s2_25, s2_26, s2_27, s2_28, s2_29, s2_30, s2_31, s2_c;
//stage 3 wires
wire s3_0, s3_1, s3_2, s3_3, s3_4, s3_5, s3_6, s3_7,
s3_8, s3_9, s3_10, s3_11, s3_12, s3_13, s3_14, s3_15,
s3_16, s3_17, s3_18, s3_19, s3_20, s3_21, s3_22, s3_23,
s3_24, s3_25, s3_26, s3_27, s3_28, s3_29, s3_30, s3_31, s3_c;
//stage 4 wires
wire s4_0, s4_1, s4_2, s4_3, s4_4, s4_5, s4_6, s4_7,
s4_8, s4_9, s4_10, s4_11, s4_12, s4_13, s4_14, s4_15,
s4_16, s4_17, s4_18, s4_19, s4_20, s4_21, s4_22, s4_23,
s4_24, s4_25, s4_26, s4_27, s4_28, s4_29, s4_30, s4_31, s4_c;
//stage 5 wires
wire s5_0, s5_1, s5_2, s5_3, s5_4, s5_5, s5_6, s5_7,
s5_8, s5_9, s5_10, s5_11, s5_12, s5_13, s5_14, s5_15,
s5_16, s5_17, s5_18, s5_19, s5_20, s5_21, s5_22, s5_23,
s5_24, s5_25, s5_26, s5_27, s5_28, s5_29, s5_30, s5_31, s5_c;
//stage 6 wires
wire s6_0, s6_1, s6_2, s6_3, s6_4, s6_5, s6_6, s6_7,
s6_8, s6_9, s6_10, s6_11, s6_12, s6_13, s6_14, s6_15,
s6_16, s6_17, s6_18, s6_19, s6_20, s6_21, s6_22, s6_23,
s6_24, s6_25, s6_26, s6_27, s6_28, s6_29, s6_30, s6_31, s6_c;
//stage 7 wires
wire s7_0, s7_1, s7_2, s7_3, s7_4, s7_5, s7_6, s7_7,
s7_8, s7_9, s7_10, s7_11, s7_12, s7_13, s7_14, s7_15,
s7_16, s7_17, s7_18, s7_19, s7_20, s7_21, s7_22, s7_23,
s7_24, s7_25, s7_26, s7_27, s7_28, s7_29, s7_30, s7_31, s7_c;

//stage 1 mux
mux2$ m1_0(.outb(s1_0), .in1(1'b0), .in0(in[0]), .s0(s[0]));
mux2$ m1_1(.outb(s1_1), .in1(in[0]), .in0(in[1]), .s0(s[0]));
mux2$ m1_2(.outb(s1_2), .in1(in[1]), .in0(in[2]), .s0(s[0]));
mux2$ m1_3(.outb(s1_3), .in1(in[2]), .in0(in[3]), .s0(s[0]));
mux2$ m1_4(.outb(s1_4), .in1(in[3]), .in0(in[4]), .s0(s[0]));
mux2$ m1_5(.outb(s1_5), .in1(in[4]), .in0(in[5]), .s0(s[0]));
mux2$ m1_6(.outb(s1_6), .in1(in[5]), .in0(in[6]), .s0(s[0]));
mux2$ m1_7(.outb(s1_7), .in1(in[6]), .in0(in[7]), .s0(s[0]));
mux2$ m1_8(.outb(s1_8), .in1(in[7]), .in0(in[8]), .s0(s[0]));
mux2$ m1_9(.outb(s1_9), .in1(in[8]), .in0(in[9]), .s0(s[0]));
mux2$ m1_10(.outb(s1_10), .in1(in[9]), .in0(in[10]), .s0(s[0]));
mux2$ m1_11(.outb(s1_11), .in1(in[10]), .in0(in[11]), .s0(s[0]));
mux2$ m1_12(.outb(s1_12), .in1(in[11]), .in0(in[12]), .s0(s[0]));
mux2$ m1_13(.outb(s1_13), .in1(in[12]), .in0(in[13]), .s0(s[0]));
mux2$ m1_14(.outb(s1_14), .in1(in[13]), .in0(in[14]), .s0(s[0]));
mux2$ m1_15(.outb(s1_15), .in1(in[14]), .in0(in[15]), .s0(s[0]));
mux2$ m1_16(.outb(s1_16), .in1(in[15]), .in0(in[16]), .s0(s[0]));
mux2$ m1_17(.outb(s1_17), .in1(in[16]), .in0(in[17]), .s0(s[0]));
mux2$ m1_18(.outb(s1_18), .in1(in[17]), .in0(in[18]), .s0(s[0]));
mux2$ m1_19(.outb(s1_19), .in1(in[18]), .in0(in[19]), .s0(s[0]));
mux2$ m1_20(.outb(s1_20), .in1(in[19]), .in0(in[20]), .s0(s[0]));
mux2$ m1_21(.outb(s1_21), .in1(in[20]), .in0(in[21]), .s0(s[0]));
mux2$ m1_22(.outb(s1_22), .in1(in[21]), .in0(in[22]), .s0(s[0]));
mux2$ m1_23(.outb(s1_23), .in1(in[22]), .in0(in[23]), .s0(s[0]));
mux2$ m1_24(.outb(s1_24), .in1(in[23]), .in0(in[24]), .s0(s[0]));
mux2$ m1_25(.outb(s1_25), .in1(in[24]), .in0(in[25]), .s0(s[0]));
mux2$ m1_26(.outb(s1_26), .in1(in[25]), .in0(in[26]), .s0(s[0]));
mux2$ m1_27(.outb(s1_27), .in1(in[26]), .in0(in[27]), .s0(s[0]));
mux2$ m1_28(.outb(s1_28), .in1(in[27]), .in0(in[28]), .s0(s[0]));
mux2$ m1_29(.outb(s1_29), .in1(in[28]), .in0(in[29]), .s0(s[0]));
mux2$ m1_30(.outb(s1_30), .in1(in[29]), .in0(in[30]), .s0(s[0]));
mux2$ m1_31(.outb(s1_31), .in1(in[30]), .in0(in[31]), .s0(s[0]));
mux2$ m1_c(.outb(s1_c), .in1(in[31]), .in0(1'b0), .s0(s[0]));

//stage 2 mux
mux2$ m2_0(.outb(s2_0), .in1(1'b0), .in0(s1_0), .s0(s[1]));
mux2$ m2_1(.outb(s2_1), .in1(1'b0), .in0(s1_1), .s0(s[1]));
mux2$ m2_2(.outb(s2_2), .in1(s1_0), .in0(s1_2), .s0(s[1]));
mux2$ m2_3(.outb(s2_3), .in1(s1_1), .in0(s1_3), .s0(s[1]));
mux2$ m2_4(.outb(s2_4), .in1(s1_2), .in0(s1_4), .s0(s[1]));
mux2$ m2_5(.outb(s2_5), .in1(s1_3), .in0(s1_5), .s0(s[1]));
mux2$ m2_6(.outb(s2_6), .in1(s1_4), .in0(s1_6), .s0(s[1]));
mux2$ m2_7(.outb(s2_7), .in1(s1_5), .in0(s1_7), .s0(s[1]));
mux2$ m2_8(.outb(s2_8), .in1(s1_6), .in0(s1_8), .s0(s[1]));
mux2$ m2_9(.outb(s2_9), .in1(s1_7), .in0(s1_9), .s0(s[1]));
mux2$ m2_10(.outb(s2_10), .in1(s1_8), .in0(s1_10), .s0(s[1]));
mux2$ m2_11(.outb(s2_11), .in1(s1_9), .in0(s1_11), .s0(s[1]));
mux2$ m2_12(.outb(s2_12), .in1(s1_10), .in0(s1_12), .s0(s[1]));
mux2$ m2_13(.outb(s2_13), .in1(s1_11), .in0(s1_13), .s0(s[1]));
mux2$ m2_14(.outb(s2_14), .in1(s1_12), .in0(s1_14), .s0(s[1]));
mux2$ m2_15(.outb(s2_15), .in1(s1_13), .in0(s1_15), .s0(s[1]));
mux2$ m2_16(.outb(s2_16), .in1(s1_14), .in0(s1_16), .s0(s[1]));
mux2$ m2_17(.outb(s2_17), .in1(s1_15), .in0(s1_17), .s0(s[1]));
mux2$ m2_18(.outb(s2_18), .in1(s1_16), .in0(s1_18), .s0(s[1]));
mux2$ m2_19(.outb(s2_19), .in1(s1_17), .in0(s1_19), .s0(s[1]));
mux2$ m2_20(.outb(s2_20), .in1(s1_18), .in0(s1_20), .s0(s[1]));
mux2$ m2_21(.outb(s2_21), .in1(s1_19), .in0(s1_21), .s0(s[1]));
mux2$ m2_22(.outb(s2_22), .in1(s1_20), .in0(s1_22), .s0(s[1]));
mux2$ m2_23(.outb(s2_23), .in1(s1_21), .in0(s1_23), .s0(s[1]));
mux2$ m2_24(.outb(s2_24), .in1(s1_22), .in0(s1_24), .s0(s[1]));
mux2$ m2_25(.outb(s2_25), .in1(s1_23), .in0(s1_25), .s0(s[1]));
mux2$ m2_26(.outb(s2_26), .in1(s1_24), .in0(s1_26), .s0(s[1]));
mux2$ m2_27(.outb(s2_27), .in1(s1_25), .in0(s1_27), .s0(s[1]));
mux2$ m2_28(.outb(s2_28), .in1(s1_26), .in0(s1_28), .s0(s[1]));
mux2$ m2_29(.outb(s2_29), .in1(s1_27), .in0(s1_29), .s0(s[1]));
mux2$ m2_30(.outb(s2_30), .in1(s1_28), .in0(s1_30), .s0(s[1]));
mux2$ m2_31(.outb(s2_31), .in1(s1_29), .in0(s1_31), .s0(s[1]));
mux2$ m2_c(.outb(s2_c), .in1(s1_30), .in0(s1_c), .s0(s[1]));

//stage 3 mux
mux2$ m3_0(.outb(s3_0), .in1(1'b0), .in0(s2_0), .s0(s[2]));
mux2$ m3_1(.outb(s3_1), .in1(1'b0), .in0(s2_1), .s0(s[2]));
mux2$ m3_2(.outb(s3_2), .in1(1'b0), .in0(s2_2), .s0(s[2]));
mux2$ m3_3(.outb(s3_3), .in1(1'b0), .in0(s2_3), .s0(s[2]));
mux2$ m3_4(.outb(s3_4), .in1(s2_0), .in0(s2_4), .s0(s[2]));
mux2$ m3_5(.outb(s3_5), .in1(s2_1), .in0(s2_5), .s0(s[2]));
mux2$ m3_6(.outb(s3_6), .in1(s2_2), .in0(s2_6), .s0(s[2]));
mux2$ m3_7(.outb(s3_7), .in1(s2_3), .in0(s2_7), .s0(s[2]));
mux2$ m3_8(.outb(s3_8), .in1(s2_4), .in0(s2_8), .s0(s[2]));
mux2$ m3_9(.outb(s3_9), .in1(s2_5), .in0(s2_9), .s0(s[2]));
mux2$ m3_10(.outb(s3_10), .in1(s2_6), .in0(s2_10), .s0(s[2]));
mux2$ m3_11(.outb(s3_11), .in1(s2_7), .in0(s2_11), .s0(s[2]));
mux2$ m3_12(.outb(s3_12), .in1(s2_8), .in0(s2_12), .s0(s[2]));
mux2$ m3_13(.outb(s3_13), .in1(s2_9), .in0(s2_13), .s0(s[2]));
mux2$ m3_14(.outb(s3_14), .in1(s2_10), .in0(s2_14), .s0(s[2]));
mux2$ m3_15(.outb(s3_15), .in1(s2_11), .in0(s2_15), .s0(s[2]));
mux2$ m3_16(.outb(s3_16), .in1(s2_12), .in0(s2_16), .s0(s[2]));
mux2$ m3_17(.outb(s3_17), .in1(s2_13), .in0(s2_17), .s0(s[2]));
mux2$ m3_18(.outb(s3_18), .in1(s2_14), .in0(s2_18), .s0(s[2]));
mux2$ m3_19(.outb(s3_19), .in1(s2_15), .in0(s2_19), .s0(s[2]));
mux2$ m3_20(.outb(s3_20), .in1(s2_16), .in0(s2_20), .s0(s[2]));
mux2$ m3_21(.outb(s3_21), .in1(s2_17), .in0(s2_21), .s0(s[2]));
mux2$ m3_22(.outb(s3_22), .in1(s2_18), .in0(s2_22), .s0(s[2]));
mux2$ m3_23(.outb(s3_23), .in1(s2_19), .in0(s2_23), .s0(s[2]));
mux2$ m3_24(.outb(s3_24), .in1(s2_20), .in0(s2_24), .s0(s[2]));
mux2$ m3_25(.outb(s3_25), .in1(s2_21), .in0(s2_25), .s0(s[2]));
mux2$ m3_26(.outb(s3_26), .in1(s2_22), .in0(s2_26), .s0(s[2]));
mux2$ m3_27(.outb(s3_27), .in1(s2_23), .in0(s2_27), .s0(s[2]));
mux2$ m3_28(.outb(s3_28), .in1(s2_24), .in0(s2_28), .s0(s[2]));
mux2$ m3_29(.outb(s3_29), .in1(s2_25), .in0(s2_29), .s0(s[2]));
mux2$ m3_30(.outb(s3_30), .in1(s2_26), .in0(s2_30), .s0(s[2]));
mux2$ m3_31(.outb(s3_31), .in1(s2_27), .in0(s2_31), .s0(s[2]));
mux2$ m3_c(.outb(s3_c), .in1(s2_28), .in0(s2_c), .s0(s[2]));

//stage 4 mux
mux2$ m4_0(.outb(s4_0), .in1(1'b0), .in0(s3_0), .s0(s[3]));
mux2$ m4_1(.outb(s4_1), .in1(1'b0), .in0(s3_1), .s0(s[3]));
mux2$ m4_2(.outb(s4_2), .in1(1'b0), .in0(s3_2), .s0(s[3]));
mux2$ m4_3(.outb(s4_3), .in1(1'b0), .in0(s3_3), .s0(s[3]));
mux2$ m4_4(.outb(s4_4), .in1(1'b0), .in0(s3_4), .s0(s[3]));
mux2$ m4_5(.outb(s4_5), .in1(1'b0), .in0(s3_5), .s0(s[3]));
mux2$ m4_6(.outb(s4_6), .in1(1'b0), .in0(s3_6), .s0(s[3]));
mux2$ m4_7(.outb(s4_7), .in1(1'b0), .in0(s3_7), .s0(s[3]));
mux2$ m4_8(.outb(s4_8), .in1(s3_0), .in0(s3_8), .s0(s[3]));
mux2$ m4_9(.outb(s4_9), .in1(s3_1), .in0(s3_9), .s0(s[3]));
mux2$ m4_10(.outb(s4_10), .in1(s3_2), .in0(s3_10), .s0(s[3]));
mux2$ m4_11(.outb(s4_11), .in1(s3_3), .in0(s3_11), .s0(s[3]));
mux2$ m4_12(.outb(s4_12), .in1(s3_4), .in0(s3_12), .s0(s[3]));
mux2$ m4_13(.outb(s4_13), .in1(s3_5), .in0(s3_13), .s0(s[3]));
mux2$ m4_14(.outb(s4_14), .in1(s3_6), .in0(s3_14), .s0(s[3]));
mux2$ m4_15(.outb(s4_15), .in1(s3_7), .in0(s3_15), .s0(s[3]));
mux2$ m4_16(.outb(s4_16), .in1(s3_8), .in0(s3_16), .s0(s[3]));
mux2$ m4_17(.outb(s4_17), .in1(s3_9), .in0(s3_17), .s0(s[3]));
mux2$ m4_18(.outb(s4_18), .in1(s3_10), .in0(s3_18), .s0(s[3]));
mux2$ m4_19(.outb(s4_19), .in1(s3_11), .in0(s3_19), .s0(s[3]));
mux2$ m4_20(.outb(s4_20), .in1(s3_12), .in0(s3_20), .s0(s[3]));
mux2$ m4_21(.outb(s4_21), .in1(s3_13), .in0(s3_21), .s0(s[3]));
mux2$ m4_22(.outb(s4_22), .in1(s3_14), .in0(s3_22), .s0(s[3]));
mux2$ m4_23(.outb(s4_23), .in1(s3_15), .in0(s3_23), .s0(s[3]));
mux2$ m4_24(.outb(s4_24), .in1(s3_16), .in0(s3_24), .s0(s[3]));
mux2$ m4_25(.outb(s4_25), .in1(s3_17), .in0(s3_25), .s0(s[3]));
mux2$ m4_26(.outb(s4_26), .in1(s3_18), .in0(s3_26), .s0(s[3]));
mux2$ m4_27(.outb(s4_27), .in1(s3_19), .in0(s3_27), .s0(s[3]));
mux2$ m4_28(.outb(s4_28), .in1(s3_20), .in0(s3_28), .s0(s[3]));
mux2$ m4_29(.outb(s4_29), .in1(s3_21), .in0(s3_29), .s0(s[3]));
mux2$ m4_30(.outb(s4_30), .in1(s3_22), .in0(s3_30), .s0(s[3]));
mux2$ m4_31(.outb(s4_31), .in1(s3_23), .in0(s3_31), .s0(s[3]));
mux2$ m4_c(.outb(s4_c), .in1(s3_24), .in0(s3_c), .s0(s[3]));

//stage 5 mux
mux2$ m5_0(.outb(s5_0), .in1(1'b0), .in0(s4_0), .s0(s[4]));
mux2$ m5_1(.outb(s5_1), .in1(1'b0), .in0(s4_1), .s0(s[4]));
mux2$ m5_2(.outb(s5_2), .in1(1'b0), .in0(s4_2), .s0(s[4]));
mux2$ m5_3(.outb(s5_3), .in1(1'b0), .in0(s4_3), .s0(s[4]));
mux2$ m5_4(.outb(s5_4), .in1(1'b0), .in0(s4_4), .s0(s[4]));
mux2$ m5_5(.outb(s5_5), .in1(1'b0), .in0(s4_5), .s0(s[4]));
mux2$ m5_6(.outb(s5_6), .in1(1'b0), .in0(s4_6), .s0(s[4]));
mux2$ m5_7(.outb(s5_7), .in1(1'b0), .in0(s4_7), .s0(s[4]));
mux2$ m5_8(.outb(s5_8), .in1(1'b0), .in0(s4_8), .s0(s[4]));
mux2$ m5_9(.outb(s5_9), .in1(1'b0), .in0(s4_9), .s0(s[4]));
mux2$ m5_10(.outb(s5_10), .in1(1'b0), .in0(s4_10), .s0(s[4]));
mux2$ m5_11(.outb(s5_11), .in1(1'b0), .in0(s4_11), .s0(s[4]));
mux2$ m5_12(.outb(s5_12), .in1(1'b0), .in0(s4_12), .s0(s[4]));
mux2$ m5_13(.outb(s5_13), .in1(1'b0), .in0(s4_13), .s0(s[4]));
mux2$ m5_14(.outb(s5_14), .in1(1'b0), .in0(s4_14), .s0(s[4]));
mux2$ m5_15(.outb(s5_15), .in1(1'b0), .in0(s4_15), .s0(s[4]));
mux2$ m5_16(.outb(s5_16), .in1(s4_0), .in0(s4_16), .s0(s[4]));
mux2$ m5_17(.outb(s5_17), .in1(s4_1), .in0(s4_17), .s0(s[4]));
mux2$ m5_18(.outb(s5_18), .in1(s4_2), .in0(s4_18), .s0(s[4]));
mux2$ m5_19(.outb(s5_19), .in1(s4_3), .in0(s4_19), .s0(s[4]));
mux2$ m5_20(.outb(s5_20), .in1(s4_4), .in0(s4_20), .s0(s[4]));
mux2$ m5_21(.outb(s5_21), .in1(s4_5), .in0(s4_21), .s0(s[4]));
mux2$ m5_22(.outb(s5_22), .in1(s4_6), .in0(s4_22), .s0(s[4]));
mux2$ m5_23(.outb(s5_23), .in1(s4_7), .in0(s4_23), .s0(s[4]));
mux2$ m5_24(.outb(s5_24), .in1(s4_8), .in0(s4_24), .s0(s[4]));
mux2$ m5_25(.outb(s5_25), .in1(s4_9), .in0(s4_25), .s0(s[4]));
mux2$ m5_26(.outb(s5_26), .in1(s4_10), .in0(s4_26), .s0(s[4]));
mux2$ m5_27(.outb(s5_27), .in1(s4_11), .in0(s4_27), .s0(s[4]));
mux2$ m5_28(.outb(s5_28), .in1(s4_12), .in0(s4_28), .s0(s[4]));
mux2$ m5_29(.outb(s5_29), .in1(s4_13), .in0(s4_29), .s0(s[4]));
mux2$ m5_30(.outb(s5_30), .in1(s4_14), .in0(s4_30), .s0(s[4]));
mux2$ m5_31(.outb(s5_31), .in1(s4_15), .in0(s4_31), .s0(s[4]));
mux2$ m5_c(.outb(s5_c), .in1(s4_16), .in0(s4_c), .s0(s[4]));

//stage 6 mux
mux2$ m6_0(.outb(s6_0), .in1(1'b0), .in0(s5_0), .s0(s[5]));
mux2$ m6_1(.outb(s6_1), .in1(1'b0), .in0(s5_1), .s0(s[5]));
mux2$ m6_2(.outb(s6_2), .in1(1'b0), .in0(s5_2), .s0(s[5]));
mux2$ m6_3(.outb(s6_3), .in1(1'b0), .in0(s5_3), .s0(s[5]));
mux2$ m6_4(.outb(s6_4), .in1(1'b0), .in0(s5_4), .s0(s[5]));
mux2$ m6_5(.outb(s6_5), .in1(1'b0), .in0(s5_5), .s0(s[5]));
mux2$ m6_6(.outb(s6_6), .in1(1'b0), .in0(s5_6), .s0(s[5]));
mux2$ m6_7(.outb(s6_7), .in1(1'b0), .in0(s5_7), .s0(s[5]));
mux2$ m6_8(.outb(s6_8), .in1(1'b0), .in0(s5_8), .s0(s[5]));
mux2$ m6_9(.outb(s6_9), .in1(1'b0), .in0(s5_9), .s0(s[5]));
mux2$ m6_10(.outb(s6_10), .in1(1'b0), .in0(s5_10), .s0(s[5]));
mux2$ m6_11(.outb(s6_11), .in1(1'b0), .in0(s5_11), .s0(s[5]));
mux2$ m6_12(.outb(s6_12), .in1(1'b0), .in0(s5_12), .s0(s[5]));
mux2$ m6_13(.outb(s6_13), .in1(1'b0), .in0(s5_13), .s0(s[5]));
mux2$ m6_14(.outb(s6_14), .in1(1'b0), .in0(s5_14), .s0(s[5]));
mux2$ m6_15(.outb(s6_15), .in1(1'b0), .in0(s5_15), .s0(s[5]));
mux2$ m6_16(.outb(s6_16), .in1(1'b0), .in0(s5_16), .s0(s[5]));
mux2$ m6_17(.outb(s6_17), .in1(1'b0), .in0(s5_17), .s0(s[5]));
mux2$ m6_18(.outb(s6_18), .in1(1'b0), .in0(s5_18), .s0(s[5]));
mux2$ m6_19(.outb(s6_19), .in1(1'b0), .in0(s5_19), .s0(s[5]));
mux2$ m6_20(.outb(s6_20), .in1(1'b0), .in0(s5_20), .s0(s[5]));
mux2$ m6_21(.outb(s6_21), .in1(1'b0), .in0(s5_21), .s0(s[5]));
mux2$ m6_22(.outb(s6_22), .in1(1'b0), .in0(s5_22), .s0(s[5]));
mux2$ m6_23(.outb(s6_23), .in1(1'b0), .in0(s5_23), .s0(s[5]));
mux2$ m6_24(.outb(s6_24), .in1(1'b0), .in0(s5_24), .s0(s[5]));
mux2$ m6_25(.outb(s6_25), .in1(1'b0), .in0(s5_25), .s0(s[5]));
mux2$ m6_26(.outb(s6_26), .in1(1'b0), .in0(s5_26), .s0(s[5]));
mux2$ m6_27(.outb(s6_27), .in1(1'b0), .in0(s5_27), .s0(s[5]));
mux2$ m6_28(.outb(s6_28), .in1(1'b0), .in0(s5_28), .s0(s[5]));
mux2$ m6_29(.outb(s6_29), .in1(1'b0), .in0(s5_29), .s0(s[5]));
mux2$ m6_30(.outb(s6_30), .in1(1'b0), .in0(s5_30), .s0(s[5]));
mux2$ m6_31(.outb(s6_31), .in1(1'b0), .in0(s5_31), .s0(s[5]));
mux2$ m6_c(.outb(s6_c), .in1(s5_0), .in0(s5_c), .s0(s[5]));

//stage 7 mux
mux2$ m7_0(.outb(s7_0), .in1(1'b0), .in0(s6_0), .s0(s[6]));
mux2$ m7_1(.outb(s7_1), .in1(1'b0), .in0(s6_1), .s0(s[6]));
mux2$ m7_2(.outb(s7_2), .in1(1'b0), .in0(s6_2), .s0(s[6]));
mux2$ m7_3(.outb(s7_3), .in1(1'b0), .in0(s6_3), .s0(s[6]));
mux2$ m7_4(.outb(s7_4), .in1(1'b0), .in0(s6_4), .s0(s[6]));
mux2$ m7_5(.outb(s7_5), .in1(1'b0), .in0(s6_5), .s0(s[6]));
mux2$ m7_6(.outb(s7_6), .in1(1'b0), .in0(s6_6), .s0(s[6]));
mux2$ m7_7(.outb(s7_7), .in1(1'b0), .in0(s6_7), .s0(s[6]));
mux2$ m7_8(.outb(s7_8), .in1(1'b0), .in0(s6_8), .s0(s[6]));
mux2$ m7_9(.outb(s7_9), .in1(1'b0), .in0(s6_9), .s0(s[6]));
mux2$ m7_10(.outb(s7_10), .in1(1'b0), .in0(s6_10), .s0(s[6]));
mux2$ m7_11(.outb(s7_11), .in1(1'b0), .in0(s6_11), .s0(s[6]));
mux2$ m7_12(.outb(s7_12), .in1(1'b0), .in0(s6_12), .s0(s[6]));
mux2$ m7_13(.outb(s7_13), .in1(1'b0), .in0(s6_13), .s0(s[6]));
mux2$ m7_14(.outb(s7_14), .in1(1'b0), .in0(s6_14), .s0(s[6]));
mux2$ m7_15(.outb(s7_15), .in1(1'b0), .in0(s6_15), .s0(s[6]));
mux2$ m7_16(.outb(s7_16), .in1(1'b0), .in0(s6_16), .s0(s[6]));
mux2$ m7_17(.outb(s7_17), .in1(1'b0), .in0(s6_17), .s0(s[6]));
mux2$ m7_18(.outb(s7_18), .in1(1'b0), .in0(s6_18), .s0(s[6]));
mux2$ m7_19(.outb(s7_19), .in1(1'b0), .in0(s6_19), .s0(s[6]));
mux2$ m7_20(.outb(s7_20), .in1(1'b0), .in0(s6_20), .s0(s[6]));
mux2$ m7_21(.outb(s7_21), .in1(1'b0), .in0(s6_21), .s0(s[6]));
mux2$ m7_22(.outb(s7_22), .in1(1'b0), .in0(s6_22), .s0(s[6]));
mux2$ m7_23(.outb(s7_23), .in1(1'b0), .in0(s6_23), .s0(s[6]));
mux2$ m7_24(.outb(s7_24), .in1(1'b0), .in0(s6_24), .s0(s[6]));
mux2$ m7_25(.outb(s7_25), .in1(1'b0), .in0(s6_25), .s0(s[6]));
mux2$ m7_26(.outb(s7_26), .in1(1'b0), .in0(s6_26), .s0(s[6]));
mux2$ m7_27(.outb(s7_27), .in1(1'b0), .in0(s6_27), .s0(s[6]));
mux2$ m7_28(.outb(s7_28), .in1(1'b0), .in0(s6_28), .s0(s[6]));
mux2$ m7_29(.outb(s7_29), .in1(1'b0), .in0(s6_29), .s0(s[6]));
mux2$ m7_30(.outb(s7_30), .in1(1'b0), .in0(s6_30), .s0(s[6]));
mux2$ m7_31(.outb(s7_31), .in1(1'b0), .in0(s6_31), .s0(s[6]));
mux2$ m7_c(.outb(s7_c), .in1(1'b0), .in0(s6_c), .s0(s[6]));

//stage 8 mux
mux2$ m8_0(.outb(out[0]), .in1(1'b0), .in0(s7_0), .s0(s[7]));
mux2$ m8_1(.outb(out[1]), .in1(1'b0), .in0(s7_1), .s0(s[7]));
mux2$ m8_2(.outb(out[2]), .in1(1'b0), .in0(s7_2), .s0(s[7]));
mux2$ m8_3(.outb(out[3]), .in1(1'b0), .in0(s7_3), .s0(s[7]));
mux2$ m8_4(.outb(out[4]), .in1(1'b0), .in0(s7_4), .s0(s[7]));
mux2$ m8_5(.outb(out[5]), .in1(1'b0), .in0(s7_5), .s0(s[7]));
mux2$ m8_6(.outb(out[6]), .in1(1'b0), .in0(s7_6), .s0(s[7]));
mux2$ m8_7(.outb(out[7]), .in1(1'b0), .in0(s7_7), .s0(s[7]));
mux2$ m8_8(.outb(out[8]), .in1(1'b0), .in0(s7_8), .s0(s[7]));
mux2$ m8_9(.outb(out[9]), .in1(1'b0), .in0(s7_9), .s0(s[7]));
mux2$ m8_10(.outb(out[10]), .in1(1'b0), .in0(s7_10), .s0(s[7]));
mux2$ m8_11(.outb(out[11]), .in1(1'b0), .in0(s7_11), .s0(s[7]));
mux2$ m8_12(.outb(out[12]), .in1(1'b0), .in0(s7_12), .s0(s[7]));
mux2$ m8_13(.outb(out[13]), .in1(1'b0), .in0(s7_13), .s0(s[7]));
mux2$ m8_14(.outb(out[14]), .in1(1'b0), .in0(s7_14), .s0(s[7]));
mux2$ m8_15(.outb(out[15]), .in1(1'b0), .in0(s7_15), .s0(s[7]));
mux2$ m8_16(.outb(out[16]), .in1(1'b0), .in0(s7_16), .s0(s[7]));
mux2$ m8_17(.outb(out[17]), .in1(1'b0), .in0(s7_17), .s0(s[7]));
mux2$ m8_18(.outb(out[18]), .in1(1'b0), .in0(s7_18), .s0(s[7]));
mux2$ m8_19(.outb(out[19]), .in1(1'b0), .in0(s7_19), .s0(s[7]));
mux2$ m8_20(.outb(out[20]), .in1(1'b0), .in0(s7_20), .s0(s[7]));
mux2$ m8_21(.outb(out[21]), .in1(1'b0), .in0(s7_21), .s0(s[7]));
mux2$ m8_22(.outb(out[22]), .in1(1'b0), .in0(s7_22), .s0(s[7]));
mux2$ m8_23(.outb(out[23]), .in1(1'b0), .in0(s7_23), .s0(s[7]));
mux2$ m8_24(.outb(out[24]), .in1(1'b0), .in0(s7_24), .s0(s[7]));
mux2$ m8_25(.outb(out[25]), .in1(1'b0), .in0(s7_25), .s0(s[7]));
mux2$ m8_26(.outb(out[26]), .in1(1'b0), .in0(s7_26), .s0(s[7]));
mux2$ m8_27(.outb(out[27]), .in1(1'b0), .in0(s7_27), .s0(s[7]));
mux2$ m8_28(.outb(out[28]), .in1(1'b0), .in0(s7_28), .s0(s[7]));
mux2$ m8_29(.outb(out[29]), .in1(1'b0), .in0(s7_29), .s0(s[7]));
mux2$ m8_30(.outb(out[30]), .in1(1'b0), .in0(s7_30), .s0(s[7]));
mux2$ m8_31(.outb(out[31]), .in1(1'b0), .in0(s7_31), .s0(s[7]));
mux2$ m8_c(.outb(c), .in1(1'b0), .in0(s7_c), .s0(s[7]));

endmodule