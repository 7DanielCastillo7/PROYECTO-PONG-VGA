`timescale 1ns / 1ps

module tb_marcador;

    reg  [9:0] pixel_x;
    reg  [9:0] pixel_y;
    reg  [9:0] box_x;
    reg  [9:0] box_y;
    reg  [3:0] digit;
    wire       en_digit;

    marcador uut (
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .box_x(box_x),
        .box_y(box_y),
        .digit(digit),
        .en_digit(en_digit)
    );

    integer x, y;

    initial begin
        box_x   = 10'd240;
        box_y   = 10'd30;
        pixel_x = 10'd240;
        pixel_y = 10'd30;

        // 1. Probar dígito 0 barriendo toda la caja de 16x28 píxeles
        digit = 4'd0;
        for (y = 30; y < 58; y = y + 1) begin
            for (x = 240; x < 256; x = x + 1) begin
                pixel_x = x;
                pixel_y = y;
                #10;
            end
        end

        // 2. Probar dígito 1 (solo enciende segmentos b y c)
        digit = 4'd1;
        for (y = 30; y < 58; y = y + 1) begin
            for (x = 240; x < 256; x = x + 1) begin
                pixel_x = x;
                pixel_y = y;
                #10;
            end
        end

        // 3. Probar dígito 8 (enciende todos los 7 segmentos)
        digit = 4'd8;
        for (y = 30; y < 58; y = y + 1) begin
            for (x = 240; x < 256; x = x + 1) begin
                pixel_x = x;
                pixel_y = y;
                #10;
            end
        end

        $finish;
    end

endmodule