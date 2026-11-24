// [USO DE IA] Código redactado/estructurado con asistencia de IA y validado por el equipo.
`default_nettype none // Exige declarar explícitamente todos los cables

module pantalla (
    input  wire       video_activo, // 1 dentro del área visible 640x480
    input  wire [9:0] pixel_x,      // Coordenada X actual del píxel
    input  wire [9:0] pixel_y,      // Coordenada Y actual del píxel
    input  wire [9:0] raqueta1_y,   // Posición Y de la paleta izquierda
    input  wire [9:0] raqueta2_y,   // Posición Y de la paleta derecha
    input  wire [9:0] pelota_x,     // Posición X de la pelota
    input  wire [9:0] pelota_y,     // Posición Y de la pelota
    input  wire [3:0] score_j1,     // Puntaje Jugador 1 (0..9)
    input  wire [3:0] score_j2,     // Puntaje Jugador 2 (0..9)
    output reg  [1:0] rojo,         // Canal rojo interno (2 bits)
    output reg  [1:0] verde,        // Canal verde interno (2 bits)
    output reg  [1:0] azul          // Canal azul interno (2 bits)
);

    // Raqueta izquierda (10 px de ancho x 60 px de alto)
    wire en_raqueta1 = (pixel_x >= 10'd20)  && (pixel_x <= 10'd29) &&
                       (pixel_y >= raqueta1_y) && (pixel_y <= raqueta1_y + 10'd59);

    // Raqueta derecha (10 px de ancho x 60 px de alto)
    wire en_raqueta2 = (pixel_x >= 10'd610) && (pixel_x <= 10'd619) &&
                       (pixel_y >= raqueta2_y) && (pixel_y <= raqueta2_y + 10'd59);

    // Pelota cuadrada (8x8 píxeles)
    wire en_pelota = (pixel_x >= pelota_x) && (pixel_x <= pelota_x + 10'd7) &&
                     (pixel_y >= pelota_y) && (pixel_y <= pelota_y + 10'd7);

    // Bordes perimetrales de la cancha (16 px de grosor)
    wire en_borde = (pixel_x < 10'd16) || (pixel_x >= 10'd624) || 
                    (pixel_y < 10'd16) || (pixel_y >= 10'd464);

    // Red central punteada dentro del área de juego
    wire en_red = (pixel_x >= 10'd318) && (pixel_x <= 10'd321) && 
                  (pixel_y[3] == 1'b0) && (pixel_y >= 10'd16) && (pixel_y < 10'd464);

    wire en_score_j1; // Píxel activo del marcador izquierdo
    wire en_score_j2; // Píxel activo del marcador derecho

    // Instancia del marcador del Jugador 1
    marcador digito_j1 (
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .box_x(10'd268),
        .box_y(10'd24),
        .digit(score_j1),
        .en_digit(en_score_j1)
    );

    // Instancia del marcador del Jugador 2
    marcador digito_j2 (
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .box_x(10'd356),
        .box_y(10'd24),
        .digit(score_j2),
        .en_digit(en_score_j2)
    );

    // Selección de color según zona activa y prioridad de dibujo
    always @(*) begin
        if (!video_activo) begin
            rojo  = 2'b00; // Apagado fuera de zona visible
            verde = 2'b00;
            azul  = 2'b00;
        end else if (en_raqueta1 || en_raqueta2 || en_pelota || en_score_j1 || en_score_j2) begin
            rojo  = 2'b11; // Blanco para raquetas, pelota y marcadores
            verde = 2'b11;
            azul  = 2'b11;
        end else if (en_borde || en_red) begin
            rojo  = 2'b10; // Tono claro/amarillento para bordes y red central
            verde = 2'b11;
            azul  = 2'b00;
        end else begin
            rojo  = 2'b00; // Fondo negro de la cancha
            verde = 2'b00;
            azul  = 2'b00;
        end
    end

endmodule