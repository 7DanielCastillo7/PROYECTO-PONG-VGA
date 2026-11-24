// [USO DE IA] Código redactado/estructurado con asistencia de IA y validado por el equipo.
`timescale 1ns / 1ps // Unidad de 1 ns y precisión de 1 ps

module tb_juego;

    reg        sinc_v;       // Pulso de cuadro simulado
    reg        btn_j1_subir; // Estímulo subir J1
    reg        btn_j1_bajar; // Estímulo bajar J1
    reg        btn_j2_subir; // Estímulo subir J2
    reg        btn_j2_bajar; // Estímulo bajar J2

    wire [9:0] raqueta1_y;   // Salida posición Y raqueta 1
    wire [9:0] raqueta2_y;   // Salida posición Y raqueta 2
    wire [9:0] pelota_x;     // Salida posición X pelota
    wire [9:0] pelota_y;     // Salida posición Y pelota
    wire [3:0] score_j1;     // Salida puntaje J1
    wire [3:0] score_j2;     // Salida puntaje J2

    juego uut ( // Instancia del módulo de lógica del juego
        .sinc_v(sinc_v),
        .btn_j1_subir(btn_j1_subir),
        .btn_j1_bajar(btn_j1_bajar),
        .btn_j2_subir(btn_j2_subir),
        .btn_j2_bajar(btn_j2_bajar),
        .raqueta1_y(raqueta1_y),
        .raqueta2_y(raqueta2_y),
        .pelota_x(pelota_x),
        .pelota_y(pelota_y),
        .score_j1(score_j1),
        .score_j2(score_j2)
    );

    initial begin
        sinc_v = 1'b0; // Inicia pulso de cuadro en 0
        forever #500 sinc_v = ~sinc_v; // Período acelerado de 1000 ns para simular rápido
    end

    initial begin
        $dumpfile("juego.vcd"); // Guarda formas de onda para inspección visual
        $dumpvars(0, tb_juego); // Registra todas las señales del testbench
    end

    initial begin
        $display("Tiempo | R1_Y | R2_Y | Pel_X | Pel_Y | J1 | J2 | Vel"); // Encabezado en consola
        $monitor("%6t | %4d | %4d | %5d | %5d | %2d | %2d | %3d",
                 $time, raqueta1_y, raqueta2_y, pelota_x, pelota_y,
                 score_j1, score_j2, uut.pelota_speed);

        btn_j1_subir = 1'b0; // Estado inicial sin botones presionados
        btn_j1_bajar = 1'b0;
        btn_j2_subir = 1'b0;
        btn_j2_bajar = 1'b0;
        #2000;

        btn_j1_subir = 1'b1; // Sube raqueta 1 y baja raqueta 2
        btn_j2_bajar = 1'b1;
        #15000;

        btn_j1_subir = 1'b0; // Suelta botones y observa trayectorias y goles
        btn_j2_bajar = 1'b0;
        #150000;

        $finish; // Finaliza la simulación
    end

endmodule
