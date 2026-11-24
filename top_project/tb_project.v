// [USO DE IA] Código redactado/estructurado con asistencia de IA y validado por el equipo.
`timescale 1ns / 1ps // Unidad de tiempo de 1 ns y precisión de 1 ps

module tb_project;

    reg        ps2_clk;  // Reloj PS/2 simulado
    reg        ps2_data; // Línea de datos PS/2 simulada
    reg        clk;      // Reloj principal de 100 MHz

    wire [3:0] vga_r;    // Salida rojo VGA
    wire [3:0] vga_g;    // Salida verde VGA
    wire [3:0] vga_b;    // Salida azul VGA
    wire       vga_hs;   // Salida H-sync VGA
    wire       vga_vs;   // Salida V-sync VGA

    project uut ( // Instancia del diseño completo
        .ps2_clk(ps2_clk),
        .ps2_data(ps2_data),
        .clk(clk),
        .vga_r(vga_r),
        .vga_g(vga_g),
        .vga_b(vga_b),
        .vga_hs(vga_hs),
        .vga_vs(vga_vs)
    );

    // Reloj maestro de 100 MHz (período de 10 ns: 5 ns en alto, 5 ns en bajo)
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("project.vcd"); // Guarda ondas para inspección visual
        $dumpvars(0, tb_project); // Registra todas las señales del top
    end

    // Envía una trama PS/2 de 11 bits: Start(0) + 8 datos(LSB) + Paridad + Stop(1)
    task enviar_byte_ps2;
        input [7:0] dato;
        integer i;
        reg paridad;
        begin
            paridad = ~(^dato); // Paridad impar PS/2

            ps2_data = 1'b0; // Bit de inicio
            #5000; ps2_clk = 1'b0;
            #5000; ps2_clk = 1'b1;

            for (i = 0; i < 8; i = i + 1) begin // 8 bits de scan code
                ps2_data = dato[i];
                #5000; ps2_clk = 1'b0;
                #5000; ps2_clk = 1'b1;
            end

            ps2_data = paridad; // Bit de paridad
            #5000; ps2_clk = 1'b0;
            #5000; ps2_clk = 1'b1;

            ps2_data = 1'b1; // Bit de parada
            #5000; ps2_clk = 1'b0;
            #5000; ps2_clk = 1'b1;

            #20000; // Espera entre tramas
        end
    endtask

    initial begin
        $display("Tiempo | J1_U | R1_Y | Pel_X | Pel_Y | HS | VS | RGB"); // Encabezado en consola
        $monitor("%6t |   %b  | %4d | %5d | %5d |  %b |  %b | %h%h%h",
                 $time, uut.btn_j1_subir, uut.raqueta1_y, uut.pelota_x, uut.pelota_y,
                 vga_hs, vga_vs, vga_r, vga_g, vga_b);

        ps2_clk  = 1'b1; // Reposo PS/2
        ps2_data = 1'b1;
        #10000;

        // Presiona tecla W (0x1D) para mover hacia arriba la raqueta 1
        enviar_byte_ps2(8'h1D);
        #200000;

        // Suelta tecla W (0xF0 seguido de 0x1D)
        enviar_byte_ps2(8'hF0);
        enviar_byte_ps2(8'h1D);
        #100000;

        $finish; // Finaliza la simulación
    end

endmodule