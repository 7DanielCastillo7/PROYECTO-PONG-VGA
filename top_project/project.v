`default_nettype none

module project (
    input  wire        ps2_clk,
    input  wire        ps2_data,
    input  wire        clk,
    output wire [3:0]  vga_r,
    output wire [3:0]  vga_g,
    output wire [3:0]  vga_b,
    output wire        vga_hs,
    output wire        vga_vs
);

    wire clk_25mhz;
    wire btn_j1_subir, btn_j1_bajar, btn_j2_subir, btn_j2_bajar;
    wire sinc_h, sinc_v, video_activo;
    wire [9:0] pixel_x, pixel_y;
    wire [9:0] raqueta1_y, raqueta2_y, pelota_x, pelota_y;
    wire [3:0] score_j1, score_j2;
    wire [1:0] rojo, verde, azul;

    assign vga_hs = sinc_h;
    assign vga_vs = sinc_v;
    assign vga_r  = {rojo, rojo};
    assign vga_g  = {verde, verde};
    assign vga_b  = {azul, azul};

    divisor_reloj mod_divisor (
        .clk_100mhz(clk),
        .clk_25mhz(clk_25mhz)
    );

    teclado mod_teclado (
        .clk_25mhz(clk_25mhz),
        .ps2_clk(ps2_clk),
        .ps2_data(ps2_data),
        .J1_sube(btn_j1_subir),
        .J1_baja(btn_j1_bajar),
        .J2_sube(btn_j2_subir),
        .J2_baja(btn_j2_bajar)
    );

    sincronia_vga mod_vga (
        .reloj(clk_25mhz),
        .reiniciar(1'b0),
        .sinc_h(sinc_h),
        .sinc_v(sinc_v),
        .video_activo(video_activo),
        .pos_x(pixel_x),
        .pos_y(pixel_y)
    );

    juego mod_juego (
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

    pantalla mod_pantalla (
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

endmodule