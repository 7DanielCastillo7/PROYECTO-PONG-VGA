`timescale 1ns / 1ps // Unidad de tiempo de 1 ns y precisión de 1 ps

module tb_teclado;

    reg  clk_25mhz; // Reloj de 25 MHz de prueba
    reg  ps2_clk;   // Reloj PS/2 simulado
    reg  ps2_data;  // Línea de datos PS/2 simulada

    wire J1_sube;   // Salida observada W
    wire J1_baja;   // Salida observada S
    wire J2_sube;   // Salida observada Flecha Arriba
    wire J2_baja;   // Salida observada Flecha Abajo

    teclado uut ( // Instancia del decodificador PS/2
        .clk_25mhz(clk_25mhz),
        .ps2_clk(ps2_clk),
        .ps2_data(ps2_data),
        .J1_sube(J1_sube),
        .J1_baja(J1_baja),
        .J2_sube(J2_sube),
        .J2_baja(J2_baja)
    );

    // Reloj de 25 MHz (período de 40 ns: 20 ns en alto, 20 ns en bajo)
    initial begin
        clk_25mhz = 1'b0;
        forever #20 clk_25mhz = ~clk_25mhz;
    end

    initial begin
        $dumpfile("teclado.vcd"); // Guarda ondas para inspección visual
        $dumpvars(0, tb_teclado); // Registra señales del testbench
    end

    // Envía una trama PS/2 completa de 11 bits: Start(0) + 8 datos(LSB) + Paridad + Stop(1)
    task enviar_byte_ps2;
        input [7:0] dato;
        integer i;
        reg paridad;
        begin
            paridad = ~(^dato); // Paridad impar estándar PS/2

            // Bit de inicio (0)
            ps2_data = 1'b0;
            #5000; ps2_clk = 1'b0;
            #5000; ps2_clk = 1'b1;

            // 8 bits de datos (del bit 0 al bit 7)
            for (i = 0; i < 8; i = i + 1) begin
                ps2_data = dato[i];
                #5000; ps2_clk = 1'b0;
                #5000; ps2_clk = 1'b1;
            end

            // Bit de paridad
            ps2_data = paridad;
            #5000; ps2_clk = 1'b0;
            #5000; ps2_clk = 1'b1;

            // Bit de parada (1)
            ps2_data = 1'b1;
            #5000; ps2_clk = 1'b0;
            #5000; ps2_clk = 1'b1;

            #20000; // Pausa entre bytes transmitidos
        end
    endtask

    initial begin
        $display("Tiempo | Scan | No_Sol | J1_U | J1_D | J2_U | J2_D"); // Encabezado en consola
        $monitor("%6t |  %h  |    %b   |   %b  |   %b  |   %b  |   %b",
                 $time, uut.scan_code, uut.No_Sol, J1_sube, J1_baja, J2_sube, J2_baja);

        ps2_clk  = 1'b1; // Línea PS/2 en reposo (alto)
        ps2_data = 1'b1;
        #10000;

        // Presionar W (0x1D) -> activa J1_sube
        enviar_byte_ps2(8'h1D);
        #50000;

        // Soltar W (0xF0 seguido de 0x1D) -> desactiva J1_sube
        enviar_byte_ps2(8'hF0);
        enviar_byte_ps2(8'h1D);
        #50000;

        // Presionar Flecha Arriba (0xE0, 0x75) -> activa J2_sube
        enviar_byte_ps2(8'hE0);
        enviar_byte_ps2(8'h75);
        #50000;

        // Soltar Flecha Arriba (0xE0, 0xF0, 0x75) -> desactiva J2_sube
        enviar_byte_ps2(8'hE0);
        enviar_byte_ps2(8'hF0);
        enviar_byte_ps2(8'h75);
        #50000;

        $finish; // Finaliza la simulación
    end

endmodule