//--------------------------------------------------------
// Library parts III
// -----------------
// EE382N-14945, Spring 2000.
// (Some are modified from those provided by Cascade Design Automation Corp).
// All module parts' name are appended with a "$" character.
// This part of the library consists of the following parts:
//
// regfile$		16x8bits double-read port register files
// regfile8x8$		8x8bits  double-read port register files
// ram16b8w$ 		16-bits x 8 words RAM
// ram8b8w$ 		8-bits x 8 words RAM
// ram8b4w$ 		8-bits x 4 words RAM
// rom4b32w$		4-bits x 32 words ROM
// rom32b32w$		32-bits x 32 words ROM
// rom64b32w$		64-bits x 32 words ROM
//
//---------------------------------------------------------
//       r e g i s t e r      f i l e :    16 x 8-bits 
//		     (two read ports only)
//           (timing specs taken from page 2-95)
//---------------------------------------------------------
  module regfile$(IN0,R1,R2,RE1,RE2,W,WE,OUT1,OUT2,CLOCK);
//module regfile$(IN0,R1,   RE1,    W,WE,OUT1,     CLOCK);
  input [7:0] IN0;
  input [3:0] R1;
  input [3:0] R2;
  //   wire [3:0] R2;
  input  RE1;
  input  RE2;
  //   wire  RE2;
  input [3:0] W;
  input  WE;
  input CLOCK;
  output [7:0] OUT1;
  output [7:0] OUT2;
  //    wire [7:0] OUT2;
  wire [7:0] IN0_temp;
  wire [3:0] R1_temp;
  wire [3:0] R2_temp;
  wire  RE1_temp;
  wire  RE2_temp;
  wire [3:0] W_temp;
  wire  WE_temp;
  reg [7:0] OUT1_temp;
  reg [7:0] OUT2_temp;
  reg  flag1;
  reg  flag2;
  reg [7:0] mem_array[15:0];
  assign IN0_temp = IN0;
  assign #(0.8:0.86:0.92) R1_temp = R1;
  assign #(0.8:0.86:0.92) R2_temp = R2;
  assign #(0.18:0.20:0.22) RE1_temp = RE1;
  assign #(0.18:0.20:0.22) RE2_temp = RE2;
  assign W_temp = W;
  assign WE_temp = WE;
  assign OUT1 = OUT1_temp;
  assign OUT2 = OUT2_temp;
  initial
    begin
    flag1 = 1'b0;
    flag2 = 1'b0;
    end
  always
    @(posedge CLOCK)
    //@(W_temp or WE_temp or IN0_temp)
      begin
      if((WE_temp == 1'b1))
        begin
        if(((W_temp >= 0) && (W_temp < 16)))
          begin
          mem_array[W_temp] = IN0_temp;
          if((W_temp == R1_temp))
            flag1 = ( ~ flag1);
          if((W_temp == R2_temp))
            flag2 = ( ~ flag2);
          end
        else
          begin
          $display("(Error) Illegal value on W pin of regfile");
          end
        end
      end
  always
    @(flag1 or RE1_temp or R1_temp)
      begin
      if((RE1_temp == 1'b1))
        if(((R1_temp >= 0) && (R1_temp < 16)))
          #(0.18:0.20:0.22) OUT1_temp = mem_array[R1_temp];
        else
          #(0.18:0.20:0.22) OUT1_temp = 'bx;
      else
        #(0.18:0.20:0.22) OUT1_temp = 'bz;
      end
  always
    @(flag2 or RE2_temp or R2_temp)
      begin
      if((RE2_temp == 1'b1))
        if(((R2_temp >= 0) && (R2_temp < 16)))
          #(0.18:0.20:0.22) OUT2_temp = mem_array[R2_temp];
        else
          #(0.18:0.20:0.22) OUT2_temp = 'bx;
      else
        #(0.18:0.20:0.22) OUT2_temp = 'bz;
      end
  specify
    $setup(W , posedge CLOCK,  0.46:0.50:0.54);
    $setup(WE, posedge CLOCK,  0.46:0.50:0.54);
    $setup(IN0,posedge CLOCK,  0.46:0.50:0.54);
    //$setup(R1, edge[01,x1] RE1,1.1:1.4:1.8);//read operations are not clocked.
    //$setup(R2, edge[01,x1] RE2,1.1:1.4:1.8);
  endspecify
endmodule


//---------------------------------------------------------
//       r e g i s t e r      f i l e :    8 x 8-bits 
//		     (two read ports only)
//           (timing specs taken from page 2-95)
//---------------------------------------------------------
 module regfile8x8$(IN0,R1,R2,RE1,RE2,W,WE,OUT1,OUT2,CLOCK);
 // module regfile8x8$(IN0,R1,   RE1,    W,WE,OUT1,     CLOCK);
  input [7:0] IN0;
  input [2:0] R1;
  input [2:0] R2;
  //   wire [2:0] R2;
  input  RE1;
  input  RE2;
  //   wire  RE2;
  input [2:0] W;
  input  WE;
  input CLOCK;
  output [7:0] OUT1;
  output [7:0] OUT2;
  //    wire [7:0] OUT2;
  wire [7:0] IN0_temp;
  wire [2:0] R1_temp;
  wire [2:0] R2_temp;
  wire  RE1_temp;
  wire  RE2_temp;
  wire [2:0] W_temp;
  wire  WE_temp;
  reg [7:0] OUT1_temp;
  reg [7:0] OUT2_temp;
  reg  flag1;
  reg  flag2;
  reg [7:0] mem_array[7:0];

  wire [7:0] REG0;
  wire [7:0] REG1;
  wire [7:0] REG2;
  wire [7:0] REG3;
  wire [7:0] REG4;
  wire [7:0] REG5;
  wire [7:0] REG6;
  wire [7:0] REG7;

  assign REG0 = mem_array[0];
  assign REG1 = mem_array[1];
  assign REG2 = mem_array[2];
  assign REG3 = mem_array[3];
  assign REG4 = mem_array[4];
  assign REG5 = mem_array[5];
  assign REG6 = mem_array[6];
  assign REG7 = mem_array[7];

  assign IN0_temp = IN0;
  assign #(0.9:1.1:1.3) R1_temp = R1;
  assign #(0.9:1.1:1.3) R2_temp = R2;
  assign #(0.18:0.20:0.22) RE1_temp = RE1;
  assign #(0.18:0.20:0.22) RE2_temp = RE2;
  assign W_temp = W;
  assign WE_temp = WE;
  assign OUT1 = OUT1_temp;
  assign OUT2 = OUT2_temp;
  initial
    begin
    flag1 = 1'b0;
    flag2 = 1'b0;
    end
  always
    @(posedge CLOCK)
    //@(W_temp or WE_temp or IN0_temp)
      begin
      if((WE_temp == 1'b1))
        begin
        if(((W_temp >= 0) && (W_temp < 16)))
          begin
          mem_array[W_temp] = IN0_temp;
          if((W_temp == R1_temp))
            flag1 = ( ~ flag1);
          if((W_temp == R2_temp))
            flag2 = ( ~ flag2);
          end
        else
          begin
          $display("(Error) Illegal value on W pin of regfile");
          end
        end
      end
  always
    @(flag1 or RE1_temp or R1_temp)
      begin
      if((RE1_temp == 1'b1))
        if(((R1_temp >= 0) && (R1_temp < 8)))
          #(0.18:0.20:0.22) OUT1_temp = mem_array[R1_temp];
        else
          #(0.18:0.20:0.22) OUT1_temp = 'bx;
      else
        #(0.18:0.20:0.22) OUT1_temp = 'bz;
      end
  always
    @(flag2 or RE2_temp or R2_temp)
      begin
      if((RE2_temp == 1'b1))
        if(((R2_temp >= 0) && (R2_temp < 8)))
          #(0.18:0.20:0.22) OUT2_temp = mem_array[R2_temp];
        else
          #(0.18:0.20:0.22) OUT2_temp = 'bx;
      else
        #(0.18:0.20:0.22) OUT2_temp = 'bz;
      end
  specify
    $setup(W , posedge CLOCK,  0.46:0.50:0.54);
    $setup(WE, posedge CLOCK,  0.46:0.50:0.54);
    $setup(IN0,posedge CLOCK,  0.46:0.50:0.54);
    //$setup(R1, edge[01,x1] RE1,1.1:1.4:1.8);//read operations are not clocked.
    //$setup(R2, edge[01,x1] RE2,1.1:1.4:1.8);
  endspecify
endmodule


//---------------------------------------------------------
//            R    A    M    :  8-bits x 8 words
//
//           (timing specs taken from page 3-11)
//---------------------------------------------------------
module  ram8b8w$ (A,DIN,OE,WR, DOUT);

	`define  access_dly    1.7:2.0:2.3	// t_acc(A)
	`define  din_dout_dly  0.7:0.8:0.9	// t_d(DIN-DOUT)
	`define  wr_dout_dly   0.7:0.8:0.9	// t_d(WR-DOUT)
	`define  wr_to_ramcell  0		// Time to toggle ramcell()
	`define  valid2z_dly	0		// t_pvz
	`define  z2valid_dly 	0		// t_pzv


	input [2:0] A;
	input [7:0] DIN;
	input WR,OE;
	output [7:0] DOUT;

	reg  [7:0] DOUT,ramout;
	reg  [2:0] lastread_addr,lastwrite_addr;
	reg wr_cycle_check;
	reg read_cycle_check;
	reg addr_hold_flag,addr_setup_flag;
	reg data_hold_flag,data_setup_flag;
	reg din_changed,a_changed;
	reg output_enable;
	reg [7:0] mem [7:0];
	event addr_unstable_memory;

always @(negedge WR)
 begin: write_block
  mem[A] = 'bx;

  fork
   begin: wr_dout
     ramout = #(`wr_dout_dly) DIN;
   end
   begin: wr_mem
     mem[A] = #(`wr_to_ramcell) DIN;
   end
   forever @(DIN)
    begin
     disable wr_dout;
     disable wr_mem;
     disable in_dout;
     disable din_mem;
     mem[A] = 'bx;
     din_changed =1;
    end
   forever
     begin: in_dout
      wait (din_changed);
      ramout = #(`din_dout_dly) DIN;
      din_changed = 0;
     end
   forever
     begin: din_mem
      wait (din_changed);
      mem[A] = #(`wr_to_ramcell) DIN;
      din_changed = 0;
     end
    forever @(posedge WR or A)
     disable write_block;
   join
end
always @(A)
  begin
     if (WR ==1)
      begin
       disable a_dout;
       a_changed =1;
      end
     else if (WR ==0)
      begin
       $display("(WARNING) %m:Address A changed when WR was low at time ",$time);
        -> addr_unstable_memory;
        ramout = 'bx;
      end
     else if (WR==1'bx)
      begin
       disable a_dout;
       a_changed =1;
       $display("(WARNING) %m:Address A changed when WR was low at time ",$time);
        -> addr_unstable_memory;
      end
  end

always @(posedge WR)
  lastwrite_addr = A;

always @(addr_unstable_memory)
     begin
       mem[lastread_addr] ='bx;
       mem[A] = 'bx;
     end


  always
     begin: a_dout
       wait(a_changed);
        ramout = #(`access_dly) mem[A];
        a_changed = 0;
        lastread_addr = A;
     end

always @(posedge addr_hold_flag )
  begin
     mem[lastwrite_addr] = 'bx;
     #0.2 addr_hold_flag = 0;
   end
always @(posedge addr_setup_flag)
   begin
     disable write_block;
     mem[A] = 'bx;
     #0.2 addr_setup_flag = 0;
   end
always @(posedge data_hold_flag)
   begin
      mem[lastwrite_addr] = 'bx;
      #0.2 data_hold_flag =0;
   end
always @(posedge data_setup_flag)
   begin
      mem[A] = 'bx;
      ramout = 'bx;
      #0.2 data_setup_flag =0;
   end
always @(ramout)
   begin
       if (OE == 0 )
        begin
         disable output_something;
         DOUT = ramout;
        end
  end
always @(OE)
       begin
          disable output_something;
          output_enable =1 ;
       end
always
     begin: output_something
      wait(output_enable);
      output_enable = 0;
      if (OE == 0)
        DOUT = #(`z2valid_dly) ramout;
      else if (OE == 1)
        DOUT = #(`valid2z_dly) 'bz;
      else
        DOUT = #(0.5*`valid2z_dly+0.5*`z2valid_dly) 'bx;
end

specify
        specparam
          addr_hold_time =0, addr_setup_time=1.0:1.2:1.4,//t_setup(A)
          data_hold_time=0, data_setup_time=0.04:0.06:0.08,//t_setup(DIN)
          write_pulse_low=1.0:1.2:1.4,			//t_wpl
	  write_pulse_high=1.0:1.2:1.4;		//t_rc(WR)
	$setup(A, negedge WR, addr_setup_time); 	//address setup check
	$setup(DIN, posedge WR,data_setup_time);	//data setup check
	$width(negedge WR, write_pulse_low); 		//WR low width check
	$width(posedge WR, write_pulse_high);		//read cycle check
	$setup(A, posedge WR, 1.1:1.3:1.7);		//t_wc(WR)

   endspecify
endmodule
//---------------------------------------------------------
//            R    A    M    :  16-bits x 8 words
//
//           (timing specs taken from page 3-11)
//---------------------------------------------------------
module	ram16b8w$ (A, DIN, OE, WRH, WRL, DOUT);

	input [2:0] A;
	input [15:0] DIN;
	input WRH, WRL, OE;
	output [15:0] DOUT;
	wire [7:0] DOUT1;
	wire [7:0] DOUT2;

	ram8b8w$	ram1(A, DIN[15:8], OE, WRH, DOUT1),
			ram2(A, DIN[7:0], OE, WRL, DOUT2);

assign	DOUT = ({DOUT1, DOUT2});
endmodule



//---------------------------------------------------------
//            R    A    M    :  8-bits x 4 words
//
//           (timing specs taken from page 3-11)
//---------------------------------------------------------
module  ram8b4w$ (A,DIN,OE,WR, DOUT);

	`define  access_dly    1.7:2.0:2.3	// t_acc(A)
	`define  din_dout_dly  0.7:0.8:0.9	// t_d(DIN-DOUT)
	`define  wr_dout_dly   0.7:0.8:0.9	// t_d(WR-DOUT)
	`define  wr_to_ramcell  0		// Time to toggle ramcell()
	`define  valid2z_dly	0		// t_pvz
	`define  z2valid_dly 	0		// t_pzv


	input [1:0] A;
	input [7:0] DIN;
	input WR,OE;
	output [7:0] DOUT;

	reg  [7:0] DOUT,ramout;
	reg  [1:0] lastread_addr,lastwrite_addr;
	reg wr_cycle_check;
	reg read_cycle_check;
	reg addr_hold_flag,addr_setup_flag;
	reg data_hold_flag,data_setup_flag;
	reg din_changed,a_changed;
	reg output_enable;
	reg [7:0] mem [3:0];
	event addr_unstable_memory;

always @(negedge WR)
 begin: write_block
  mem[A] = 'bx;

  fork
   begin: wr_dout
     ramout = #(`wr_dout_dly) DIN;
   end
   begin: wr_mem
     mem[A] = #(`wr_to_ramcell) DIN;
   end
   forever @(DIN)
    begin
     disable wr_dout;
     disable wr_mem;
     disable in_dout;
     disable din_mem;
     mem[A] = 'bx;
     din_changed =1;
    end
   forever
     begin: in_dout
      wait (din_changed);
      ramout = #(`din_dout_dly) DIN;
      din_changed = 0;
     end
   forever
     begin: din_mem
      wait (din_changed);
      mem[A] = #(`wr_to_ramcell) DIN;
      din_changed = 0;
     end
    forever @(posedge WR or A)
     disable write_block;
   join
end

always @(A)
  begin
     if (WR ==1)
      begin
       disable a_dout;
       a_changed =1;
      end
     else if (WR ==0)
      begin
       $display("(WARNING) %m:Address A changed when WR was low at time ",$time);
        -> addr_unstable_memory;
        ramout = 'bx;
      end
     else if (WR==1'bx)
      begin
       disable a_dout;
       a_changed =1;
       $display("(WARNING) %m:Address A changed when WR was low at time ",$time);
        -> addr_unstable_memory;
      end
  end
always @(posedge WR)
  lastwrite_addr = A;

always @(addr_unstable_memory)
     begin
       mem[lastread_addr] ='bx;
       mem[A] = 'bx;
     end


  always
     begin: a_dout
       wait(a_changed);
        ramout = #(`access_dly) mem[A];
        a_changed = 0;
        lastread_addr = A;
     end

always @(posedge addr_hold_flag )
  begin
     mem[lastwrite_addr] = 'bx;
     #0.2 addr_hold_flag = 0;
   end
always @(posedge addr_setup_flag)
   begin
     disable write_block;
     mem[A] = 'bx;
     #0.2 addr_setup_flag = 0;
   end
always @(posedge data_hold_flag)
   begin
      mem[lastwrite_addr] = 'bx;
      #0.2 data_hold_flag =0;
   end
always @(posedge data_setup_flag)
   begin
      mem[A] = 'bx;
      ramout = 'bx;
      #0.2 data_setup_flag =0;
   end
always @(ramout)
   begin
       if (OE == 0 )
        begin
         disable output_something;
         DOUT = ramout;
        end
  end
always @(OE)
       begin
          disable output_something;
          output_enable =1 ;
       end
always
     begin: output_something
      wait(output_enable);
      output_enable = 0;
      if (OE == 0)
        #(0.3:0.4:0.5) DOUT = #(`z2valid_dly) ramout;
      else if (OE == 1)
        #(0.3:0.4:0.5) DOUT = #(`valid2z_dly) 'bz;
      else
        #(0.3:0.4:0.5) DOUT = #(0.5*`valid2z_dly+0.5*`z2valid_dly) 'bx;
end

specify
        specparam
          addr_hold_time =0, addr_setup_time=1.0:1.2:1.4,//t_setup(A)
          data_hold_time=0, data_setup_time=0.04:0.06:0.08,//t_setup(DIN)
          write_pulse_low=1.0:1.2:1.4,			//t_wpl
	  write_pulse_high=1.0:1.2:1.4;		//t_rc(WR)
	$setup(A, negedge WR, addr_setup_time); 	//address setup check
	$setup(DIN, posedge WR,data_setup_time);	//data setup check
	$width(negedge WR, write_pulse_low); 		//WR low width check
	$width(posedge WR, write_pulse_high);		//read cycle check
	$setup(A, posedge WR, 1.1:1.3:1.7);		//t_wc(WR)

   endspecify
endmodule


//---------------------------------------------------------
//            R    O    M    :  4-bits x 32 words
//
//---------------------------------------------------------
// You will need to "stack" the ROM up to satisfy the "length"
// and "width" requirements.  For instance:
//
// rom4b32w$  ROM11 (....);
// rom4b32w$  ROM12 (....);
//		:
// rom4b32w$  ROM21 (....);
// rom4b32w$  ROM22 (....);
//		:
// where ROMij is the ith row, jth column ROM.
//
// You will need to initialize the ROMs using the initial 
// statement.  For example:
//
// initial readmemh("rom/rom12.data", ROM12.mem);
//		:
// where all romxx.data files are placed in the "rom" 
// subdirectory.
//---------------------------------------------------------
module rom4b32w$(A,OE,DOUT);
  input [4:0] A;
  input  OE;
  output [3:0] DOUT;
  wire [4:0] A_temp;
  wire  OE_temp;

  `define d_A     1.0
  `define d_OE_r  1.0
  `define d_OE_f  1.0
  `define d_DOUT  0

  reg [3:0] DOUT_temp;
  reg [3:0] mem[31:0];
  assign #(`d_A) A_temp = A;
  assign #(`d_OE_r,`d_OE_f) OE_temp = OE;
  assign #(`d_DOUT) DOUT = DOUT_temp;
  always
    @(A_temp or OE_temp)
      begin
      if((OE_temp == 1'b1))
        DOUT_temp = mem[A_temp];
      else      if((OE_temp == 1'b0))
        DOUT_temp = 4'bz;
      else
        DOUT_temp = 4'bx;
      end
endmodule


module rom32b32w$(A,OE,DOUT);
  input [4:0] A;
  input  OE;
  output [31:0] DOUT;
  wire [4:0] A_temp;
  wire  OE_temp;

  `define d_A     1.0
  `define d_OE_r  1.0
  `define d_OE_f  1.0
  `define d_DOUT  0

  reg [31:0] DOUT_temp;
  reg [31:0] mem[31:0];
  assign #(`d_A) A_temp = A;
  assign #(`d_OE_r,`d_OE_f) OE_temp = OE;
  assign #(`d_DOUT) DOUT = DOUT_temp;
  always
    @(A_temp or OE_temp)
      begin
      if((OE_temp == 1'b1))
        DOUT_temp = mem[A_temp];
      else      if((OE_temp == 1'b0))
        DOUT_temp = 32'bz;
      else
        DOUT_temp = 32'bx;
      end
endmodule



module rom64b32w$(A,OE,DOUT);
  input [4:0] A;
  input  OE;
  output [63:0] DOUT;
  wire [4:0] A_temp;
  wire  OE_temp;

  `define d_A     1.0
  `define d_OE_r  1.0
  `define d_OE_f  1.0
  `define d_DOUT  0

  reg [63:0] DOUT_temp;
  reg [63:0] mem[31:0];
  assign #(`d_A) A_temp = A;
  assign #(`d_OE_r,`d_OE_f) OE_temp = OE;
  assign #(`d_DOUT) DOUT = DOUT_temp;
  always
    @(A_temp or OE_temp)
      begin
      if((OE_temp == 1'b1))
        DOUT_temp = mem[A_temp];
      else      if((OE_temp == 1'b0))
        DOUT_temp = 64'bz;
      else
        DOUT_temp = 64'bx;
      end
endmodule


