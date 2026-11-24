// [USO DE IA] Código redactado/estructurado con asistencia de IA y validado por el equipo.
`timescale 1ns / 1ps // Unidad de tiempo de 1 ns y precisión de 1 ps

module tb_divisor_reloj;

    reg  clk_100mhz; // Estímulo de reloj de 100 MHz para el módulo
    wire clk_25mhz;  // Señal de salida observada del divisor

    divisor_reloj uut ( // Instancia del módulo bajo prueba
        .clk_100mhz(clk_100mhz),
        .clk_25mhz(clk_25mhz)
    );

    initial begin
        clk_100mhz = 1'b0; // Inicia el reloj en 0
        forever #5 clk_100mhz = ~clk_100mhz; // Invierte cada 5 ns (período 10 ns = 100 MHz)
    end

    initial begin
        $dumpfile("divisor_reloj.vcd"); // Guarda ondas para visor tipo GTKWave
        $dumpvars(0, tb_divisor_reloj); // Registra todas las señales del testbench
    end

    initial begin
        $display("Tiempo(ns) | clk_100mhz | contador | clk_25mhz"); // Encabezado en consola
        $monitor("%8t   |     %b      |    %b    |     %b", // Imprime cambios de señal
                 $time, clk_100mhz, uut.contador, clk_25mhz);
        #200; // Simula 200 ns (5 ciclos completos de 25 MHz)
        $finish; // Detiene la simulación
    end

endmodule