// tb_template.v
// 

// Testbench for Mod RM

module TOP;
    // wires and regs
    wire [63:0] value;

    wire is_address;  // 1 if an address and needs mem read, 0 if its a reg value
    
    reg [7:0] mod_rm_byte;
    reg [7:0] sib_byte;

    reg [31:0] eax;
    reg [31:0] ecx;
    reg [31:0] edx;
    reg [31:0] ebx;
    reg [31:0] esp;
    reg [31:0] ebp;
    reg [31:0] esi;
    reg [31:0] edi;

    reg [63:0] reg_0;
    reg [63:0] reg_1;
    reg [63:0] reg_2;
    reg [63:0] reg_3;
    reg [63:0] reg_4;
    reg [63:0] reg_5;
    reg [63:0] reg_6;
    reg [63:0] reg_7;

    reg [31:0] displacement;

    reg [2:0] seg_sel;

    reg [15:0] es;
    reg [15:0] cs;
    reg [15:0] ss;
    reg [15:0] ds;
    reg [15:0] fs;
    reg [15:0] gs;


    mod_rm uut (
        value,

        is_address,
        
        mod_rm_byte,
        sib_byte,

        eax,
        ecx,
        edx,
        ebx,
        esp,
        ebp,
        esi,
        edi,

        reg_0,
        reg_1,
        reg_2,
        reg_3,
        reg_4,
        reg_5,
        reg_6,
        reg_7,

        displacement,

        seg_sel,

        es,
        cs,
        ss,
        ds,
        fs,
        gs


    );

    initial begin
        $display("============ \n Begin ModR/M Test \n============");
        mod_rm_byte = 0;
        sib_byte = 0;

        eax = 32'h0000_AAAA;
        ecx = 32'h0000_CCCC;
        edx = 32'h0000_DDDD;
        ebx = 32'h0000_BBBB;
        esp = 32'h0000_1111;
        ebp = 32'h0000_2222;
        esi = 32'h0000_3333;
        edi = 32'h0000_4444;

        reg_0 = 64'hAAAA_AAAA_AAAA_AAAA;
        reg_1 = 64'h1111_1111_1111_1111;
        reg_2 = 64'h2222_2222_2222_2222;
        reg_3 = 64'h3333_3333_3333_3333;
        reg_4 = 64'h4444_4444_4444_4444;
        reg_5 = 64'h5555_5555_5555_5555;
        reg_6 = 64'h6666_6666_6666_6666;
        reg_7 = 64'h7777_7777_7777_7777;

        displacement = 32'h0000_FFFF;

        seg_sel = 0;

        es = 1;
        cs = 2;
        ss = 3;
        ds = 4;
        fs = 5;
        gs = 6;

        #12.5

        // test each mod and rm with 000 as reg/op
        $display("Testing MOD/RM Values");

        mod_rm_byte = 8'h00;
        #5
        if ((value != ((es << 16) + eax)) || is_address != 1) $display("MOD_RM %X FAIL, value: %X, is_address: %X", mod_rm_byte, value, is_address);

        mod_rm_byte = 8'h01;
        #5
        if ((value != ((es << 16) + ecx)) || is_address != 1) $display("MOD_RM %X FAIL, value: %X, is_address: %X", mod_rm_byte, value, is_address);
        
        mod_rm_byte = 8'h02;
        #5
        if ((value != ((es << 16) + edx)) || is_address != 1) $display("MOD_RM %X FAIL, value: %X, is_address: %X", mod_rm_byte, value, is_address);
        
        mod_rm_byte = 8'h03;
        #5
        if ((value != ((es << 16) + ebx)) || is_address != 1) $display("MOD_RM %X FAIL, value: %X, is_address: %X", mod_rm_byte, value, is_address);
        
        mod_rm_byte = 8'h04;    // sib
        #5
        if ((value != ((es << 16) + eax + eax)) || is_address != 1) $display("MOD_RM %X FAIL, value: %X, is_address: %X", mod_rm_byte, value, is_address);
        
        mod_rm_byte = 8'h05;
        #5
        if ((value != ((es << 16) + displacement)) || is_address != 1) $display("MOD_RM %X FAIL, value: %X, is_address: %X", mod_rm_byte, value, is_address);
        
        mod_rm_byte = 8'h06;
        #5
        if ((value != ((es << 16) + esi)) || is_address != 1) $display("MOD_RM %X FAIL, value: %X, is_address: %X", mod_rm_byte, value, is_address);
        
        mod_rm_byte = 8'h07;
        #5
        if ((value != ((es << 16) + edi)) || is_address != 1) $display("MOD_RM %X FAIL, value: %X, is_address: %X", mod_rm_byte, value, is_address);
        
        // Mod 01
        
        mod_rm_byte = 8'h40;
        #5
        if ((value != ((es << 16) + eax + displacement)) || is_address != 1) $display("MOD_RM %X FAIL, value: %X, is_address: %X", mod_rm_byte, value, is_address);

        mod_rm_byte = 8'h41;
        #5
        if ((value != ((es << 16) + ecx + displacement)) || is_address != 1) $display("MOD_RM %X FAIL, value: %X, is_address: %X", mod_rm_byte, value, is_address);
        
        mod_rm_byte = 8'h42;
        #5
        if ((value != ((es << 16) + edx + displacement)) || is_address != 1) $display("MOD_RM %X FAIL, value: %X, is_address: %X", mod_rm_byte, value, is_address);
        
        mod_rm_byte = 8'h43;
        #5
        if ((value != ((es << 16) + ebx + displacement)) || is_address != 1) $display("MOD_RM %X FAIL, value: %X, is_address: %X", mod_rm_byte, value, is_address);
        
        mod_rm_byte = 8'h44;    // sib
        #5
        if ((value != ((es << 16) + eax + eax + displacement)) || is_address != 1) $display("MOD_RM %X FAIL, value: %X, is_address: %X", mod_rm_byte, value, is_address);
        
        mod_rm_byte = 8'h45;
        seg_sel = 2;
        #5
        if ((value != ((ss << 16) + ebp + displacement)) || is_address != 1) $display("MOD_RM %X FAIL, value: %X, is_address: %X", mod_rm_byte, value, is_address);
        
        mod_rm_byte = 8'h46;
        seg_sel = 0;
        #5
        if ((value != ((es << 16) + esi + displacement)) || is_address != 1) $display("MOD_RM %X FAIL, value: %X, is_address: %X", mod_rm_byte, value, is_address);
        
        mod_rm_byte = 8'h47;
        #5
        if ((value != ((es << 16) + edi + displacement)) || is_address != 1) $display("MOD_RM %X FAIL, value: %X, is_address: %X", mod_rm_byte, value, is_address);

        // Mod 10

        mod_rm_byte = 8'h80;
        #5
        if ((value != ((es << 16) + eax + displacement)) || is_address != 1) $display("MOD_RM %X FAIL, value: %X, is_address: %X", mod_rm_byte, value, is_address);

        mod_rm_byte = 8'h81;
        #5
        if ((value != ((es << 16) + ecx + displacement)) || is_address != 1) $display("MOD_RM %X FAIL, value: %X, is_address: %X", mod_rm_byte, value, is_address);
        
        mod_rm_byte = 8'h82;
        #5
        if ((value != ((es << 16) + edx + displacement)) || is_address != 1) $display("MOD_RM %X FAIL, value: %X, is_address: %X", mod_rm_byte, value, is_address);
        
        mod_rm_byte = 8'h83;
        #5
        if ((value != ((es << 16) + ebx + displacement)) || is_address != 1) $display("MOD_RM %X FAIL, value: %X, is_address: %X", mod_rm_byte, value, is_address);
        
        mod_rm_byte = 8'h84;    // sib
        #5
        if ((value != ((es << 16) + eax + eax + displacement)) || is_address != 1) $display("MOD_RM %X FAIL, value: %X, is_address: %X", mod_rm_byte, value, is_address);
        
        mod_rm_byte = 8'h85;
        seg_sel = 2;
        #5
        if ((value != ((ss << 16) + ebp + displacement)) || is_address != 1) $display("MOD_RM %X FAIL, value: %X, is_address: %X", mod_rm_byte, value, is_address);
        
        mod_rm_byte = 8'h86;
        seg_sel = 0;
        #5
        if ((value != ((es << 16) + esi + displacement)) || is_address != 1) $display("MOD_RM %X FAIL, value: %X, is_address: %X", mod_rm_byte, value, is_address);
        
        mod_rm_byte = 8'h87;
        #5
        if ((value != ((es << 16) + edi + displacement)) || is_address != 1) $display("MOD_RM %X FAIL, value: %X, is_address: %X", mod_rm_byte, value, is_address);

        // Mod 11

        mod_rm_byte = 8'hC0;
        #5
        if ((value != (reg_0) || is_address != 0)) $display("MOD_RM %X FAIL, value: %X, is_address: %X", mod_rm_byte, value, is_address);

        mod_rm_byte = 8'hC1;
        #5
        if ((value != (reg_1) || is_address != 0)) $display("MOD_RM %X FAIL, value: %X, is_address: %X", mod_rm_byte, value, is_address);
        
        mod_rm_byte = 8'hC2;
        #5
        if ((value != (reg_2) || is_address != 0)) $display("MOD_RM %X FAIL, value: %X, is_address: %X", mod_rm_byte, value, is_address);
        
        mod_rm_byte = 8'hC3;
        #5
        if ((value != (reg_3) || is_address != 0)) $display("MOD_RM %X FAIL, value: %X, is_address: %X", mod_rm_byte, value, is_address);
        
        mod_rm_byte = 8'hC4;
        #5
        if ((value != (reg_4) || is_address != 0)) $display("MOD_RM %X FAIL, value: %X, is_address: %X", mod_rm_byte, value, is_address);
        
        mod_rm_byte = 8'hC5;
        #5
        if ((value != (reg_5) || is_address != 0)) $display("MOD_RM %X FAIL, value: %X, is_address: %X", mod_rm_byte, value, is_address);
        
        mod_rm_byte = 8'hC6;
        #5
        if ((value != (reg_6) || is_address != 0)) $display("MOD_RM %X FAIL, value: %X, is_address: %X", mod_rm_byte, value, is_address);
        
        mod_rm_byte = 8'hC7;
        #5
        if ((value != (reg_7) || is_address != 0)) $display("MOD_RM %X FAIL, value: %X, is_address: %X", mod_rm_byte, value, is_address);


        // Test Segment Registers
        $display("Testing Segment Register Selection");
        mod_rm_byte = 8'h00;

        seg_sel = 0;
        #5
        if ((value != ((es << 16) + eax)) || is_address != 1) $display("SEG %X FAIL, value: %X", seg_sel, value);

        seg_sel = 1;
        #5
        if ((value != ((cs << 16) + eax)) || is_address != 1) $display("SEG %X FAIL, value: %X", seg_sel, value);

        seg_sel = 2;
        #5
        if ((value != ((ss << 16) + eax)) || is_address != 1) $display("SEG %X FAIL, value: %X", seg_sel, value);

        seg_sel = 3;
        #5
        if ((value != ((ds << 16) + eax)) || is_address != 1) $display("SEG %X FAIL, value: %X", seg_sel, value);

        seg_sel = 4;
        #5
        if ((value != ((fs << 16) + eax)) || is_address != 1) $display("SEG %X FAIL, value: %X", seg_sel, value);

        seg_sel = 5;
        #5
        if ((value != ((gs << 16) + eax)) || is_address != 1) $display("SEG %X FAIL, value: %X", seg_sel, value);



        $display("==========\n End Test \n==========");
    end


    initial #1000 $finish;

    initial begin
        $vcdplusfile("name.dump.vpd");
        $vcdpluson(0, TOP);
    end


endmodule