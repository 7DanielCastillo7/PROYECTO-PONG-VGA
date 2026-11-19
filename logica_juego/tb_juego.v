`timescale 1ns / 1ps

module tb_juego;

    reg        sinc_v;
    reg        btn_j1_subir;
    reg        btn_j1_bajar;
    reg        btn_j2_subir;
    reg        btn_j2_bajar;

    wire [9:0] raqueta1_y;
    wire [9:0] raqueta2_y;
    wire [9:0] pelota_x;
    wire [9:0] pelota_y;
    wire [3:0] score_j1;
    wire [3:0] score_j2;

    juego uut (
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

    // Reloj de cuadro acelerado para ver movimiento rápido en simulación
    initial begin
        sinc_v = 1'b0;
        forever #500 sinc_v = ~sinc_v;
    end

    initial begin
        btn_j1_subir = 1'b0;
        btn_j1_bajar = 1'b0;
        btn_j2_subir = 1'b0;
        btn_j2_bajar = 1'b0;
        #2000;

        // Mover raqueta 1 hacia arriba y raqueta 2 hacia abajo
        btn_j1_subir = 1'b1;
        btn_j2_bajar = 1'b1;
        #15000;

        // Soltar botones y dejar que la pelota avance y rebote/anote
        btn_j1_subir = 1'b0;
        btn_j2_bajar = 1'b0;
        #150000;

        $finish;
    end

endmodule
