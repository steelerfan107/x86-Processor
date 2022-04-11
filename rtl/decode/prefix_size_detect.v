module prefix_size_detect (
      input [23:0] instruction,			   
      output [1:0] prefix_bytes,
      output size_prefix	   
);

   prefix_map_cloud pmc (
     instruction[23],
     instruction[22],
     instruction[21],
     instruction[20],
     instruction[19],
     instruction[18],
     instruction[17],
     instruction[16],
     instruction[15],
     instruction[14],
     instruction[13],
     instruction[12],
     instruction[11],
     instruction[10],
     instruction[9],
     instruction[8],
     instruction[7],
     instruction[6],
     instruction[5],
     instruction[4],
     instruction[3],
     instruction[2],
     instruction[1],
     instruction[0],
     prefix_bytes[1],
     prefix_bytes[0],
     size_prefix			 
   );
   
endmodule
   
