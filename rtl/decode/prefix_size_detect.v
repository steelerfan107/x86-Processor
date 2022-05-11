module prefix_size_detect (
      input [23:0] instruction,			   
      output [1:0] prefix_bytes,
      output size_prefix,
      output detected_f4	   
);

   wire [23:0] instruction_mask;
   wire [23:0] instruction_masked;
   
   wire        f40, f41, f42;
   wire        m0, m1, m2;
   wire        im0, im1, im2;

   or2$ (m1, f40, f41);
   or2$ (m2, m1, f42); 

   inv1$ (im0,f40);  
   inv1$ (im1,m1);
   inv1$ (im2,m2);
  

   assign instruction_mask = {{8{im0}},{8{im1}},{8{im2}}};

   logic_tree_bus #(.WIDTH(24),.NINPUTS(2)) ({instruction, instruction_mask},instruction_masked);
   
   prefix_map_cloud pmc (
     instruction_masked[23],
     instruction_masked[22],
     instruction_masked[21],
     instruction_masked[20],
     instruction_masked[19],
     instruction_masked[18],
     instruction_masked[17],
     instruction_masked[16],
     instruction_masked[15],
     instruction_masked[14],
     instruction_masked[13],
     instruction_masked[12],
     instruction_masked[11],
     instruction_masked[10],
     instruction_masked[9],
     instruction_masked[8],
     instruction_masked[7],
     instruction_masked[6],
     instruction_masked[5],
     instruction_masked[4],
     instruction_masked[3],
     instruction_masked[2],
     instruction_masked[1],
     instruction_masked[0],
     prefix_bytes[1],
     prefix_bytes[0],
     size_prefix			 
   );

   or3$ (detected_f4, f40, f41, f42);
   
   compare #(.WIDTH(8)) (8'hF4, instruction[23:16], f40);
   compare #(.WIDTH(8)) (8'hF4, instruction[15:8], f41);
   compare #(.WIDTH(8)) (8'hF4, instruction[7:0], f42);
  
			 
endmodule
   
