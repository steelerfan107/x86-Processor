////////////////////////////////////////////
//
// Pipestage
//
// A Valid Ready Handshake Pipestage
//

module pipestage (
   clk,
   reset,
   in_valid,
   in_ready,
   in_data,
   out_valid,
   out_ready,
   out_data
);

   parameter BYPASS = 0;
   parameter WIDTH = 64;

   input clk, reset;

   input              in_valid, out_ready;
   input [WIDTH-1:0]  in_data;

   output 	      out_valid, in_ready;
   output [WIDTH-1:0] out_data;

   wire 	      en0, en1;
   wire [WIDTH-1:0]   out_data_0, out_data_1;
   wire [WIDTH-1:0]   nc0, nc1;

   wire               reg0_valid, reg1_valid;
   wire               reg0_invalid, reg1_invalid;

   wire               in_accept;
   wire               out_accept;

   wire               head, tail;
   wire               not_head, not_tail;

   wire               clear0, clear0_logic, clear1, clear1_logic;

   genvar 	      i;
   generate
      // Full Bandwidth Circular Buffer
      // Cuts off forward and backward timing path.
      // 1 Cycle Latency
      if (!BYPASS) begin
	 // Data Registers
	 // - The data registers will be loaded when the head pointer points to
	 //   that entry AND an entry is accepted (in_valid AND in_ready)
         register #(.WIDTH(WIDTH)) d0_reg (clk, reset, in_data, out_data_0, nc0, en0);
         register #(.WIDTH(WIDTH)) d1_reg (clk, reset, in_data, out_data_1, nc1, en1);

	 // Valid Registers
	 // - Indicates if each register is valid.
	 // - Set : When entry is accepted and head points to that entry. or reset.
	 // - Clear : When entry is taken and tail points to that entry. or reset.
         register #(.WIDTH(1)) v0_reg (clk, clear0, 1'b1, reg0_valid, reg0_invalid, en0);
         register #(.WIDTH(1)) v1_reg (clk, clear1, 1'b1, reg1_valid, reg1_invalid, en1);

	 // Head/Tail Registers
	 // - Since there is only two entries the head and tail just need to be
	 //   a single bit
         register #(.WIDTH(1)) h_reg (clk, reset, not_head , head, not_head,  in_accept);
         register #(.WIDTH(1)) t_reg (clk, reset, not_tail , tail, not_tail, out_accept);

	 // Data Multiplexer
	 // - Read data from the tail pointer
         mux #(.WIDTH(WIDTH),.INPUTS(2)) mux_out ( {out_data_1,out_data_0} , out_data, tail);

	 // Accept Logic
	 // - An entry is officially inside the pipe when in_valid and in_ready is 1
	 // - An entry is officially taken from the pipe when out_valid and out_ready is 1
	 and2$ out_acc (out_accept, out_valid, out_ready);
	 and2$ in_acc  (in_accept , in_valid,   in_ready);

	 // Write Logic
	 // - Write to the pipe that the head points to and data is accepted
	 and2$ write0  (en0 , not_head, in_accept);
	 and2$ write1  (en1 ,     head, in_accept);	 

	 // Ready Logic
	 // - The buffer is ready to accept new data when a register is not valid
	 nand2$ iready (in_ready , reg0_valid, reg1_valid);

	 // Valid Logic
	 // - The buffer is valid when one of the registers has data
	 or2$   ovalid (out_valid, reg0_valid, reg1_valid); 

	 // Clear Logic
	 // - Clear the valid bits if the tail points to the buffer and data is taken
	 and2$ clear0a  (clear0_logic , not_tail, out_accept);
	 and2$ clear1a  (clear1_logic ,     tail, out_accept);
	         
	 or2$   c0     (clear0, reset, clear0_logic); 
	 or2$   c1     (clear1, reset, clear1_logic);		 
      end
      else begin
	 // Pass Through
	 assign out_valid = in_valid;
	 assign in_ready = out_ready;
	 assign out_data = in_data;
      end     
   endgenerate
   
endmodule 
