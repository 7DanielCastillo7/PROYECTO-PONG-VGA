`timescale 1ns / 1ps

module tb_teclado;

    reg  clk_25mhz;
    reg  ps2_clk;
    reg  ps2_data;

    wire J1_sube;
    wire J1_baja;
    wire J2_sube;
    wire J2_baja;

    teclado uut (
        .clk_25mhz(clk_25mhz),
        .ps2_clk(ps2_clk),
        .ps2_data(ps2_data),
        .J1_sube(J1_sube),
        .J1_baja(J1_baja),
        .J2_sube(J2_sube),
        .J2_baja(J2_baja)
    );

    // Reloj de 25 MHz (Período = 40 ns)
    initial begin
        clk_25mhz = 1'b0;
        forever #20 clk_25mhz = ~clk_25mhz;
    end

    // Tarea para enviar trama PS/2 de 11 bits
    task enviar_byte_ps2;
        input [7:0] dato;
        integer i;
        reg paridad;
        begin
            paridad = ~(^dato);

            // Bit Start (0)
            ps2_data = 1'b0;
            #5000; ps2_clk = 1'b0;
            #5000; ps2_clk = 1'b1;

            // 8 Bits de datos (LSB primero)
            for (i = 0; i < 8; i = i + 1) begin
                ps2_data = dato[i];
                #5000; ps2_clk = 1'b0;
                #5000; ps2_clk = 1'b1;
            end

            // Bit Paridad
            ps2_data = paridad;
            #5000; ps2_clk = 1'b0;
            #5000; ps2_clk = 1'b1;

            // Bit Stop (1)
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

        // Presionar y soltar W (0x1D)
        enviar_byte_ps2(8'h1D);
        #50000;
        enviar_byte_ps2(8'hF0);
        enviar_byte_ps2(8'h1D);
        #50000;

        // Presionar y soltar Flecha Arriba (0xE0, 0x75)
        enviar_byte_ps2(8'hE0);
        enviar_byte_ps2(8'h75);
        #50000;
        enviar_byte_ps2(8'hE0);
        enviar_byte_ps2(8'hF0);
        enviar_byte_ps2(8'h75);
        #50000;

        $finish;
    end

endmodule