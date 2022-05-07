/*Supporting only OF [5], SF [4], ZF [3], AF [2], CF [1], and PF [0] flags
ADD: The OF, SF, ZF, AF, CF, and PF flags are set according to the result.'

AND: The OF and CF flags are cleared; the SF, ZF, and PF flags are set according to the result. The
state of the AF flag is undefined. 

BSF: The ZF flag is set to 1 if all the source operand is 0; otherwise, the ZF flag is cleared. The CF,
OF, SF, AF, and PF, flags are undefined.

CALL: none

CLD: The DF flag is set to 0. The CF, OF, ZF, SF, AF, and PF flags are unaffected.

CMOVC: None.

CMPXCHG: The ZF flag is set if the values in the destination operand and register AL, AX, or EAX are equal;
otherwise it is cleared. The CF, PF, AF, SF, and OF flags are set according to the results of the
comparison operation.

DAA: The CF and AF flags are set if the adjustment of the value results in a decimal carry in either
digit of the result (see the “Operation” section above). The SF, ZF, and PF flags are set according
to the result. The OF flag is undefined.

HLT: None. 

IRetd: None?

JNBE/JNE/JMP: None.

MOV/MOVQ/MOVS: None. 

NOT: None. 

OR: The OF and CF flags are cleared; the SF, ZF, and PF flags are set according to the result. The
state of the AF flag is undefined.

PADDW/PADDD: None.

PMAX/MINSW: None. 

PUSH/POP: None. 

REP MOVS: None. 

RET: None. 

SAL/SAR: The CF flag contains the value of the last bit shifted out of the destination operand. 
The OF flag is affected only for 1-bit shifts, otherwise, it is undefined. 
The SF, ZF, and PF flags are set according to the result. If the
count is 0, the flags are not affected. For a non-zero count, the AF flag is undefined.

STD: The DF flag is set. The CF, OF, ZF, SF, AF, and PF flags are unaffected.

XCHG: None. 
*/
`timescale 1ns / 1ps
module eflags(eflags_in, set_eflags, eflags_out);
input [6:0] eflags_in;
input [6:0] set_eflags;
output [6:0] eflags_out;

latch$ DF(.d(eflags_in[6]), .en(set_eflags[6]), .q(eflags_out[6]));
latch$ OF(.d(eflags_in[5]), .en(set_eflags[5]), .q(eflags_out[5]));
latch$ SF(.d(eflags_in[4]), .en(set_eflags[4]), .q(eflags_out[4]));
latch$ ZF(.d(eflags_in[3]), .en(set_eflags[3]), .q(eflags_out[3]));
latch$ AF(.d(eflags_in[2]), .en(set_eflags[2]), .q(eflags_out[2]));
latch$ CF(.d(eflags_in[1]), .en(set_eflags[1]), .q(eflags_out[1]));
latch$ PF(.d(eflags_in[0]), .en(set_eflags[0]), .q(eflags_out[0]));

endmodule