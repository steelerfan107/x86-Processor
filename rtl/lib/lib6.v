//--------------------------------------------------------
// Library parts VI
// -----------------
// EE382N-14945, Spring 2000.
// (Some are modified from those provided by Cascade Design Automation Corp).
// All module parts' name are appended with a "$" character.
// This part of the library consists of the following parts:
//
// sram128x8$ 		128 x 8-bit SRAM
// sram32x16$ 		32 x 16-bit SRAM
// sram32x32$ 		32 x 32-bit SRAM
//
//---------------------------------------------------------
//          S    R    A    M    :  128 x 8 bits
//
// Timing specs taken from CY7C128(55), Cypress Semiconductor.
//---------------------------------------------------------
module  sram128x8$ (A,DIO,OE,WR, CE);

	`define  t_DOE		25
	`define  t_HZ		17.5
        // t_HZCE = t_HZOE = t_HZWE = 17.5


	input [6:0] A;
	inout [7:0] DIO;
	input WR,OE;
	input CE;

	reg   [6:0] A_temp;
	reg   CE_temp;
	reg  [6:0] lastread_addr;
	reg din_changed,a_changed;
	reg [7:0] mem [127:0];
	event addr_unstable_memory;

always @(negedge WR or CE)
 if ((CE==0)&&(WR==0))
 begin: write_block
  mem[A] = 'bx;

  fork
   begin: wr_mem
     mem[A] = DIO;
   end
   forever @(DIO)
    begin
     disable wr_mem;
     mem[A] = DIO;
    end
    forever @(posedge WR or A)
     disable write_block;
   join
end

always @(A)
  begin
     if ((WR ==1)&&(CE==0))
      begin
       disable a_dout;
       a_changed =1;
      end
     else
     if (CE==0)
      begin
       $display("(WARNING) Address changed when WR was low at time %t",$realtime);
        -> addr_unstable_memory;
      end
  end

always @(addr_unstable_memory)
     begin
       mem[lastread_addr] ='bx;
       mem[A] = 'bx;
     end

always
     begin: a_dout
       wait(a_changed);
        a_changed = 0;
        lastread_addr = A;
     end

always@(CE)
   if ((WR==1)&&(OE==0)&&(CE==0))
	#35 CE_temp = CE;    
   else
	CE_temp = CE;

always@(A)
   if ((WR==1)&&(OE==0)&&(CE==0))
	#35 A_temp = A;   //t_AA = 35 + t_DOE = 60
   else
	A_temp = A;


assign #(`t_DOE,`t_DOE,`t_HZ) 
	DIO= ((WR==1)&&(OE==0)&&(CE_temp==0))?mem[A_temp]:8'bzzzz;
assign  #(`t_HZ)              DIO= (WR)? 8'bzzzz:8'bzzzz;

specify
        specparam
          //addr_hold_time =0, data_hold_time=0, 
	  address_setup_time=25,			//t_AW  = 25
	  data_setup_time=25,				//t_SD  = 25
	  CE_setup_time=35,				//t_SCE = 35
          write_pulse_low=25,				//t_PWE = 25
	  cycle_time=75;				//t_RC  = 75
	$setup(A, negedge WR, address_setup_time);	//address setup check
	$setup(DIO, posedge WR, data_setup_time);	//data setup check
	$setup(negedge CE, posedge WR, CE_setup_time);	//CE setup check
	$width(negedge WR, write_pulse_low); 		//WR low width check
	$period(posedge WR, cycle_time);		//cycle time check
   endspecify
endmodule

//---------------------------------------------------------
//          S    R    A    M    :  32 x 8 bits
//
// Timing specs taken from CY7C128(55), Cypress Semiconductor.
//---------------------------------------------------------
module  sram32x8$ (A,DIO,OE,WR, CE);

	
	`define  t_DOE		25
	`define  t_HZ		17.5
        // t_HZCE = t_HZOE = t_HZWE = 17.5


	input [4:0] A;
	inout [7:0] DIO;
	input WR,OE;
	input CE;

	reg   [4:0] A_temp;
	reg   CE_temp;
	reg  [4:0] lastread_addr;
	reg din_changed,a_changed;
	reg [7:0] mem [31:0];
	event addr_unstable_memory;

always @(negedge WR or CE)
 if ((CE==0)&&(WR==0))
 begin: write_block
  mem[A] = 'bx;

  fork
   begin: wr_mem
     mem[A] = DIO;
   end
   forever @(DIO)
    begin
     disable wr_mem;
     mem[A] = DIO;
    end
    forever @(posedge WR or A)
     disable write_block;
   join
end

always @(A)
  begin
     if ((WR ==1)&&(CE==0))
      begin
       disable a_dout;
       a_changed =1;
      end
     else
     if (CE==0)
      begin
       $display("(WARNING) Address changed when WR was low at time %t",$realtime);
        -> addr_unstable_memory;
      end
  end

always @(addr_unstable_memory)
     begin
       mem[lastread_addr] ='bx;
       mem[A] = 'bx;
     end

always
     begin: a_dout
       wait(a_changed);
        a_changed = 0;
        lastread_addr = A;
     end

always@(CE)
   if ((WR==1)&&(OE==0)&&(CE==0))
	#35 CE_temp = CE;    
   else
	CE_temp = CE;

always@(A)
   if ((WR==1)&&(OE==0)&&(CE==0))
	#35 A_temp = A;   
   else
	A_temp = A;


assign #(`t_DOE,`t_DOE,`t_HZ) 
	DIO= ((WR==1)&&(OE==0)&&(CE_temp==0))?mem[A_temp]:8'bzzzz;
assign  #(`t_HZ)              DIO= (WR)? 8'bzzzz:8'bzzzz;

specify
        specparam
          //addr_hold_time =0, data_hold_time=0, 
	  address_setup_time=25,			//t_AW  = 25
	  data_setup_time=25,				//t_SD  = 25
	  CE_setup_time=37.5,				//t_SCE = 37.5
          write_pulse_low=25,				//t_PWE = 25
	  cycle_time=75;				//t_RC  = 75
	$setup(A, negedge WR, address_setup_time);	//address setup check
	$setup(DIO, posedge WR, data_setup_time);	//data setup check
	$setup(negedge CE, posedge WR, CE_setup_time);	//CE setup check
	$width(negedge WR, write_pulse_low); 		//WR low width check
	$period(posedge WR, cycle_time);		//cycle time check
   endspecify
endmodule

module	sram32x16$(A,DIO,OE,WRH,WRL,CE);

	input [4:0] A;
	inout [15:0] DIO;
	input WRH, WRL, OE, CE;
	
	sram32x8$	ram1(A, DIO[15:8], OE, WRH, CE),
			ram2(A, DIO[7:0], OE, WRL, CE);

endmodule
/*------------------------------------------------------------------
module sram_test;

reg [6:0] A;
tri [7:0] DIO;
reg [7:0] DIO_reg;
reg WR,OE;
reg CE;
reg en;

bufif1 buffer0(DIO[0], DIO_reg[0], en);
bufif1 buffer1(DIO[1], DIO_reg[1], en);
bufif1 buffer2(DIO[2], DIO_reg[2], en);
bufif1 buffer3(DIO[3], DIO_reg[3], en);
bufif1 buffer4(DIO[4], DIO_reg[4], en);
bufif1 buffer5(DIO[5], DIO_reg[5], en);
bufif1 buffer6(DIO[6], DIO_reg[6], en);
bufif1 buffer7(DIO[7], DIO_reg[7], en);

sram128x8$ ram(A,DIO,OE,WR, CE);

//initial $readmemh("mem.data",ram.mem);

initial ram.mem[0] = 0;

initial 
$monitor("%t A=%h, en=%b, DIO=%h, OE=%h, WR=%h, CE=%h, ram.mem[0]=%h",
	$time, A, en, DIO, OE, WR, CE, ram.mem[0]);


initial
begin 
	WR=1;
	CE=1;
	OE=1;
	en=1;
	A=0;
	#10 
	CE=0;
	DIO_reg = 'hf;
	#50 
	WR=0;
	#100 
	WR=1;
	CE=1;
	#100
$strobe("end of write cycle, ram.mem[0]=%h",ram.mem[0]);

	#100
	en=0;
	CE=0;
	OE=0;
	#150
//read the valid data here, before CE=1;
	CE=1;
	#100
$strobe("end of read cycle, DIO = %h,ram.mem[0]=%h",DIO, ram.mem[0]);

	#100
	CE=0;
	en=1;
	A=0;
	DIO_reg = 'h8;
	#50 
	WR=0;
	#100 
	WR=1;
	CE=1;
	en=0;
	#100
$strobe("end of write cycle, ram.mem[0]=%h",ram.mem[0]);

	#100
	CE=0;
	#150
//read the valid data here, before CE=1;
	CE=1;
	#100
$strobe("end of read cycle, DIO=%h, ram.mem[0]=%h",DIO, ram.mem[0]);
	#100
	$stop;

end
endmodule
*/

/*------------------------------------------------------------------
New traces:

VERILOG-XL 1.6   Mar 12, 1993  15:36:51
  * Copyright Cadence Design Systems, Inc. 1985, 1988.    *
  *     All Rights Reserved.       Licensed Software.     *
  * Confidential and proprietary information which is the *
  *      property of Cadence Design Systems, Inc.         *
Compiling source file "lib6"
Highest level modules:
sram_test

                   0 A=00, en=1, DIO=xx, OE=1, WR=1, CE=1, ram.mem[0]=00
                  10 A=00, en=1, DIO=xx, OE=1, WR=1, CE=0, ram.mem[0]=00
                  35 A=00, en=1, DIO=0f, OE=1, WR=1, CE=0, ram.mem[0]=00
                  60 A=00, en=1, DIO=0f, OE=1, WR=0, CE=0, ram.mem[0]=0f
                 160 A=00, en=1, DIO=0f, OE=1, WR=1, CE=1, ram.mem[0]=0f
end of write cycle, ram.mem[0]=0f
                 360 A=00, en=0, DIO=zz, OE=0, WR=1, CE=0, ram.mem[0]=0f
                 480 A=00, en=0, DIO=0f, OE=0, WR=1, CE=0, ram.mem[0]=0f
                 510 A=00, en=0, DIO=0f, OE=0, WR=1, CE=1, ram.mem[0]=0f
                 545 A=00, en=0, DIO=zz, OE=0, WR=1, CE=1, ram.mem[0]=0f
end of read cycle, DIO = zz,ram.mem[0]=0f
                 710 A=00, en=1, DIO=08, OE=0, WR=1, CE=0, ram.mem[0]=0f
                 760 A=00, en=1, DIO=08, OE=0, WR=0, CE=0, ram.mem[0]=08
                 860 A=00, en=0, DIO=zz, OE=0, WR=1, CE=1, ram.mem[0]=08
end of write cycle, ram.mem[0]=08
                1060 A=00, en=0, DIO=zz, OE=0, WR=1, CE=0, ram.mem[0]=08
                1180 A=00, en=0, DIO=08, OE=0, WR=1, CE=0, ram.mem[0]=08
                1210 A=00, en=0, DIO=08, OE=0, WR=1, CE=1, ram.mem[0]=08
                1245 A=00, en=0, DIO=zz, OE=0, WR=1, CE=1, ram.mem[0]=08
end of read cycle, DIO=zz, ram.mem[0]=08
L199 "lib6": $stop at simulation time 1410
Type ? for help
C1 > 
C1 > 308 simulation events + 85 accelerated events + 115 timing check events
CPU time: 0 secs to compile + 0 secs to link + 0 secs in simulation
End of VERILOG-XL 1.6   Mar 12, 1993  15:37:36

------------------------------------------------------------------*/

//---------------------------------------------------------
//          S    R    A    M    :  32 x 32 bits
//
// Timing specs taken from CY7C128(55), Cypress Semiconductor.
//---------------------------------------------------------
module  sram32x32$ (A,DIO,OE,WR, CE);

	`define  t_DOE		25
	`define  t_HZ		17.5
	// t_HZCE = t_HZOE = t_HZWE = 17.5


	input [4:0] A;
	inout [31:0] DIO;
	input WR,OE;
	input CE;
	//output [31:0] DOUT;

	//reg  [31:0] DOUT,ramout;
	reg   [4:0] A_temp;
	reg   CE_temp;
	reg  [4:0] lastread_addr;
	reg din_changed,a_changed;
	reg [31:0] mem [31:0];
	event addr_unstable_memory;

always @(negedge WR or CE)
 if ((CE==0)&&(WR==0))
 begin: write_block
  mem[A] = 'bx;

  fork
   begin: wr_mem
     mem[A] = DIO;
   end
   forever @(DIO)
    begin
     disable wr_mem;
     mem[A] = DIO;
    end
    forever @(posedge WR or A)
     disable write_block;
   join
end

always @(A)
  begin
     if ((WR ==1)&&(CE==0))
      begin
       disable a_dout;
       a_changed =1;
      end
     else
     if (CE==0)
      begin
       $display("(WARNING) Address changed when WR was low at time %t",$realtime);
        -> addr_unstable_memory;
      end
  end

always @(addr_unstable_memory)
     begin
       mem[lastread_addr] ='bx;
       mem[A] = 'bx;
     end

always
     begin: a_dout
       wait(a_changed);
        a_changed = 0;
        lastread_addr = A;
     end

always@(CE)
   if ((WR==1)&&(OE==0)&&(CE==0))
	#35 CE_temp = CE;   //t_ACE = 70 + t_DOE = 120 
   else
	CE_temp = CE;

always@(A)
   if ((WR==1)&&(OE==0)&&(CE==0))
	#35 A_temp = A;   
   else
	A_temp = A;


assign #(`t_DOE,`t_DOE,`t_HZ) 
	DIO= ((WR==1)&&(OE==0)&&(CE_temp==0))?mem[A_temp]:32'bzzzz;
assign  #(`t_HZ)              DIO= (WR)? 32'bzzzz:32'bzzzz;

specify
        specparam
          //addr_hold_time =0, data_hold_time=0, 
	  address_setup_time=25,			//t_AW  = 25
	  data_setup_time=25,				//t_SD  = 25
	  CE_setup_time=37.5,				//t_SCE = 37.5
          write_pulse_low=25,				//t_PWE = 25
	  cycle_time=75;				//t_RC  = 75
	$setup(A, negedge WR, address_setup_time);	//address setup check
	$setup(DIO, posedge WR, data_setup_time);	//data setup check
	$setup(negedge CE, posedge WR, CE_setup_time);	//CE setup check
	$width(negedge WR, write_pulse_low); 		//WR low width check
	$period(posedge WR, cycle_time);		//cycle time check
   endspecify
endmodule

