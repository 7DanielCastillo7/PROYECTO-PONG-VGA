// [USO DE IA] Código redactado/estructurado con asistencia de IA y validado por el equipo.
`default_nettype none // Exige declarar explícitamente todos los cables

module project (
    input  wire        ps2_clk,  // Reloj serial del teclado PS/2
    input  wire        ps2_data, // Datos seriales del teclado PS/2
    input  wire        clk,      // Reloj maestro de 100 MHz de la Basys 3
    output wire [3:0]  vga_r,    // Canal rojo VGA (4 bits por DAC en tarjeta)
    output wire [3:0]  vga_g,    // Canal verde VGA (4 bits por DAC en tarjeta)
    output wire [3:0]  vga_b,    // Canal azul VGA (4 bits por DAC en tarjeta)
    output wire        vga_hs,   // Sincronismo horizontal VGA
    output wire        vga_vs    // Sincronismo vertical VGA
);

    wire clk_25mhz; // Reloj dividido a 25 MHz para VGA y teclado
    wire btn_j1_subir, btn_j1_bajar, btn_j2_subir, btn_j2_bajar; // Controles decodificados de ambos jugadores
    wire sinc_h, sinc_v, video_activo; // Señales de sincronía y zona visible 640x480
    wire [9:0] pixel_x, pixel_y; // Coordenadas actuales de barrido VGA
    wire [9:0] raqueta1_y, raqueta2_y, pelota_x, pelota_y; // Posiciones actuales en pantalla
    wire [3:0] score_j1, score_j2; // Marcadores BCD de Jugador 1 y Jugador 2
    wire [1:0] rojo, verde, azul; // Colores internos de 2 bits generados por pantalla

    // Conexión de sincronismos y expansión de 2 bits a 4 bits por canal RGB
    assign vga_hs = sinc_h;
    assign vga_vs = sinc_v;
    assign vga_r  = {rojo, rojo};
    assign vga_g  = {verde, verde};
    assign vga_b  = {azul, azul};

    // 1. Divisor de reloj: 100 MHz -> 25 MHz
    divisor_reloj mod_divisor (
        .clk_100mhz(clk),
        .clk_25mhz(clk_25mhz)
    );

    // 2. Decodificador de teclado PS/2 (W, S, Flecha Arriba, Flecha Abajo)
    teclado mod_teclado (
        .clk_25mhz(clk_25mhz),
        .ps2_clk(ps2_clk),
        .ps2_data(ps2_data),
        .J1_sube(btn_j1_subir),
        .J1_baja(btn_j1_bajar),
        .J2_sube(btn_j2_subir),
        .J2_baja(btn_j2_bajar)
    );

    // 3. Generador de sincronía VGA 640x480 @ 60 Hz
    sincronia_vga mod_vga (
        .reloj(clk_25mhz),
        .reiniciar(1'b0),
        .sinc_h(sinc_h),
        .sinc_v(sinc_v),
        .video_activo(video_activo),
        .pos_x(pixel_x),
        .pos_y(pixel_y)
    );

    // 4. Lógica principal del juego (paletas, pelota, colisiones y puntaje)
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

    // 5. Renderizador de escena y puntajes sobre la grilla VGA
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