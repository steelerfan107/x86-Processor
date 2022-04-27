// tb_register_file.v
// Brandon Zupan

// Testbench for testing the register file seperately from everything else

module TOP;
    reg clk;
    reg reset;

    reg [1:0] register_size;

    reg [2:0] op_1;
    wire [31:0] op_1_value;

    reg [2:0] op_2;
    wire [31:0] op_2_value;

    reg [2:0] sib_base_reg;
    wire [31:0] sib_base_value;
    reg [2:0] sib_index_reg;
    wire [31:0] sib_index_value;

    reg [2:0] writeback_reg;
    reg writeback_en;
    reg [1:0] writeback_size;
    reg [31:0] writeback_data;

    wire [31:0] eax_out;
    wire [31:0] ecx_out;
    wire [31:0] edx_out;
    wire [31:0] ebx_out;
    wire [31:0] esp_out;
    wire [31:0] ebp_out;
    wire [31:0] esi_out;
    wire [31:0] edi_out;

    register_file uut (
        clk,
        reset,

        register_size,

        op_1,
        op_1_value,

        op_2,
        op_2_value,

        sib_base_reg,
        sib_base_value,
        sib_index_reg,
        sib_index_value,
        
        writeback_reg,
        writeback_en,
        writeback_size,
        writeback_data,

        eax_out,
        ecx_out,
        edx_out,
        ebx_out,
        esp_out,
        ebp_out,
        esi_out,
        edi_out
    );

    // write 32 bit value to each register
    integer eax_data = 32'h3967_2177;
    integer ecx_data = 32'h8fe3_17ec;
    integer edx_data = 32'h7222_1624;
    integer ebx_data = 32'h7db1_6000;
    integer esp_data = 32'hed96_98fc;
    integer ebp_data = 32'h4977_bccc;
    integer esi_data = 32'h18b4_7c59;
    integer edi_data = 32'hcc90_53ba;

    integer ax_data = 16'h4776;
    integer cx_data = 16'h0b10;
    integer dx_data = 16'h00b9;
    integer bx_data = 16'h8f0e;
    integer sp_data = 16'hcc79;
    integer bp_data = 16'h91c3;
    integer si_data = 16'he394;
    integer di_data = 16'h05f8;

    integer al_data = 8'h74;
    integer cl_data = 8'h73;
    integer dl_data = 8'ha3;
    integer bl_data = 8'h04;
    integer ah_data = 8'hbc;
    integer ch_data = 8'hb0;
    integer dh_data = 8'hbc;
    integer bh_data = 8'hdb;

    initial begin
        $display("============ \n Begin Test \n============");
        reset = 1;

        clk = 0;
        register_size = 0;
        op_1 = 0;
        op_2 = 0;
        sib_base_reg = 0;
        sib_index_reg = 0;
        writeback_reg = 0;
        writeback_en = 0;
        writeback_size = 0;
        writeback_data = 0;

        #12.5

        reset = 0;
        writeback_en = 1;

        // write 32 bit value to each register
        $display("Testing 32 bit register writes");
        writeback_size = 3;

        writeback_reg = 0;
        writeback_data = eax_data;
        #5

        if (eax_out != eax_data) $display("FAIL: Register %d write test", writeback_reg);

        writeback_reg = 1;
        writeback_data = ecx_data;
        #5

        if (ecx_out != ecx_data) $display("FAIL: Register %d write test", writeback_reg);

        writeback_reg = 2;
        writeback_data = edx_data;
        #5

        if (edx_out != edx_data) $display("FAIL: Register %d write test", writeback_reg);

        writeback_reg = 3;
        writeback_data = ebx_data;
        #5

        if (ebx_out != ebx_data) $display("FAIL: Register %d write test", writeback_reg);

        writeback_reg = 4;
        writeback_data = esp_data;
        #5

        if (esp_out != esp_data) $display("FAIL: Register %d write test", writeback_reg);

        writeback_reg = 5;
        writeback_data = ebp_data;
        #5

        if (ebp_out != ebp_data) $display("FAIL: Register %d write test", writeback_reg);

        writeback_reg = 6;
        writeback_data = esi_data;
        #5

        if (esi_out != esi_data) $display("FAIL: Register %d write test", writeback_reg);

        writeback_reg = 7;
        writeback_data = edi_data;
        #5

        if (edi_out != edi_data) $display("FAIL: Register %d write test", writeback_reg);


        // write 32 bit value to each register
        $display("Testing 16 bit register writes");
        writeback_size = 2;

        writeback_reg = 0;
        writeback_data = {16'h0, ax_data};
        #5

        $display("Testing 8 bit register writes");
        writeback_size = 1;
        writeback_data = 32'd0;

        #5

        writeback_data = 32'h0000_00ff;


    end

    // initial begin
    //     $display("============ \n Begin Test \n============");
    //     reset = 1;

    //     clk = 0;
    //     register_size = 0;
    //     op_1 = 0;
    //     op_2 = 0;
    //     sib_base_reg = 0;
    //     sib_index_reg = 0;
    //     writeback_reg = 0;
    //     writeback_en = 0;
    //     writeback_size = 0;
    //     writeback_data = 0;

    //     #12.5

    //     reset = 0;

    //     // Write to EAX then read
    //     writeback_reg = 0;
    //     writeback_size = 0;
    //     writeback_data = 32'hABCD;
    //     writeback_en = 1;

    //     #10

    //     writeback_en = 0;
    //     writeback_data = 0;

    //     // test writing to each register and verify register output is correct
    //     // not looping this bc i want to verify that each register can get a unique value
    //     // input values randomly generated
    //     $display("Testing 32 bit write");
    //     writeback_en = 1;

    //     writeback_reg = 0;
    //     writeback_data = 32'h3227cf28;
        
    //     #10

    //     if (eax_out != writeback_data) $display("FAIL: EAX Write Test");

    //     writeback_reg = 1;
    //     writeback_data = 32'hebc344b6;

    //     #10

    //     if (ecx_out != writeback_data) $display("FAIL: ECX Write Test FAIL");

    //     writeback_reg = 2;
    //     writeback_data = 32'h068cc8d3;

    //     #10

    //     if (edx_out != writeback_data) $display("FAIL EDX Write Test");

    //     writeback_reg = 3;
    //     writeback_data = 32'h3c178a98;

    //     #10

    //     if (ebx_out != writeback_data) $display("FAIL: EBX Write Test");

    //     writeback_reg = 4;
    //     writeback_data = 32'h4e812720;
        
    //     #10

    //     if (esp_out != writeback_data) $display("FAIL ESP Write Test");

    //     writeback_reg = 5;
    //     writeback_data = 32'h55213d50;

    //     #10

    //     if (ebp_out != writeback_data) $display("FAIL: EBP Write Test");

    //     writeback_reg = 6;
    //     writeback_data = 32'h02b6921e;

    //     #10

    //     if (esi_out != writeback_data) $display("FAIL: ESI Write Test");

    //     writeback_reg = 7;
    //     writeback_data = 32'h0b19d3ba;

    //     #10

    //     if (edi_out != writeback_data) $display("FAIL: EDI Write Test");

    //     // test register selects
    //     $display("Testing OP1 32 bit");

    //     op_1 = 0;
    //     #10
    //     if (op_1_value != eax_out) $display("FAIL: OP1 Value %d", op_1);

    //     op_1 = 1;
    //     #10
    //     if (op_1_value != ecx_out) $display("FAIL: OP1 Value %d", op_1);

    //     op_1 = 2;
    //     #10
    //     if (op_1_value != edx_out) $display("FAIL: OP1 Value %d", op_1);

    //     op_1 = 3;
    //     #10
    //     if (op_1_value != ebx_out) $display("FAIL: OP1 Value %d", op_1);

    //     op_1 = 4;
    //     #10
    //     if (op_1_value != esp_out) $display("FAIL: OP1 Value %d", op_1);

    //     op_1 = 5;
    //     #10
    //     if (op_1_value != ebp_out) $display("FAIL: OP1 Value %d", op_1);

    //     op_1 = 6;
    //     #10
    //     if (op_1_value != esi_out) $display("FAIL: OP1 Value %d", op_1);

    //     op_1 = 7;
    //     #10
    //     if (op_1_value != edi_out) $display("FAIL: OP1 Value %d", op_1);

    //     $display("Testing OP2 32 bit");

    //     op_2 = 0;
    //     #10
    //     if (op_2_value != eax_out) $display("FAIL: OP2 Value %d", op_2);

    //     op_2 = 1;
    //     #10
    //     if (op_2_value != ecx_out) $display("FAIL: OP2 Value %d", op_2);

    //     op_2 = 2;
    //     #10
    //     if (op_2_value != edx_out) $display("FAIL: OP2 Value %d", op_2);

    //     op_2 = 3;
    //     #10
    //     if (op_2_value != ebx_out) $display("FAIL: OP2 Value %d", op_2);

    //     op_2 = 4;
    //     #10
    //     if (op_2_value != esp_out) $display("FAIL: OP2 Value %d", op_2);

    //     op_2 = 5;
    //     #10
    //     if (op_2_value != ebp_out) $display("FAIL: OP2 Value %d", op_2);

    //     op_2 = 6;
    //     #10
    //     if (op_2_value != esi_out) $display("FAIL: OP2 Value %d", op_2);

    //     op_2 = 7;
    //     #10
    //     if (op_2_value != edi_out) $display("FAIL: OP2 Value %d", op_2);

    //     $display("Testing SIB Base");

    //     sib_base_reg = 0;
    //     #10
    //     if (sib_base_value != eax_out) $display("FAIL: SIB Base Value %d", sib_base_reg);

    //     sib_base_reg = 1;
    //     #10
    //     if (sib_base_value != ecx_out) $display("FAIL: SIB Base Value %d", sib_base_reg);

    //     sib_base_reg = 2;
    //     #10
    //     if (sib_base_value != edx_out) $display("FAIL: SIB Base Value %d", sib_base_reg);

    //     sib_base_reg = 3;
    //     #10
    //     if (sib_base_value != ebx_out) $display("FAIL: SIB Base Value %d", sib_base_reg);

    //     sib_base_reg = 4;
    //     #10
    //     if (sib_base_value != esp_out) $display("FAIL: SIB Base Value %d", sib_base_reg);

    //     sib_base_reg = 5;
    //     #10
    //     if (sib_base_value != ebp_out) $display("FAIL: SIB Base Value %d", sib_base_reg);

    //     sib_base_reg = 6;
    //     #10
    //     if (sib_base_value != esi_out) $display("FAIL: SIB Base Value %d", sib_base_reg);

    //     sib_base_reg = 7;
    //     #10
    //     if (sib_base_value != edi_out) $display("FAIL: SIB Base Value %d", sib_base_reg);

    //     $display("Testing SIB Index");

    //     sib_index_reg = 0;
    //     #10
    //     if (sib_index_value != eax_out) $display("FAIL: SIB Index Value %d", sib_index_reg);

    //     sib_index_reg = 1;
    //     #10
    //     if (sib_index_value != ecx_out) $display("FAIL: SIB Index Value %d", sib_index_reg);

    //     sib_index_reg = 2;
    //     #10
    //     if (sib_index_value != edx_out) $display("FAIL: SIB Index Value %d", sib_index_reg);

    //     sib_index_reg = 3;
    //     #10
    //     if (sib_index_value != ebx_out) $display("FAIL: SIB Index Value %d", sib_index_reg);

    //     sib_index_reg = 4;
    //     #10
    //     if (sib_index_value != esp_out) $display("FAIL: SIB Index Value %d", sib_index_reg);

    //     sib_index_reg = 5;
    //     #10
    //     if (sib_index_value != ebp_out) $display("FAIL: SIB Index Value %d", sib_index_reg);

    //     sib_index_reg = 6;
    //     #10
    //     if (sib_index_value != esi_out) $display("FAIL: SIB Index Value %d", sib_index_reg);

    //     sib_index_reg = 7;
    //     #10
    //     if (sib_index_value != edi_out) $display("FAIL: SIB Index Value %d", sib_index_reg);

    //     $display("Testing 16 bit write");
    //     // 16 bit write
    //     writeback_size = 1;

    //     writeback_reg = 0;
    //     // writeback_data = 32'h3227cf28;
    //     writeback_data = 32'h1234abcd;
        
    //     #10

    //     if (eax_out != 32'h3227abcd) $display("FAIL: AX Write Test");

    //     writeback_reg = 1;
    //     // writeback_data = 32'hebc344b6;
    //     writeback_data = 32'h234abcd1;

    //     #10

    //     if (ecx_out != 32'hebc3_bcd1) $display("FAIL: CX Write Test FAIL");

    //     writeback_reg = 2;
    //     // writeback_data = 32'h068cc8d3;
    //     writeback_data = 32'h34ab_cd12;

    //     #10

    //     if (edx_out != 32'h068c_cd12) $display("FAIL DX Write Test");

    //     writeback_reg = 3;
    //     // writeback_data = 32'h3c178a98;
    //     writeback_data = 32'h4abc_d123;

    //     #10

    //     if (ebx_out != 32'h3c17_d123) $display("FAIL: BX Write Test");

    //     writeback_reg = 4;
    //     // writeback_data = 32'h4e812720;
    //     writeback_data = 32'habcd_1234;
        
    //     #10

    //     if (esp_out != 32'h4e81_1234) $display("FAIL SP Write Test");

    //     writeback_reg = 5;
    //     // writeback_data = 32'h55213d50;
    //     writeback_data = 32'hbcd1_234a;

    //     #10

    //     if (ebp_out != 32'h5521_234a) $display("FAIL: BP Write Test");

    //     writeback_reg = 6;
    //     // writeback_data = 32'h02b6921e;
    //     writeback_data = 32'hcd12_34ab;

    //     #10

    //     if (esi_out != 32'h02b6_34ab) $display("FAIL: SI Write Test");

    //     writeback_reg = 7;
    //     // writeback_data = 32'h0b19d3ba;
    //     writeback_data = 32'hd123_4abc;

    //     #10

    //     if (edi_out != 32'h0b19_4abc) $display("FAIL: DI Write Test");


    //     // 16 bit reads
    //     register_size = 1;

    //     // test register selects
    //     $display("Testing OP1 16 bit");

    //     op_1 = 0;
    //     #10
    //     if (op_1_value != (eax_out & 32'h0000_FFFF)) $display("FAIL: OP1 Value %d", op_1);

    //     op_1 = 1;
    //     #10
    //     if (op_1_value != (ecx_out & 32'h0000_FFFF)) $display("FAIL: OP1 Value %d", op_1);

    //     op_1 = 2;
    //     #10
    //     if (op_1_value != (edx_out & 32'h0000_FFFF)) $display("FAIL: OP1 Value %d", op_1);

    //     op_1 = 3;
    //     #10
    //     if (op_1_value != (ebx_out & 32'h0000_FFFF)) $display("FAIL: OP1 Value %d", op_1);

    //     op_1 = 4;
    //     #10
    //     if (op_1_value != (esp_out & 32'h0000_FFFF)) $display("FAIL: OP1 Value %d", op_1);

    //     op_1 = 5;
    //     #10
    //     if (op_1_value != (ebp_out & 32'h0000_FFFF)) $display("FAIL: OP1 Value %d", op_1);

    //     op_1 = 6;
    //     #10
    //     if (op_1_value != (esi_out & 32'h0000_FFFF)) $display("FAIL: OP1 Value %d", op_1);

    //     op_1 = 7;
    //     #10
    //     if (op_1_value != (edi_out & 32'h0000_FFFF)) $display("FAIL: OP1 Value %d", op_1);

    //     $display("Testing OP2 16 bit");

    //     op_2 = 0;
    //     #10
    //     if (op_2_value != (eax_out & 32'h0000_FFFF)) $display("FAIL: OP2 Value %d", op_2);

    //     op_2 = 1;
    //     #10
    //     if (op_2_value != (ecx_out & 32'h0000_FFFF)) $display("FAIL: OP2 Value %d", op_2);

    //     op_2 = 2;
    //     #10
    //     if (op_2_value != (edx_out & 32'h0000_FFFF)) $display("FAIL: OP2 Value %d", op_2);

    //     op_2 = 3;
    //     #10
    //     if (op_2_value != (ebx_out & 32'h0000_FFFF)) $display("FAIL: OP2 Value %d", op_2);

    //     op_2 = 4;
    //     #10
    //     if (op_2_value != (esp_out & 32'h0000_FFFF)) $display("FAIL: OP2 Value %d", op_2);

    //     op_2 = 5;
    //     #10
    //     if (op_2_value != (ebp_out & 32'h0000_FFFF)) $display("FAIL: OP2 Value %d", op_2);

    //     op_2 = 6;
    //     #10
    //     if (op_2_value != (esi_out & 32'h0000_FFFF)) $display("FAIL: OP2 Value %d", op_2);

    //     op_2 = 7;
    //     #10
    //     if (op_2_value != (edi_out & 32'h0000_FFFF)) $display("FAIL: OP2 Value %d", op_2);

    //     // 8 bit writes
    //     // i really hope i don't regret doing a more thorough test later lmfao
    //     // i am suffering existance is pain
    //     // ʕ•ᴥ•ʔ

    //     $display("Testing 8 bit writes");
    //     writeback_size = 2;

    //     writeback_data = 32'h0000_00aa;
    //     writeback_reg = 0;
        
    //     #10

    //     if (eax_out != 32'h3227_abaa) $display("FAIL: AL Write Test x%X", eax_out);

    //     writeback_data = 32'h0000_00bb;
    //     writeback_reg = 1;
        
    //     #10

    //     if (ecx_out != 32'hebc3_bcbb) $display("FAIL: CL Write Test");

    //     writeback_data = 32'h0000_00cc;
    //     writeback_reg = 2;
        
    //     #10

    //     if (edx_out != 32'h068c_cdcc) $display("FAIL: DL Write Test");

    //     writeback_data = 32'h0000_00dd;
    //     writeback_reg = 3;
        
    //     #10

    //     if (ebx_out != 32'h3c17_d1dd) $display("FAIL: BL Write Test");

    //     writeback_reg = 4;
    //     writeback_data = 32'h0000_0011;
        
    //     #10

    //     if (eax_out != 32'h3227_11aa) $display("FAIL: AH Write Test x%X", eax_out);

    //     writeback_data = 32'h0000_0022;
    //     writeback_reg = 5;
        
    //     #10

    //     if (ecx_out != 32'hebc3_22bb) $display("FAIL: CH Write Test x%X", ecx_out);

    //     writeback_data = 32'h0000_0033;
    //     writeback_reg = 6;
        
    //     #10

    //     if (edx_out != 32'h068c_33cc) $display("FAIL: DH Write Test x%X", edx_out);

    //     writeback_data = 32'h0000_0044;
    //     writeback_reg = 7;
        
    //     #10

    //     if (ebx_out != 32'h3c17_44dd) $display("FAIL: BH Write Test x%X", ebx_out);


    //     // 8 bit reads
    //     register_size = 2;


    //     // test register selects
    //     $display("Testing OP1 8 bit");

    //     op_1 = 0;
    //     #10
    //     if (op_1_value != (eax_out & 32'h0000_00FF)) $display("FAIL: OP1 Value %d", op_1);

    //     op_1 = 1;
    //     #10
    //     if (op_1_value != (ecx_out & 32'h0000_00FF)) $display("FAIL: OP1 Value %d", op_1);

    //     op_1 = 2;
    //     #10
    //     if (op_1_value != (edx_out & 32'h0000_00FF)) $display("FAIL: OP1 Value %d", op_1);

    //     op_1 = 3;
    //     #10
    //     if (op_1_value != (ebx_out & 32'h0000_00FF)) $display("FAIL: OP1 Value %d", op_1);

    //     op_1 = 4;
    //     #10
    //     if (op_1_value != 32'h0000_0011) $display("FAIL: OP1 Value %d, op_1_value = x%X", op_1, op_1_value);

    //     op_1 = 5;
    //     #10
    //     if (op_1_value != 32'h0000_0022) $display("FAIL: OP1 Value %d", op_1);

    //     op_1 = 6;
    //     #10
    //     if (op_1_value != 32'h0000_0033) $display("FAIL: OP1 Value %d", op_1);

    //     op_1 = 7;
    //     #10
    //     if (op_1_value != 32'h0000_0044) $display("FAIL: OP1 Value %d", op_1);

    //     $display("Testing OP2 8 bit");

    //     op_2 = 0;
    //     #10
    //     if (op_2_value != (eax_out & 32'h0000_00FF)) $display("FAIL: OP2 Value %d", op_2);

    //     op_2 = 1;
    //     #10
    //     if (op_2_value != (ecx_out & 32'h0000_00FF)) $display("FAIL: OP2 Value %d", op_2);

    //     op_2 = 2;
    //     #10
    //     if (op_2_value != (edx_out & 32'h0000_00FF)) $display("FAIL: OP2 Value %d", op_2);

    //     op_2 = 3;
    //     #10
    //     if (op_2_value != (ebx_out & 32'h0000_00FF)) $display("FAIL: OP2 Value %d", op_2);

    //     op_2 = 4;
    //     #10
    //     if (op_2_value != 32'h0000_0011) $display("FAIL: OP2 Value %d", op_2);

    //     op_2 = 5;
    //     #10
    //     if (op_2_value != 32'h0000_0022) $display("FAIL: OP2 Value %d", op_2);

    //     op_2 = 6;
    //     #10
    //     if (op_2_value != 32'h0000_0033) $display("FAIL: OP2 Value %d", op_2);

    //     op_2 = 7;
    //     #10
    //     if (op_2_value != 32'h0000_0044) $display("FAIL: OP2 Value %d", op_2);



    //     $display("==========\n End Test \n==========");
    // end

    initial #1000 $finish;

    always #5 clk = ~clk;

    initial begin
        $vcdplusfile("register_file.dump.vpd");
        $vcdpluson(0, TOP);
    end

endmodule
