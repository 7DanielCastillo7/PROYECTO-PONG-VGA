// [USO DE IA] Código redactado/estructurado con asistencia de IA y validado por el equipo.
`default_nettype none // Exige declarar explícitamente todos los cables

module juego (
    input  wire       sinc_v,                        // Pulso de sincronismo vertical (actualiza por cuadro)
    input  wire       btn_j1_subir,                  // Control para subir raqueta izquierda
    input  wire       btn_j1_bajar,                  // Control para bajar raqueta izquierda
    input  wire       btn_j2_subir,                  // Control para subir raqueta derecha
    input  wire       btn_j2_bajar,                  // Control para bajar raqueta derecha
    output reg  [9:0] raqueta1_y = 10'd210,           // Posición Y inicial de raqueta 1
    output reg  [9:0] raqueta2_y = 10'd210,           // Posición Y inicial de raqueta 2
    output reg  [9:0] pelota_x   = 10'd320,           // Posición X inicial de la pelota
    output reg  [9:0] pelota_y   = 10'd240,           // Posición Y inicial de la pelota
    output reg  [3:0] score_j1   = 4'd0,              // Puntaje Jugador 1 (0..9)
    output reg  [3:0] score_j2   = 4'd0               // Puntaje Jugador 2 (0..9)
);

    reg       dir_x        = 1'b1;                   // Dirección X: 1 = derecha, 0 = izquierda
    reg       dir_y        = 1'b1;                   // Dirección Y: 1 = abajo, 0 = arriba
    reg [3:0] pelota_speed = 4'd2;                   // Velocidad de la pelota (píxeles por cuadro, máx. 6)
    reg [3:0] hit_count    = 4'd0;                   // Contador de golpes en raquetas (0..9)

    always @(posedge sinc_v) begin
        // Movimiento Raqueta 1 dentro de límites verticales
        if (btn_j1_subir && (raqueta1_y > 10'd16))
            raqueta1_y <= raqueta1_y - 10'd4;
        else if (btn_j1_bajar && (raqueta1_y < 10'd404))
            raqueta1_y <= raqueta1_y + 10'd4;

        // Movimiento Raqueta 2 dentro de límites verticales
        if (btn_j2_subir && (raqueta2_y > 10'd16))
            raqueta2_y <= raqueta2_y - 10'd4;
        else if (btn_j2_bajar && (raqueta2_y < 10'd404))
            raqueta2_y <= raqueta2_y + 10'd4;

        // Detección de gol en borde derecho (punto para Jugador 1)
        if (pelota_x >= 10'd624) begin
            pelota_x     <= 10'd320;                 // Centra la pelota en X
            pelota_y     <= 10'd240;                 // Centra la pelota en Y
            dir_x        <= 1'b0;                    // Saca hacia la izquierda
            pelota_speed <= 4'd2;                    // Reinicia velocidad base
            hit_count    <= 4'd0;                    // Reinicia contador de golpes
            if (score_j1 < 4'd9) score_j1 <= score_j1 + 1'b1;
            else begin score_j1 <= 4'd0; score_j2 <= 4'd0; end // Reinicia marcador tras 9
        end
        // Detección de gol en borde izquierdo (punto para Jugador 2)
        else if (pelota_x <= 10'd16) begin
            pelota_x     <= 10'd320;                 // Centra la pelota en X
            pelota_y     <= 10'd240;                 // Centra la pelota en Y
            dir_x        <= 1'b1;                    // Saca hacia la derecha
            pelota_speed <= 4'd2;                    // Reinicia velocidad base
            hit_count    <= 4'd0;                    // Reinicia contador de golpes
            if (score_j2 < 4'd9) score_j2 <= score_j2 + 1'b1;
            else begin score_j1 <= 4'd0; score_j2 <= 4'd0; end // Reinicia marcador tras 9
        end
        else begin
            // Rebote horizontal y colisiones con ambas raquetas
            if (dir_x) begin
                // Colisión con raqueta derecha (Jugador 2)
                if ((pelota_x + 10'd7 >= 10'd610) && (pelota_x <= 10'd619) &&
                    (pelota_y + 10'd7 >= raqueta2_y) && (pelota_y <= raqueta2_y + 10'd59)) begin
                    dir_x <= 1'b0;                   // Invierte dirección hacia la izquierda
                    if (hit_count == 4'd9) begin
                        hit_count    <= 4'd0;
                        if (pelota_speed < 4'd6) pelota_speed <= pelota_speed + 1'b1; // Acelera cada 10 golpes
                    end else begin
                        hit_count    <= hit_count + 1'b1;
                    end
                end
                else begin
                    pelota_x <= pelota_x + {6'b0, pelota_speed}; // Avanza hacia la derecha
                end
            end
            else begin
                // Colisión con raqueta izquierda (Jugador 1)
                if ((pelota_x <= 10'd29) && (pelota_x + 10'd7 >= 10'd20) &&
                    (pelota_y + 10'd7 >= raqueta1_y) && (pelota_y <= raqueta1_y + 10'd59)) begin
                    dir_x <= 1'b1;                   // Invierte dirección hacia la derecha
                    if (hit_count == 4'd9) begin
                        hit_count    <= 4'd0;
                        if (pelota_speed < 4'd6) pelota_speed <= pelota_speed + 1'b1; // Acelera cada 10 golpes
                    end else begin
                        hit_count    <= hit_count + 1'b1;
                    end
                end
                else begin
                    pelota_x <= pelota_x - {6'b0, pelota_speed}; // Avanza hacia la izquierda
                end
            end

            // Rebote vertical en bordes superior e inferior
            if (dir_y) begin
                if (pelota_y >= 10'd464)
                    dir_y <= 1'b0;                   // Rebota hacia arriba
                else
                    pelota_y <= pelota_y + {6'b0, pelota_speed}; // Avanza hacia abajo
            end else begin
                if (pelota_y <= 10'd16)
                    dir_y <= 1'b1;                   // Rebota hacia abajo
                else
                    pelota_y <= pelota_y - {6'b0, pelota_speed}; // Avanza hacia arriba
            end
        end
    end

endmodule