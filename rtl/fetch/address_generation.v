//////////////////////////////////////
//
//  Address Generation Module
//

module address_generation (
   // Clock Interface
   clk,
   reset,

   // Control Interface
   load_address,
   load,

   // Code Segment
   cs_register,	

   // Instruction Memory Interface
   imem_valid,
   imem_ready,
   imem_address			  
);

   parameter IADDRW = 32;
   
   // Clock Interface
   input                 clk;
   input                 reset;
   
   // Control Interface
   input [IADDRW-1:0]    load_address;
   input 	         load;
 
   // Code Segment
   input [15:0] 	 cs_register;

   // Instruction Memory Interface
   output 	         imem_valid;
   input 	         imem_ready;
   output [IADDRW-1:0]   imem_address;

  
   wire [31:0] 		 address;
   wire [31:0] 		 address_in;
   wire [31:0] 		 address_b;
   wire [31:0] 		 address_mux;
   wire [31:0] 		 load_address_p16;
   wire [31:0] 		 address_p16;

   wire 		 nc0, nc1, nc2;

   wire 		 vro;
   wire                  sel0, sel1;

   assign sel1 = load;
   
   and2$ vr( vro, imem_valid, imem_ready);
   or2$ sel0_or (sel0, vro, load);
         
   register #(.WIDTH(32)) address_reg (clk, reset, address_in, address, address_b, 1'b1);
  
   mux #(.INPUTS(2),.WIDTH(32))  bypass_mux   ({load_address,address},address_mux,load);
   mux #(.INPUTS(4),.WIDTH(32))  reg_load_mux ({load_address_p16, load_address,address_p16,address}, address_in, {sel1,vro});

   wire [3:0] 		 nc3;
   assign imem_address[3:0] = 'h0;
   
   CLA32 cs_addr     (address_mux, {cs_register,16'b0},  1'b0,  {imem_address[31:4],nc3}, nc0);
   CLA32 reg_addr    (32'd16,      address,           ,  1'b0,  address_p16,              nc1);
   CLA32 load_addr   (32'd16,      load_address,      ,  1'b0,  load_address_p16,         nc2);
   /*
   slow_addr #(.WIDTH(32)) cs_addr   (address_mux, {cs_register,16'b0}, {imem_address[31:4],nc3},         nc0);
   slow_addr #(.WIDTH(32)) reg_addr  (32'd16,      address,             address_p16,          nc1);
   slow_addr #(.WIDTH(32)) load_addr (32'd16,      load_address,        load_address_p16,     nc2);
   */
endmodule
			  
