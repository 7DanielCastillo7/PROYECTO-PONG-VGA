// [USO DE IA] Código redactado/estructurado con asistencia de IA y validado por el equipo.
`timescale 1ns / 1ps // Unidad de tiempo de 1 ns y precisión de 1 ps

module tb_marcador;

    reg  [9:0] pixel_x; // Coordenada X barrida en simulación
    reg  [9:0] pixel_y; // Coordenada Y barrida en simulación
    reg  [9:0] box_x;   // Origen X de la caja del dígito
    reg  [9:0] box_y;   // Origen Y de la caja del dígito
    reg  [3:0] digit;   // Dígito de prueba
    wire       en_digit;// Salida de píxel activo del marcador

    marcador uut ( // Instancia del módulo marcador
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .box_x(box_x),
        .box_y(box_y),
        .digit(digit),
        .en_digit(en_digit)
    );

    integer x, y; // Contadores de barrido para filas y columnas

    initial begin
        box_x   = 10'd240; // Ubica la caja en X = 240
        box_y   = 10'd30;  // Ubica la caja en Y = 30
        pixel_x = 10'd240;
        pixel_y = 10'd30;

        // 1. Barrido completo de 16x28 píxeles para el dígito 0
        digit = 4'd0;
        for (y = 30; y < 58; y = y + 1) begin
            for (x = 240; x < 256; x = x + 1) begin
                pixel_x = x; // Actualiza columna
                pixel_y = y; // Actualiza fila
                #10;         // Espera 10 ns por píxel
            end
        end

        // 2. Barrido completo para el dígito 1 (segmentos b y c activos)
        digit = 4'd1;
        for (y = 30; y < 58; y = y + 1) begin
            for (x = 240; x < 256; x = x + 1) begin
                pixel_x = x;
                pixel_y = y;
                #10;
            end
        end

        // 3. Barrido completo para el dígito 8 (todos los segmentos activos)
        digit = 4'd8;
        for (y = 30; y < 58; y = y + 1) begin
            for (x = 240; x < 256; x = x + 1) begin
                pixel_x = x;
                pixel_y = y;
                #10;
            end
        end

        $finish; // Finaliza la simulación
    end

endmodule