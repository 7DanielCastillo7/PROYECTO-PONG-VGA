`timescale 1ns / 1ps

module tb_pantalla;

    reg        video_activo;
    reg  [9:0] pixel_x;
    reg  [9:0] pixel_y;
    reg  [9:0] raqueta1_y;
    reg  [9:0] raqueta2_y;
    reg  [9:0] pelota_x;
    reg  [9:0] pelota_y;
    reg  [3:0] score_j1;
    reg  [3:0] score_j2;

    wire [1:0] rojo;
    wire [1:0] verde;
    wire [1:0] azul;

    pantalla uut (
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
        // Posiciones iniciales estándar
        raqueta1_y = 10'd200;
        raqueta2_y = 10'd200;
        pelota_x   = 10'd316;
        pelota_y   = 10'd236;
        score_j1   = 4'd3;
        score_j2   = 4'd5;

        // 1. Fuera de zona visible (debe dar negro: 0,0,0)
        video_activo = 1'b0;
        pixel_x = 10'd100; pixel_y = 10'd100;
        #50;

        // 2. Zona de fondo de cancha
        video_activo = 1'b1;
        pixel_x = 10'd100; pixel_y = 10'd100;
        #50;

        // 3. Sobre la Raqueta 1 (X = 25, Y = 220)
        pixel_x = 10'd25; pixel_y = 10'd220;
        #50;

        // 4. Sobre la Raqueta 2 (X = 615, Y = 220)
        pixel_x = 10'd615; pixel_y = 10'd220;
        #50;

        // 5. Sobre la Pelota (X = 318, Y = 238)
        pixel_x = 10'd318; pixel_y = 10'd238;
        #50;

        // 6. Sobre la red central punteada (X = 320, Y = 10)
        pixel_x = 10'd320; pixel_y = 10'd10;
        #50;

        $finish;
    end

endmodule