`timescale 1ns / 1ps

module tb_project;

    reg        ps2_clk;
    reg        ps2_data;
    reg        clk;

    wire [3:0] vga_r;
    wire [3:0] vga_g;
    wire [3:0] vga_b;
    wire       vga_hs;
    wire       vga_vs;

    project uut (
        .ps2_clk(ps2_clk),
        .ps2_data(ps2_data),
        .clk(clk),
        .vga_r(vga_r),
        .vga_g(vga_g),
        .vga_b(vga_b),
        .vga_hs(vga_hs),
        .vga_vs(vga_vs)
    );

    // Reloj principal de la Basys 3: 100 MHz (Período = 10 ns)
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    task enviar_byte_ps2;
        input [7:0] dato;
        integer i;
        reg paridad;
        begin
            paridad = ~(^dato);

            ps2_data = 1'b0;
            #5000; ps2_clk = 1'b0;
            #5000; ps2_clk = 1'b1;

            for (i = 0; i < 8; i = i + 1) begin
                ps2_data = dato[i];
                #5000; ps2_clk = 1'b0;
                #5000; ps2_clk = 1'b1;
            end

            ps2_data = paridad;
            #5000; ps2_clk = 1'b0;
            #5000; ps2_clk = 1'b1;

            ps2_data = 1'b1;
            #5000; ps2_clk = 1'b0;
            #5000; ps2_clk = 1'b1;

            #20000;
        end
    endtask

    initial begin
        ps2_clk  = 1'b1;
        ps2_data = 1'b1;
        #10000;

        // Presionar tecla W para mover raqueta 1
        enviar_byte_ps2(8'h1D);
        #200000;

        // Soltar tecla W
        enviar_byte_ps2(8'hF0);
        enviar_byte_ps2(8'h1D);
        #100000;

        $finish;
    end

endmodule