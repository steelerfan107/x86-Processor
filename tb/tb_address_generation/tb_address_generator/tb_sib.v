// tb_sib.v
// Brandon Zupan

// Testbench for testing the SIB value generator

module TOP;
    wire [31:0] sib_out;

    reg [7:0] sib_byte;

    // no esp
    reg [31:0] eax;
    reg [31:0] ecx;
    reg [31:0] edx;
    reg [31:0] ebx;
    reg [31:0] esp;
    reg [31:0] ebp;
    reg [31:0] esi;
    reg [31:0] edi;

    reg [2:0] seg_sel;

    reg [15:0] es;
    reg [15:0] cs;
    reg [15:0] ss;
    reg [15:0] ds;
    reg [15:0] fs;
    reg [15:0] gs;

    sib uut (

        sib_out,

        sib_byte,

        eax,
        ecx,
        edx,
        ebx,
        esp,
        ebp,
        esi,
        edi,

        seg_sel,

        es,
        cs,
        ss,
        ds,
        fs,
        gs
    );

    initial begin
        $display("============ \n Begin Test \n============");
        sib_byte = 0;

        eax = 0;
        ecx = 32'h0000_00cc;
        edx = 32'h0000_00dd;
        ebx = 32'h0000_00bb;
        esp = 32'h0000_0011;
        ebp = 32'h0000_0022;
        esi = 32'h0000_0033;
        edi = 32'h0000_0044;

        seg_sel = 0;

        es = 16'haa00;
        cs = 16'hbb00;
        ss = 16'hcc00;
        ds = 16'hdd00;
        fs = 16'hee00;
        gs = 16'hff00;

        #12.5

        // Test each ss and index with eax as base
        $display("Testing each SS and Index with Base 1");
        eax = 32'h0000_aa00;

        // eax as base
        sib_byte = 8'h00;
        #5
        if (sib_out != ((es << 16) + eax + eax)) $display("SIB %X FAIL", sib_byte);

        sib_byte = 8'h08;
        #5
        if (sib_out != ((es << 16) + eax + ecx)) $display("SIB %X FAIL", sib_byte);

        sib_byte = 8'h10;
        #5
        if (sib_out != ((es << 16) + eax + edx)) $display("SIB %X FAIL", sib_byte);

        sib_byte = 8'h18;
        #5
        if (sib_out != ((es << 16) + eax + ebx)) $display("SIB %X FAIL", sib_byte);

        sib_byte = 8'h20;
        #5
        if (sib_out != ((es << 16) + eax)) $display("SIB %X FAIL", sib_byte);

        sib_byte = 8'h28;
        #5
        if (sib_out != ((es << 16) + eax + ebp)) $display("SIB %X FAIL", sib_byte);

        sib_byte = 8'h30;
        #5
        if (sib_out != ((es << 16) + eax + esi)) $display("SIB %X FAIL", sib_byte);

        sib_byte = 8'h38;
        #5
        if (sib_out != ((es << 16) + eax + edi)) $display("SIB %X FAIL", sib_byte);


        // scale of *2
        sib_byte = 8'h40;
        #5
        if (sib_out != ((es << 16) + eax + 2*eax)) $display("SIB %X FAIL", sib_byte);

        sib_byte = 8'h48;
        #5
        if (sib_out != ((es << 16) + eax + 2*ecx)) $display("SIB %X FAIL", sib_byte);

        sib_byte = 8'h50;
        #5
        if (sib_out != ((es << 16) + eax + 2*edx)) $display("SIB %X FAIL", sib_byte);

        sib_byte = 8'h58;
        #5
        if (sib_out != ((es << 16) + eax + 2*ebx)) $display("SIB %X FAIL", sib_byte);

        sib_byte = 8'h60;
        #5
        if (sib_out != ((es << 16) + eax)) $display("SIB %X FAIL", sib_byte);

        sib_byte = 8'h68;
        #5
        if (sib_out != ((es << 16) + eax + 2*ebp)) $display("SIB %X FAIL", sib_byte);

        sib_byte = 8'h70;
        #5
        if (sib_out != ((es << 16) + eax + 2*esi)) $display("SIB %X FAIL", sib_byte);

        sib_byte = 8'h78;
        #5
        if (sib_out != ((es << 16) + eax + 2*edi)) $display("SIB %X FAIL", sib_byte);


        // scale of *4
        sib_byte = 8'h80;
        #5
        if (sib_out != ((es << 16) + eax + 4*eax)) $display("SIB %X FAIL", sib_byte);

        sib_byte = 8'h88;
        #5
        if (sib_out != ((es << 16) + eax + 4*ecx)) $display("SIB %X FAIL", sib_byte);

        sib_byte = 8'h90;
        #5
        if (sib_out != ((es << 16) + eax + 4*edx)) $display("SIB %X FAIL", sib_byte);

        sib_byte = 8'h98;
        #5
        if (sib_out != ((es << 16) + eax + 4*ebx)) $display("SIB %X FAIL", sib_byte);

        sib_byte = 8'hA0;
        #5
        if (sib_out != ((es << 16) + eax)) $display("SIB %X FAIL", sib_byte);

        sib_byte = 8'hA8;
        #5
        if (sib_out != ((es << 16) + eax + 4*ebp)) $display("SIB %X FAIL", sib_byte);

        sib_byte = 8'hB0;
        #5
        if (sib_out != ((es << 16) + eax + 4*esi)) $display("SIB %X FAIL", sib_byte);

        sib_byte = 8'hB8;
        #5
        if (sib_out != ((es << 16) + eax + 4*edi)) $display("SIB %X FAIL", sib_byte);


        // scale of *8
        sib_byte = 8'hC0;   // aa00_0000 + 0000_aa00 + 0005_5000 = aa05_fa00
        #5
        if (sib_out != ((es << 16) + eax + 8*eax)) $display("SIB %X FAIL", sib_byte);

        sib_byte = 8'hC8;
        #5
        if (sib_out != ((es << 16) + eax + 8*ecx)) $display("SIB %X FAIL", sib_byte);

        sib_byte = 8'hD0;
        #5
        if (sib_out != ((es << 16) + eax + 8*edx)) $display("SIB %X FAIL", sib_byte);

        sib_byte = 8'hD8;
        #5
        if (sib_out != ((es << 16) + eax + 8*ebx)) $display("SIB %X FAIL", sib_byte);

        sib_byte = 8'hE0;
        #5
        if (sib_out != ((es << 16) + eax)) $display("SIB %X FAIL", sib_byte);

        sib_byte = 8'hE8;
        #5
        if (sib_out != ((es << 16) + eax + 8*ebp)) $display("SIB %X FAIL", sib_byte);

        sib_byte = 8'hF0;
        #5
        if (sib_out != ((es << 16) + eax + 8*esi)) $display("SIB %X FAIL", sib_byte);

        sib_byte = 8'hF8;
        #5
        if (sib_out != ((es << 16) + eax + 8*edi)) $display("SIB %X FAIL", sib_byte);

        eax = 32'h0000_00aa;

        $display("Testing SS 00 with Base 1");
        ecx = 32'h0000_cc00;

        sib_byte = 8'h01;
        #5
        if (sib_out != ((es << 16) + ecx + eax)) $display("SIB %X FAIL", sib_byte);
        
        sib_byte = 8'h09;
        #5
        if (sib_out != ((es << 16) + ecx + ecx)) $display("SIB %X FAIL", sib_byte);

        sib_byte = 8'h11;
        #5
        if (sib_out != ((es << 16) + ecx + edx)) $display("SIB %X FAIL", sib_byte);
        
        sib_byte = 8'h19;
        #5
        if (sib_out != ((es << 16) + ecx + ebx)) $display("SIB %X FAIL", sib_byte);
        
        sib_byte = 8'h21;
        #5
        if (sib_out != ((es << 16) + ecx)) $display("SIB %X FAIL", sib_byte);
        
        sib_byte = 8'h29;
        #5
        if (sib_out != ((es << 16) + ecx + ebp)) $display("SIB %X FAIL", sib_byte);
        
        sib_byte = 8'h31;
        #5
        if (sib_out != ((es << 16) + ecx + esi)) $display("SIB %X FAIL", sib_byte);
        
        sib_byte = 8'h39;
        #5
        if (sib_out != ((es << 16) + ecx + edi)) $display("SIB %X FAIL", sib_byte);

        ecx = 32'h0000_00cc;

        $display("Testing SS 00 with Base 2");
        edx = 32'h0000_dd00;

        sib_byte = 8'h02;
        #5
        if (sib_out != ((es << 16) + edx + eax)) $display("SIB %X FAIL", sib_byte);
        
        sib_byte = 8'h0A;
        #5
        if (sib_out != ((es << 16) + edx + ecx)) $display("SIB %X FAIL", sib_byte);
        
        sib_byte = 8'h12;
        #5
        if (sib_out != ((es << 16) + edx + edx)) $display("SIB %X FAIL", sib_byte);
        
        sib_byte = 8'h1A;
        #5
        if (sib_out != ((es << 16) + edx + ebx)) $display("SIB %X FAIL", sib_byte);
        
        sib_byte = 8'h22;
        #5
        if (sib_out != ((es << 16) + edx)) $display("SIB %X FAIL", sib_byte);
        
        sib_byte = 8'h2A;
        #5
        if (sib_out != ((es << 16) + edx + ebp)) $display("SIB %X FAIL", sib_byte);
        
        sib_byte = 8'h32;
        #5
        if (sib_out != ((es << 16) + edx + esi)) $display("SIB %X FAIL", sib_byte);
        
        sib_byte = 8'h3A;
        #5
        if (sib_out != ((es << 16) + edx + edi)) $display("SIB %X FAIL", sib_byte);

        edx = 32'h0000_00dd;

        $display("Testing SS 00 with Base 3");
        ebx = 32'h0000_bb00;

        sib_byte = 8'h03;
        #5
        if (sib_out != ((es << 16) + ebx + eax)) $display("SIB %X FAIL", sib_byte);

        sib_byte = 8'h0B;
        #5
        if (sib_out != ((es << 16) + ebx + ecx)) $display("SIB %X FAIL", sib_byte);
        
        sib_byte = 8'h13;
        #5
        if (sib_out != ((es << 16) + ebx + edx)) $display("SIB %X FAIL", sib_byte);
        
        sib_byte = 8'h1B;
        #5
        if (sib_out != ((es << 16) + ebx + ebx)) $display("SIB %X FAIL", sib_byte);
        
        sib_byte = 8'h23;
        #5
        if (sib_out != ((es << 16) + ebx)) $display("SIB %X FAIL", sib_byte);
        
        sib_byte = 8'h2B;
        #5
        if (sib_out != ((es << 16) + ebx + ebp)) $display("SIB %X FAIL", sib_byte);
        
        sib_byte = 8'h33;
        #5
        if (sib_out != ((es << 16) + ebx + esi)) $display("SIB %X FAIL", sib_byte);
        
        sib_byte = 8'h3B;
        #5
        if (sib_out != ((es << 16) + ebx + edi)) $display("SIB %X FAIL", sib_byte);

        ebx = 32'h0000_00bb;

        $display("Testing SS 00 with Base 4");
        esp = 32'h0000_1100;

        sib_byte = 8'h04;
        #5
        if (sib_out != ((ss << 16) + esp + eax)) $display("SIB %X FAIL", sib_byte);
        
        sib_byte = 8'h0C;
        #5
        if (sib_out != ((ss << 16) + esp + ecx)) $display("SIB %X FAIL", sib_byte);
        
        sib_byte = 8'h14;
        #5
        if (sib_out != ((ss << 16) + esp + edx)) $display("SIB %X FAIL", sib_byte);
        
        sib_byte = 8'h1C;
        #5
        if (sib_out != ((ss << 16) + esp + ebx)) $display("SIB %X FAIL", sib_byte);
        
        sib_byte = 8'h24;
        #5
        if (sib_out != ((ss << 16) + esp)) $display("SIB %X FAIL", sib_byte);
        
        sib_byte = 8'h2C;
        #5
        if (sib_out != ((ss << 16) + esp + ebp)) $display("SIB %X FAIL", sib_byte);
        
        sib_byte = 8'h34;
        #5
        if (sib_out != ((ss << 16) + esp + esi)) $display("SIB %X FAIL", sib_byte);
        
        sib_byte = 8'h3C;
        #5
        if (sib_out != ((ss << 16) + esp + edi)) $display("SIB %X FAIL", sib_byte);

        esp = 32'h0000_0011;

        $display("*** SKIPPING BASE 5 TEST FOR NOW ***");
        
        $display("Testing SS 00 with Base 6");
        esi = 32'h0000_3300;

        sib_byte = 8'h06;
        #5
        if (sib_out != ((es << 16) + esi + eax)) $display("SIB %X FAIL", sib_byte);

        sib_byte = 8'h0E;
        #5
        if (sib_out != ((es << 16) + esi + ecx)) $display("SIB %X FAIL", sib_byte);
        
        sib_byte = 8'h16;
        #5
        if (sib_out != ((es << 16) + esi + edx)) $display("SIB %X FAIL", sib_byte);
        
        sib_byte = 8'h1E;
        #5
        if (sib_out != ((es << 16) + esi + ebx)) $display("SIB %X FAIL", sib_byte);
        
        sib_byte = 8'h26;
        #5
        if (sib_out != ((es << 16) + esi)) $display("SIB %X FAIL", sib_byte);
        
        sib_byte = 8'h2E;
        #5
        if (sib_out != ((es << 16) + esi + ebp)) $display("SIB %X FAIL", sib_byte);
        
        sib_byte = 8'h36;
        #5
        if (sib_out != ((es << 16) + esi + esi)) $display("SIB %X FAIL", sib_byte);
        
        sib_byte = 8'h3E;
        #5
        if (sib_out != ((es << 16) + esi + edi)) $display("SIB %X FAIL", sib_byte);

        esi = 32'h0000_0033;

        $display("Testing SS 00 with Base 7");
        edi = 32'h0000_4400;

        sib_byte = 8'h07;
        #5
        if (sib_out != ((es << 16) + edi + eax)) $display("SIB %X FAIL", sib_byte);

        sib_byte = 8'h0F;
        #5
        if (sib_out != ((es << 16) + edi + ecx)) $display("SIB %X FAIL", sib_byte);
        
        sib_byte = 8'h17;
        #5
        if (sib_out != ((es << 16) + edi + edx)) $display("SIB %X FAIL", sib_byte);
        
        sib_byte = 8'h1F;
        #5
        if (sib_out != ((es << 16) + edi + ebx)) $display("SIB %X FAIL", sib_byte);
        
        sib_byte = 8'h27;
        #5
        if (sib_out != ((es << 16) + edi)) $display("SIB %X FAIL", sib_byte);
        
        sib_byte = 8'h2F;
        #5
        if (sib_out != ((es << 16) + edi + ebp)) $display("SIB %X FAIL", sib_byte);
        
        sib_byte = 8'h37;
        #5
        if (sib_out != ((es << 16) + edi + esi)) $display("SIB %X FAIL", sib_byte);
        
        sib_byte = 8'h3F;
        #5
        if (sib_out != ((es << 16) + edi + edi)) $display("SIB %X FAIL", sib_byte);

        edi = 32'h0000_0044;
        
        
    
        // TODO: test changing Segment registers
        $display("Testing Segment Registers");

        // switch back to using SIB of 00
        sib_byte = 8'h20;

        seg_sel = 0;
        #5
        if (sib_out != ((es << 16) + eax)) $display("SEG SELECT %X FAIL: SIB_OUT = %X", seg_sel, sib_out);

        seg_sel = 1;
        #5
        if (sib_out != ((cs << 16) + eax)) $display("SEG SELECT %X FAIL", seg_sel);
        
        seg_sel = 2;
        #5
        if (sib_out != ((ss << 16) + eax)) $display("SEG SELECT %X FAIL", seg_sel);
        
        seg_sel = 3;
        #5
        if (sib_out != ((ds << 16) + eax)) $display("SEG SELECT %X FAIL", seg_sel);
        
        seg_sel = 4;
        #5
        if (sib_out != ((fs << 16) + eax)) $display("SEG SELECT %X FAIL", seg_sel);
        
        seg_sel = 5;
        #5
        if (sib_out != ((gs << 16) + eax)) $display("SEG SELECT %X FAIL", seg_sel);
    


        $display("==========\n End Test \n==========");
    end


    initial #1000 $finish;

    initial begin
        $vcdplusfile("sib.dump.vpd");
        $vcdpluson(0, TOP);
    end


endmodule