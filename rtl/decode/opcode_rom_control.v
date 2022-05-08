module opcode_rom_control (
  modrm,
  sizeop,
  opcode,
  rom_control,
  rom_in_control			   	
);

   input [2:0]     modrm;
   input           sizeop;
   input [15:0]    opcode;
   output [3:0]    rom_control;
   output          rom_in_control;

   opcode_rom_control_cloud orcc (
     sizeop,
     opcode[15],
     opcode[14],
     opcode[13],
     opcode[12],
     opcode[11],
     opcode[10],
     opcode[9],
     opcode[8],
     opcode[7],
     opcode[6],
     opcode[5],
     opcode[4],
     opcode[3],
     opcode[2],
     opcode[1],
     opcode[0],
     modrm[2],
     modrm[1],
     modrm[0],
     rom_control[3],
     rom_control[2],
     rom_control[1],
     rom_control[0],
     rom_in_control				  
   );
   
endmodule
