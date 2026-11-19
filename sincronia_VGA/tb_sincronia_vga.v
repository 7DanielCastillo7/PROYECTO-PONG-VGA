`timescale 1ns / 1ps

module tb_sincronia_vga;

    reg        reloj;
    reg        reiniciar;
    wire       sinc_h;
    wire       sinc_v;
    wire       video_activo;
    wire [9:0] pos_x;
    wire [9:0] pos_y;

    sincronia_vga uut (
        .reloj(reloj),
        .reiniciar(reiniciar),
        .sinc_h(sinc_h),
        .sinc_v(sinc_v),
        .video_activo(video_activo),
        .pos_x(pos_x),
        .pos_y(pos_y)
    );

    // Reloj de 25 MHz (Período = 40 ns)
    initial begin
        reloj = 1'b0;
        forever #20 reloj = ~reloj;
    end

    initial begin
        reiniciar = 1'b1;
        #100;
        reiniciar = 1'b0;

        // Simular poco más de 1 cuadro VGA completo (~16.8 ms)
        #17000000;
        $finish;
    end

endmodule