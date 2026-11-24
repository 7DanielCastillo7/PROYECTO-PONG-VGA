// [USO DE IA] Código redactado/estructurado con asistencia de IA y validado por el equipo.
`timescale 1ns / 1ps // Unidad de 1 ns y precisión de 1 ps

module tb_pantalla;

    reg        video_activo; // Habilitación de video visible
    reg  [9:0] pixel_x;      // Coordenada X de prueba
    reg  [9:0] pixel_y;      // Coordenada Y de prueba
    reg  [9:0] raqueta1_y;   // Posición Y raqueta 1
    reg  [9:0] raqueta2_y;   // Posición Y raqueta 2
    reg  [9:0] pelota_x;     // Posición X pelota
    reg  [9:0] pelota_y;     // Posición Y pelota
    reg  [3:0] score_j1;     // Puntaje J1 de prueba
    reg  [3:0] score_j2;     // Puntaje J2 de prueba

    wire [1:0] rojo;         // Salida canal rojo
    wire [1:0] verde;        // Salida canal verde
    wire [1:0] azul;         // Salida canal azul

    pantalla uut ( // Instancia del módulo pantalla
        .video_activo(video_activo),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .raqueta1_y(raqueta1_y),
        .raqueta2_y(raqueta2_y),
        .pelota_x(pelota_x),
        .pelota_y(pelota_y),
        .score_j1(score_j1),
        .score_j2(score_j2),
        .rojo(rojo),
        .verde(verde),
        .azul(azul)
    );

    initial begin
        $dumpfile("pantalla.vcd"); // Guarda ondas para inspección visual
        $dumpvars(0, tb_pantalla); // Registra señales del testbench
    end

    initial begin
        $display("Tiempo | Act |   X  |   Y  |  R  |  G  |  B"); // Encabezado en consola
        $monitor("%6t |  %b  | %4d | %4d | %2b | %2b | %2b",
                 $time, video_activo, pixel_x, pixel_y, rojo, verde, azul);

        // Posiciones y puntajes iniciales de prueba
        raqueta1_y = 10'd200;
        raqueta2_y = 10'd200;
        pelota_x   = 10'd316;
        pelota_y   = 10'd236;
        score_j1   = 4'd3;
        score_j2   = 4'd5;

        // 1. Fuera de zona visible (debe dar negro: 00, 00, 00)
        video_activo = 1'b0;
        pixel_x = 10'd100; pixel_y = 10'd100;
        #50;

        // 2. Fondo de la cancha (debe dar negro dentro de zona visible)
        video_activo = 1'b1;
        pixel_x = 10'd100; pixel_y = 10'd100;
        #50;

        // 3. Sobre Raqueta 1 (debe dar blanco: 11, 11, 11)
        pixel_x = 10'd25; pixel_y = 10'd220;
        #50;

        // 4. Sobre Raqueta 2 (debe dar blanco: 11, 11, 11)
        pixel_x = 10'd615; pixel_y = 10'd220;
        #50;

        // 5. Sobre la Pelota (debe dar blanco: 11, 11, 11)
        pixel_x = 10'd318; pixel_y = 10'd238;
        #50;

        // 6. Sobre la red central punteada (X=320, Y=16 tiene bit Y[3]=0 -> color de red)
        pixel_x = 10'd320; pixel_y = 10'd16;
        #50;

        $finish; // Finaliza la simulación
    end

endmodule