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
        $display("Testing each SS and Index with EAX as base");
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

        // TODO: Finish numbering the sib bytes for *4 and *8
        // run to make sure it works properly

        // copy and paste to test each other base?
        // test changing Segment registers




        $display("==========\n End Test \n==========");
    end


    initial #1000 $finish;

    initial begin
        $vcdplusfile("sib.dump.vpd");
        $vcdpluson(0, TOP);
    end


endmodule