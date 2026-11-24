`timescale 1ns / 1ps // Unidad de 1 ns y precisión de 1 ps

module tb_sincronia_vga;

    reg        reloj;        // Reloj de entrada de 25 MHz
    reg        reiniciar;    // Señal de reinicio del testbench
    wire       sinc_h;       // Salida sincronismo horizontal
    wire       sinc_v;       // Salida sincronismo vertical
    wire       video_activo; // Salida zona visible activa
    wire [9:0] pos_x;        // Coordenada horizontal actual
    wire [9:0] pos_y;        // Coordenada vertical actual

    sincronia_vga uut ( // Instancia del generador de sincronía VGA
        .reloj(reloj),
        .reiniciar(reiniciar),
        .sinc_h(sinc_h),
        .sinc_v(sinc_v),
        .video_activo(video_activo),
        .pos_x(pos_x),
        .pos_y(pos_y)
    );

    // Reloj de 25 MHz (período de 40 ns: 20 ns en alto, 20 ns en bajo)
    initial begin
        reloj = 1'b0;
        forever #20 reloj = ~reloj;
    end

    initial begin
        $dumpfile("sincronia_vga.vcd"); // Guarda ondas para inspección visual
        $dumpvars(0, tb_sincronia_vga); // Registra señales del testbench
    end

    initial begin
        $display("Iniciando simulación VGA 640x480 @ 60Hz...");
        reiniciar = 1'b1; // Activa reinicio inicial
        #100;
        reiniciar = 1'b0; // Libera reinicio y comienza barrido

        // Espera ~17 ms para observar al menos un cuadro vertical completo (~16.7 ms)
        #17000000;
        $display("Simulación completada en t=%0t ns (pos_x=%0d, pos_y=%0d)",
                 $time, pos_x, pos_y);
        $finish; // Finaliza la simulación
    end

endmodule