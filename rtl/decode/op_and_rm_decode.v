module (
     	mask_op,
        dec_modrm,
        pre_size_override,
        rom_control,
        dec_size,  
        dec_set_d_flag,
        dec_clear_d_flag,   
        dec_op0,   
        dec_op1,
        dec_op0_reg,
        dec_op1_reg,  
        dec_modrm, 
        dec_sib,   
        dec_alu_op,  
        dec_flag_0,  
        dec_flag_1,  
        dec_stack_op   	
)

   input    [15:0]       mask_op;  
   input    [7:0]        dec_modrm; 
   input 		 pre_size_override;   
   output   [2:0] 	 rom_control;
   output   [2:0]	 dec_size;   
   output      		 dec_set_d_flag;  
   output                dec_clear_d_flag;   
   output   [2:0]        dec_op0;   
   output   [2:0]        dec_op1;   
   output   [2:0]        dec_op0_reg;   
   output   [2:0]        dec_op1_reg;   
   output   [7:0]	 dec_modrm;  
   output   [7:0]        dec_sib;   
   output   [31:0]       dec_imm;   
   output   [31:0]       dec_disp;   
   output   [3:0]        dec_alu_op;   
   output   [2:0]        dec_flag_0;   
   output   [2:0]        dec_flag_1;   
   output   [1:0]        dec_stack_op;

   wire [1:0] 		 reg0_sel;
   wire [1:0] 		 reg1_sel;

   wire [2:0] 		 reg0_cloud;
   wire [2:0] 		 reg1_cloud;
   
   mux #(.WIDTH(3), .INPUTS(4)) ({3'b0,mask_op[10:8],mask_dec_modrm[5:3],reg0_cloud},dec_op0_reg,reg0_sel);
   mux #(.WIDTH(3), .INPUTS(4)) ({3'b0,mask_op[10:8],mask_dec_modrm[5:3],reg1_cloud},dec_op1_reg,reg0_sel);   
   
   opcode_modrm_control_cloud opcode_modrm_control_cloud(
     .modrm7(dec_modrm[7]), 
     .modrm6(dec_modrm[6]), 
     .modrm5(dec_modrm[5]), 
     .modrm4(dec_modrm[4]), 
     .modrm3(dec_modrm[3]), 
     .modrm2(dec_modrm[2]), 
     .modrm1(dec_modrm[1]), 
     .modrm0(dec_modrm[0]), 
     .op15(mask_op[15]), 
     .op14(mask_op[14]), 
     .op13(mask_op[13]), 
     .op12(mask_op[12]), 
     .op11(mask_op[11]), 
     .op10(mask_op[10]), 
     .op9(mask_op[9]), 
     .op8(mask_op[8]), 
     .op7(mask_op[7]), 
     .op6(mask_op[6]), 
     .op5(mask_op[5]), 
     .op4(mask_op[4]), 
     .op3(mask_op[3]), 
     .op2(mask_op[2]), 
     .op1(mask_op[1]), 
     .op0(mask_op[0]),
     .sizeov(pre_size_override),							 
     .setd(dec_set_d_flag), 
     .cleard(dec_clear_d_flag), 
     .size2(dec_size[2]), 
     .size1(dec_size[1]), 
     .size0(dec_size[0]), 
     .op0_2(dec_op0[2]), 
     .op0_1(dec_op0[1]), 
     .op0_0(dec_op0[0]), 
     .op1_2(dec_op1[2]), 
     .op1_1(dec_op1[1]), 
     .op1_0(dec_op1[0]), 
     .op0_reg_4(reg0_sel[1]), 
     .op0_reg_3(reg0_sel[0]), 
     .op0_reg_2(reg0_cloud[2]), 
     .op0_reg_1(reg0_cloud[1]), 
     .op0_reg_0(reg0_cloud[0]), 
     .op1_reg_4(reg1_sel[1]), 
     .op1_reg_3(reg1_sel[0]), 
     .op1_reg_2(reg1_cloud[2]), 
     .op1_reg_1(reg1_cloud[1]), 
     .op1_reg_0(reg1_cloud[0]), 
     .alu_op_3(dec_alu_op[3]), 
     .alu_op_2(dec_alu_op[2]), 
     .alu_op_1(dec_alu_op[1]), 
     .alu_op_0(dec_alu_op[0]), 
     .flag0_2(dec_flag_0[2]), 
     .flag0_1(dec_flag_0[1]), 
     .flag0_0(dec_flag_0[0]), 
     .flag1_2(dec_flag_1[2]), 
     .flag1_1(dec_flag_1[1]), 
     .flag1_0(dec_flag_1[0]), 
     .stack_op_1(dec_stack_op[1]), 
     .stack_op_0(dec_stack_op[0]), 
     .rom_control_2(rom_control[2]), 
     .rom_control_1(rom_control[1]), 
     .rom_control_0(rom_control[0])				   
  );

endmodule
